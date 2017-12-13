if { ! [file exists work] } {
	vlib work
}

set sources {risc_i_16_pack alu reg_file datapath control sync_reset cpu}

foreach s $sources {
    vcom -87 ../src/${s}.vhd
}

vcom -93 ../src/memory.vhd
vcom -87 ../src/cpu_tb.vhd
