set project_name "test_zero_project"

set project_found [llength [get_projects $project_name] ]
if {$project_found > 0} close_project

# set the reference directory to where the script is
set origin_dir [file dirname [info script]]
cd [file dirname [info script]]

# create project
create_project $project_name "$project_name" -force

# path to the sources
set src_path ../..

# add sources
add_files -norecurse tb_top.sv
add_files -norecurse $src_path/common/common_macros.svh
add_files -norecurse $src_path/DSP/libraries/pkg_logo.sv
add_files -norecurse $src_path/DSP/libraries/pkg_modem.sv
add_files -norecurse $src_path/DSP/BFM/ddc/if_ddc_bfm.sv

# uvm
set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]

# lunch simulation
# set_property top tb_top [get_filesets sim_1]
# launch_simulation