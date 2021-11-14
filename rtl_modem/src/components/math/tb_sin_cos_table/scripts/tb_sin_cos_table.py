import subprocess
import codecs
import re
import shutil
import time
import random

#---------------------------------------------------------------------------------------------------------------------------------
# result message
#---------------------------------------------------------------------------------------------------------------------------------
all_results = ""
some_tabs = "    "
dlmtr = "----------------------------------------------------------------------------------------------------------------------\n"

all_results += "\n"
all_results += dlmtr
all_results += some_tabs
all_results += "sin_cos_table.vhdl\n"
all_results += dlmtr

#---------------------------------------------------------------------------------------------------------------------------------
# settings
#---------------------------------------------------------------------------------------------------------------------------------
tests = [
      "pipe"
    , "solid"
]
number_of_tests = 10

result_folder = '_result'
transcript_name = "transcript"
config_full_table = 0
total_result = "PASS"

#---------------------------------------------------------------------------------------------------------------------------------
# get start time
#---------------------------------------------------------------------------------------------------------------------------------
start_time = time.time()

#---------------------------------------------------------------------------------------------------------------------------------
# build sources
#---------------------------------------------------------------------------------------------------------------------------------
subprocess.call(["make", "build"])
subprocess.call(["mkdir", "_result"])
subprocess.call(["mkdir", "_result/seeds"])

#---------------------------------------------------------------------------------------------------------------------------------
# run all tests
#---------------------------------------------------------------------------------------------------------------------------------
for j in tests:
    for i in range(number_of_tests):
        test_name = j
        uvm_name = test_name + "_uvm"
        config_full_table = random.randint(0, 1)
        subprocess.call(["make", uvm_name, "CONFIG_FULL_TABLE=%d" % config_full_table])

        # read transcript
        fin = codecs.open(transcript_name, 'r')
        data_src = fin.read()
        fin.close()

        # if test is passed then it contains "TEST_PASSED" message
        result_pass = re.findall(r"TEST_FAILED", data_src)
        if (result_pass != []):
            current_result = "FAIL"
            total_result = "FAIL"
        else:
            current_result = "PASS"

        # get seed from the transcript
        seed = re.findall(r"Sv_Seed = \d+", data_src)
        seed = re.findall(r"\d+", seed[0])
        # print(seed)

        namestr_number = "number_" + str(i)
        namestr_seed = "seed_" + seed[0]
        newname = \
              current_result + some_tabs \
            + test_name + "_" \
            + namestr_number + "_" \
            + namestr_seed \
            + ".log"
        shutil.move(transcript_name, result_folder + '/seeds/' + newname)

        all_results += newname + "\n"

    all_results += dlmtr

#---------------------------------------------------------------------------------------------------------------------------------
# get finish time
#---------------------------------------------------------------------------------------------------------------------------------
finish_time = time.time()

all_results += "start time: \t" + time.strftime("%b %d %Y %H:%M:%S", time.gmtime(start_time)) + "\n"
all_results += "finish_time:\t" + time.strftime("%b %d %Y %H:%M:%S", time.gmtime(finish_time)) + "\n"

#---------------------------------------------------------------------------------------------------------------------------------
# print result message
#---------------------------------------------------------------------------------------------------------------------------------
print(all_results)

#---------------------------------------------------------------------------------------------------------------------------------
# print result to file
#---------------------------------------------------------------------------------------------------------------------------------
result_output_file_name = result_folder + "/tests.RESULT"
fout = codecs.open(result_output_file_name, 'w')
fout.write(total_result)
fout.close