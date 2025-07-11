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
         'en_tick_test',
         'bangen_tick_test',
         'free_run_test_001']

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
@pytest.mark.parametrize("depth_p,reset_val_p", [(2, 1), (2, 0), (5, 63)])
@pytest.mark.parametrize("test_name", tests)
@max_score(0)
def test_each_runner(test_name, depth_p, reset_val_p):
    # This line must be first
    parameters = dict(locals())
    del parameters['test_name']
    _runner(test_name, parameters)

# Opposite above, run all the tests in one simulation but reset
# between tests to ensure that reset is clearing all state.
@pytest.mark.parametrize("depth_p,reset_val_p", [(2, 1), (2, 0), (5, 63)])
@max_score(2)
def test_all_runner(depth_p, reset_val_p):
    # This line must be first
    parameters = dict(locals())
    _runner(None, parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@pytest.mark.parametrize("depth_p,reset_val_p", [(5, 63)])
@max_score(1)
def test_lint(depth_p, reset_val_p):
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only"], parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@pytest.mark.parametrize("depth_p,reset_val_p", [(5, 63)])
@max_score(1)
def test_style(depth_p, reset_val_p):
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

    reset_i._log.debug("Reset complete")

    # Always assign inputs on the falling edge
    if (not FinishFalling):
        await RisingEdge(dut.clk_i)
    

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

    reset_i = dut.reset_i
    data_o = dut.data_o

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    assert data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert data_o.value == dut.reset_val_p.value, f"Incorrect Result: data_o should be {dut.reset_val_p.value} after reset. Got: {data_o.value} at Time {get_sim_time(units='ns')}ns."

async def wait_for(clk_i, signal, value):
    while(signal.value.is_resolvable and signal.value != value):
        await FallingEdge(clk_i)

@cocotb.test()
async def en_tick_test(dut):
    """Test one clock cycle of the shift register"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')
    
    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz Frequency)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    data_o = dut.data_o
    data_i = dut.data_i
    enable_i = dut.enable_i

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    # First, test shifting in a 1
    data_i.value = 1
    enable_i.value = 1

    await FallingEdge(dut.clk_i)

    expected = ((dut.reset_val_p.value << 1) | dut.data_i.value) & ((1 << dut.depth_p.value) - 1)

    assert data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert data_o.value == expected, f"Incorrect Result: data_o != {expected}. Got: {data_o.value} at Time {get_sim_time(units='ns')}ns."

    await RisingEdge(dut.clk_i)

    # Then do the same test, but shift in a 0

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    data_i.value = 0
    enable_i.value = 1

    await FallingEdge(dut.clk_i)

    expected = ((dut.reset_val_p.value << 1) | dut.data_i.value) & ((1 << dut.depth_p.value) - 1)

    assert data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert data_o.value == expected, f"Incorrect Result: data_o != {expected}. Got: {data_o.value} at Time {get_sim_time(units='ns')}ns."


@cocotb.test()
async def bangen_tick_test(dut):
    """Test one clock cycle of the shift register, with enable low"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')
    
    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz Frequency)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    data_o = dut.data_o
    data_i = dut.data_i
    enable_i = dut.enable_i

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    # First, test shifting in a 1, but no enable
    data_i.value = 1
    enable_i.value = 0

    await FallingEdge(dut.clk_i)

    # Shouldn't change
    expected = dut.reset_val_p.value

    assert data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert data_o.value == expected, f"Incorrect Result: data_o != {expected}. Got: {data_o.value} at Time {get_sim_time(units='ns')}ns."

    await RisingEdge(dut.clk_i)

    # Then do the same test, but "shift" in a 0

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    data_i.value = 0
    enable_i.value = 0

    await FallingEdge(dut.clk_i)

    # Shouldn't change
    expected = dut.reset_val_p.value

    assert data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert data_o.value == expected, f"Incorrect Result: data_o != {expected}. Got: {data_o.value} at Time {get_sim_time(units='ns')}ns."

async def free_run_test(dut, l):
    """Test 100 cycles of the shift register"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')
    
    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz Frequency)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    clk_i = dut.clk_i
    reset_i = dut.reset_i
    data_o = dut.data_o
    data_i = dut.data_i
    enable_i = dut.enable_i

    await RisingEdge(clk_i)

    await reset(dut, reset_i, cycles=10, FinishFalling=True)

    data_i.value = 0
    enable_i.value = 0
    await FallingEdge(clk_i)

    expected = dut.reset_val_p.value
    mask = (1 << dut.depth_p.value) -1

    seq = [random.randint(0, 4) for i in range(l)]
    for i in seq:
        assert data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
        assert data_o.value == expected, f"Incorrect Result: data_o != {expected}. Got: {data_o.value} at Time {get_sim_time(units='ns')}ns."

        enable_i.value = (i == 1 or i == 3)
        data_i.value = (i == 2 or i == 3)
        await FallingEdge(dut.clk_i)
        if(enable_i.value):
            expected = ((expected << 1) | data_i.value) & mask
           
tf = TestFactory(test_function=free_run_test)
tf.add_option(name='l', optionlist=[100])
tf.generate_tests()

