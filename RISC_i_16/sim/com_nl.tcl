if { ! [file exists work] } {
	vlib work
}

vcom -87 ../src/risc_i_16_pack.vhd
vcom -93 ../src/memory.vhd
vlog -timescale "1 ns / 1 ps" ../syn/netlist/cpu.v
vcom -87 ../src/cpu_tb.vhd
