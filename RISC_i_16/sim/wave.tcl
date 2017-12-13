onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /cpu_tb/dut/control_inst/clk_i
add wave -noupdate -format Logic /cpu_tb/dut/control_inst/res_i
add wave -noupdate -format Literal -radix decimal /cpu_tb/dut/datapath_inst/reg_file_inst/reg_file
add wave -noupdate -format Literal -radix hexadecimal /cpu_tb/dut/datapath_inst/pc
add wave -noupdate -format Literal /cpu_tb/dut/control_inst/op_code_i
add wave -noupdate -format Logic /cpu_tb/dut/control_inst/zero
add wave -noupdate -format Logic /cpu_tb/dut/control_inst/carry
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {751 ns} 0}
WaveRestoreZoom {62 ns} {1338 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
