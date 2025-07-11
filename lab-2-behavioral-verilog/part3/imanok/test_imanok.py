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
timescale = "1ps/1ps"
tests = ['reset_test',
         "sequence_single_test_001",
         "sequence_single_test_002",
         "sequence_single_test_003",
         "sequence_single_test_004",
         "sequence_single_test_005",
         "sequence_single_test_006",
         "sequence_single_test_007",
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
def test_each_runner(test_name):
    # This line must be first
    parameters = dict(locals())
    del parameters['test_name']
    _runner(test_name, parameters)

# Opposite above, run all the tests in one simulation but reset
# between tests to ensure that reset is clearing all state.
@max_score(8)
def test_all_runner():
    # This line must be first
    parameters = dict(locals())
    _runner(None, parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(.5)
def test_lint():
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only"], parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(.5)
def test_style():
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
    buttons = {
        "U":dut.up_i,
        "u":dut.unup_i,
        "R":dut.right_i,
        "r":dut.unright_i,
        "D":dut.down_i,
        "d":dut.undown_i,
        "l":dut.left_i,
        "L":dut.unleft_i,
        "a":dut.a_i,
        "A":dut.una_i,
        "b":dut.b_i,
        "B":dut.unb_i,
        "S":dut.start_i,
        "s":dut.unstart_i
    }
               
    clk_i = dut.clk_i
    reset_i = dut.reset_i
    unlocked_o = dut.cheat_code_unlocked_o
    
    for _,v in buttons.items():
        v.value = LogicArray(['x'])

    await reset(dut, reset_i, cycles=10, FinishFalling=True)

    for _,v in buttons.items():
        v.value = 0

    await FallingEdge(clk_i)

    assert unlocked_o.value.is_resolvable, f"Unresolvable value in cheat_code_unlocked_o (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert unlocked_o.value == 0 , f"Error! Cheat code unlocked after reset!. Got: {unlocked_o.value} at Time {get_sim_time(units='ns')}ns."

    
@cocotb.test()
async def reset_test(dut):
    """Test for Initialization"""

    await pretest_sequence(dut)
    await reset_sequence(dut)
    

async def sequence_single_test(dut, sequence):
    """Test for a single sequence of inputs"""

    await pretest_sequence(dut)
    await reset_sequence(dut)

    clk_i = dut.clk_i
    unlocked_o = dut.cheat_code_unlocked_o
    buttons = {
        "U":dut.up_i,
        "u":dut.unup_i,
        "R":dut.right_i,
        "r":dut.unright_i,
        "D":dut.down_i,
        "d":dut.undown_i,
        "L":dut.left_i,
        "l":dut.unleft_i,
        "A":dut.a_i,
        "a":dut.una_i,
        "B":dut.b_i,
        "b":dut.unb_i,
        "S":dut.start_i,
        "s":dut.unstart_i
    }


    history = ""
    goal = "SsAaBbRrLlRrLlDdDdUuUu"
    last = "u"
    unlocked = False
    for i in sequence:
        await FallingEdge(clk_i)
        # Check from posedge
        assert_resolvable(unlocked_o)
        assert unlocked_o.value == unlocked, f"Error! Cheat code unlocked does not match expected!. Got: {unlocked_o.value} at Time {get_sim_time(units='ns')}ns."

        # Set values
        buttons[last].value = 0
        buttons[i].value = 1
        last = i
        history = history + i
        unlocked = history.endswith(goal)
        await RisingEdge(clk_i)        

    await FallingEdge(clk_i)
    assert_resolvable(unlocked_o)
    assert unlocked_o.value == unlocked, f"Error! Cheat code unlocked does not match expected!. Got: {unlocked_o.value} at Time {get_sim_time(units='ns')}ns."

tf = TestFactory(test_function=sequence_single_test)

sequences = ["UUDDLRLRBAS"[::-1],
             "uuddlrlrbas"[::-1],
             "UUDDLRLRBASuuddlrlrbas"[::-1],
             "SsAaBbRrLlRrLlDdDdUuUu",
             "Ss",
             "SsAaBbRrLlRrLlDdDdUuUuUu",
             "SsSsAaBbRrLlRrLlDdDdUuUuUu",
             "SsAaBbRrLlRrLlDdDdUuUuSsAaBbRrLlRrLlDdDdUuUu"
             ]
tf.add_option(name='sequence', optionlist=sequences)
tf.generate_tests()
