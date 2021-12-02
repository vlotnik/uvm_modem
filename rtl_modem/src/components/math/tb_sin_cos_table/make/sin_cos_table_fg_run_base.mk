## | base

base_run_sim:
	vsim -64 -c -voptargs="+acc" \
	-g FULL_TABLE=${CONFIG_FULL_TABLE} \
	-g PHASE_W=${CONFIG_PHASE_W} \
	-g SINCOS_W=${CONFIG_SINCOS_W} \
	-g PIPE_CE=${CONFIG_PIPE_CE} \
	-L rtl_modem \
	-L ${DEF_LIB} \
	-sv_seed random \
	${DEF_LIB}.tb_sin_cos_table \
	+UVM_VERBOSITY=UVM_FULL \
	+UVM_TESTNAME=sincos_base_test \
	-do "set NoQuitOnFinish 1" \
	-do "run -all" \
	-do "quit"

base_run_sim_gui:
	vsim -64 -voptargs="+acc" \
	-g FULL_TABLE=${CONFIG_FULL_TABLE} \
	-g PHASE_W=${CONFIG_PHASE_W} \
	-g SINCOS_W=${CONFIG_SINCOS_W} \
	-g PIPE_CE=${CONFIG_PIPE_CE} \
	-L rtl_modem \
	-L ${DEF_LIB} \
	-sv_seed random \
	${DEF_LIB}.tb_sin_cos_table \
	+UVM_VERBOSITY=UVM_HIGH \
	+UVM_TESTNAME=sincos_base_test \
	-do "wave.do" \
	-do "run -all" \
	-do "quit"

base_uvm: \
	comp_sv \
	base_run_sim

base_uvm_gui: \
	comp_sv \
	base_run_sim_gui

base_all: \
	build \
	base_uvm \

base_all_gui: \
	build \
	base_uvm_gui \