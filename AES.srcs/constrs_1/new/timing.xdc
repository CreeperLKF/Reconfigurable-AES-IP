


set_property IOSTANDARD LVCMOS18 [get_ports {data_in[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_in[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_in[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_in[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_in[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_in[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_in[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_in[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_out[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_out[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_out[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_out[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_out[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_out[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_out[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {data_out[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmd_in[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmd_in[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports clk_sys]
set_property IOSTANDARD LVCMOS18 [get_ports ok_out]
set_property IOSTANDARD LVCMOS18 [get_ports ready_out]
set_property IOSTANDARD LVCMOS18 [get_ports rst_n]

set_property PACKAGE_PIN B6 [get_ports {cmd_in[1]}]
set_property PACKAGE_PIN C6 [get_ports {cmd_in[0]}]
set_property PACKAGE_PIN A6 [get_ports {data_in[7]}]
set_property PACKAGE_PIN A7 [get_ports {data_in[6]}]
set_property PACKAGE_PIN B8 [get_ports {data_in[5]}]
set_property PACKAGE_PIN C8 [get_ports {data_in[4]}]
set_property PACKAGE_PIN A8 [get_ports {data_in[3]}]
set_property PACKAGE_PIN A9 [get_ports {data_in[2]}]
set_property PACKAGE_PIN B9 [get_ports {data_in[1]}]
set_property PACKAGE_PIN C9 [get_ports {data_in[0]}]
set_property PACKAGE_PIN G6 [get_ports {data_out[7]}]
set_property PACKAGE_PIN F7 [get_ports {data_out[6]}]
set_property PACKAGE_PIN G8 [get_ports {data_out[5]}]
set_property PACKAGE_PIN E8 [get_ports {data_out[4]}]
set_property PACKAGE_PIN F8 [get_ports {data_out[3]}]
set_property PACKAGE_PIN D9 [get_ports {data_out[2]}]
set_property PACKAGE_PIN E9 [get_ports {data_out[1]}]
set_property PACKAGE_PIN A5 [get_ports {data_out[0]}]
set_property PACKAGE_PIN E5 [get_ports clk_sys]
set_property PACKAGE_PIN F6 [get_ports ok_out]
set_property PACKAGE_PIN D5 [get_ports ready_out]
set_property PACKAGE_PIN B5 [get_ports rst_n]







create_clock -period 40.000 -name clk_sys -waveform {0.000 20.000} [get_ports clk_sys]
create_clock -period 10.000 -name VIRTUAL_clk_out1_clk_wiz_0 -waveform {0.000 5.000}
create_clock -period 20.000 -name VIRTUAL_clk_50 -waveform {0.000 10.000}


