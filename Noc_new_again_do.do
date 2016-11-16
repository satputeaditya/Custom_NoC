quietly set ACTELLIBNAME proasic3e
quietly set PROJECT_DIR "D:/Actelprj/EE272/CRC"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   vlib presynth
}
vmap presynth presynth
vmap proasic3e "C:/Microsemi/Libero_v9.2/Designer/lib/modelsim/precompiled/vlog/proasic3e"

vlog -work presynth "${PROJECT_DIR}/hdl/basic_fsm_test.v"

vsim -L proasic3e -L presynth  -t 1ps presynth.NoC_new_again
# The following lines are commented because no testbench is associated with the project
# add wave /testbench/*
# run 1000ns


restart -force -nowave

vsim -t 1ns
config wave -signalnamewidth 1
radix -hex



add wave -divider -height 30 "NoC READ / MASTER WRITE"
add wave sim:/NoC_new_again/rst
add wave sim:/NoC_new_again/clk
add wave sim:/NoC_new_again/CMD_READ
add wave sim:/NoC_new_again/ALE_READ
add wave sim:/NoC_new_again/READ_THIS

add wave -divider -height 30 "NoC WRITE / MASTER READ"
add wave sim:/NoC_new_again/CMD_READ
add wave sim:/NoC_new_again/ALE_READ


add wave -divider -height 30 " REGISTERS"

add wave sim:/NoC_new_again/READ_CODE
add wave sim:/NoC_new_again/READ_RESP_CODE
add wave sim:/NoC_new_again/WRITE_CODE
add wave sim:/NoC_new_again/WRITE_RESP_CODE
add wave sim:/NoC_new_again/MESSAGE_CODE
add wave sim:/NoC_new_again/SOURCE_ID
add wave sim:/NoC_new_again/RETURN_ID
add wave sim:/NoC_new_again/ADDRESS
add wave sim:/NoC_new_again/READ_LEN
add wave sim:/NoC_new_again/READ_PKT_SIZE


add wave -divider -height 30 " STATE MC 1"

add wave sim:/NoC_new_again/STATE_1
add wave sim:/NoC_new_again/JUMP
add wave sim:/NoC_new_again/IDLE_count
add wave sim:/NoC_new_again/READ_count
add wave sim:/NoC_new_again/ERR_LOC


add wave -divider -height 30 " OTHER SIGNALS"

add wave sim:/NoC_new_again/LEN
add wave sim:/NoC_new_again/ONES
add wave sim:/NoC_new_again/ADDR_LEN
add wave sim:/NoC_new_again/READ_RESP_RESERVED
add wave sim:/NoC_new_again/ERROR
add wave sim:/NoC_new_again/ERR_CODE
add wave sim:/NoC_new_again/MESSAGE_LENGTH




run
force -freeze sim:/NoC_new_again/rst 1 0
force -freeze sim:/NoC_new_again/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/NoC_new_again/CMD_READ 00 0
force -freeze sim:/NoC_new_again/ALE_READ 1 0
run
force -freeze sim:/NoC_new_again/rst 0 0
run
force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 1 2
run
force -freeze sim:/NoC_new_again/CMD_READ 23 2
force -freeze sim:/NoC_new_again/ALE_READ 1 2
run
force -freeze sim:/NoC_new_again/CMD_READ 81 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 20 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 03 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 40 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 0C 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 1 2
run
force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 1 2
run
force -freeze sim:/NoC_new_again/CMD_READ 63 2
force -freeze sim:/NoC_new_again/ALE_READ 1 2

run
force -freeze sim:/NoC_new_again/CMD_READ 09 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 08 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 20 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 03 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 40 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 04 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run

force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run

force -freeze sim:/NoC_new_again/CMD_READ 03 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 63 2
force -freeze sim:/NoC_new_again/ALE_READ 1 2
run
force -freeze sim:/NoC_new_again/CMD_READ 0D 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 20 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 03 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 40 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 04 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 63 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 56 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ F0 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ B1 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 63 2
force -freeze sim:/NoC_new_again/ALE_READ 1 2
run
force -freeze sim:/NoC_new_again/CMD_READ 8D 2
force -freeze sim:/NoC_new_again/ALE_READ 1 2
run
force -freeze sim:/NoC_new_again/CMD_READ 08 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 20 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 03 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 40 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 04 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 00 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 01 2
force -freeze sim:/NoC_new_again/ALE_READ 0 2
run
force -freeze sim:/NoC_new_again/CMD_READ 63 2
force -freeze sim:/NoC_new_again/ALE_READ 1 2
run

force -freeze sim:/NoC_new_again/CMD_READ xx 2
force -freeze sim:/NoC_new_again/ALE_READ x 2
run

run
wave zoom full