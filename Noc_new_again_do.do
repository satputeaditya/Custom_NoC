quietly set ACTELLIBNAME proasic3e
quietly set PROJECT_DIR "D:/Actelprj/EE272/CRC"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   vlib presynth
}
vmap presynth presynth
vmap proasic3e "C:/Microsemi/Libero_v9.2/Designer/lib/modelsim/precompiled/vlog/proasic3e"

vlog -work presynth "${PROJECT_DIR}/hdl/NocC_ver_2.v"

vsim -L proasic3e -L presynth  -t 1ps presynth.NocC_ver_2
# The following lines are commented because no testbench is associated with the project
# add wave /testbench/*
# run 1000ns


restart -force -nowave

vsim -t 1ns
config wave -signalnamewidth 1
radix -hex



add wave -divider -height 12 "NoC READ / MASTER WRITE"
add wave sim:/NocC_ver_2/rst
add wave sim:/NocC_ver_2/clk
add wave sim:/NocC_ver_2/CMD_READ
add wave sim:/NocC_ver_2/ALE_READ
add wave sim:/NocC_ver_2/READ_SM
add wave sim:/NocC_ver_2/IDLE_count

add wave sim:/NocC_ver_2/SIPO_1
add wave sim:/NocC_ver_2/SIPO_1_copy

add wave sim:/NocC_ver_2/SIPO_2
add wave sim:/NocC_ver_2/SIPO_2_copy					


add wave sim:/NocC_ver_2/READ_PKT_SIZE
add wave sim:/NocC_ver_2/READ_count
add wave sim:/NocC_ver_2/READ_count_en
add wave sim:/NocC_ver_2/READ_count_re

add wave sim:/NocC_ver_2/WRITE_PKT_SIZE
add wave sim:/NocC_ver_2/WRITE_count
add wave sim:/NocC_ver_2/WRITE_count_en
add wave sim:/NocC_ver_2/WRITE_count_re

add wave -divider -height 12 "NoC WRITE / MASTER READ"
add wave sim:/NocC_ver_2/CMD_READ					
add wave sim:/NocC_ver_2/ALE_READ					


add wave -divider -height 12 " READ REGISTERS"

add wave sim:/NocC_ver_2/READ_CODE
add wave sim:/NocC_ver_2/READ_SOURCE_ID
add wave sim:/NocC_ver_2/READ_ADDRESS
add wave sim:/NocC_ver_2/READ_LEN

add wave -divider -height 12 " WRITE REGISTERS"

add wave sim:/NocC_ver_2/WRITE_CODE
add wave sim:/NocC_ver_2/WRITE_SOURCE_ID
add wave sim:/NocC_ver_2/WRITE_ADDRESS
add wave sim:/NocC_ver_2/WRITE_DATA
add wave sim:/NocC_ver_2/WRITE_LEN

#add wave -divider -height 12 " FIFO SIGNALS"
#add wave sim:/NocC_ver_2/READ_SM_FIFO_push
#add wave sim:/NocC_ver_2/READ_SM_FIFO_pop
#add wave sim:/NocC_ver_2/READ_SM_FIFO_full
#add wave sim:/NocC_ver_2/READ_SM_FIFO_empty
#add wave sim:/NocC_ver_2/READ_SM_FIFO_data_out
##add wave sim:/NocC_ver_2/READ_SM/memory2/mem


run
force -freeze sim:/NocC_ver_2/rst 1 0
force -freeze sim:/NocC_ver_2/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/NocC_ver_2/CMD_READ 00 0
force -freeze sim:/NocC_ver_2/ALE_READ 1 0
run
force -freeze sim:/NocC_ver_2/rst 0 0
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 23 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 81 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 0C 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run

#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 63 2  
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 09 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 08 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run

#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 63 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 0D 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 63 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 56 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ F0 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ B1 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run

#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 63 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 8D 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 08 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 01 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run

#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 63 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 12 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 65 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 84 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ C2 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ B2 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run

#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 63 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 0D 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 01 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ E3 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ F3 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run

#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 23 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 3D 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run

#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 63 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 8C 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ ED 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 57 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ D4 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 76 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run

#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 63 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ C6 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ F9 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ E9 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ FD 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 7C 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run

#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 23 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ AA 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run

#  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 63 2
force -freeze sim:/NocC_ver_2/ALE_READ 1 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 77 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 00 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 20 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 03 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 40 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 04 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ E5 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ F7 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ AF 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
force -freeze sim:/NocC_ver_2/CMD_READ 72 2
force -freeze sim:/NocC_ver_2/ALE_READ 0 2
run
wave zoom full
