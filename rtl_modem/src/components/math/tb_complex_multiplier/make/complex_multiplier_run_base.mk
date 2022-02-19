## | base

BASE_RUN_SIM_CMD = \
	-g GP_DW=${CONFIG_GP_DW} \
	-g A_DW=${CONFIG_A_DW} \
	-g B_DW=${CONFIG_B_DW} \
	-g TYPE=${CONFIG_TYPE} \
	-g PIPE_CE=${CONFIG_PIPE_CE} \
	-g CONJ_MULT=${CONFIG_CONJ_MULT} \
	-L rtl_modem \
	-L ${DEF_LIB} \
	-sv_seed random \
	${DEF_LIB}.tb_complex_multiplier \
	+UVM_VERBOSITY=UVM_HIGH \
	+UVM_TESTNAME=compmult_base_test \
	-do "wave.do" \
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