vlib work
vlog -f ram_files_list.txt +cover -covercells
vsim -voptargs=+acc work.ram_top -cover -classdebug -uvmcontrol=all
add wave /ram_top/ramif/*
run 0
add wave -position insertpoint  \
sim:/ram_top/DUT/MEM_DEPTH \
sim:/ram_top/DUT/ADDR_SIZE \
sim:/ram_top/DUT/clk \
sim:/ram_top/DUT/rst_n \
sim:/ram_top/DUT/rx_valid \
sim:/ram_top/DUT/din \
sim:/ram_top/DUT/dout \
sim:/ram_top/DUT/tx_valid \
sim:/ram_top/DUT/memory \
sim:/ram_top/DUT/addr_wr \
sim:/ram_top/DUT/addr_re
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/sb/tx_valid_ref \
sim:/uvm_root/uvm_test_top/env/sb/dout_ref \
sim:/uvm_root/uvm_test_top/env/sb/w_addr \
sim:/uvm_root/uvm_test_top/env/sb/r_addr \
sim:/uvm_root/uvm_test_top/env/sb/ref_mem
run -all