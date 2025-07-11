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
from cocotb.binary import BinaryValue

_DIR_PATH = os.path.dirname(os.path.realpath(__file__))
_MODULE= "test_" + os.path.basename(_DIR_PATH)

timescale = "1ps/1ps"
tests = ['init_test',
         'all_test'
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
    _runner(test_name, parameters, ds=[f'HEXPATH="{_DIR_PATH}/"'])

# Opposite above, run all the tests in one simulation but reset
# between tests to ensure that reset is clearing all state.
@max_score(1)
def test_all_runner():
    # This line must be first
    parameters = dict(locals())
    _runner(None, parameters, ds=[f'HEXPATH="{_DIR_PATH}/"'])

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(.5)
def test_lint():
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only"], parameters, ds=[f'HEXPATH="{_DIR_PATH}/"'])

@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(.5)
def test_style():
    # This line must be first
    parameters = dict(locals())
    _lint(["--lint-only", "-Wwarn-style", "-Wno-lint"], parameters, ds=[f'HEXPATH="{_DIR_PATH}/"'])
@cocotb.test()
async def init_test(dut):
    """Test for Basic Connectivity"""

    hex_i = dut.hex_i
    hex_i.value = 0

    await Timer(1, units="ns")

    assert dut.ssd_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."


@cocotb.test()
async def all_test(dut):
    """Test for converting numbers from graycode to binary"""

    hex_i = dut.hex_i
    hex_i.value = 0

    values = {0:BinaryValue(0x40, 7, False),
              1:BinaryValue(0x79, 7, False),
              2:BinaryValue(0x24, 7, False),
              3:BinaryValue(0x30, 7, False),
              4:BinaryValue(0x19, 7, False),
              5:BinaryValue(0x12, 7, False),
              6:BinaryValue(0x02, 7, False),
              7:BinaryValue(0x78, 7, False),
              8:BinaryValue(0x00, 7, False),
              9:BinaryValue(0x18, 7, False),
              10:BinaryValue(0x08, 7, False),
              11:BinaryValue(0x03, 7, False),
              12:BinaryValue(0x46, 7, False),
              13:BinaryValue(0x21, 7, False),
              14:BinaryValue(0x06, 7, False),
              15:BinaryValue(0x0e, 7, False)}

    await Timer(1, units="ns")

    assert dut.ssd_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."

    for i in range(0, (1 << len(hex_i)) - 1):
       hex_i.value = i

       await Timer(1, units="ns")
       assert dut.ssd_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."

       expected = values[hex_i.value.integer]
       assert dut.ssd_o.value == (expected) , f"Incorrect Result: hex_i == {hex_i.value}. Got: ssd_o == {dut.ssd_o.value} at Time {get_sim_time(units='ns')}ns."
