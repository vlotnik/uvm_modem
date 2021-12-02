## +-----------------------------------------------------------------------------------------------------------------------------+
## | complex_multiplier_fg, makefile
## +-----------------------------------------------------------------------------------------------------------------------------+

include make/complex_multiplier_fg_build.mk
include ${INCLUDE}/test_base_cmds.mk
include make/complex_multiplier_fg_run_base.mk

	CONFIG_GPDW = 10
	CONFIG_A_W = 9
	CONFIG_B_W = 15
	CONFIG_TYPE = 1
	CONFIG_PIPE_CE = 0
	CONFIG_CONJ_MULT = 1

    ## uvm:                         compile SIM sources and run all tests
    uvm: \
	comp_sv \
	base_run_sim

    ## all:                         compile all sources and run all tests
    all: \
	build \
	uvm

    run_tests: ##                   launch Python script
	python3.7 scripts/tb_complex_multiplier_fg.py