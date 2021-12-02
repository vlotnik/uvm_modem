## +-----------------------------------------------------------------------------------------------------------------------------+
## | sin_cos_table_fg
## +-----------------------------------------------------------------------------------------------------------------------------+

# path to Src
UVM_PATH = ../../../../..
INCLUDE  = ${UVM_PATH}/_include
include ${INCLUDE}/src_path.mk
include ${INCLUDE}/make_cmds.mk

DIR = ${INCLUDE}/${SRC_PATH_ROOT}
LIB_PATH = _libs
DEF_LIB = ${LIB_PATH}/work

    create_libs: ##                     create RTL libraries
	vlib ${LIB_PATH}
	vlib ${LIB_PATH}/rtl_modem

    map_libs: ##                        map RTL libraries
	vmap rtl_modem 				_libs/rtl_modem

    comp_vhd: ##                        compile RTL sources
	vcom -64 -2008 -work rtl_modem ${DIR}/src/components/math/sin_cos_table.vhdl

    ## build:                           build RTL
    build: \
	clean \
	create_libs \
	map_libs \
	comp_vhd \
	build_done

    comp_sv: ##                         compile SIM sources
	vlog -64 \
	-work ${DEF_LIB} \
	+incdir+${UVM_PATH}/common \
	-dpiheader ${UVM_PATH}/DSP/libraries/lib_c_math.h ${UVM_PATH}/DSP/libraries/lib_c_math.c \
	-L rtl_modem \
	-work ${DEF_LIB} ${UVM_PATH}/system/raxi/raxi_bfm.sv \
	-work ${DEF_LIB} ${UVM_PATH}/system/raxi/pkg_raxi.sv \
	-work ${DEF_LIB} ${UVM_PATH}/system/pipe/pkg_pipe.sv \
	-work ${DEF_LIB} hdl_classes/pkg_sincos.sv \
	-work ${DEF_LIB} tb_sin_cos_table.sv