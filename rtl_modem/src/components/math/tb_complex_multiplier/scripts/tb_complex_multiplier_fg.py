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
all_results += "tb_complex_multiplier\n"
all_results += dlmtr

#---------------------------------------------------------------------------------------------------------------------------------
# settings
#---------------------------------------------------------------------------------------------------------------------------------
tests = [
      "default"
]
number_of_tests = 20

result_folder = '_result'
transcript_name = "transcript"
total_result = "PASS"

config_pipe_ce = 0
config_conj_mult = 0
config_a_dw = 8
config_b_dw = 8
config_type = 0

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

        config_pipe_ce = random.randint(0, 1)
        config_conj_mult = random.randint(0, 1)
        config_a_dw = random.randint(8, 16)
        config_b_dw = random.randint(8, 16)
        config_type = random.randint(0, 1)

        subprocess.call(["make", uvm_name,
              "CONFIG_A_DW=%d" % config_a_dw
            , "CONFIG_B_DW=%d" % config_b_dw
            , "CONFIG_TYPE=%d" % config_type
            , "CONFIG_CONJ_MULT=%d" % config_conj_mult
        ])

        # read transcript
        fin = codecs.open(transcript_name, 'r', encoding="windows-1251")
        data_src = fin.read()
        fin.close()

        # if test is not passed then it contains "TEST_FAILED" message
        result_fail = re.findall(r"TEST_FAILED", data_src)
        if (result_fail != []):
            current_result = "FAIL"
            total_result = "FAIL"
        else:
            current_result = "PASS"

        # get seed from the transcript
        seed = re.findall(r"Sv_Seed = \d+", data_src)
        seed = re.findall(r"\d+", seed[0])
        # print(seed)

        namestr_id = "id_" + str(i)
        namestr_seed = "seed_" + seed[0]
        newname = \
              current_result + some_tabs \
            + test_name + "_" \
            + namestr_id + "_" \
            + namestr_seed \
            + ".log"

        current_result_str = \
              current_result + some_tabs \
            + test_name + some_tabs \
            + "id = %3d" % i \
            + ", g_a_dw = %2d" % config_a_dw \
            + ", g_b_dw = %2d" % config_b_dw \
            + ", g_type = %1d" % config_type \
            + ", g_conj_mult = %1d" % config_conj_mult

        shutil.move(transcript_name, result_folder + '/seeds/' + newname)

        all_results += current_result_str + "\n"

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
fout = codecs.open(result_output_file_name, 'w', encoding="windows-1251")
fout.write(total_result)
fout.close