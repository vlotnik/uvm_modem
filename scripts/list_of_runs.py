import os
import subprocess

def run_clean(tb_path):
    current_path = os.getcwd()
    os.chdir(tb_path)
    subprocess.call(["make", "clean"])
    subprocess.call(["make", "clean_log"])
    os.chdir(current_path)

def run_all(tb_path, output):
    current_path = os.getcwd()
    os.chdir(tb_path)
    if (output == "file"):
        f = open("sim.log", "w")
        subprocess.call(["make", "all"], stdout=f)
    else:
        subprocess.call(["make", "all"])
    os.chdir(current_path)

def run_build(tb_path, output):
    current_path = os.getcwd()
    os.chdir(tb_path)
    if (output == "file"):
        f = open("build.log", "w")
        subprocess.call(["make", "build"], stdout=f)
    else:
        subprocess.call(["make", "build"])
    os.chdir(current_path)

def run_tests(tb_path, output):
    current_path = os.getcwd()
    os.chdir(tb_path)
    if (output == "file"):
        f = open("sim.log", "w")
        subprocess.call(["make", "run_tests"], stdout=f)
    else:
        subprocess.call(["make", "run_tests"])
    os.chdir(current_path)