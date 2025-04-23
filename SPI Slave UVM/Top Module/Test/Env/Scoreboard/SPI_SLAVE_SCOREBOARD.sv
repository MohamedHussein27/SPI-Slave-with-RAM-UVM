package spi_slave_scoreboard_pkg;
    import spi_slave_shared_pkg::*;
    import spi_slave_seq_item_pkg::*;
    import spi_slave_config_obj_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_slave_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(spi_slave_scoreboard)
        uvm_analysis_export #(spi_slave_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(spi_slave_seq_item) sb_fifo;
        spi_slave_seq_item seq_item_sb;

        bit DATA_or_ADD; // indicates whether its read data or read address state
        reg queue_store[$]; // to store data
        logic [3:0] size; // to indicate the size of the queue 
        
        // Reference signals
        logic [9:0] rx_data_ref;
        logic rx_valid_ref;
        logic MISO_ref;

        // flags
        bit reference_or_next = 0; // flag to decide when to send the sequence item to reference task or next_State task


        function new(string name = "spi_slave_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction


        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        // connect
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        // run
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                // sequence item will be sent 
                if (reference_or_next) begin
                    ref_model(seq_item_sb);
                    reference_or_next = 0; // next time sequence item will be sent to next_state task
                end
                else if(!reference_or_next) begin
                    next_state(seq_item_sb);
                    reference_or_next = 1; // next time sequence item will be sent to refernce model
                end
                if(!reference_or_next) begin // take only sequencce items for the reference model
                    // compare
                    if (seq_item_sb.MISO !== MISO_ref) begin
                        error_count_out++;
                        $display("error in data out at %0d", error_count_out);           
                        `uvm_error("run_phase", $sformatf("comparison failed transaction received by the DUT:%s while the reference out:0b%0b",
                        seq_item_sb.convert2string(), MISO_ref));
                    end
                    else begin
                        `uvm_info("run_phase", $sformatf("correct spi_slave out: %s", seq_item_sb.convert2string()), UVM_HIGH);
                        correct_count_out++;
                    end
                end
            end
        endtask

        // reference model
        task ref_model (spi_slave_seq_item seq_item_chk);
            // output logic
            if (!seq_item_chk.rst_n) begin
                rx_data_ref = 0;
                rx_valid_ref = 1'b0;
                MISO_ref = 1'b0;
                DATA_or_ADD = 1'b0; // read address comes first
                counter = 0; // defined in shared package
                queue_store.delete(); // deleting queue
                size = 0;
                state_finished = 0; // defined in shared package
                cs = IDLE;
                ns = IDLE;
                delay = 1; // defined in shared package
            end
            else begin 
                if(cs == IDLE) begin
                    rx_valid_ref = 1'b0;
                    queue_store.delete(); // deleting queue
                    size = 0;
                    counter = 0; // defined in shared package
                    MISO_ref = 1'b0; 
                    state_finished = 0; // defined in shared package
                    ns = IDLE;
                end
                else if(cs == WRITE || cs == READ_ADD) begin
                    queue_store.push_back(seq_item_chk.MOSI); // filling queue
                    size = queue_store.size();
                    if (size == 10) state_finished = 1; // defined in shared package
                    if (size == 11) begin // the data is ready at size = 10 but we used size = 11 to add a delay to match the dut
                        rx_valid_ref = 1'b1;
                        //rx_data_ref = queue_store; // wrong assignment
                        for (int i = 0; i < 10; i++) begin
                            //rx_data_ref[i] = queue_store[i]; // assign each bit from queue to rx_data
                            rx_data_ref[9-i] = queue_store.pop_front(); // evacuating queue
                        end
                        if (cs == READ_ADD) DATA_or_ADD = 1'b1; // it's READ_DATA state turn
                    end
                end
                else if(cs == READ_DATA) begin
                    if(rx_valid_ref) rx_valid_ref = 0; // put it first to consider the clock delay
                    if(seq_item_chk.tx_valid) begin
                        MISO_ref = seq_item_chk.tx_data[7 - counter]; // MSB first
                        counter++;
                        if (counter == 7) begin
                            DATA_or_ADD = 1'b0; // it's READ_ADD state turn
                            state_finished = 1; // defined in shared package
                            tx_flag = 1'b0;
                        end
                    end  
                    else begin
                        queue_store.push_back(seq_item_chk.MOSI); // filling queue
                        size = queue_store.size();
                        if (size == 11) begin // the data is ready at size = 10 but we used size = 11 to add a delay to match the dut
                            rx_valid_ref = 1'b1;
                            for (int i = 0; i < 10; i++) begin
                                rx_data_ref[9-i] = queue_store.pop_front(); // assign each bit from queue to rx_data
                            end
                            tx_flag = 1'b1; // defined in shared package
                        end
                    end                 
                end
            end
            // next state logic (written upside down to consider the clock delay)
            if (cs == WRITE) begin
                if (seq_item_chk.ss_n) cs = IDLE;
                else cs = WRITE;
            end
            else if (cs == READ_ADD) begin
                if (seq_item_chk.ss_n) cs = IDLE;
                else cs = READ_ADD;
            end
            else if (cs == READ_DATA) begin
                if (seq_item_chk.ss_n) cs = IDLE;
                else cs = READ_DATA;
            end
            else if (cs == CHK_CMD) begin
                if (seq_item_chk.ss_n) cs = IDLE;
                else if (!seq_item_chk.ss_n && !seq_item_chk.MOSI) cs = WRITE;
                else if (!seq_item_chk.ss_n && seq_item_chk.MOSI && !DATA_or_ADD) cs = READ_ADD;
                else if (!seq_item_chk.ss_n && seq_item_chk.MOSI && DATA_or_ADD) cs = READ_DATA;
            end
            else if (cs == IDLE) begin
                if (delay) cs = IDLE; // flag delay is defined in shared package
                else if (seq_item_chk.ss_n) cs = IDLE;
                else if (!seq_item_chk.ss_n) cs = CHK_CMD;
                delay = 0; // cancelling delay as we need it only for one clock tick
            end
        endtask

        // this is next state logic for the three main states, i added this function to help in constrianting MOSI
        task next_state (spi_slave_seq_item seq_item_next);
            if (cs == CHK_CMD) begin
                if (seq_item_next.ss_n) ns = IDLE;
                else if (!seq_item_next.ss_n && !sampling_MOSI) ns = WRITE;
                else if (!seq_item_next.ss_n && sampling_MOSI && !DATA_or_ADD) ns = READ_ADD;
                else if (!seq_item_next.ss_n && sampling_MOSI && DATA_or_ADD) ns = READ_DATA;
            end
        endtask
        
        // report
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("total successful transactions: %0d", correct_count_out), UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("total failed transactions: %0d", error_count_out), UVM_MEDIUM);
        endfunction
    endclass
endpackage
