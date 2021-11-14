## | pipe                                                                                                                        |

pipe_run_sim:
	vsim -64 -c -voptargs="+acc" \
	-g PIPE_CE=1 \
	-g FULL_TABLE=${CONFIG_FULL_TABLE} \
	-L demodulators \
	-L ${DEF_LIB} \
	-sv_seed random \
	${DEF_LIB}.tb_sin_cos_table \
	+UVM_VERBOSITY=UVM_FULL \
	+UVM_TESTNAME=sincos_test_pipe \
	-coverage \
	-do "set NoQuitOnFinish 1" \
	-do "run -all" \
	-do "coverage report" \
	-do "quit"

pipe_run_sim_gui:
	vsim -64 -voptargs="+acc" \
	-g PIPE_CE=1 \
	-g FULL_TABLE=${CONFIG_FULL_TABLE} \
	-L demodulators \
	-L ${DEF_LIB} \
	-sv_seed random \
	${DEF_LIB}.tb_sin_cos_table \
	+UVM_VERBOSITY=UVM_HIGH \
	+UVM_TESTNAME=sincos_test_pipe \
	-coverage \
	-do "wave.do" \
	-do "run -all" \
	-do "quit"

pipe_uvm: \
	comp_sv \
	pipe_run_sim

pipe_uvm_gui: \
	comp_sv \
	pipe_run_sim_gui

pipe_all: \
	build \
	pipe_uvm \

pipe_all_gui: \
	build \
	pipe_uvm_gui \