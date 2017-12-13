#
# synthesize prol16
#

# some variables
set design alu
set sources {risc_i_16_pack}

# analyze
echo "Analyzing..."
foreach s $sources {
    analyze -format vhdl ../src/${s}.vhd
}

# elaborate
echo "Elaborate..."
elaborate $design

# set environment and constraints
set_operating_conditions WORST
set_max_delay -from [get_ports alu_func_i] -to [get_ports zero_o] 5
set_max_area 0

# compile
echo "Compile..."
compile

# write results

# changing names is required for legal identifiers
echo "Changing names..."
change_names -rules verilog -hierarchy

echo "Writing netlist and SDF..."
write -hierarchy -format verilog -output netlist/${design}.v
write_sdf -context verilog -version 2.1 netlist/${design}.snps.sdf
# use INWAY sdf patchers to fix snps' stuff
exec /usr/bin/env IFXPERL=/opt/perl_5.8.7/bin/perl /opt/inway_5.2.1/bin/sdf_patch \
    -step synthesis -list_ntc_cells ntc.lst netlist/$design.snps.sdf netlist/$design.sdf

echo "Writing reports..."
report_area > ../doc/${design}_area.rep
report_timing > ../doc/${design}_timing.rep
