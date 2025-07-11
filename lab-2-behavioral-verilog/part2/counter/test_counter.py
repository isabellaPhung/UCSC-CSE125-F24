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
         'up_test',
         'down_test',
         'updown_test',
         'overflow_test',
         'underflow_test',
         'fuzz_test_001',
         'fuzz_test_002',
         'fuzz_test_003']

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
@pytest.mark.parametrize("width_p,reset_val_p", [(2, 1), (7, 11), (5, 31), (4, 0)])
@pytest.mark.parametrize("test_name", tests)
def test_each_runner(test_name, width_p, reset_val_p):
    # This line must be first
    parameters = dict(locals())
    del parameters['test_name']
    _runner(test_name, parameters)

# Opposite above, run all the tests in one simulation but reset
# between tests to ensure that reset is clearing all state.
@pytest.mark.parametrize("width_p,reset_val_p", [(2, 1), (7, 11), (5, 31), (4, 0)])
@max_score(.5)
def test_all_runner(width_p, reset_val_p):
    # This line must be first
    parameters = dict(locals())
    _runner(None, parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@pytest.mark.parametrize("width_p", [7])
@pytest.mark.parametrize("reset_val_p", [2])
@max_score(.5)
def test_lint(width_p, reset_val_p):
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only"], parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@pytest.mark.parametrize("width_p", [7])
@pytest.mark.parametrize("reset_val_p", [1])
@max_score(.5)
def test_style(width_p, reset_val_p):
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

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')

    # Unrealistically fast clock, but nice for mental math (1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    up_i = dut.up_i
    down_i = dut.down_i
    count_o = dut.count_o

    up_i.value = LogicArray(['x'])
    down_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    # Set the initial inputs
    up_i.value = 0
    down_i.value = 0

    # Always check outputs on the rising edge
    await RisingEdge(dut.clk_i)

    ex_val = dut.reset_val_p.value

    assert count_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert count_o.value == ex_val , f"Incorrect Result: count_o != {ex_val}. Got: {count_o.value} at Time {get_sim_time(units='ns')}ns."


@cocotb.test()
async def up_test(dut):
    """Test up_i"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')
    
    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz Frequency)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    up_i = dut.up_i
    down_i = dut.down_i
    count_o = dut.count_o

    up_i.value = LogicArray(['x'])
    down_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    # Always Set Inputs on the falling edge
    up_i.value = 0
    down_i.value = 0

    # Always check outputs on the rising edge
    await RisingEdge(dut.clk_i)
    
    await FallingEdge(dut.clk_i)
    up_i.value = 1
    
    # Increment once.
    await RisingEdge(dut.clk_i)

    ex_val = dut.reset_val_p.value + 1
    if(ex_val == (1 << len(dut.count_o))):
       ex_val = 0

    await FallingEdge(dut.clk_i)
    up_i.value = 0

    # Check after one cycle of up
    assert count_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert count_o.value == ex_val , f"Incorrect Result: count_o != {ex_val}. Got: {count_o.value} at Time {get_sim_time(units='ns')}ns."

    await RisingEdge(dut.clk_i)

    # Value should remain constant.
    assert count_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert count_o.value == ex_val , f"Incorrect Result: count_o != {ex_val}. Got: {count_o.value} at Time {get_sim_time(units='ns')}ns."

@cocotb.test()
async def down_test(dut):
    """Test down_i"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')

    # Unrealistically fast clock, but nice for mental math (1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    up_i = dut.up_i
    down_i = dut.down_i
    count_o = dut.count_o

    up_i.value = LogicArray(['x'])
    down_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    # Always Set Inputs on the falling edge
    up_i.value = 0
    down_i.value = 0

    # Always check outputs on the rising edge
    await RisingEdge(dut.clk_i)
    
    await FallingEdge(dut.clk_i)
    down_i.value = 1
    
    # Increment once.
    await RisingEdge(dut.clk_i)

    ex_val = dut.reset_val_p.value - 1

    if(ex_val == -1):
       ex_val = (1 << len(dut.count_o)) -1

    await FallingEdge(dut.clk_i)
    down_i.value = 0

    # Check after one cycle of down
    assert count_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert count_o.value == ex_val , f"Incorrect Result: count_o != {ex_val}. Got: {count_o.value} at Time {get_sim_time(units='ns')}ns."

    await RisingEdge(dut.clk_i)

    # Value should remain constant.
    assert count_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert count_o.value == ex_val , f"Incorrect Result: count_o != {ex_val}. Got: {count_o.value} at Time {get_sim_time(units='ns')}ns."

@cocotb.test()
async def updown_test(dut):
    """Test for up_i and down_i (Simultaneously)"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')

    # Unrealistically fast clock, but nice for mental math (1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    up_i = dut.up_i
    down_i = dut.down_i
    count_o = dut.count_o

    up_i.value = LogicArray(['x'])
    down_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    # Always Set Inputs on the falling edge
    up_i.value = 0
    down_i.value = 0

    # Always check outputs on the rising edge
    await RisingEdge(dut.clk_i)
    
    await FallingEdge(dut.clk_i)
    up_i.value = 1
    down_i.value = 1
    
    # Increment once.
    await RisingEdge(dut.clk_i)

    ex_val = dut.reset_val_p.value

    await FallingEdge(dut.clk_i)
    up_i.value = 0
    down_i.value = 0

    # Check after one cycle of down
    assert count_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert count_o.value == ex_val , f"Incorrect Result: count_o != {ex_val}. Got: {count_o.value} at Time {get_sim_time(units='ns')}ns."

    await RisingEdge(dut.clk_i)

    # Value should remain constant.
    assert count_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert count_o.value == ex_val , f"Incorrect Result: count_o != {ex_val}. Got: {count_o.value} at Time {get_sim_time(units='ns')}ns."

async def wait_for(dut, value):
    while(dut.count_o.value.is_resolvable and dut.count_o.value != value):
        await FallingEdge(dut.clk_i)

@cocotb.test()
async def overflow_test(dut):
    """Test for Overflow"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')
    
    # Unrealistically fast clock, but nice for mental math (1 ns period == 1 GHz Frequency)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    up_i = dut.up_i
    down_i = dut.down_i
    count_o = dut.count_o

    up_i.value = LogicArray(['x'])
    down_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    # Always Set Inputs on the falling edge
    up_i.value = 0
    down_i.value = 0
    
    await FallingEdge(dut.clk_i)
    up_i.value = 1
    
    count_to = (1<<dut.width_p.value)-1
    ex_val = count_to
    await with_timeout(wait_for(dut, value=count_to), count_to + 1, 'ns')

    # Increment once more.
    await FallingEdge(dut.clk_i)

    assert count_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert count_o.value == 0 , f"Incorrect Result: count_o != {ex_val}. Got: {count_o.value} at Time {get_sim_time(units='ns')}ns."

@cocotb.test()
async def underflow_test(dut):
    """Test for Underflow"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')

    # Unrealistically fast clock, but nice for mental math (1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    up_i = dut.up_i
    down_i = dut.down_i
    count_o = dut.count_o

    up_i.value = LogicArray(['x'])
    down_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    # Always Set Inputs on the falling edge
    up_i.value = 0
    down_i.value = 0
    
    await FallingEdge(dut.clk_i)
    down_i.value = 1
    
    count_to = 0
    ex_val = (1<<dut.width_p.value)-1
    await with_timeout(wait_for(dut, value=0), dut.reset_val_p.value + 1, 'ns')

    # Decrement once more to underflow
    await FallingEdge(dut.clk_i)

    assert count_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert count_o.value == ex_val, f"Incorrect Result: count_o != {ex_val}. Got: {count_o.value} at Time {get_sim_time(units='ns')}ns."

async def fuzz_test(dut, l):
    """Test for Random Input"""

    # Set the clock to Z for 10 ns. This helps separate tests.
    dut.clk_i.value = LogicArray(['z'])
    await Timer(10, 'ns')

    # Unrealistically fast clock, but nice for mental math (1 GHz)
    c = Clock(dut.clk_i, 1, 'ns')

    # Start the clock (soon). Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(c.start(start_high=False))

    reset_i = dut.reset_i
    up_i = dut.up_i
    down_i = dut.down_i
    count_o = dut.count_o

    up_i.value = LogicArray(['x'])
    down_i.value = LogicArray(['x'])

    await RisingEdge(dut.clk_i)

    await reset(dut, dut.reset_i, cycles=10, FinishFalling=True)

    # Set the initial inputs
    up_i.value = 0
    down_i.value = 0

    await FallingEdge(dut.clk_i)

    seq = [random.randint(0, 4) for i in range(l)]
    for i in seq:
        await FallingEdge(dut.clk_i)
        up_i.value = (i == 1 or i == 3)
        down_i.value = (i == 2 or i == 3)

    await FallingEdge(dut.clk_i)

    ctrseq = list(range((1<<dut.width_p.value)))
    idx = seq.count(1) + dut.reset_val_p.value - seq.count(2)
    idx = idx % len(ctrseq)
    ex_val = ctrseq[idx]
    
    assert count_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert count_o.value == ex_val , f"Incorrect Result: count_o != {ex_val}. Got: {count_o.value} at Time {get_sim_time(units='ns')}ns."

tf = TestFactory(test_function=fuzz_test)
tf.add_option(name='l', optionlist=[10, 100, 1000])
tf.generate_tests()
