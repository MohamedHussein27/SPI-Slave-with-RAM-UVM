module spi_slave_sva(spi_slave_if.DUT spi_slaveif);

    // assertions
    // assertions for next state

    // check the value of the current state when reset is asserted
    property rst_n_ns_p;
        @(posedge spi_slaveif.clk) (!spi_slaveif.rst_n) |=> (DUT.cs == DUT.IDLE);
    endproperty

    // ensure FSM transitions correctly from DUT.IDLE to DUT.CHK_CMD when ss_n is deasserted
    property idle_to_chk_cmd_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.IDLE && !spi_slaveif.ss_n) |=> (DUT.cs == DUT.CHK_CMD);
    endproperty

    // ensure FSM transitions from DUT.CHK_CMD to DUT.WRITE when spi_slaveif.MOSI is 0
    property chk_cmd_to_write_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.CHK_CMD && !spi_slaveif.ss_n && spi_slaveif.MOSI == 0) |=> (DUT.cs == DUT.WRITE);
    endproperty

    // ensure FSM transitions from DUT.CHK_CMD to DUT.READ_ADD when spi_slaveif.MOSI is 1 and ADD_DATA_checker is 1
    property chk_cmd_to_read_add_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.CHK_CMD && !spi_slaveif.ss_n && spi_slaveif.MOSI == 1 && DUT.ADD_DATA_checker == 1) |=> (DUT.cs == DUT.READ_ADD);
    endproperty

    // ensure FSM transitions from DUT.CHK_CMD to DUT.READ_DATA when spi_slaveif.MOSI is 1 and ADD_DATA_checker is 0
    property chk_cmd_to_read_data_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.CHK_CMD && !spi_slaveif.ss_n && spi_slaveif.MOSI == 1 && DUT.ADD_DATA_checker == 0) |=> (DUT.cs == DUT.READ_DATA);
    endproperty    

    // ensure FSM remains in DUT.WRITE unless ss_n is asserted
    property write_hold_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.WRITE && !spi_slaveif.ss_n) |=> (DUT.cs == DUT.WRITE);
    endproperty   

    // ensure FSM transitions from DUT.WRITE to DUT.IDLE when ss_n is asserted or counter1 reaches max
    property write_to_idle_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.WRITE && spi_slaveif.ss_n) |=> (DUT.cs == DUT.IDLE);
    endproperty   

    // ensure FSM remains in DUT.READ_ADD unless ss_n is asserted
    property read_add_hold_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.READ_ADD && !spi_slaveif.ss_n) |=> (DUT.cs == DUT.READ_ADD);
    endproperty   

    // ensure FSM transitions from DUT.READ_ADD to DUT.IDLE when ss_n is asserted or counter1 reaches max
    property read_add_to_idle_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.READ_ADD && spi_slaveif.ss_n) |=> (DUT.cs == DUT.IDLE);
    endproperty

    // ensure FSM remains in DUT.READ_DATA unless ss_n is asserted
    property read_data_hold_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.READ_DATA && !spi_slaveif.ss_n) |=> (DUT.cs == DUT.READ_DATA);
    endproperty

    // ensure FSM transitions from DUT.READ_DATA to DUT.IDLE when ss_n is asserted
    property read_data_to_idle_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.READ_DATA && spi_slaveif.ss_n) |=> (DUT.cs == DUT.IDLE);
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

    // check the value of spi_slaveif.rx_valid when DUT.cs is DUT.IDLE
    property idle_o_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.IDLE) |=> (!spi_slaveif.rx_valid);
    endproperty

    // check the value of spi_slaveif.rx_data, spi_slaveif.rx_valid when DUT.cs is DUT.WRITE and counter is maxed
    property write_o_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.WRITE) && (DUT.counter1 == 4'hf) |=> $rose(spi_slaveif.rx_valid) && (spi_slaveif.rx_data == DUT.bus) |=> $fell(spi_slaveif.rx_valid);
    endproperty

    // check the value of spi_slaveif.rx_data, spi_slaveif.rx_valid and DUT.ADD_DATA_checker when DUT.cs is DUT.READ_ADD and counter is maxed
    property read_add_o_p;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.READ_ADD) && (DUT.counter1 == 4'hf) |=> $rose(spi_slaveif.rx_valid) && (spi_slaveif.rx_data == DUT.bus) && $fell(DUT.ADD_DATA_checker) |=> $fell(spi_slaveif.rx_valid);
    endproperty

    // check the value of spi_slaveif.rx_valid when DUT.cs is DUTREAD_DATA and the first counter is maxed
    property read_data_o_p_1;  
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.READ_DATA) && (DUT.counter1 == 4'hf) |=> $rose(spi_slaveif.rx_valid) && (spi_slaveif.rx_data == DUT.bus) |=> $fell(spi_slaveif.rx_valid);
    endproperty

    // check the value of spi_slaveif.MISO when DUT.cs is READ_DATA and spi_slaveif.tx_valid is high
    property read_data_o_p_2;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.READ_DATA) && (DUT.tx_valid) |=> (DUT.MISO == DUT.tx_data[$past(DUT.counter2)]);
    endproperty

    // check the value of DUT.ADD_DATA_checker when DUT.cs is DUTREAD_DATA and DUT.counter2 is maxed
    property read_data_o_p_3;
        @(posedge spi_slaveif.clk) disable iff (spi_slaveif.rst_n == 0) (DUT.cs == DUT.READ_DATA) && (DUT.counter2 == 3'b111) |=> DUT.ADD_DATA_checker;
    endproperty

    // Garded assertions
    rst_n_o_a: assert property (rst_n_o_p);
    idle_o_a: assert property (idle_o_p);
    write_o_a: assert property (write_o_p);
    read_add_o_a: assert property (read_add_o_p);
    read_data_o_a_1: assert property (read_data_o_p_1);
    read_data_o_a_2: assert property (read_data_o_p_2);
    read_data_o_a_3: assert property (read_data_o_p_3);

    // cover assertions
    rst_n_o_c: cover property (rst_n_o_p);
    idle_o_c:  cover property (idle_o_p );
    write_o_c: cover property (write_o_p);
    read_add_o_c: cover property (read_add_o_p);
    read_data_o_c_1: cover property (read_data_o_p_1);
    read_data_o_c_2: cover property (read_data_o_p_2);
    read_data_o_c_3: cover property (read_data_o_p_3);
   
endmodule