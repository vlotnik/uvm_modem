## +-----------------------------------------------------------------------------------------------------------------------------+
## | simple_fir_filter, makefile
## +-----------------------------------------------------------------------------------------------------------------------------+

include make/simple_fir_filter_build.mk
include ${INCLUDE}/test_base_cmds.mk
include make/simple_fir_filter_run_base.mk

	CONFIG_G_NOF_TAPS = 19
	CONFIG_G_COEF_DW = 16
	CONFIG_G_SAMPLE_DW = 17
	CONFIG_SV_SEED = random

    ## uvm:                             compile SIM sources and run all tests
    uvm: \
	comp_sv \
	base_run_sim

    ## all:                             compile all sources and run all tests
    all: \
	build \
	uvm

    run_tests: ##                       launch Python script
	python3.7 scripts/tb_simple_fir_filter.py