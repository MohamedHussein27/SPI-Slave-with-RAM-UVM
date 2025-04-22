package spi_wrapper_randomized_sequence_pkg;
    import spi_wrapper_seq_item_pkg::*;
    import spi_wrapper_shared_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_wrapper_randomized_sequence extends uvm_sequence #(spi_wrapper_seq_item);
        `uvm_object_utils(spi_wrapper_randomized_sequence);
        spi_wrapper_seq_item seq_item;

        function new(string name = "spi_wrapper_randomized_sequence");
            super.new(name);
        endfunction

        task body;
            repeat(1000)begin
                seq_item = spi_wrapper_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize()); 
                // next stetements are for constrianting the MOSI signal in each state according to the steps   
                if(ns == WRITE) begin // made it for one clock as to be write_add or write_data randomly
                    i++; // defined in shared package
                    if(i == 1) write_constraint = 0; // Disable the constraint after 1 cycles
                end      
                else if(ns == READ_ADD) begin // made it for two clocks to make the first two values of MOSI to be 2'b10 in case of read_add state 
                    i++; // defined in shared package
                    if(i == 2) read_add_constraint = 0; // Disable the constraint after 2 cycles
                end 
                else if(ns == READ_DATA) begin // made it for two clocks to make the first two values of MOSI to be 2'b11 in case of read_data state
                    //#20;
                    //if (constraint_done) seq_item.MOSI_read_data_con.constraint_mode(0); // Disable the constraint after 1 cycles
                    i++; // defined in shared package
                    if(i == 2) read_data_constraint = 0; // Disable the constraint after 2 cycles
                end 
                else if(cs == IDLE) begin
                    // enable all the constraints
                    write_constraint = 1;
                    read_add_constraint = 1;
                    read_data_constraint = 1;
                    i = 0; // defined in shared package
                end  
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage