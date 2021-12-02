import os
# import subprocess
from fnmatch import fnmatch
import time
import sys
# import re

from list_of_tests import *
from list_of_runs import *

# --------------------------------------------------------------------------------------------------------------------------------
def print_results(tb_path):
    list_of_results = []
    for path, dirs, files in os.walk(tb_path):
        for name in files:
            if fnmatch(name, pattern):
                # print(os.path.join(path, name))
                list_of_results.append(os.path.join(path, name))
    return list_of_results

def check_results(tb_path):
    fin = open(tb_path, "rt")
    result = fin.read()
    fin.close()
    return result

# --------------------------------------------------------------------------------------------------------------------------------
# get start time
start_time = time.time()

# get list of tests
tb_path = get_list_of_tests()

# pattern for test results
pattern = "*RESULT"
all_results = ""

dlmtr = "----------------------------------------------------------------------------------------------------------------------\n"

if (sys.argv[1] == "clean"):
    subprocess.call(["make", "clean_rest"])

# main loop
for f in range(len(tb_path)):
    test_start_time = time.time()

    # if (tb_path[f][0] == 1):
    if (sys.argv[1] == "clean"):
        run_clean(tb_path[f][1])
    if (sys.argv[1] == "all"):
        if (tb_path[f][0] == 0):
            run_build(tb_path[f][1], sys.argv[2])
        if (tb_path[f][0] == 1):
            run_all(tb_path[f][1], sys.argv[2])
    if (sys.argv[1] == "build"):
        run_build(tb_path[f][1], sys.argv[2])
    if (sys.argv[1] == "run_tests"):
        if (tb_path[f][0] == 0):
            run_build(tb_path[f][1], sys.argv[2])
        else:
            run_tests(tb_path[f][1], sys.argv[2])

    list_of_results = print_results(tb_path[f][1])
    all_results += dlmtr
    all_results += tb_path[f][1] + "\n"
    all_results += dlmtr
    # print(list_of_results)
    if (list_of_results == []):
        all_results += "NO RESULTS\n"
    for resf in range (len(list_of_results)):
        current_result = check_results(list_of_results[resf])
        # print(current_result + "\t" + list_of_results[resf])
        all_results += (current_result + "\t" + list_of_results[resf] + "\n")

    test_finish_time = time.time()
    test_total_time = test_finish_time - test_start_time

    all_results += "TIME:\t" + time.strftime("%H:%M:%S", time.gmtime(test_total_time)) + "\n"
    all_results += "\n"

all_results += dlmtr

# get finish time
finish_time = time.time()
total_time = finish_time - start_time

all_results += "PING:\t" + time.strftime("%b %d %Y %H:%M:%S", time.gmtime(start_time)) + "\n"
all_results += "PONG:\t" + time.strftime("%b %d %Y %H:%M:%S", time.gmtime(finish_time)) + "\n"
all_results += "TIME:\t" + time.strftime("%H:%M:%S", time.gmtime(total_time)) + "\n"

all_results += dlmtr
all_results += "DONE"

if (sys.argv[1] == "all" or sys.argv[1] == "build" or sys.argv[1] == "run_tests"):
    print(all_results)

    fin = open("RESULT", "wt")
    fin.write(all_results)
    fin.close()