## | base

BASE_RUN_SIM_CMD = \
	-g GP_DW=${CONFIG_GP_DW} \
	-g FULL_TABLE=${CONFIG_FULL_TABLE} \
	-g PHASE_DW=${CONFIG_PHASE_DW} \
	-g SINCOS_DW=${CONFIG_SINCOS_DW} \
	-g PIPE_CE=${CONFIG_PIPE_CE} \
	-L rtl_modem \
	-L ${DEF_LIB} \
	-sv_seed ${CONFIG_SV_SEED} \
	${DEF_LIB}.tb_sin_cos_table \
	+UVM_VERBOSITY=UVM_FULL \
	+UVM_TESTNAME=sincos_base_test \
	-do "set NoQuitOnFinish 1" \
	-do "run -all" \
	-do "quit"

base_run_sim:
	vsim -64 -c -voptargs="+acc" \
	${BASE_RUN_SIM_CMD}

base_run_sim_gui:
	vsim -64 -voptargs="+acc" \
	${BASE_RUN_SIM_CMD}

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