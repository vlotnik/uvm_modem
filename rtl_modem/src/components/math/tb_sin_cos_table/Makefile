## +-----------------------------------------------------------------------------------------------------------------------------+
## | sin_cos_table_fg, makefile                                                                                                  |
## +-----------------------------------------------------------------------------------------------------------------------------+

include make/sin_cos_table_fg_build.mk
include make/sin_cos_table_fg_run_solid.mk
include make/sin_cos_table_fg_run_pipe.mk
include make/sin_cos_table_fg_runs.mk

	CONFIG_FULL_TABLE = 1

    ## uvm:                         compile SIM sources and run all tests
    uvm: \
	comp_sv \
	solid_run_sim \
	solid_copytr \
	pipe_run_sim \
	pipe_copytr \

    ## all:                         compile all sources and run all tests
    all: \
	build \
	uvm \
	rm_transcript

    run_tests: ##                   launch Python script
	python3.7 scripts/tb_sin_cos_table.py