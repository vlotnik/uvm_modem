## +-----------------------------------------------------------------------------------------------------------------------------+
## | list of tests:                                                                                                              |
## +-----------------------------------------------------------------------------------------------------------------------------+
## | solid                                                                                                                       |

solid_run_sim:
	vsim -64 -c -voptargs="+acc" \
	-g PIPE_CE=0 \
	-g FULL_TABLE=${CONFIG_FULL_TABLE} \
	-L demodulators \
	-L ${DEF_LIB} \
	-sv_seed random \
	${DEF_LIB}.tb_sin_cos_table \
	+UVM_VERBOSITY=UVM_FULL \
	+UVM_TESTNAME=sincos_test_solid \
	-coverage \
	-do "set NoQuitOnFinish 1" \
	-do "run -all" \
	-do "coverage report" \
	-do "quit"

solid_run_sim_gui:
	vsim -64 -voptargs="+acc" \
	-g PIPE_CE=0 \
	-g FULL_TABLE=${CONFIG_FULL_TABLE} \
	-L demodulators \
	-L ${DEF_LIB} \
	-sv_seed random \
	${DEF_LIB}.tb_sin_cos_table \
	+UVM_VERBOSITY=UVM_HIGH \
	+UVM_TESTNAME=sincos_test_solid \
	-coverage \
	-do "wave.do" \
	-do "run -all" \
	-do "quit"

solid_uvm: \
	comp_sv \
	solid_run_sim

solid_uvm_gui: \
	comp_sv \
	solid_run_sim_gui

solid_all: \
	build \
	solid_uvm \

solid_all_gui: \
	build \
	solid_uvm_gui \