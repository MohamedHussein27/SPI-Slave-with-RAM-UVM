vlib work
vlog -f spi_wrapper_files_list.txt +cover -covercells
vsim -voptargs=+acc work.spi_wrapper_top -cover -classdebug -uvmcontrol=all
add wave /spi_wrapper_top/spi_wrapperif/*
run 0
add wave -position insertpoint  \
sim:/spi_wrapper_top/DUT/MEM_DEPTH \
sim:/spi_wrapper_top/DUT/ADDR_SIZE \
sim:/spi_wrapper_top/DUT/clk \
sim:/spi_wrapper_top/DUT/rst_n \
sim:/spi_wrapper_top/DUT/MOSI \
sim:/spi_wrapper_top/DUT/ss_n \
sim:/spi_wrapper_top/DUT/MISO \
sim:/spi_wrapper_top/DUT/rxdata \
sim:/spi_wrapper_top/DUT/txdata \
sim:/spi_wrapper_top/DUT/rx_valid \
sim:/spi_wrapper_top/DUT/tx_valid
add wave -position insertpoint  \
sim:/spi_wrapper_top/DUT/SPI/IDLE \
sim:/spi_wrapper_top/DUT/SPI/CHK_CMD \
sim:/spi_wrapper_top/DUT/SPI/WRITE \
sim:/spi_wrapper_top/DUT/SPI/READ_ADD \
sim:/spi_wrapper_top/DUT/SPI/READ_DATA \
sim:/spi_wrapper_top/DUT/SPI/clk \
sim:/spi_wrapper_top/DUT/SPI/rst_n \
sim:/spi_wrapper_top/DUT/SPI/MOSI \
sim:/spi_wrapper_top/DUT/SPI/tx_valid \
sim:/spi_wrapper_top/DUT/SPI/ss_n \
sim:/spi_wrapper_top/DUT/SPI/tx_data \
sim:/spi_wrapper_top/DUT/SPI/MISO \
sim:/spi_wrapper_top/DUT/SPI/rx_valid \
sim:/spi_wrapper_top/DUT/SPI/rx_data \
sim:/spi_wrapper_top/DUT/SPI/cs \
sim:/spi_wrapper_top/DUT/SPI/ns \
sim:/spi_wrapper_top/DUT/SPI/ADD_DATA_checker \
sim:/spi_wrapper_top/DUT/SPI/counter1 \
sim:/spi_wrapper_top/DUT/SPI/counter2 \
sim:/spi_wrapper_top/DUT/SPI/bus
add wave -position insertpoint  \
sim:/spi_wrapper_top/DUT/Ram/MEM_DEPTH \
sim:/spi_wrapper_top/DUT/Ram/ADDR_SIZE \
sim:/spi_wrapper_top/DUT/Ram/clk \
sim:/spi_wrapper_top/DUT/Ram/rst_n \
sim:/spi_wrapper_top/DUT/Ram/rx_valid \
sim:/spi_wrapper_top/DUT/Ram/din \
sim:/spi_wrapper_top/DUT/Ram/dout \
sim:/spi_wrapper_top/DUT/Ram/tx_valid \
sim:/spi_wrapper_top/DUT/Ram/memory \
sim:/spi_wrapper_top/DUT/Ram/addr_wr \
sim:/spi_wrapper_top/DUT/Ram/addr_re
add wave -position insertpoint  \
sim:/spi_wrapper_shared_pkg::MEM_DEPTH \
sim:/spi_wrapper_shared_pkg::ADDR_SIZE \
sim:/spi_wrapper_shared_pkg::cs \
sim:/spi_wrapper_shared_pkg::ns \
sim:/spi_wrapper_shared_pkg::sampling_MOSI \
sim:/spi_wrapper_shared_pkg::addresses_with_values \
sim:/spi_wrapper_shared_pkg::k \
sim:/spi_wrapper_shared_pkg::q \
sim:/spi_wrapper_shared_pkg::counter \
sim:/spi_wrapper_shared_pkg::state_finished \
sim:/spi_wrapper_shared_pkg::delay \
sim:/spi_wrapper_shared_pkg::MISO_delay \
sim:/spi_wrapper_shared_pkg::i \
sim:/spi_wrapper_shared_pkg::write_constraint \
sim:/spi_wrapper_shared_pkg::read_add_constraint \
sim:/spi_wrapper_shared_pkg::read_data_constraint \
sim:/spi_wrapper_shared_pkg::correct_count_out \
sim:/spi_wrapper_shared_pkg::error_count_out
add wave -position insertpoint  \
sim:/spi_slave_shared_pkg::cs \
sim:/spi_slave_shared_pkg::state_finished \
sim:/spi_slave_shared_pkg::correct_count_out \
sim:/spi_slave_shared_pkg::error_count_out
add wave -position insertpoint  \
sim:/ram_shared_pkg::error_count_out \
sim:/ram_shared_pkg::correct_count_out
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/wrapper_sb/reference_or_next \
sim:/uvm_root/uvm_test_top/env/wrapper_sb/MISO_ref \
sim:/uvm_root/uvm_test_top/env/wrapper_sb/tx_valid_ref \
sim:/uvm_root/uvm_test_top/env/wrapper_sb/tx_data_ref \
sim:/uvm_root/uvm_test_top/env/wrapper_sb/w_addr_ref \
sim:/uvm_root/uvm_test_top/env/wrapper_sb/r_addr_ref \
sim:/uvm_root/uvm_test_top/env/wrapper_sb/ref_mem \
sim:/uvm_root/uvm_test_top/env/wrapper_sb/rx_valid_ref \
sim:/uvm_root/uvm_test_top/env/wrapper_sb/rx_data_ref \
sim:/uvm_root/uvm_test_top/env/wrapper_sb/DATA_or_ADD
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/slave_sb/MISO_ref \
sim:/uvm_root/uvm_test_top/env/slave_sb/rx_valid_ref \
sim:/uvm_root/uvm_test_top/env/slave_sb/rx_data_ref \
sim:/uvm_root/uvm_test_top/env/slave_sb/DATA_or_ADD
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/ram_sb/tx_valid_ref \
sim:/uvm_root/uvm_test_top/env/ram_sb/dout_ref \
sim:/uvm_root/uvm_test_top/env/ram_sb/w_addr \
sim:/uvm_root/uvm_test_top/env/ram_sb/r_addr \
sim:/uvm_root/uvm_test_top/env/ram_sb/ref_mem

run -all