import os
# Import the CSE 125 utilities
_REPO_ROOT = os.getenv('REPO_ROOT')
assert (_REPO_ROOT), "REPO_ROOT must be defined in environment as a non-empty string"
assert (os.path.exists(_REPO_ROOT)), "REPO_ROOT path must exist"
import sys
sys.path.append(os.path.join(_REPO_ROOT, "util"))
from utilities import *

import random
random.seed(42)

import pytest
import pytest_utils
from pytest_utils.decorators import max_score, visibility, tags

import cocotb

from cocotb_test.simulator import run
from cocotb.clock import Clock
from cocotb.regression import TestFactory
from cocotb.utils import get_sim_time
from cocotb.triggers import Timer, ClockCycles, RisingEdge, FallingEdge, with_timeout, Combine
from cocotb.types import LogicArray

import queue
from itertools import product

_DIR_PATH = os.path.dirname(os.path.realpath(__file__))
_MODULE= "test_" + os.path.basename(_DIR_PATH)

timescale = "1ps/1ps"
tests = ['reset_test'
         ,'single_test'
         ,'fill_test'
         ,'fill_empty_test'
         ,'in_fuzz_test'
         ,'out_fuzz_test'
         ,'inout_fuzz_test'
         ,'stream_test'
         ]

def _runner(n, ps, ds=[]):
    """Run the simulator on test n, with parameters ps, and defines
    ds. If n is none, it will run all tests"""

    simulator = os.getenv('SIM').lower()

    if(n is None):
        name = "all"
    else:
        name = n

    work_dir = os.path.join(_DIR_PATH, "run", name, get_param_string(ps), simulator)
    sim_build = os.path.join(_DIR_PATH, "build", get_param_string(ps))

    sources = get_sources(_REPO_ROOT, _DIR_PATH)
    top = get_top(_DIR_PATH)

    # Icarus doesn't build, it just runs.
    if simulator.startswith("icarus"):
        sim_build = work_dir

    if simulator.startswith("verilator"):
        compile_args=["-Wno-fatal", "-DVM_TRACE_FST=1", "-DVM_TRACE=1"]
        plus_args = ["--trace", "--trace-fst"]
        if(not os.path.exists(work_dir)):
            os.makedirs(work_dir)
    else:
        compile_args=[]
        plus_args = []

    run(verilog_sources=sources, toplevel=top, module=_MODULE, compile_args=compile_args, plus_args=plus_args, sim_build=sim_build, timescale=timescale,
        parameters=ps, defines=ds + ["VM_TRACE_FST=1", "VM_TRACE=1"], includes=[_DIR_PATH], work_dir=work_dir, waves=True, testcase=n)

# Function to build (run) the lint and style checks.
def _lint(ca, ps, ds=[]):

    # Create the expected makefile so cocotb-test won't complain.
    sim_build = "lint"
    if(not os.path.exists("lint")):
       os.mkdir("lint")

    with open("lint/Vtop.mk", 'w') as fd:
        fd.write("all:")

    make_args = ["-n"]
    compile_args = ca

    run(verilog_sources=get_sources(_REPO_ROOT, _DIR_PATH), toplevel=get_top(_DIR_PATH), module=_MODULE, compile_args=compile_args, sim_build=sim_build, timescale=timescale,
        parameters=ps, defines=ds, includes=[_DIR_PATH], make_args=make_args, compile_only=True)

# Admittedly test_each approach is a bit hacky. If we treat Verilog
# parameters as pytest parameters, each parameterization runs all the
# tests within one simulation (fine, but not ideal). The drawback is
# that it is impossible to identify which test failed within a
# parameterization inside the simulation. Instead, we run each test
# individually by listing them as pytest parameters (but not a verilog
# parameters) so that they get tested individually.
@pytest.mark.parametrize("width_p", [7, 32])
@pytest.mark.parametrize("depth_log2_p", [4, 2])
@pytest.mark.parametrize("test_name", tests)
def test_each_runner(test_name, width_p, depth_log2_p):
    # This line must be first
    parameters = dict(locals())
    del parameters['test_name']
    _runner(test_name, parameters)

# Opposite above, run all the tests in one simulation but reset
# between tests to ensure that reset is clearing all state.
@pytest.mark.parametrize("width_p", [7, 32])
@pytest.mark.parametrize("depth_log2_p", [4, 1])
@max_score(3)
def test_all_runner(width_p, depth_log2_p):
    # This line must be first
    parameters = dict(locals())
    _runner(None, parameters)

@pytest.mark.parametrize("width_p", [7])
@pytest.mark.parametrize("depth_log2_p", [4])
@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(.5)
def test_lint(width_p, depth_log2_p):
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only"], parameters)

@pytest.mark.parametrize("width_p", [7])
@pytest.mark.parametrize("depth_log2_p", [4])
@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(.5)
def test_style(width_p, depth_log2_p):
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only", "-Wwarn-style", "-Wno-lint"], parameters)

async def reset(dut, reset_i, cycles, FinishFalling=True):
    # Wait for the next rising edge
    await RisingEdge(dut.clk_i)

    # Always assign inputs on the falling edge
    await FallingEdge(dut.clk_i)
    reset_i.value = 1

    await ClockCycles(dut.clk_i, cycles)

    # Always assign inputs on the falling edge
    await FallingEdge(dut.clk_i)
    reset_i.value = 0

    reset_i._log.debug("Reset complete")

    # Always assign inputs on the falling edge
    if (not FinishFalling):
        await RisingEdge(dut.clk_i)

async def wait_for_signal(dut, signal, value):
    signal = getattr(dut, signal)
    while(signal.value.is_resolvable and signal.value != value):
        await FallingEdge(dut.clk_i)

async def pretest_sequence(dut):
    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')

    # Unrealistically fast clock, but nice for mental math (1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

async def reset_sequence(dut):
    clk_i = dut.clk_i
    reset_i = dut.reset_i

    ready_i = dut.ready_i
    valid_i = dut.valid_i
    ready_o = dut.ready_o
    valid_o = dut.valid_o

    await reset(dut, reset_i, cycles=10, FinishFalling=True)

    ready_i.value = 0
    valid_i.value = 0

    await FallingEdge(clk_i)

    assert_resolvable(valid_o)
    assert valid_o.value == 0, f"Error! valid_o is 1 after reset at Time {get_sim_time(units='ns')}ns."

    assert_resolvable(ready_o)
    assert ready_o.value == 1, f"Error! ready_o is 0 after reset at Time {get_sim_time(units='ns')}ns."

    await FallingEdge(clk_i)

async def delay_cycles(dut, ncyc, polarity):
    for _ in range(ncyc):
        if(polarity):
            await RisingEdge(dut.clk_i)
        else:
            await FallingEdge(dut.clk_i)

def assert_resolvable(s):
    assert s.value.is_resolvable, f"Unresolvable value in {s._path} (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."

class FifoModel():
    def __init__(self, dut):

        self._dut = dut
        self._data_o = dut.data_o
        self._data_i = dut.data_i

        # Model the fifo like a simple software queue
        self._q = queue.SimpleQueue()

        self._width_p = dut.width_p.value
        self._depth_log2_p = dut.depth_log2_p.value
        self._deqs = 0
        self._enqs = 0

    def consume(self):
        assert_resolvable(self._data_i)
        self._q.put(self._data_i.value)
        self._enqs += 1

    def produce(self):
        assert_resolvable(self._data_o)
        got = self._data_o.value
        expected = self._q.get()
        assert got == expected, f"Error! Value on deque iteration {self._deqs} does not match expected. Expected: {expected}. Got: {got}"
        self._deqs += 1


class ReadyValidInterface():
    def __init__(self, clk, reset, ready, valid):
        self._clk_i = clk
        self._reset_i = reset
        self._ready = ready
        self._valid = valid

    def is_in_reset(self):
        if((not self._reset_i.value.is_resolvable) or self._reset_i.value  == 1):
            return True

    def assert_resolvable(self):
        if(not self.is_in_reset()):
            assert_resolvable(self._valid)
            assert_resolvable(self._ready)

    def is_handshake(self):
        return ((self._valid == 1) and (self._ready == 1))

    async def _handshake(self):
        while True:
            await RisingEdge(self._clk_i)
            if (not self.is_in_reset()):
                self.assert_resolvable()
                if(self.is_handshake()):
                    break

    async def handshake(self, ns):
        """Wait for a handshake, raising an exception if it hasn't
        happened after ns nanoseconds of simulation time"""

        # If ns is none, wait indefinitely
        if(ns):
            await with_timeout(self._handshake(), ns, 'ns')
        else:
            await self._handshake()


class RandomDataGenerator():
    def __init__(self, dut):
        self._dut = dut

    def generate(self):
        value = random.randint(0, (1 << self._dut.width_p.value) - 1)
        return value

class RateGenerator():
    def __init__(self, dut, r):
        self._rate = r

    def generate(self):
        if(self._rate == 0):
            return False
        else:
            return (random.randint(1,int(1/self._rate)) == 1)

class OutputModel():
    def __init__(self, dut, g, l):
        self._clk_i = dut.clk_i
        self._reset_i = dut.reset_i
        self._dut = dut

        self._rv_in = ReadyValidInterface(self._clk_i, self._reset_i,
                                          dut.valid_i, dut.ready_o)

        self._rv_out = ReadyValidInterface(self._clk_i, self._reset_i,
                                           dut.valid_o, dut.ready_i)
        self._generator = g
        self._length = l

        self._coro = None

        self._nout = 0

    def start(self):
        """ Start Output Model """
        if self._coro is not None:
            raise RuntimeError("Output Model already started")
        self._coro = cocotb.start_soon(self._run())

    def stop(self) -> None:
        """ Stop Output Model """
        if self._coro is None:
            raise RuntimeError("Output Model never started")
        self._coro.kill()
        self._coro = None

    async def wait(self, t):
        await with_timeout(self._coro, t, 'ns')

    def nproduced(self):
        return self._nout

    async def _run(self):
        """ Output Model Coroutine"""

        self._nout = 0
        clk_i = self._clk_i
        ready_i = self._dut.ready_i
        reset_i = self._dut.reset_i
        valid_o = self._dut.valid_o

        await FallingEdge(clk_i)

        if(not (reset_i.value.is_resolvable and reset_i.value == 0)):
            await FallingEdge(reset_i)

        # Precondition: Falling Edge of Clock
        while self._nout < self._length:
            await FallingEdge(clk_i)
            consume = self._generator.generate()
            success = 0
            ready_i.value = consume

            # Wait until valid
            while(consume and not success):
                await RisingEdge(clk_i)
                assert_resolvable(valid_o)
                #assert valid_o.value.is_resolvable, f"Unresolvable value in valid_o (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."

                success = True if (valid_o.value == 1) else False
                if (success):
                    self._nout += 1

        ready_i.value = 0
        return self._nout

class InputModel():
    def __init__(self, dut, data, rate, l):
        self._clk_i = dut.clk_i
        self._reset_i = dut.reset_i
        self._dut = dut

        self._rv_in = ReadyValidInterface(self._clk_i, self._reset_i,
                                          dut.valid_i, dut.ready_o)

        self._rate = rate
        self._data = data
        self._length = l

        self._coro = None

        self._nin = 0

    def start(self):
        """ Start Input Model """
        if self._coro is not None:
            raise RuntimeError("Input Model already started")
        self._coro = cocotb.start_soon(self._run())

    def stop(self) -> None:
        """ Stop Input Model """
        if self._coro is None:
            raise RuntimeError("Input Model never started")
        self._coro.kill()
        self._coro = None

    async def wait(self, t):
        await with_timeout(self._coro, t, 'ns')

    def nconsumed(self):
        return self._nin

    async def _run(self):
        """ Input Model Coroutine"""

        self._nin = 0
        clk_i = self._clk_i
        reset_i = self._dut.reset_i
        ready_o = self._dut.ready_o
        valid_i = self._dut.valid_i
        data_i = self._dut.data_i

        await delay_cycles(self._dut, 1, False)

        if(not (reset_i.value.is_resolvable and reset_i.value == 0)):
            await FallingEdge(reset_i)

        await delay_cycles(self._dut, 2, False)

        # Precondition: Falling Edge of Clock
        while self._nin < self._length:
            produce = self._rate.generate()
            din = self._data.generate()
            success = 0
            await FallingEdge(clk_i)
            valid_i.value = produce
            data_i.value = din

            # Wait until ready
            while(produce and not success):
                await RisingEdge(clk_i)
                assert_resolvable(ready_o)
                #assert ready_o.value.is_resolvable, f"Unresolvable value in ready_o (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."

                success = True if (ready_o.value == 1) else False
                if (success):
                    self._nin += 1

        valid_i.value = 0
        return self._nin

class ModelRunner():
    def __init__(self, dut, model):

        self._clk_i = dut.clk_i
        self._reset_i = dut.reset_i

        self._rv_in = ReadyValidInterface(self._clk_i, self._reset_i,
                                          dut.valid_i, dut.ready_o)
        self._rv_out = ReadyValidInterface(self._clk_i, self._reset_i,
                                           dut.valid_o, dut.ready_i)

        self._model = model

        self._events = queue.SimpleQueue()

        self._coro_run_in = None
        self._coro_run_out = None

    def start(self):
        """Start model"""
        if self._coro_run_in is not None:
            raise RuntimeError("Model already started")
        self._coro_run_input = cocotb.start_soon(self._run_input(self._model))
        self._coro_run_output = cocotb.start_soon(self._run_output(self._model))

    async def _run_input(self, model):
        while True:
            await self._rv_in.handshake(None)
            self._events.put(get_sim_time(units='ns'))
            self._model.consume()

    async def _run_output(self, model):
        while True:
            await self._rv_out.handshake(None)
            assert (self._events.qsize() > 0), "Error! Module produced output without valid input"
            input_time = self._events.get(get_sim_time(units='ns'))
            self._model.produce()

    def stop(self) -> None:
        """Stop monitor"""
        if self._coro_run is None:
            raise RuntimeError("Monitor never started")
        self._coro_run_input.kill()
        self._coro_run_output.kill()
        self._coro_run_input = None
        self._coro_run_output = None


@cocotb.test()
async def reset_test(dut):
    """Test for Initialization"""

    await pretest_sequence(dut)
    await reset_sequence(dut)

@cocotb.test()
async def single_test(dut):
    """Test to transmit a single element in one cycle."""

    l = 1
    rate = 1

    m = ModelRunner(dut, FifoModel(dut))
    om = OutputModel(dut, RateGenerator(dut, 1), l)
    im = InputModel(dut, RandomDataGenerator(dut), RateGenerator(dut, rate), l)

    await pretest_sequence(dut)
    await reset_sequence(dut)

    # Wait one cycle for reset to start
    await FallingEdge(dut.clk_i)

    m.start()
    om.start()
    await FallingEdge(dut.clk_i)
    await FallingEdge(dut.clk_i)
    await FallingEdge(dut.clk_i)

    im.start()
    await RisingEdge(dut.valid_i)
    await RisingEdge(dut.clk_i)

    timeout = False
    try:
        await om.wait(1.5)
    except:
        timeout = True
    assert not timeout, "Error! Maximum latency expected for this fifo is one cycle."

    dut.valid_i.value = 0
    dut.ready_i.value = 0

@cocotb.test()
async def fill_test(dut):
    """Test if fifo_1r1w fills to depth_p elements"""

    depth_p = (1 << dut.depth_log2_p.value)
    l = depth_p
    rate = 1

    m = ModelRunner(dut, FifoModel(dut))
    om = OutputModel(dut, RateGenerator(dut, 0), l)
    im = InputModel(dut, RandomDataGenerator(dut), RateGenerator(dut, rate), l)

    await pretest_sequence(dut)
    await reset_sequence(dut)

    # Wait one cycle for reset to start
    await FallingEdge(dut.clk_i)

    m.start()
    om.start()
    im.start()

    await RisingEdge(dut.valid_i)
    await RisingEdge(dut.clk_i)

    success = False
    try:
        await im.wait(depth_p)
        success = True
    except:
        nconsumed = im.nconsumed()

    if(not success):
        assert nconsumed != depth_p, f"Error! Could not fill fifo with {depth_p} elements in {depth_p} cycles. Fifo consumed {nconsumed} elements."

@cocotb.test()
async def fill_empty_test(dut):
    """Test if fifo_1r1w fills to depth_p elements"""

    depth_p = (1 << dut.depth_log2_p.value)
    l = depth_p
    rate = 1

    m = ModelRunner(dut, FifoModel(dut))
    om = OutputModel(dut, RateGenerator(dut, 0), l)
    im = InputModel(dut, RandomDataGenerator(dut), RateGenerator(dut, rate), l)

    await pretest_sequence(dut)
    await reset_sequence(dut)

    # Wait one cycle for reset to start
    await FallingEdge(dut.clk_i)

    m.start()
    om.start()
    im.start()

    await RisingEdge(dut.valid_i)
    await RisingEdge(dut.clk_i)

    success = False
    try:
        await im.wait(depth_p)
        success = True
    except:
        nconsumed = im.nconsumed()

    if(not success):
        assert nconsumed != depth_p, f"Error! Could not fill fifo with {depth_p} elements in {depth_p} cycles. Fifo consumed {nconsumed} elements."

    om = OutputModel(dut, RateGenerator(dut, 1), l)
    om.start()

    await RisingEdge(dut.ready_i)
    await RisingEdge(dut.clk_i)

    nproduced = 0
    success = False
    try:
        await om.wait(depth_p)
        success = True
    except:
        nproduced = om.nproduced()

    if(not success):
        assert nproduced != depth_p, f"Error! Could not empty fifo with {depth_p} elements in {depth_p} cycles. Fifo produced {nproduced} elements."

@cocotb.test()
async def out_fuzz_test(dut):
    """Transmit 4 * depth_p random data elements at 50% line rate (Output/Consumer is fuzzed)"""

    l = (1 << dut.depth_log2_p.value) * 4
    rate = .5

    timeout = 2 * l * int(1/rate)

    m = ModelRunner(dut, FifoModel(dut))
    om = OutputModel(dut, RateGenerator(dut, rate), l)
    im = InputModel(dut, RandomDataGenerator(dut), RateGenerator(dut, 1), l)

    await pretest_sequence(dut)
    await reset_sequence(dut)

    # Wait one cycle for reset to start
    await FallingEdge(dut.clk_i)

    m.start()
    om.start()
    im.start()

    # Wait for the first piece of data to arrive at the output.
    await RisingEdge(dut.valid_o)
    try:
        await om.wait(timeout + .5)
    except cocotb.result.SimTimeoutError:
        assert 0, f"Test timed out. Could not transmit {l} elements in {timeout} ns, with output rate {rate}. Only transmitted: {om._nout}"


@cocotb.test()
async def in_fuzz_test(dut):
    """Transmit 4 * depth_p random data elements at 50% line rate (Input/Producer is fuzzed)"""

    l = (1 << dut.depth_log2_p.value) * 4
    rate = .5

    timeout = 2 * l * int(1/rate)

    m = ModelRunner(dut, FifoModel(dut))
    om = OutputModel(dut, RateGenerator(dut, 1), l)
    im = InputModel(dut, RandomDataGenerator(dut), RateGenerator(dut, rate), l)

    await pretest_sequence(dut)
    await reset_sequence(dut)

    # Wait one cycle for reset to start
    await FallingEdge(dut.clk_i)

    m.start()
    om.start()
    im.start()

    # Wait for the first piece of data to arrive at the output.
    await RisingEdge(dut.valid_o)
    try:
        await om.wait(timeout + .5)
    except cocotb.result.SimTimeoutError:
        assert 0, f"Test timed out. Could not transmit {l} elements in {timeout} ns, with output rate {rate}. Only transmitted: {om._nout}"

@cocotb.test()
async def inout_fuzz_test(dut):
    """Transmit 4 * depth_p random data elements at ~25% line rate (Both are fuzzed)"""

    l = (1 << dut.depth_log2_p.value) * 4
    rate = .5

    timeout = 2 * l * int(1/rate) * int(1/rate)

    m = ModelRunner(dut, FifoModel(dut))
    om = OutputModel(dut, RateGenerator(dut, rate), l)
    im = InputModel(dut, RandomDataGenerator(dut), RateGenerator(dut, rate), l)

    await pretest_sequence(dut)
    await reset_sequence(dut)

    # Wait one cycle for reset to start
    await FallingEdge(dut.clk_i)

    m.start()
    om.start()
    im.start()

    # Wait for the first piece of data to arrive at the output.
    await RisingEdge(dut.valid_o)
    try:
        await om.wait(timeout + .5)
    except cocotb.result.SimTimeoutError:
        assert 0, f"Test timed out. Could not transmit {l} elements in {timeout} ns, with output rate {rate}. Only transmitted: {om._nout}"

@cocotb.test()
async def stream_test(dut):
    """Transmit 4 * depth_p random data elements at 100% line rate"""

    # This is the InputModel
    l = (1 << dut.depth_log2_p.value) * 4
    rate = 1

    timeout = l

    m = ModelRunner(dut, FifoModel(dut))
    om = OutputModel(dut, RateGenerator(dut, rate), l)
    im = InputModel(dut, RandomDataGenerator(dut), RateGenerator(dut, rate), l)

    await pretest_sequence(dut)
    await reset_sequence(dut)

    await FallingEdge(dut.clk_i)

    m.start()
    om.start()
    im.start()

    # We're doing a throughput test. We only care about the output
    # throughput.  We can wait for the rising edge of valid_o because
    # it (should, if the circuit is implemented correctly) occur at,
    # or just after the clock edge.
    await RisingEdge(dut.valid_o)
    try:
        # Add .5 to give us a half cycle of clock to count output handshakes
        await om.wait(timeout + .5)
    except cocotb.result.SimTimeoutError:
        assert 0, f"Test timed out. Could not transmit {l} elements in {timeout} ns, with output rate {rate}. Only transmitted: {om._nout}"

