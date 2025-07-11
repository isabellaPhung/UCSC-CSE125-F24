# Utility functions for parsing the filelist. Each module directory
# must have filelist.json with keys for "top" and "files", like so:

# {
#     "top": "hello",
#     "files":
#     ["part1/sim/hello.sv"
#     ]
# }

# Each file in the filelist is relative to the repository root.

import os
import json

def get_files_from_filelist(p, n):
    """ Get a list of files from a json filelist.

    Arguments:
    p -- Path to the directory that contains the .json file
    n -- name of the .json file to read.
    """
    n = os.path.join(p, n)
    with open(n) as filelist:
        files = json.load(filelist)["files"]
    return files

def get_sources(r, p):
    """ Get a list of source file paths from a json filelist.

    Arguments:
    r -- Absolute path to the root of the repository.
    p -- Absolute path to the directory containing filelist.json
    """
    sources = get_files_from_filelist(p, "filelist.json")
    sources = [os.path.join(r, f) for f in sources]
    return sources

def get_top(p):
    """ Get the name of the top level module from a filelist.json.

    Arguments:
    p -- Absolute path to the directory containing filelist.json
    """
    return get_top_from_filelist(p, "filelist.json")

def get_top_from_filelist(p, n):
    """ Get the name of the top level module a json filelist.

    Arguments:
    p -- Absolute path to the directory containing filelist.json
    n -- name of the .json file to read.
    """
    n = os.path.join(p, n)
    with open(n) as filelist:
        top = json.load(filelist)["top"]
        return top

def get_param_string(parameters):
    """ Get a string of all the parameters concatenated together.

    Arguments:
    parameters -- a list of key value pairs
    """
    return "_".join(("{}={}".format(*i) for i in parameters.items()))

from cocotb.utils import get_sim_time

def assert_resolvable(s):
    assert s.value.is_resolvable, f"Unresolvable value in {s._path} (x or z in some or all bits) at Time {get_sim_time(units='ns')}ns."
