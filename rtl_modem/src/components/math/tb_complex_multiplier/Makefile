## +-----------------------------------------------------------------------------------------------------------------------------+
## | complex_multiplier_fg, makefile                                                                                             |
## +-----------------------------------------------------------------------------------------------------------------------------+

include make/complex_multiplier_fg_build.mk
include make/complex_multiplier_fg_run_default.mk
include make/complex_multiplier_fg_runs.mk

	CONFIG_A_DW = 9
	CONFIG_B_DW = 15
	CONFIG_TYPE = 1
	CONFIG_PIPE_CE = 0
	CONFIG_CONJ_MULT = 1

    ## uvm:                         compile SIM sources and run all tests
    uvm: \
	comp_sv \
	solid_run_sim \
	pipe_run_sim \

    ## all:                         compile all sources and run all tests
    all: \
	build \
	uvm \
	rm_transcript

    run_tests: ##                   launch Python script
	python3.7 scripts/tb_complex_multiplier_fg.py