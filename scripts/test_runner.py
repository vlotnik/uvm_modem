import subprocess
import codecs
import re
import shutil
import time

#---------------------------------------------------------------------------------------------------------------------------------
# define separators
#---------------------------------------------------------------------------------------------------------------------------------
some_tabs = "    "
dlmtr = "----------------------------------------------------------------------------------------------------------------------\n"

result_folder = '_result'
transcript_name = "transcript"

MAX_SEED = 2**31

#---------------------------------------------------------------------------------------------------------------------------------
# start of result message
#---------------------------------------------------------------------------------------------------------------------------------
def make_som(test_name):
    message = ""
    message += "\n"
    message += dlmtr
    message += some_tabs
    message += test_name
    message += "\n"
    message += dlmtr
    return message

#---------------------------------------------------------------------------------------------------------------------------------
# run build
#---------------------------------------------------------------------------------------------------------------------------------
def call_build():
    subprocess.call(["make", "build"])
    subprocess.call(["mkdir", "_result"])
    subprocess.call(["mkdir", "_result/seeds"])

#---------------------------------------------------------------------------------------------------------------------------------
# run uvm test
#---------------------------------------------------------------------------------------------------------------------------------
def call_uvm_test(uvm_name, config):
    args = "make %s" % uvm_name
    args += " "
    for j in config:
        args += "CONFIG_%s=%d " % (j.upper(), config[j])

    subprocess.call(args, shell=True)

#---------------------------------------------------------------------------------------------------------------------------------
# parse transcript file, if "TEST_FAILED" is found then return "FAIL", otherwise return "PASS"
#---------------------------------------------------------------------------------------------------------------------------------
def get_current_result():
    fin = codecs.open(transcript_name, 'r', encoding="windows-1251")
    data_src = fin.read()
    fin.close()

    # if test is not passed then it contains "TEST_FAILED" message
    result_fail = re.findall(r"TEST_FAILED", data_src)
    result_pass = re.findall(r"TEST_PASSED", data_src)
    if (result_fail != []):
        return "FAIL"
    else:
        if (result_pass != []):
            return "PASS"
        else:
            return "FAIL"

#---------------------------------------------------------------------------------------------------------------------------------
# rename transcript to .log file and copy it to the result_folder
#---------------------------------------------------------------------------------------------------------------------------------
def copy_log_file(i, config_seed, current_result, test_name):
    namestr_id = "id_" + str(i)
    namestr_seed = "seed_" + str(config_seed)
    newname = \
          current_result + some_tabs \
        + test_name + "_" \
        + namestr_id + "_" \
        + namestr_seed \
        + ".log"
    shutil.move(transcript_name, result_folder + '/seeds/' + newname)

#---------------------------------------------------------------------------------------------------------------------------------
# generate string with results and configuration
#---------------------------------------------------------------------------------------------------------------------------------
def get_current_result_str(current_result, test_name, config):
    result = current_result + some_tabs + test_name
    for j in config:
        if (j != "sv_seed"):
            result += ", %s = %d" % (j, config[j])
    print(result)
    return result

#---------------------------------------------------------------------------------------------------------------------------------
# generate string with timings
#---------------------------------------------------------------------------------------------------------------------------------
def get_result_time(start_time, finish_time):
    total_time = finish_time - start_time
    result = ""
    result += "PING:\t" + time.strftime("%b %d %Y %H:%M:%S", time.gmtime(start_time)) + "\n"
    result += "PONG:\t" + time.strftime("%b %d %Y %H:%M:%S", time.gmtime(finish_time)) + "\n"
    result += "TIME:\t" + time.strftime("%H:%M:%S", time.gmtime(total_time)) + "\n"
    return result

#---------------------------------------------------------------------------------------------------------------------------------
# create result file
#---------------------------------------------------------------------------------------------------------------------------------
def make_result_file(total_result):
    result_output_file_name = result_folder + "/tests.RESULT"
    fout = codecs.open(result_output_file_name, 'w', encoding="windows-1251")
    fout.write(total_result)
    fout.close