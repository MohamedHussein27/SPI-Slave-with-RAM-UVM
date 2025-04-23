package ram_scoreboard_pkg;
    import ram_shared_pkg::*;
    import ram_seq_item_pkg::*;
    import ram_config_obj_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class ram_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(ram_scoreboard)
        uvm_analysis_export #(ram_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
        ram_seq_item seq_item_sb;

        parameter MEM_DEPTH = 256;
        parameter ADDR_SIZE = 8;
        // internal signals
        logic [ADDR_SIZE-1:0] ref_mem [MEM_DEPTH]; // fixed array to verify RAM 
        bit [7:0] r_addr, w_addr;


        bit delayed_output; // to make a delay one clock in the output
        logic [7:0] dout; // just to add one clock delay to make the output of the RAM matches the DUT
        // we will take a copy from the correct output but compare it at the next clock edge
        // reference signals
        logic [7:0] dout_ref;
        logic tx_valid_ref;

        function new(string name = "ram_scoreboard", uvm_component parent = null);
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
                ref_model(seq_item_sb);
                // compare
                if (seq_item_sb.dout !== dout_ref) begin
                    error_count_out++;
                    $display("error in data out at %0d", error_count_out);           
                    `uvm_error("run_phase", $sformatf("comparison failed transaction received by the DUT:%s while the reference out:0b%0b",
                    seq_item_sb.convert2string(), dout_ref));
                end
                else begin
                    `uvm_info("run_phase", $sformatf("correct ram out: %s", seq_item_sb.convert2string()), UVM_HIGH);
                    correct_count_out++;
                end
            end
        endtask

        // reference model
        task ref_model (ram_seq_item seq_item_chk);
            if(!seq_item_chk.rst_n) begin
                dout_ref = 8'h00;
                tx_valid_ref = 1'b0;
                r_addr = 8'h00;
                w_addr = 8'h00;
                delayed_output = 1'b0;
            end
            if (delayed_output) begin 
                dout_ref = dout; // copy assigned to ref data out
                delayed_output = 0;
            end
            else begin
                if (seq_item_chk.rx_valid) begin
                    if (seq_item_chk.din[9:8] == 2'b00) begin // write address
                        w_addr = seq_item_chk.din[7:0];
                        tx_valid_ref = 1'b0;
                    end
                    else if (seq_item_chk.din[9:8] == 2'b01) begin // write data
                        ref_mem[w_addr] = seq_item_chk.din[7:0];
                        tx_valid_ref = 1'b0;
                    end
                    else if (seq_item_chk.din[9:8] == 2'b10) begin // read address
                        r_addr = seq_item_chk.din[7:0];
                        tx_valid_ref = 1'b0;
                        delayed_output = 1'b0;
                    end
                    else if (seq_item_chk.din[9:8] == 2'b11) begin // read data
                        dout = ref_mem[r_addr];
                        tx_valid_ref = 1'b1;
                        delayed_output = 1'b1;
                    end
                end
            end
        endtask
        
        // report
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("total successful transactions in RAM: %0d", correct_count_out), UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("total failed transactions in RAM: %0d
            ", error_count_out), UVM_MEDIUM);
        endfunction
    endclass
endpackage
