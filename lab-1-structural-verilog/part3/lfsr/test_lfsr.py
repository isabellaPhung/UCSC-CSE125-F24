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
from cocotb.triggers import Timer, ClockCycles, RisingEdge, FallingEdge, with_timeout
from cocotb.types import LogicArray

_DIR_PATH = os.path.dirname(os.path.realpath(__file__))
_MODULE= "test_" + os.path.basename(_DIR_PATH)
   
timescale = "1ps/1ps"
   
tests = ['reset_test',
         'tick_test',
         'loop_test'
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
        compile_args=["-Wno-fatal"]
        if(not os.path.exists(work_dir)):
            os.makedirs(work_dir)
    else:
        compile_args=[]

    run(verilog_sources=sources, toplevel=top, module=_MODULE, compile_args=compile_args, sim_build=sim_build, timescale=timescale,
        parameters=ps, defines=ds, work_dir=work_dir, waves=True, testcase=n)
   
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
@max_score(0)
def test_each_runner(test_name):
    # This line must be first
    parameters = dict(locals())
    del parameters['test_name']
    _runner(test_name, parameters)

# Opposite above, run all the tests in one simulation but reset
# between tests to ensure that reset is clearing all state.
@max_score(2)
def test_all_runner():
    # This line must be first
    parameters = dict(locals())
    _runner(None, parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(1)
def test_lint():
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only"], parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(1)
def test_style():
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only", "-Wwarn-style", "-Wno-lint"], parameters)


### Begin Tests ###

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

    # Always assign inputs on the falling edge
    if (not FinishFalling):
        await RisingEdge(dut.clk_i)

async def wait_for_signal(dut, signal, value):
    signal = getattr(dut, signal)
    while(signal.value.is_resolvable and signal.value != value):
        await FallingEdge(dut.clk_i)

async def delay_cycles(dut, ncyc, polarity):
    for _ in range(ncyc):
        if(polarity):
            await RisingEdge(dut.clk_i)
        else:
            await FallingEdge(dut.clk_i)
    
@cocotb.test()
async def reset_test(dut):
    """Test for Initialization"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')

    # Unrealistically fast clock, but nice for mental math (1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))
    model = LfsrModel(dut.clk_i, dut.reset_i, dut.en_i, dut.data_o)
    model.start()

    reset_i = dut.reset_i
    data_o = dut.data_o

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    # Always check outputs on the rising edge
    await RisingEdge(dut.clk_i)

    assert_resolvable(data_o)
    expected = model._state
    assert data_o.value == expected, f"Incorrect Result: data_o != {expected}. Got: {data_o.value} at Time {get_sim_time(units='ns')}ns."

async def wait_for(clk_i, signal, value):
    while(signal.value.is_resolvable and signal.value != value):
        await FallingEdge(clk_i)

@cocotb.test()
async def tick_test(dut):
    """Test one clock cycle of the LFSR"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')
    
    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz Frequency)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))
    model = LfsrModel(dut.clk_i, dut.reset_i, dut.en_i, dut.data_o)
    model.start()

    reset_i = dut.reset_i
    data_o = dut.data_o

    await RisingEdge(dut.clk_i)

    dut.en_i.value = 0
    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)
    dut.en_i.value = 1

    await RisingEdge(dut.clk_i)

    expected = model._state
    assert_resolvable(data_o)
    assert data_o.value == expected, f"Incorrect Result: data_o != {expected}. Got: {data_o.value} at Time {get_sim_time(units='ns')}ns."

@cocotb.test()
async def loop_test(dut):
    """Test two complete cycles of the LFSR"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')
    
    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz Frequency)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))
    model = LfsrModel(dut.clk_i, dut.reset_i, dut.en_i, dut.data_o)
    model.start()

    reset_i = dut.reset_i
    data_o = dut.data_o

    await RisingEdge(dut.clk_i)

    dut.en_i.value = 0
    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)
    dut.en_i.value = 1

    for i in range(6 * (2<<(len(data_o))-1)):
        await RisingEdge(dut.clk_i)
        expected = model._state
        assert_resolvable(data_o)
        assert data_o.value == expected, f"Incorrect Result: data_o != {expected}. Got: {data_o.value} at Time {get_sim_time(units='ns')}ns."
        await FallingEdge(dut.clk_i)
        dut.en_i.value = ((i % 3) == 1)
        
class LfsrModel():
    def __init__(self, clk_i, reset_i, en_i, data_o):
        self._clk_i = clk_i
        self._reset_i = reset_i
        self._en_i = en_i
        self._data_o = data_o
        self._state = 0
        self._nstate = 0
        self._coro_run = None

    def start(self):
        """Start model"""
        if self._coro_run is not None:
            raise RuntimeError("Model already started")
        self._coro_run = cocotb.start_soon(self._run())

    async def _run(self):
        while True:
            await RisingEdge(self._clk_i)
            if(not(self._reset_i.value.is_resolvable)):
                pass
            elif(self._reset_i.value == 1):
                self._nstate = 1
            elif(self._en_i.value.is_resolvable and self._en_i.value == 0):
                pass
            elif(self._en_i.value.is_resolvable and self._en_i.value == 1):
                self._nstate = (self._nstate << 1) | (((self._nstate>>3)&1) ^ ((self._nstate>>8)&1))

            self._nstate = self._nstate & ((1<< 9) - 1)
            await FallingEdge(self._clk_i)
            self._state = self._nstate 
      
    def stop(self) -> None:
        """Stop monitor"""
        if self._coro_run is None:
            raise RuntimeError("Monitor never started")
    
