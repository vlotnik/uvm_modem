## +-----------------------------------------------------------------------------------------------------------------------------+
## | rounder, makefile
## +-----------------------------------------------------------------------------------------------------------------------------+

include make/rounder_build.mk
include ${INCLUDE}/test_base_cmds.mk
include make/rounder_run_base.mk

	CONFIG_GP_DW = 10
	CONFIG_NOF_SAMPLES = 2
	CONFIG_SAMPLE_DW = 16
	CONFIG_RND_LSB = 1
	CONFIG_PIPE_CE = 0
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
	python3.7 scripts/tb_rounder.py