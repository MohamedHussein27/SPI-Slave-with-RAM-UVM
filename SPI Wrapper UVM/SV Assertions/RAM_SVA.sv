module ram_sva(ram_if.DUT ramif);

    // assertions
    // immediate signals
    /*always_comb begin
        if(!ramif.rst_n) begin
            `ifdef SIM // to make it invisible when synthesizing
                dout_ia: assert final(dout == 8'h00);
                ramif.tx_valid_ia: assert final(tx_valid == 1'b0);
                addr_wr_ia:  assert final(addr_wr  == 8'h00);
                addr_re_ia:  assert final(addr_re  == 8'h00);
            `endif
        end
    end*/
    
    // properties
    property rst_n_p; // check the value of the outputs, read address and write address when reset
        @(posedge ramif.clk) (!ramif.rst_n) |=> ((ramif.dout == 8'h00) && (ramif.tx_valid == 1'b0) && (DUT.Ram.addr_wr == 8'h00) && (DUT.Ram.addr_re == 8'h00));
    endproperty

    property addr_wr_p; // check on write address when operation is write address
        @(posedge ramif.clk) disable iff (ramif.rst_n == 0) ramif.rx_valid && (ramif.din[9:8] == 2'b00) |=> (DUT.Ram.addr_wr == $past(ramif.din[7:0]));
    endproperty

    property addr_re_p; // check on read address when operation is read address
        @(posedge ramif.clk) disable iff (ramif.rst_n == 0) ramif.rx_valid && (ramif.din[9:8] == 2'b10) |=> (DUT.Ram.addr_re == $past(ramif.din[7:0]));
    endproperty

    property w_data_p; // check on memory value when write data
        @(posedge ramif.clk) disable iff (ramif.rst_n == 0) ramif.rx_valid && (ramif.din[9:8] == 2'b01) |=> (DUT.Ram.memory[DUT.Ram.addr_wr] == $past(ramif.din[7:0]));
    endproperty

    property r_data_p; // check on dout when operatoion is read data
        @(posedge ramif.clk) disable iff (ramif.rst_n == 0) ramif.rx_valid && (ramif.din[9:8] == 2'b11) |=> (ramif.dout === $past(DUT.Ram.memory[$past(DUT.Ram.addr_re)]));
    endproperty

    property tx_valid_p; // check on tx_valid when the operation is read data
        @(posedge ramif.clk) disable iff (ramif.rst_n == 0) ramif.rx_valid && (ramif.din[9:8] == 2'b11) |=> (ramif.tx_valid);
    endproperty

    property not_tx_valid_p; // check on ramif.tx_valid when the operation is not read data
        @(posedge ramif.clk) disable iff (ramif.rst_n == 0) ramif.rx_valid && (ramif.din[9:8] != 2'b11) |=> (!ramif.tx_valid);
    endproperty

    property not_rx_valid_p; // check on the value of ramif.dout when ramif.rx_valid is not high
        @(posedge ramif.clk) disable iff (ramif.rst_n == 0) (!ramif.rx_valid) && (ramif.din[9:8] == 2'b11) |=> (ramif.dout === $past(ramif.dout));
    endproperty

    // garded assertions
    rst_n_a: assert property (rst_n_p); 
    addr_wr_a: assert property (addr_wr_p);
    addr_re_a: assert property (addr_re_p);
    w_data_a:  assert property (w_data_p);
    r_data_a:  assert property (r_data_p);
    tx_valid_a: assert property (tx_valid_p);
    not_tx_valid_a: assert property (not_tx_valid_p);
    rx_valid_a: assert property (not_rx_valid_p);

    // cover assertions
    rst_n_c: cover property (rst_n_p);
    addr_wr_c: cover property (addr_wr_p);
    addr_re_c: cover property (addr_re_p);
    w_data_c:  cover property (w_data_p );
    r_data_c:  cover property (r_data_p );
    tx_valid_c: cover property (tx_valid_p);
    not_tx_valid_c: cover property (not_tx_valid_p);
    rx_valid_c: cover property (not_rx_valid_p);
endmodule