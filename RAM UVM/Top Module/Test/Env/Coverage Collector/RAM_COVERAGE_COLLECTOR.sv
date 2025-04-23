package ram_coverage_collector_pkg;
    import ram_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class ram_coverage_collector extends uvm_component;
        `uvm_component_utils(ram_coverage_collector)
        uvm_analysis_export #(ram_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;

        ram_seq_item ram_item_cov;


        // cover group
        covergroup RAM_Cross_Group;
            // cover points
            cp_tx_valid: coverpoint ram_item_cov.tx_valid;
            cp_rx_valid: coverpoint ram_item_cov.rx_valid;
            cp_din9: coverpoint ram_item_cov.din[9];
            cp_din8: coverpoint ram_item_cov.din[8];
            // cross coverage
            wr_addr_C: cross cp_din9, cp_din8, cp_rx_valid { // write address corss
                bins wr_addr = binsof(cp_din9) intersect {0} && binsof(cp_din8) intersect {0} && binsof(cp_rx_valid) intersect {1};
                option.cross_auto_bin_max = 0; // we only want to cover write address condition
            }
            rd_addr_C: cross cp_din9, cp_din8, cp_rx_valid { // read address corss
                bins rd_addr = binsof(cp_din9) intersect {1} && binsof(cp_din8) intersect {0} && binsof(cp_rx_valid) intersect {1};
                option.cross_auto_bin_max = 0;
            }
            wr_data_C: cross cp_din9, cp_din8, cp_rx_valid { // write data corss
                bins wr_data = binsof(cp_din9) intersect {0} && binsof(cp_din8) intersect {1} && binsof(cp_rx_valid) intersect {1};
                option.cross_auto_bin_max = 0;
            }
            rd_data_C: cross cp_din9, cp_din8, cp_rx_valid, cp_tx_valid { // read data corss
                bins rd_data = binsof(cp_din9) intersect {1} && binsof(cp_din8) intersect {1} && binsof(cp_rx_valid) intersect {1} && binsof(cp_tx_valid) intersect {1};
                option.cross_auto_bin_max = 0;
            }
        endgroup

        function new (string name = "ram_coverage_collector", uvm_component parent = null);
            super.new(name, parent);
            RAM_Cross_Group = new;
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(ram_item_cov);        
                RAM_Cross_Group.sample();
            end
        endtask
    endclass
endpackage