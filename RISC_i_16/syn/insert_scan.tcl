# compile
echo "Compile..."
compile -scan

# insert scan
set_scan_configuration -style multiplexed_flip_flop
set_scan_configuration -chain_count 1

set_dft_signal -view existing_dft -type Reset \
  -port [get_port {res_i}] -active_state 0
set_dft_signal -view existing_dft -type ScanClock \
  -port [get_port {clk_i}] -timing [list 45 55]
set_dft_signal -view existing_dft -type ScanDataIn \
  -port [get_port {mem_data_i[0]}]
set_dft_signal -view existing_dft -type ScanDataOut \
  -port [get_port {mem_data_o[0]}]
set_dft_signal -view existing_dft -type ScanEnable \
  -port [get_port {scan_enable_i}]
set_dft_signal -view existing_dft -type Constant \
  -port [get_port {test_mode_i}] -active_state 1

create_test_protocol

dft_drc > ../doc/${design}.pre_scan.drc
preview_dft -show all > ../doc/${design}.pre_scan.preview

set_dft_insertion_configuration -synthesis_optimization none
set_dft_insertion_configuration -map_effort low
insert_dft

dft_drc > ../doc/${design}.drc

report_scan_path -view existing_dft -chain all > ../doc/${design}.scan_report
report_dft_signal -view existing_dft          >> ../doc/${design}.scan_report
report_dft_configuration                      >> ../doc/${design}.scan_report

write_test_protocol -out ${design}.spf
