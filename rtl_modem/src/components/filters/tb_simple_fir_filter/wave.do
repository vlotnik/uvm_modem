onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_simple_fir_filter/dut/g_nof_taps
add wave -noupdate /tb_simple_fir_filter/dut/g_sample_dw
add wave -noupdate /tb_simple_fir_filter/dut/g_iraxi_dw
add wave -noupdate /tb_simple_fir_filter/dut/g_oraxi_dw
add wave -noupdate /tb_simple_fir_filter/dut/c_mreg_dw
add wave -noupdate /tb_simple_fir_filter/dut/*
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {100 ns}
