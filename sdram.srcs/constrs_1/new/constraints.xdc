set_property PACKAGE_PIN B14 [get_ports A[0]]       
set_property IOSTANDARD LVCMOS15 [get_ports A[0]]

set_property PACKAGE_PIN N11 [get_ports {clk}]       
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -period 20 [get_ports clk]