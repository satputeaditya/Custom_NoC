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



add wave -divider -height 12 "NoC READ / MASTER WRITE"
add wave sim:/NoC_new_again/rst
add wave sim:/NoC_new_again/clk
add wave sim:/NoC_new_again/CMD_READ
add wave sim:/NoC_new_again/ALE_READ
add wave sim:/NoC_new_again/READ_THIS

#add wave -divider -height 12 "NoC WRITE / MASTER READ"	#COMMENTED OUT
#add wave sim:/NoC_new_again/CMD_READ					#COMMENTED OUT
#add wave sim:/NoC_new_again/ALE_READ					#COMMENTED OUT


add wave -divider -height 12 " READ REGISTERS"
add wave -color purple sim:/NoC_new_again/READ_CODE
#add wave -color purple sim:/NoC_new_again/READ_RESP_CODE    #COMMENTED OUT
add wave -color purple sim:/NoC_new_again/READ_SOURCE_ID
add wave -color purple sim:/NoC_new_again/READ_ADDRESS
add wave -color purple sim:/NoC_new_again/READ_LEN
add wave -color purple sim:/NoC_new_again/READ_PKT_SIZE
add wave -color blue sim:/NoC_new_again/READ_count



add wave -divider -height 12 " WRITE REGISTERS"
add wave -color yellow sim:/NoC_new_again/WRITE_CODE
#add wave -color yellow sim:/NoC_new_again/WRITE_RESP_CODE  #COMMENTED OUT
add wave -color yellow sim:/NoC_new_again/WRITE_SOURCE_ID
add wave -color yellow sim:/NoC_new_again/WRITE_ADDRESS
add wave -color yellow sim:/NoC_new_again/WRITE_LEN
add wave -color yellow sim:/NoC_new_again/WRITE_PKT_SIZE
add wave -color blue sim:/NoC_new_again/WRITE_count


#add wave sim:/NoC_new_again/MESSAGE_CODE				#COMMENTED OUT


add wave -divider -height 12 " STATE MC 1"
add wave -color gold sim:/NoC_new_again/STATE_1
add wave -color magenta sim:/NoC_new_again/JUMP
add wave -color blue sim:/NoC_new_again/IDLE_count
add wave -color blue sim:/NoC_new_again/ERR_LOC


add wave -divider -height 12 " READ SIGNALS"
add wave sim:/NoC_new_again/R_LEN_BIT
#add wave sim:/NoC_new_again/R_ONES    					#COMMENTED OUT
add wave sim:/NoC_new_again/R_ADDR_LEN

add wave -divider -height 12 " WRITE SIGNALS"
add wave sim:/NoC_new_again/W_LEN_BIT
#add wave sim:/NoC_new_again/W_ONES						#COMMENTED OUT
add wave sim:/NoC_new_again/W_ADDR_LEN

#add wave sim:/NoC_new_again/READ_RESP_RESERVED			#COMMENTED OUT
#add wave sim:/NoC_new_again/MESSAGE_LENGTH				#COMMENTED OUT



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
force -freeze sim:/NoC_new_again/CMD_READ 99 2
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
