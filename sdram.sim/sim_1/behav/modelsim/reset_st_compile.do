######################################################################
#
# File name : reset_st_compile.do
# Created on: Wed Oct 13 01:19:57 +0300 2021
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vcom  -93 -work xil_defaultlib  \
"../../../../sdram.srcs/sources_1/new/reset_st.vhd" \


quit -force

