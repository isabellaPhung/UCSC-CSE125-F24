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

tests = ['width_in',
         'width_out',
         'init_test',
         'add_test_001',
         'add_test_002',
         'add_test_003',
         'add_test_004',
         'add_test_005',
         'add_test_006',
         'add_test_007',
         'add_test_008',
         'add_test_009',
         ]
   
# Admittedly test_each approach is a bit hacky. If we treat Verilog
# parameters as pytest parameters, each parameterization runs all the
# tests within one simulation (fine, but not ideal). The drawback is
# that it is impossible to identify which test failed within a
# parameterization inside the simulation. Instead, we run each test
# individually by listing them as pytest parameters (but not a verilog
# parameters) so that they get tested individually.
@pytest.mark.parametrize("width_p", [2, 7])
@pytest.mark.parametrize("test_name", tests)
def test_each_runner(test_name, width_p):
    # This line must be first
    parameters = dict(locals())
    del parameters['test_name']
    _runner(test_name, parameters)

# Opposite above, run all the tests in one simulation but reset
# between tests to ensure that reset is clearing all state.
@pytest.mark.parametrize("width_p", [2, 7])
@max_score(1)
def test_all_runner(width_p):
    # This line must be first
    parameters = dict(locals())
    _runner(None, parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(.5)
@pytest.mark.parametrize("width_p", [7])
def test_lint(width_p):
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only"], parameters)

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@pytest.mark.parametrize("width_p", [7])
@max_score(.5)
def test_style(width_p):
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only", "-Wwarn-style", "-Wno-lint"], parameters)


### Begin Tests ###

@cocotb.test()
async def width_out(dut):
    """The width of sum_o should be equal to width_p, and a_i, b_i should be equal to width_p -1"""
    assert len(dut.sum_o) == (dut.width_p.value + 1)

@cocotb.test()
async def width_in(dut):
    """The width of sum_o should be equal to width_p, and a_i, b_i should be equal to width_p -1"""
    assert len(dut.a_i) == (dut.width_p.value)
    assert len(dut.b_i) == (dut.width_p.value)

@cocotb.test()
async def init_test(dut):
    """Test for Basic Connectivity"""

    A = 0
    B = 0

    dut.a_i.value = 0
    dut.b_i.value = 0

    await Timer(1, units="ns")

    assert_resolvable(dut.sum_o)
    
async def add_test(dut, a, b):
    """Test for adding two numbers"""

    # I would like to test numbers that depend on the parameters to
    # the DUT (e.g. width_p), but the parameters are not available
    # until test runtime, so we occasionally have to pass in strings
    # that reference the DUT. Hence, these if/else statements (until I
    # find a better way).
    
    if(isinstance(a, int)):
        A = a
    else:
        A = eval(a)

    if(isinstance(b, int)):
        B = b
    else:
        B = eval(b)
    
    dut.a_i.value = A
    dut.b_i.value = B

    await Timer(1, units="ns")

    assert_resolvable(dut.sum_o)
    assert dut.sum_o.value == (A + B) , f"Incorrect Result: {dut.a_i.value} + {dut.b_i.value} != {dut.a_i.value + dut.b_i.value}. Got: {dut.sum_o.value} at Time {get_sim_time(units='ns')}ns."

tf = TestFactory(test_function=add_test)

test = "sum"
for a,b in [(0,0), (0,1), (1,0), (1,1)]:
    tf.add_option(name='a', optionlist=[a])
    tf.add_option(name='b', optionlist=[b])
    #tf.generate_tests(prefix=f"{test}(a={a},b={b})_")
    tf.generate_tests()

test = "carryin"
for a,b in [(1,2), (2,1)]:
    tf.add_option(name='a', optionlist=[a])
    tf.add_option(name='b', optionlist=[b])
    #tf.generate_tests(prefix=f"{test}(a={a},b={b})_")
    tf.generate_tests()

tf.add_option(name='a', optionlist=["(1 << len(dut.a_i)) - 1"])
tf.add_option(name='b', optionlist=[1])
#tf.generate_tests(prefix="carryout(a=maxval,b=1)_")
tf.generate_tests()

tf.add_option(name='a', optionlist=[1])
tf.add_option(name='b', optionlist=["(1 << len(dut.a_i)) - 1"])
#tf.generate_tests(prefix="carryout(a=1,b=maxval)_")
tf.generate_tests()

tf.add_option(name='a', optionlist=["(1 << len(dut.a_i)) - 1"])
tf.add_option(name='b', optionlist=["(1 << len(dut.a_i)) - 1"])
#tf.generate_tests(prefix="carryout(a=maxval,b=maxval)_")
tf.generate_tests()

tf.add_option(name='a', optionlist=3*["random.randint(0, (1 << len(dut.a_i)) - 1)"])
tf.add_option(name='b', optionlist=3*["random.randint(0, (1 << len(dut.b_i)) - 1)"])
#tf.generate_tests(prefix="random_")
tf.generate_tests()

