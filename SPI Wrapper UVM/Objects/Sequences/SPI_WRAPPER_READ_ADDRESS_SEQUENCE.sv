package spi_wrapper_read_address_sequence_pkg;
    import spi_wrapper_seq_item_pkg::*;
    import spi_wrapper_shared_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_wrapper_read_address_sequence extends uvm_sequence #(spi_wrapper_seq_item);
        `uvm_object_utils(spi_wrapper_read_address_sequence);
        spi_wrapper_seq_item seq_item;

        function new(string name = "spi_wrapper_read_address_sequence");
            super.new(name);
        endfunction

        int j = 0;  // counter to loop on the rows of address_with values

        task body;
            logic read_address_queue[$] = {1,1,0}; // queue to make the MOSI choose read address state
            int x = 0; // counter for achieving read state logic
            bit done = 0; // flag for terminating read address sequence
            q = 0;
            // read_address test to test MISO signal having the correct output when it is a real memory value rather than an unknown signal
            while(!done) begin
                seq_item = spi_wrapper_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.rst_n = 1;
                if(x == 0) seq_item.ss_n = 0; //go to CHK_CMD state
                else if (x < 4) begin // enter three times 
                    seq_item.MOSI = read_address_queue.pop_front();
                end
                else if(x >= 4 && q < 8) begin // q < 8 as by this we would have the address completed in MOSI
                    seq_item.MOSI = addresses_with_values[j][7 - q]; // to get the stored addresses to MISO
                    q++;
                end
                else begin
                    q++; // counter q is declared in shared package
                    if(q == 9 || q == 10) seq_item.ss_n = 1; //end protocol, (q == 9) ==> one clock after retreiving the address              
                    else if(q == 11) begin 
                        done = 1; // terminating read address sequence
                        j++;
                    end
                end
                x++;
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage