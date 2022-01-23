# path to Src
UVM_PATH = ../..

BASE_SIM_CMD = \
	-sv_seed random \
	-L def_lib -lib def_lib def_lib.tb_test_zero_project_top \
	-do "set NoQuitOnFinish 0" \
	-do "run -all"

clean:
	rm -rf work transcript *.wlf def_lib modelsim.ini wlft* *RESULT

comp_sv:
	vlog -64 \
	-work def_lib \
	-F ${UVM_PATH}/DSP/_compile.f \
	hdl_classes/pkg_demo_basemod.sv \
	tb_test_zero_project_top.sv

build: \
	clean \
	comp_sv \

run_sim:
	vsim -64 -c -voptargs="+acc" \
	${BASE_SIM_CMD}

run_sim_gui:
	vsim -64 -voptargs="+acc" \
	${BASE_SIM_CMD}

all: \
	build \
	run_sim

all_gui: \
	build \
	run_sim_gui