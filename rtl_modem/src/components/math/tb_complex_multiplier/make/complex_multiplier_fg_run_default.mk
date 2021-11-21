## | default

default_run_sim:
	vsim -64 -c -voptargs="+acc" \
	-g A_DW=${CONFIG_A_DW} \
	-g B_DW=${CONFIG_B_DW} \
	-g TYPE=${CONFIG_TYPE} \
	-g CONJ_MULT=${CONFIG_CONJ_MULT} \
	-L rtl_modem \
	-L ${DEF_LIB} \
	-sv_seed random \
	${DEF_LIB}.tb_complex_multiplier \
	+UVM_VERBOSITY=UVM_HIGH \
	+UVM_TESTNAME=compmult_test_default \
	-coverage \
	-do "set NoQuitOnFinish 1" \
	-do "run -all" \
	-do "coverage report" \
	-do "quit"

default_run_sim_gui:
	vsim -64 -voptargs="+acc" \
	-g A_DW=${CONFIG_A_DW} \
	-g B_DW=${CONFIG_B_DW} \
	-g TYPE=${CONFIG_TYPE} \
	-g CONJ_MULT=${CONFIG_CONJ_MULT} \
	-L rtl_modem \
	-L ${DEF_LIB} \
	-sv_seed random \
	${DEF_LIB}.tb_complex_multiplier \
	+UVM_VERBOSITY=UVM_HIGH \
	+UVM_TESTNAME=compmult_test_default \
	-do "wave.do" \
	-do "run -all" \
	-do "quit"

default_uvm: \
	comp_sv \
	default_run_sim

default_uvm_gui: \
	comp_sv \
	default_run_sim_gui

default_all: \
	build \
	default_uvm \

default_all_gui: \
	build \
	default_uvm_gui \