module spi_slave_sva(spi_slave_if.DUT spi_slaveif);

    // assertions
    // assertions for next state

    // check the value of the current state when reset is asserted
    property rst_n_ns_p;
        @(posedge spi_slaveif.clk) (!spi_slaveif.rst_n) |=> (DUT.SPI.cs == DUT.SPI.IDLE);
    endproperty

    // ensure FSM transitions correctly from DUT.SPI.IDLE to DUT.SPI.CHK_CMD when ss_n is deasserted
    property idle_to_chk_cmd_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.IDLE && !spi_slaveif.ss_n) |=> (DUT.SPI.cs == DUT.SPI.CHK_CMD);
    endproperty

    // ensure FSM transitions from DUT.SPI.CHK_CMD to DUT.SPI.WRITE when spi_slaveif.MOSI is 0
    property chk_cmd_to_write_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.CHK_CMD && !spi_slaveif.ss_n && spi_slaveif.MOSI == 0) |=> (DUT.SPI.cs == DUT.SPI.WRITE);
    endproperty

    // ensure FSM transitions from DUT.SPI.CHK_CMD to DUT.SPI.READ_ADD when spi_slaveif.MOSI is 1 and ADD_DATA_checker is 1
    property chk_cmd_to_read_add_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.CHK_CMD && !spi_slaveif.ss_n && spi_slaveif.MOSI == 1 && DUT.SPI.ADD_DATA_checker == 1) |=> (DUT.SPI.cs == DUT.SPI.READ_ADD);
    endproperty

    // ensure FSM transitions from DUT.SPI.CHK_CMD to DUT.SPI.READ_DATA when spi_slaveif.MOSI is 1 and ADD_DATA_checker is 0
    property chk_cmd_to_read_data_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.CHK_CMD && !spi_slaveif.ss_n && spi_slaveif.MOSI == 1 && DUT.SPI.ADD_DATA_checker == 0) |=> (DUT.SPI.cs == DUT.SPI.READ_DATA);
    endproperty    

    // ensure FSM remains in DUT.SPI.WRITE unless ss_n is asserted
    property write_hold_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.WRITE && !spi_slaveif.ss_n) |=> (DUT.SPI.cs == DUT.SPI.WRITE);
    endproperty   

    // ensure FSM transitions from DUT.SPI.WRITE to DUT.SPI.IDLE when ss_n is asserted or counter1 reaches max
    property write_to_idle_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.WRITE && spi_slaveif.ss_n) |=> (DUT.SPI.cs == DUT.SPI.IDLE);
    endproperty   

    // ensure FSM remains in DUT.SPI.READ_ADD unless ss_n is asserted
    property read_add_hold_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.READ_ADD && !spi_slaveif.ss_n) |=> (DUT.SPI.cs == DUT.SPI.READ_ADD);
    endproperty   

    // ensure FSM transitions from DUT.SPI.READ_ADD to DUT.SPI.IDLE when ss_n is asserted or counter1 reaches max
    property read_add_to_idle_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.READ_ADD && spi_slaveif.ss_n) |=> (DUT.SPI.cs == DUT.SPI.IDLE);
    endproperty

    // ensure FSM remains in DUT.SPI.READ_DATA unless ss_n is asserted
    property read_data_hold_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.READ_DATA && !spi_slaveif.ss_n) |=> (DUT.SPI.cs == DUT.SPI.READ_DATA);
    endproperty

    // ensure FSM transitions from DUT.SPI.READ_DATA to DUT.SPI.IDLE when ss_n is asserted
    property read_data_to_idle_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.READ_DATA && spi_slaveif.ss_n) |=> (DUT.SPI.cs == DUT.SPI.IDLE);
    endproperty

     // assertions
    rst_n_ns_a: assert property (rst_n_ns_p);
    idle_to_chk_cmd_a: assert property (idle_to_chk_cmd_p);
    chk_cmd_to_write_a: assert property (chk_cmd_to_write_p);
    chk_cmd_to_read_add_a: assert property (chk_cmd_to_read_add_p);
    chk_cmd_to_read_data_a: assert property (chk_cmd_to_read_data_p);
    write_hold_a: assert property (write_hold_p);
    write_to_idle_a: assert property (write_to_idle_p);
    read_add_hold_a: assert property (read_add_hold_p);
    read_add_to_idle_a: assert property (read_add_to_idle_p);
    read_data_hold_a: assert property (read_data_hold_p);
    read_data_to_idle_a: assert property (read_data_to_idle_p);
    
    // cover assertions
    rst_n_ns_c: cover property (rst_n_ns_p);
    idle_to_chk_cmd_c: cover property (idle_to_chk_cmd_p);
    chk_cmd_to_write_c: cover property (chk_cmd_to_write_p);
    chk_cmd_to_read_add_c: cover property (chk_cmd_to_read_add_p);
    chk_cmd_to_read_data_c: cover property (chk_cmd_to_read_data_p);
    write_hold_c: cover property (write_hold_p);
    write_to_idle_c: cover property (write_to_idle_p);
    read_add_hold_c: cover property (read_add_hold_p);
    read_add_to_idle_c: cover property (read_add_to_idle_p);
    read_data_hold_c: cover property (read_data_hold_p);
    read_data_to_idle_c: cover property (read_data_to_idle_p);

    // assertions for output logic
    // check the value of rx_data, rx_valid and MISO when reset
    property rst_n_o_p;
        @(posedge spi_slaveif.clk) (!spi_slaveif.rst_n) |=> ((spi_slaveif.rx_data == 0) && (!spi_slaveif.rx_valid) && (!spi_slaveif.MISO));
    endproperty

    // check the value of spi_slaveif.rx_valid when DUT.SPI.cs is DUT.SPI.IDLE
    property idle_o_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.IDLE) |=> (!spi_slaveif.rx_valid);
    endproperty

    // check the value of spi_slaveif.rx_data, spi_slaveif.rx_valid when DUT.SPI.cs is DUT.SPI.WRITE and counter is maxed
    property write_o_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.WRITE) && (DUT.SPI.counter1 == 4'hf) |=> $rose(spi_slaveif.rx_valid) && (spi_slaveif.rx_data == DUT.SPI.bus) |=> $fell(spi_slaveif.rx_valid);
    endproperty

    // check the value of spi_slaveif.rx_data, spi_slaveif.rx_valid and DUT.SPI.ADD_DATA_checker when DUT.SPI.cs is DUT.SPI.READ_ADD and counter is maxed
    property read_add_o_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.READ_ADD) && (DUT.SPI.counter1 == 4'hf) |=> $rose(spi_slaveif.rx_valid) && (spi_slaveif.rx_data == DUT.SPI.bus) && $fell(DUT.SPI.ADD_DATA_checker) |=> $fell(spi_slaveif.rx_valid);
    endproperty

    // check the value of spi_slaveif.rx_valid when DUT.SPI.cs is DUT.SPIREAD_DATA and the first counter is maxed
    property read_data_o_p_1;  
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.READ_DATA) && (DUT.SPI.counter1 == 4'hf) |=> $rose(spi_slaveif.rx_valid) && (spi_slaveif.rx_data == DUT.SPI.bus) |=> $fell(spi_slaveif.rx_valid);
    endproperty

    // check the value of spi_slaveif.MISO when DUT.SPI.cs is READ_DATA and spi_slaveif.tx_valid is high
    /*property read_data_o_p_2;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.READ_DATA) && (DUT.SPI.tx_valid) |=> (DUT.SPI.MISO == DUT.SPI.tx_data[$past(DUT.SPI.counter2)]);
    endproperty*/ // we can't use this property when verifying the wrapper as we don't have a memory in this scoreboard 

    // check the value of DUT.SPI.ADD_DATA_checker when DUT.SPI.cs is DUT.SPIREAD_DATA and DUT.SPI.counter2 is maxed
    property read_data_o_p_3;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.SPI.cs == DUT.SPI.READ_DATA) && (DUT.SPI.counter2 == 3'b111) |=> DUT.SPI.ADD_DATA_checker;
    endproperty

    // Garded assertions
    rst_n_o_a: assert property (rst_n_o_p);
    idle_o_a: assert property (idle_o_p);
    write_o_a: assert property (write_o_p);
    read_add_o_a: assert property (read_add_o_p);
    read_data_o_a_1: assert property (read_data_o_p_1);
    //read_data_o_a_2: assert property (read_data_o_p_2);
    read_data_o_a_3: assert property (read_data_o_p_3);

    // cover assertions
    rst_n_o_c: cover property (rst_n_o_p);
    idle_o_c:  cover property (idle_o_p );
    write_o_c: cover property (write_o_p);
    read_add_o_c: cover property (read_add_o_p);
    read_data_o_c_1: cover property (read_data_o_p_1);
    //read_data_o_c_2: cover property (read_data_o_p_2);
    read_data_o_c_3: cover property (read_data_o_p_3);
   
endmodule