import os
# Import the CSE 125 utilities
_REPO_ROOT = os.getenv('REPO_ROOT')
assert (_REPO_ROOT), "REPO_ROOT must be defined in environment as a non-empty string"
assert (os.path.exists(_REPO_ROOT)), "REPO_ROOT path must exist"
import sys
sys.path.append(os.path.join(_REPO_ROOT, "util"))
from utilities import *

from math import log, ceil
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
from cocotb.result import SimTimeoutError

_DIR_PATH = os.path.dirname(os.path.realpath(__file__))
_MODULE= "test_" + os.path.basename(_DIR_PATH)
   
timescale = "1ps/1ps"
timescale = "1ps/1ps"
tests = ['reset_test',
         'min_delay_test',
         'max_delay_test',
         'noise_test'
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
@pytest.mark.parametrize("min_delay_p", [10, 500, 1000])
@pytest.mark.parametrize("test_name", tests)
def test_each_runner(test_name, min_delay_p):
    # This line must be first
    parameters = dict(locals())
    del parameters['test_name']
    _runner(test_name, parameters)

# Opposite above, run all the tests in one simulation but reset
# between tests to ensure that reset is clearing all state.
@pytest.mark.parametrize("min_delay_p", [10, 500, 1000])
@max_score(.5)
def test_all_runner(min_delay_p):
    # This line must be first
    parameters = dict(locals())
    _runner(None, parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@pytest.mark.parametrize("min_delay_p", [1000])
@max_score(.5)
def test_lint(min_delay_p):
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only"], parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@pytest.mark.parametrize("min_delay_p", [1000])
@max_score(.5)
def test_style(min_delay_p):
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
           
@cocotb.test()
async def reset_test(dut):
    """Test for Initialization"""

    # Set the clock to Z for 10 ns. This helps separate tests when test_all is running.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')
    
    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    button_i = dut.button_i
    button_o = dut.button_o

    button_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    button_i.value = LogicArray(['0'])

    await RisingEdge(dut.clk_i)

    assert_resolvable(button_o)
    assert button_o.value == 0 , f"Incorrect Result: button_o != {0}. Got: {button_o.value} at Time {get_sim_time(units='ns')}ns."

async def wait_for(dut, value):
    while(dut.button_o.value.is_resolvable and dut.button_o.value != value):
        await FallingEdge(dut.clk_i)

async def wait_cycles(dut, value, cycles):
    for i in range(cycles):
        if(dut.button_o.value.is_resolvable and dut.button_o.value == value):
            break;
        await FallingEdge(dut.clk_i)

@cocotb.test()
async def min_delay_test(dut):
    """Test mininimum delay parameter"""

    # Set the clock to Z for 10 ns. This helps separate tests when test_all is running.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')
    
    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    button_i = dut.button_i
    button_o = dut.button_o
    min_delay_p = dut.min_delay_p.value

    button_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    button_i.value = LogicArray(['0'])

    await RisingEdge(dut.clk_i)

    assert_resolvable(button_o)
    assert button_o.value == 0 , f"Incorrect Result: button_o != {0}. Got: {button_o.value} at Time {get_sim_time(units='ns')}ns."

    button_i.value = LogicArray(['1'])

    try:
        await with_timeout(wait_for(dut, value=1), min_delay_p, 'ns')
    except:
        assert_resolvable(button_o)
        assert button_o.value == 0 , f"Too early! button_o != {0}. Got: {button_o.value} at Time {get_sim_time(units='ns')}ns."

@cocotb.test()
async def max_delay_test(dut):
    """Test mininimum delay parameter"""

    # Set the clock to Z for 10 ns. This helps separate tests when test_all is running.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')
    
    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    button_i = dut.button_i
    button_o = dut.button_o
    min_delay_p = dut.min_delay_p.value

    button_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    button_i.value = LogicArray(['0'])

    await RisingEdge(dut.clk_i)

    assert_resolvable(button_o)
    assert button_o.value == 0 , f"Incorrect Result: button_o != {0}. Got: {button_o.value} at Time {get_sim_time(units='ns')}ns."

    button_i.value = LogicArray(['1'])

    await with_timeout(wait_for(dut, value=1), (1 << ceil(log(min_delay_p, 2))) + 1, 'ns')

@cocotb.test()
async def noise_test(dut):
    """Test for min_delay_p in the presence of noise"""

    # Set the clock to Z for 10 ns. This helps separate tests when test_all is running.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')

    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    button_i = dut.button_i
    button_o = dut.button_o
    min_delay_p = dut.min_delay_p.value

    button_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    button_i.value = LogicArray(['0'])

    await RisingEdge(dut.clk_i)

    assert_resolvable(button_o)
    assert button_o.value == 0 , f"Incorrect Result: button_o != {0}. Got: {button_o.value} at Time {get_sim_time(units='ns')}ns."

    button_i.value = LogicArray(['1'])

    seq = [random.randint(0, 1) for i in range(min_delay_p)]
    for i in seq:
        await FallingEdge(dut.clk_i)
        button_i.value = i

    await RisingEdge(dut.clk_i)
    if(seq[-1] == 0):
        button_i.value = 1
        mindelay = cocotb.start_soon(with_timeout(wait_for(dut, value=1), min_delay_p - 1, 'ns'))
        maxdelay = cocotb.start_soon(with_timeout(wait_for(dut, value=1), (1 << ceil(log(min_delay_p, 2))) + 1, 'ns'))
    else:
        mindelay = cocotb.start_soon(with_timeout(wait_for(dut, value=1), min_delay_p - seq[::-1].index(0) - 1, 'ns'))
        maxdelay = cocotb.start_soon(with_timeout(wait_for(dut, value=1), (1 << ceil(log(min_delay_p, 2))) - seq[::-1].index(0) +1, 'ns'))

    try:
        await mindelay
    except SimTimeoutError:
        assert_resolvable(button_o)
        assert button_o.value == 0 , f"Too early! button_o != {0}. Got: {button_o.value} at Time {get_sim_time(units='ns')}ns."
   
    try:
        await maxdelay
    except SimTimeoutError:
        assert_resolvable(button_o)
        assert button_o.value == 1 , f"Too Late! button_o != {1}. Got: {button_o.value} at Time {get_sim_time(units='ns')}ns."

# @cocotb.test()
async def multipress_test(dut):
    """Test for multiple valid presses"""

    # Set the clock to Z for 10 ns. This helps separate tests when test_all is running.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')

    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    button_i = dut.button_i
    button_o = dut.button_o

    button_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

# tf = TestFactory(test_function=fuzz_test)
# tf.add_option(name='l', optionlist=[10, 100, 1000])
# tf.generate_tests()
