## | base

BASE_RUN_SIM_CMD = \
	-g G_NOF_TAPS=${CONFIG_G_NOF_TAPS} \
	-g G_COEF_DW=${CONFIG_G_COEF_DW} \
	-g G_SAMPLE_DW=${CONFIG_G_SAMPLE_DW} \
	-L rtl_modem \
	-L ${DEF_LIB} \
	-sv_seed ${CONFIG_SV_SEED} \
	${DEF_LIB}.tb_simple_fir_filter \
	+UVM_VERBOSITY=UVM_HIGH \
	+UVM_TESTNAME=simplefir_base_test \
	-do "wave.do" \
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