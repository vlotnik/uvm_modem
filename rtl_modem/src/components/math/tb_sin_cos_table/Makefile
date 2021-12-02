## +-----------------------------------------------------------------------------------------------------------------------------+
## | sin_cos_table_fg, makefile
## +-----------------------------------------------------------------------------------------------------------------------------+

include make/sin_cos_table_fg_build.mk
include ${INCLUDE}/test_base_cmds.mk
include make/sin_cos_table_fg_run_base.mk

	CONFIG_GPDW = 10
	CONFIG_FULL_TABLE = 0
	CONFIG_PHASE_W = 12
	CONFIG_SINCOS_W = 16
	CONFIG_PIPE_CE = 1
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
	python3.7 scripts/tb_sin_cos_table.py