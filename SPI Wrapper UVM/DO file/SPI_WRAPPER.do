vlib work
vlog -f spi_wrapper_files_list.txt +cover -covercells
vsim -voptargs=+acc work.spi_wrapper_top -cover -classdebug -uvmcontrol=all
add wave /spi_wrapper_top/spi_wrapperif/*
run -all
