if { ! [file exists work] } {
	vlib work
}

vcom -87 ../src/risc_i_16_pack.vhd
vlog -timescale "1 ns / 1 ps" ../syn/netlist/alu.v
vcom -87 ../src/alu_tb.vhd
