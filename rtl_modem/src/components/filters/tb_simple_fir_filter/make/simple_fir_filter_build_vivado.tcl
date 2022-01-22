# Vivado 2021.2

set project_name "tb_simple_fir_filter"

# close project if it's allready created
set project_found [llength [get_projects $project_name] ]
if {$project_found > 0} close_project

# set the reference directory to where the script is
set origin_dir [file dirname [info script]]
cd [file dirname [info script]]

# create project
create_project $project_name "$project_name" -force

set RTL_path "../../../../../../../rtl_modem"
set UVM_path "../../../../../../../uvm_modem"

# add sources
add_files -norecurse $RTL_path/src/components/filters/simple_fir_filter.vhdl

add_files -norecurse $UVM_path/common/common_macros.svh
add_files -norecurse $UVM_path/DSP/libraries/file_io.svh
add_files -norecurse $UVM_path/DSP/libraries/pkg_modem.sv
add_files -norecurse $UVM_path/DSP/libraries/pkg_modem_math.sv
add_files -norecurse $UVM_path/DSP/components/dsp_base/dsp_base_seqc.svh
add_files -norecurse $UVM_path/DSP/components/dsp_base/dsp_base_layr.svh
add_files -norecurse $UVM_path/DSP/components/filters/filter_design.svh
add_files -norecurse $UVM_path/DSP/components/filters/fir_filter.svh
add_files -norecurse $UVM_path/DSP/pkg_vrf_dsp_components.sv
add_files -norecurse $UVM_path/system/rAXI/raxi_seqi.svh
add_files -norecurse $UVM_path/system/rAXI/raxi_drvr.svh
add_files -norecurse $UVM_path/system/rAXI/raxi_mont.svh
add_files -norecurse $UVM_path/system/rAXI/raxi_agnt_cfg.svh
add_files -norecurse $UVM_path/system/rAXI/raxi_agnt.svh
add_files -norecurse $UVM_path/system/rAXI/raxi_bfm.sv
add_files -norecurse $UVM_path/system/rAXI/pkg_raxi.sv
add_files -norecurse $UVM_path/system/pipe/pipe_seqi.svh
add_files -norecurse $UVM_path/system/pipe/sim_pipe.svh
add_files -norecurse $UVM_path/system/pipe/pipe_scrb.svh
add_files -norecurse $UVM_path/system/pipe/pipe_agnt.svh
add_files -norecurse $UVM_path/system/pipe/pipe_seqc.svh
add_files -norecurse $UVM_path/system/pipe/pkg_pipe.sv
add_files -norecurse $UVM_path/rtl_modem/src/components/filters/tb_simple_fir_filter/hdl_classes/simplefir_seqc_coef.svh
add_files -norecurse $UVM_path/rtl_modem/src/components/filters/tb_simple_fir_filter/hdl_classes/simplefir_seqc_data.svh
add_files -norecurse $UVM_path/rtl_modem/src/components/filters/tb_simple_fir_filter/hdl_classes/sim_simple_fir_filter.svh
add_files -norecurse $UVM_path/rtl_modem/src/components/filters/tb_simple_fir_filter/hdl_classes/simplefir_scrb.svh
add_files -norecurse $UVM_path/rtl_modem/src/components/filters/tb_simple_fir_filter/hdl_classes/simplefir_base_test.svh
add_files -norecurse $UVM_path/rtl_modem/src/components/filters/tb_simple_fir_filter/hdl_classes/pkg_simplefir.sv
add_files -norecurse $UVM_path/rtl_modem/src/components/filters/tb_simple_fir_filter/tb_simple_fir_filter.sv

# uvm
set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]

# lunch simulation
set_property top tb_simple_fir_filter [get_filesets sim_1]
launch_simulation