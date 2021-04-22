# path to Src
UVM_PATH = ../..

clean:
	rm -rf work transcript *.wlf def_lib modelsim.ini wlft* *RESULT

comp_sv:
	vlog -64 \
	-work def_lib \
	-F ${UVM_PATH}/DSP/_compile.f \
	hdl_classes/pkg_demo_basemod.sv \
	tb_top.sv

run_sim:
	vsim -64 -c -voptargs="+acc" \
	-sv_seed random \
	-L def_lib -lib def_lib def_lib.tb_top \
	-do "set NoQuitOnFinish 1" \
	-do "run -all"

build: \
	clean \
	comp_sv \

all: \
	build \
	run_sim