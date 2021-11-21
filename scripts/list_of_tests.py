import os

def get_list_of_tests():
    current_path = os.getcwd()

    # list of tests
    tb_path = []
    # list of tests
    # [0] = only build
    # [1] = build and simulate

    # only build

    # build and simulate
    tb_path.append([1, current_path + "/rtl_modem/src/components/math/tb_sin_cos_table"])
    tb_path.append([1, current_path + "/rtl_modem/src/components/math/tb_complex_multiplier"])

    return tb_path