vlib work
vlog -f spi_slave_files_list.txt +cover -covercells
vsim -voptargs=+acc work.spi_slave_top -cover -classdebug -uvmcontrol=all
add wave /spi_slave_top/spi_slaveif/*
run 0 
add wave -position insertpoint  \
sim:/spi_slave_top/DUT/IDLE \
sim:/spi_slave_top/DUT/CHK_CMD \
sim:/spi_slave_top/DUT/WRITE \
sim:/spi_slave_top/DUT/READ_ADD \
sim:/spi_slave_top/DUT/READ_DATA \
sim:/spi_slave_top/DUT/clk \
sim:/spi_slave_top/DUT/rst_n \
sim:/spi_slave_top/DUT/MOSI \
sim:/spi_slave_top/DUT/tx_valid \
sim:/spi_slave_top/DUT/ss_n \
sim:/spi_slave_top/DUT/tx_data \
sim:/spi_slave_top/DUT/MISO \
sim:/spi_slave_top/DUT/rx_valid \
sim:/spi_slave_top/DUT/rx_data \
sim:/spi_slave_top/DUT/cs \
sim:/spi_slave_top/DUT/ns \
sim:/spi_slave_top/DUT/ADD_DATA_checker \
sim:/spi_slave_top/DUT/counter1 \
sim:/spi_slave_top/DUT/counter2 \
sim:/spi_slave_top/DUT/bus
add wave -position insertpoint  \
sim:/spi_slave_shared_pkg::cs \
sim:/spi_slave_shared_pkg::ns \
sim:/spi_slave_shared_pkg::sampling_MOSI \
sim:/spi_slave_shared_pkg::test_finished \
sim:/spi_slave_shared_pkg::counter \
sim:/spi_slave_shared_pkg::state_finished \
sim:/spi_slave_shared_pkg::tx_flag \
sim:/spi_slave_shared_pkg::delay \
sim:/spi_slave_shared_pkg::constraint_done \
sim:/spi_slave_shared_pkg::i \
sim:/spi_slave_shared_pkg::correct_count_out \
sim:/spi_slave_shared_pkg::error_count_out
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/sb/reference_or_next \
sim:/uvm_root/uvm_test_top/env/sb/MISO_ref \
sim:/uvm_root/uvm_test_top/env/sb/rx_valid_ref \
sim:/uvm_root/uvm_test_top/env/sb/rx_data_ref \
sim:/uvm_root/uvm_test_top/env/sb/size \
sim:/uvm_root/uvm_test_top/env/sb/DATA_or_ADD 
run -all