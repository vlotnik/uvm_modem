#---------------------------------------------------------------------------------------------------------------------------------
# name : test_zero_project
#---------------------------------------------------------------------------------------------------------------------------------

# Vivado 2020.2

set project_name "vivado_tb_test_zero_project_top"

# close project if it's allready created
set project_found [llength [get_projects $project_name] ]
if {$project_found > 0} close_project

# set the reference directory to where the script is
set origin_dir [file dirname [info script]]
cd [file dirname [info script]]

# create project
create_project $project_name "$project_name" -force

set SRC_path "../../../.."
# set RTL_path "../../../../rtl_modem"
set UVM_path "$SRC_path/uvm_modem"

add_files -norecurse $UVM_path/DSP/libraries/pkg_logo.sv
add_files -norecurse $UVM_path/DSP/libraries/file_io.svh
add_files -norecurse $UVM_path/DSP/libraries/pkg_modem.sv
add_files -norecurse $UVM_path/DSP/libraries/pkg_modem_math.sv
add_files -norecurse $UVM_path/common/common_macros.svh

add_files -norecurse $UVM_path/DSP/BFM/ddc/if_ddc_drvr.svh
add_files -norecurse $UVM_path/DSP/BFM/ddc/if_ddc_agnt.svh
add_files -norecurse $UVM_path/DSP/BFM/ddc/if_ddc_bfm.sv
add_files -norecurse $UVM_path/DSP/pkg_vrf_dsp_bfm.sv

add_files -norecurse $UVM_path/DSP/components/dsp_base/dsp_base_seqc.svh
add_files -norecurse $UVM_path/DSP/components/dsp_base/dsp_base_layr.svh
add_files -norecurse $UVM_path/DSP/components/data_generators/dsp_seqc_sym_framer.svh
add_files -norecurse $UVM_path/DSP/components/data_generators/dsp_layr_sym_framer.svh
add_files -norecurse $UVM_path/DSP/components/iq_mappers/iqmap_base.svh
add_files -norecurse $UVM_path/DSP/components/iq_mappers/iqmap.svh
add_files -norecurse $UVM_path/DSP/components/iq_mappers/dsp_seqc_iq_mapper.svh
add_files -norecurse $UVM_path/DSP/components/iq_mappers/dsp_layr_iq_mapper.svh
add_files -norecurse $UVM_path/DSP/components/filters/filter_design.svh
add_files -norecurse $UVM_path/DSP/components/filters/fir_resampler.svh
add_files -norecurse $UVM_path/DSP/components/filters/fir_resampler.svh
add_files -norecurse $UVM_path/DSP/components/filters/fir_filter.svh
add_files -norecurse $UVM_path/DSP/components/filters/dsp_seqc_resampler.svh
add_files -norecurse $UVM_path/DSP/components/filters/dsp_layr_resampler.svh
add_files -norecurse $UVM_path/DSP/components/dsp_math/dspmath_mixer.svh
add_files -norecurse $UVM_path/DSP/components/dsp_math/dsp_seqc_mixer.svh
add_files -norecurse $UVM_path/DSP/components/dsp_math/dsp_layr_mixer.svh
add_files -norecurse $UVM_path/DSP/components/dsp_math/dsp_seqc_summator.svh
add_files -norecurse $UVM_path/DSP/components/dsp_math/dsp_layr_summator.svh
add_files -norecurse $UVM_path/DSP/pkg_vrf_dsp_components.sv

add_files -norecurse $UVM_path/DSP/modulators/base/basemod_base_seqc.svh
add_files -norecurse $UVM_path/DSP/modulators/base/basemod_envr.svh
add_files -norecurse $UVM_path/DSP/pkg_vrf_dsp_modulators.sv

add_files -norecurse $UVM_path/_demo/test_zero_project/hdl_classes/demo_basemod_test.svh
add_files -norecurse $UVM_path/_demo/test_zero_project/hdl_classes/pkg_demo_basemod.sv
add_files -norecurse $UVM_path/_demo/test_zero_project/tb_test_zero_project_top.sv

# uvm
set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]

# lunch simulation
set_property top tb_test_zero_project_top [get_filesets sim_1]
# launch_simulation