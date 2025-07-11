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
from cocotb.types import LogicArray, Range

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

    temp = ps.copy()
    del temp['filename_p']
    work_dir = os.path.join(_DIR_PATH, "run", name, get_param_string(temp), simulator)
    sim_build = os.path.join(_DIR_PATH, "build", get_param_string(temp))

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

timescale = "1ps/1ps"
tests = ['reset_test',
         "read_all_test",
         "write_limit_test",
         "write_and_reset",
         "conflict_test"
         ]

# Admittedly test_each approach is a bit hacky. If we treat Verilog
# parameters as pytest parameters, each parameterization runs all the
# tests within one simulation (fine, but not ideal). The drawback is
# that it is impossible to identify which test failed within a
# parameterization inside the simulation. Instead, we run each test
# individually by listing them as pytest parameters (but not a verilog
# parameters) so that they get tested individually.
@pytest.mark.parametrize("width_p,depth_p,filename_p", [(8, 8, "8x8.hex"), (11, 17, "11x17.hex")])
@pytest.mark.parametrize("test_name", tests)
def test_each_runner(test_name, width_p, depth_p, filename_p):
    # This line must be first
    parameters = dict(locals())
    del parameters['test_name']
    # Curse... something.
    del parameters['filename_p']
    parameters['filename_p'] = f"\"{filename_p}\""
    _runner(test_name, parameters, ds=[f'HEXPATH="{_DIR_PATH}/"'])

# Opposite above, run all the tests in one simulation but reset
# between tests to ensure that reset is clearing all state.
@pytest.mark.parametrize("width_p,depth_p,filename_p", [(8, 8, "8x8.hex"), (11, 17, "11x17.hex")])
@max_score(2)
def test_all_runner(width_p, depth_p, filename_p):
    # This line must be first
    parameters = dict(locals())
    # Curse... something.
    del parameters['filename_p']
    parameters['filename_p'] = f"\"{filename_p}\""
    _runner(None, parameters, ds=[f'HEXPATH="{_DIR_PATH}/"'])

@pytest.mark.parametrize("width_p,depth_p,filename_p", [(11, 17, "11x17.hex")])
@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(.5)
def test_lint(width_p, depth_p, filename_p):
    # This line must be first
    parameters = dict(locals())
    # Curse... something.
    del parameters['filename_p']
    parameters['filename_p'] = f"\"{filename_p}\""
    _lint(["--lint-only"], parameters, ds=[f'HEXPATH="{_DIR_PATH}/"'])

@pytest.mark.parametrize("width_p,depth_p,filename_p", [(11, 17, "11x17.hex")])
@pytest.mark.skipif(not os.getenv('SIM').lower().startswith("verilator"), reason="Requires Verilator")
@max_score(.5)
def test_style(width_p, depth_p, filename_p):
    # This line must be first
    parameters = dict(locals())
    # Curse... something.
    del parameters['filename_p']
    parameters['filename_p'] = f"\"{filename_p}\""
    _lint(["--lint-only", "-Wwarn-style", "-Wno-lint"], parameters, ds=[f'HEXPATH="{_DIR_PATH}/"'])

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

    wr_valid_i = dut.wr_valid_i
    wr_data_i = dut.wr_data_i
    wr_addr_i = dut.wr_addr_i

    rd_data_o = dut.rd_data_o
    rd_addr_i = dut.rd_addr_i

    inputs = [wr_valid_i, wr_data_i, wr_addr_i, rd_addr_i]

    for p in inputs:
        p.value = LogicArray(['x'] * len(p))

    await reset(dut, reset_i, cycles=10, FinishFalling=True)

    for p in inputs:
        p.value = 0

    await FallingEdge(clk_i)

    assert rd_data_o.value.is_resolvable, f"Unresolvable value in rd_data_o (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."


@cocotb.test()
async def reset_test(dut):
    """Test for Initialization"""

    await pretest_sequence(dut)
    await reset_sequence(dut)

@cocotb.test()
async def read_all_test(dut):
    """Test for Ingesting Memory Initialization Files"""

    await pretest_sequence(dut)
    await reset_sequence(dut)

    clk_i = dut.clk_i
    wr_valid_i = dut.wr_valid_i
    wr_data_i = dut.wr_data_i
    wr_addr_i = dut.wr_addr_i

    rd_data_o = dut.rd_data_o
    rd_addr_i = dut.rd_addr_i

    inputs = [wr_valid_i, wr_data_i, wr_addr_i, rd_addr_i]

    for p in inputs:
        p.value = 0

    await FallingEdge(clk_i)

    for i in range(0, dut.depth_p.value):
        rd_addr_i.value = i

        await FallingEdge(clk_i)

        expected = (dut.depth_p.value - i - 1)
        assert rd_data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
        assert rd_data_o.value == expected, f"Incorrect result read from memory: Expected {expected}. Got: {rd_data_o.value} at Time {get_sim_time(units='ns')}ns."

@cocotb.test()
async def write_limit_test(dut):
    """Test for the first and last addresses"""

    await pretest_sequence(dut)
    await reset_sequence(dut)

    clk_i = dut.clk_i

    wr_valid_i = dut.wr_valid_i
    wr_data_i = dut.wr_data_i
    wr_addr_i = dut.wr_addr_i

    rd_data_o = dut.rd_data_o
    rd_addr_i = dut.rd_addr_i

    inputs = [wr_valid_i, wr_data_i, wr_addr_i, rd_addr_i]
    depth = dut.depth_p.value
    width = dut.width_p.value
    for p in inputs:
        p.value = 0

    await FallingEdge(clk_i)

    s = '01' * depth
    wr_addr_i.value = 0
    wr_data_i.value = LogicArray(s[0:width], Range(width-1,'downto', 0))
    wr_valid_i.value = 1

    await FallingEdge(clk_i)

    wr_addr_i.value = depth - 1
    wr_data_i.value = LogicArray(s[1:width + 1], Range(width-1,'downto', 0))
    wr_valid_i.value = 1

    await FallingEdge(clk_i)

    wr_addr_i.value = 0
    wr_data_i.value = 0
    wr_valid_i.value = 0

    # Wait a bit, to see what happens.
    await FallingEdge(clk_i)
    await FallingEdge(clk_i)
    await FallingEdge(clk_i)

    rd_addr_i.value = 0
    expected = LogicArray(s[0:width]).integer

    await FallingEdge(clk_i)

    assert rd_data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert rd_data_o.value == expected, f"Incorrect result read back from address 0: Expected {expected}. Got: {rd_data_o.value} at Time {get_sim_time(units='ns')}ns."

    rd_addr_i.value = depth-1
    expected = LogicArray(s[1:width + 1], Range(width-1,'downto', 0)).integer

    await FallingEdge(clk_i)

    assert rd_data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert rd_data_o.value == expected, f"Incorrect result read from address {depth_p-1}: Expected {expected}. Got: {rd_data_o.value} at Time {get_sim_time(units='ns')}ns."

@cocotb.test()
async def write_and_reset(dut):
    """Test for writing while under reset"""

    await pretest_sequence(dut)
    await reset_sequence(dut)

    clk_i = dut.clk_i
    reset_i = dut.reset_i

    wr_valid_i = dut.wr_valid_i
    wr_data_i = dut.wr_data_i
    wr_addr_i = dut.wr_addr_i

    rd_data_o = dut.rd_data_o
    rd_addr_i = dut.rd_addr_i

    inputs = [wr_valid_i, wr_data_i, wr_addr_i, rd_addr_i]
    depth = dut.depth_p.value
    width = dut.width_p.value

    for p in inputs:
        p.value = 0

    await FallingEdge(clk_i)

    s = '11' * width
    wr_addr_i.value = 1
    wr_data_i.value = LogicArray(s[0:width], Range(width - 1,'downto', 0))
    wr_valid_i.value = 1

    await FallingEdge(clk_i)

    wr_addr_i.value = 0
    wr_data_i.value = 0
    wr_valid_i.value = 0

    # Wait a bit, to see what happens.
    await FallingEdge(clk_i)
    await FallingEdge(clk_i)
    await FallingEdge(clk_i)

    s = '0' * width
    wr_addr_i.value = 1
    reset_i.value = 1
    wr_data_i.value = LogicArray(s[0:width], Range(width - 1,'downto', 0))
    wr_valid_i.value = 1

    await FallingEdge(clk_i)

    wr_addr_i.value = 1
    reset_i.value = 0
    wr_data_i.value = LogicArray(s[0:width], Range(width - 1,'downto', 0))
    wr_valid_i.value = 0

    await FallingEdge(clk_i)
    await FallingEdge(clk_i)
    await FallingEdge(clk_i)

    rd_addr_i.value = 1
    s = '1' * width
    expected = LogicArray(s[0:width]).integer

    await FallingEdge(clk_i)

    assert rd_data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert rd_data_o.value == expected, f"Incorrect result. Writing during reset should not affect memory contents. Expected {expected}. Got: {rd_data_o.value} at Time {get_sim_time(units='ns')}ns."


@cocotb.test()
async def conflict_test(dut):
    """Test for writing and reading the same address"""

    await pretest_sequence(dut)
    await reset_sequence(dut)

    clk_i = dut.clk_i
    reset_i = dut.reset_i

    wr_valid_i = dut.wr_valid_i
    wr_data_i = dut.wr_data_i
    wr_addr_i = dut.wr_addr_i

    rd_data_o = dut.rd_data_o
    rd_addr_i = dut.rd_addr_i

    inputs = [wr_valid_i, wr_data_i, wr_addr_i, rd_addr_i]
    depth = dut.depth_p.value
    width = dut.width_p.value

    for p in inputs:
        p.value = 0

    await FallingEdge(clk_i)

    s = '11' * width
    wr_addr_i.value = 1
    wr_data_i.value = LogicArray(s[0:width], Range(width - 1,'downto', 0))
    wr_valid_i.value = 1

    await FallingEdge(clk_i)

    wr_addr_i.value = 0
    wr_data_i.value = 0
    wr_valid_i.value = 0

    # Wait a bit, to see what happens.
    await FallingEdge(clk_i)
    await FallingEdge(clk_i)
    await FallingEdge(clk_i)

    s = '0' * width
    wr_addr_i.value = 1
    rd_addr_i.value = 1
    wr_data_i.value = LogicArray(s[0:width], Range(width - 1,'downto', 0))
    wr_valid_i.value = 1

    await RisingEdge(clk_i)

    s = '1' * width
    expected = LogicArray(s[0:width]).integer

    assert rd_data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert rd_data_o.value == expected, f"Incorrect result. Reading while writing the same address should return old data. Expected {expected}. Got: {rd_data_o.value} at Time {get_sim_time(units='ns')}ns."

    await FallingEdge(clk_i)

    s = '0' * width
    expected = LogicArray(s[0:width]).integer

    assert rd_data_o.value.is_resolvable, f"Unresolvable value (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
    assert rd_data_o.value == expected, f"Incorrect result. Reading while writing the same address should return new data after the clock edge. Expected {expected}. Got: {rd_data_o.value} at Time {get_sim_time(units='ns')}ns."
