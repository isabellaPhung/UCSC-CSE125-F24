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
timescale = "1ps/1ps"
tests = ['reset_test',
         *[f'multiply_single_test_{i:03d}' for i in range(1,26)]
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
         parameters=ps, defines=ds + ["VM_TRACE_FST=1", "VM_TRACE=1"], work_dir=work_dir, waves=True, testcase=n)
   
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
        parameters=ps, defines=ds, make_args=make_args, compile_only=True)

# Admittedly test_each approach is a bit hacky. If we treat Verilog
# parameters as pytest parameters, each parameterization runs all the
# tests within one simulation (fine, but not ideal). The drawback is
# that it is impossible to identify which test failed within a
# parameterization inside the simulation. Instead, we run each test
# individually by listing them as pytest parameters (but not a verilog
# parameters) so that they get tested individually.
@pytest.mark.parametrize("test_name", tests)
@pytest.mark.parametrize("width_p", [2, 4, 11])
def test_each_runner(test_name, width_p):
    # This line must be first
    parameters = dict(locals())
    del parameters['test_name']
    _runner(test_name, parameters)

# Opposite above, run all the tests in one simulation but reset
# between tests to ensure that reset is clearing all state.
@pytest.mark.parametrize("width_p", [2, 4, 11])
@max_score(4)
def test_all_runner(width_p):
    # This line must be first
    parameters = dict(locals())
    _runner(None, parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@pytest.mark.parametrize("width_p", [11])
@max_score(.5)
def test_lint(width_p):
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only"], parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@pytest.mark.parametrize("width_p", [11])
@max_score(.5)
def test_style(width_p):
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

class MultiplierModel():
    def __init__(self, dut):

        self._dut = dut
        self._a_i = dut.a_i
        self._b_i = dut.b_i
        self._result_o = dut.result_o

        # Model the latency-insensitive multiplier interface like a simple software queue
        self._q = queue.SimpleQueue()
        
        self._width_p = dut.width_p.value

    def consume(self):
        assert_resolvable(self._a_i)
        assert_resolvable(self._b_i)
        self._q.put((self._a_i.value, self._b_i.value))

    def produce(self):
        assert_resolvable(self._result_o)
        got = self._result_o.value
        a_i, b_i = self._q.get()
        expected = a_i * b_i
        assert got == expected, f"Error! Product of {a_i} and {b_i} does not match expected. Expected: {expected}. Got: {got}"
        
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
        a_i = random.randint(0, (1 << self._dut.width_p.value) - 1)
        b_i = random.randint(0, (1 << self._dut.width_p.value) - 1)
        return (a_i, b_i)

class SingletonGenerator():
    def __init__(self, dut, pair):
        self._value = pair

    def generate(self):
        return self._value

class EdgeCaseGenerator():

    def __init__(self, dut):
        self._dut = dut
        limits = [0, 1, (1 << self._dut.width_p.value) - 1]
        self._pairs = list(product(limits, limits))
        self._loc = 0

    def ninputs(self):
        return len(self._pairs)

    def generate(self):
        val = self._pairs[self._loc]
        self._loc += 1
        return val

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

            await FallingEdge(clk_i)
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
        a_i = self._dut.a_i
        b_i = self._dut.b_i

        await delay_cycles(self._dut, 1, False)

        if(not (reset_i.value.is_resolvable and reset_i.value == 0)):
            await FallingEdge(reset_i)

        await delay_cycles(self._dut, 2, False)

        data = self._data.generate()
        # Precondition: Falling Edge of Clock
        while self._nin < self._length:
            produce = self._rate.generate()
            success = 0
            valid_i.value = produce
            # TODO: Figure out long term how to abstract this
            a_i.value = data[0]
            b_i.value = data[1]

            # Wait until ready
            while(produce and not success):
                await RisingEdge(clk_i)
                assert_resolvable(ready_o)

                success = True if (ready_o.value == 1) else False
                if (success):
                    self._nin += 1

            # Make sure we're not about to exit the loop
            if((self._nin < self._length) and success ):
                data = self._data.generate()

            await FallingEdge(clk_i)
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

async def multiply_single_test(dut, a, b):
    """Test for multiplying two numbers, starting with reset each time"""
    # I would like to test numbers that depend on the parameters to
    # the DUT (e.g. width_p), but the parameters are not available
    # until test runtime, so we occasionally have to pass in strings
    # that reference the DUT. Hence, these if/else statements (until I
    # find a better way).
    
    mask = (1 << dut.width_p.value) - 1
    timeout = dut.width_p.value * 3 + 4
    
    if(isinstance(a, int)):
        A = a
    else:
        A = eval(a) & mask
 
    if(isinstance(b, int)):
        B = b & mask
    else:
        B = eval(b) & mask

    timeout = dut.width_p.value * 2 + 4

    m = ModelRunner(dut, MultiplierModel(dut))
    om = OutputModel(dut, RateGenerator(dut, .5), 1)
    im = InputModel(dut, SingletonGenerator(dut, (A, B)), RateGenerator(dut, .5), 1)

    await pretest_sequence(dut)
    await reset_sequence(dut)

    await FallingEdge(dut.clk_i)

    m.start()
    om.start()
    im.start()

    await m._rv_in.handshake(None)
    try:
        await om.wait(timeout)
    except cocotb.result.SimTimeoutError:
        assert 0, f"Test timed out. Result took to long to compute"

tf = TestFactory(test_function=multiply_single_test)
test="multiply_single_test"

a = [0, 1, "(1 << (len(dut.a_i) - 1))", "int('01'*dut.width_p.value)//2", "(1 << len(dut.a_i)) - 1"]
b = [0, 1, "(1 << (len(dut.b_i) - 1))", "int('10'*dut.width_p.value)//2", "(1 << len(dut.b_i)) - 1"]
tf.add_option(name='a', optionlist=a)
tf.add_option(name='b', optionlist=b)
tf.generate_tests()

