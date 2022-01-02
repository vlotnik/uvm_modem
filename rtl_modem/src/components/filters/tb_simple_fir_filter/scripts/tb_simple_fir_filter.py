import sys
import time
import random

UVM_PATH = "../../../../.."
sys.path.insert(0, UVM_PATH + "/scripts/")
from test_runner import *

#---------------------------------------------------------------------------------------------------------------------------------
start_time = time.time()

#---------------------------------------------------------------------------------------------------------------------------------
# result message
#---------------------------------------------------------------------------------------------------------------------------------
total_result = "PASS"
tb_top_name = "simple_fir_filter"
all_results = make_som(tb_top_name)

#---------------------------------------------------------------------------------------------------------------------------------
# settings
#---------------------------------------------------------------------------------------------------------------------------------
tests = [
      "base"
]
number_of_tests = 10

config = {
      "g_nof_taps" : 32
    , "g_coef_dw" : 16
    , "g_sample_dw" : 12
    , "sv_seed" : 0
}

#---------------------------------------------------------------------------------------------------------------------------------
# build sources
#---------------------------------------------------------------------------------------------------------------------------------
call_build()

#---------------------------------------------------------------------------------------------------------------------------------
# run all tests
#---------------------------------------------------------------------------------------------------------------------------------
for j in tests:
    for i in range(number_of_tests):
        test_name = j
        uvm_name = test_name + "_uvm"

        config["g_nof_taps"] = random.randint(8, 64)
        config["g_coef_dw"] = random.randint(8, 16)
        config["g_sample_dw"] = random.randint(8, 16)
        config["sv_seed"] = random.randint(0, MAX_SEED)

        call_uvm_test(uvm_name, config)

        current_result = get_current_result()
        if (current_result == "FAIL"):
            total_result = current_result
        copy_log_file(i, config["sv_seed"], current_result, test_name)
        current_result_str = get_current_result_str(current_result, test_name, config)

        all_results += current_result_str + "\n"

    all_results += dlmtr

finish_time = time.time()
#---------------------------------------------------------------------------------------------------------------------------------

result_time = get_result_time(start_time, finish_time)
all_results += result_time

#---------------------------------------------------------------------------------------------------------------------------------
# print result message
#---------------------------------------------------------------------------------------------------------------------------------
print(all_results)
make_result_file(total_result)