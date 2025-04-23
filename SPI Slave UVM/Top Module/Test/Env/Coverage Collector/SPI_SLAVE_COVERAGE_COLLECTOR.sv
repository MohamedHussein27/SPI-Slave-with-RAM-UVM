package spi_slave_coverage_collector_pkg;
    import spi_slave_shared_pkg::*;
    import spi_slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_slave_coverage_collector extends uvm_component;
        `uvm_component_utils(spi_slave_coverage_collector)
        uvm_analysis_export #(spi_slave_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(spi_slave_seq_item) cov_fifo;

        spi_slave_seq_item spi_slave_item_cov;


        // cover group
        covergroup SPI_SLAVE_Cross_Group;
            // cover points
            cp_tx_valid: coverpoint spi_slave_item_cov.tx_valid;
            cp_tx_data: coverpoint spi_slave_item_cov.tx_data;
            cp_rx_valid: coverpoint spi_slave_item_cov.rx_valid;
            cp_ss_n: coverpoint spi_slave_item_cov.ss_n;
            cp_rx_data9: coverpoint spi_slave_item_cov.rx_data[9];
            cp_rx_data8: coverpoint spi_slave_item_cov.rx_data[8];
            // cross coverage
            wr_addr_C: cross cp_rx_data9, cp_rx_data8, cp_rx_valid { // write address corss
                bins wr_addr = binsof(cp_rx_data9) intersect {0} && binsof(cp_rx_data8) intersect {0} && binsof(cp_rx_valid) intersect {1};
                option.cross_auto_bin_max = 0; // we only want to cover write address condition
            }
            rd_addr_C: cross cp_rx_data9, cp_rx_data8, cp_rx_valid { // read address corss
                bins rd_addr = binsof(cp_rx_data9) intersect {1} && binsof(cp_rx_data8) intersect {0} && binsof(cp_rx_valid) intersect {1};
                option.cross_auto_bin_max = 0;
            }
            wr_data_C: cross cp_rx_data9, cp_rx_data8, cp_rx_valid { // write data corss
                bins wr_data = binsof(cp_rx_data9) intersect {0} && binsof(cp_rx_data8) intersect {1} && binsof(cp_rx_valid) intersect {1};
                option.cross_auto_bin_max = 0;
            }
            rd_data_C: cross cp_rx_data9, cp_rx_data8, cp_rx_valid { // read data corss
                bins rd_data = binsof(cp_rx_data9) intersect {1} && binsof(cp_rx_data8) intersect {1} && binsof(cp_rx_valid) intersect {1};
                option.cross_auto_bin_max = 0;
            }
            receive_C: cross cp_tx_valid, cp_tx_data { // when tx_valid is high we should receive tx_data
                bins receive = binsof(cp_tx_valid) intersect {1} && binsof(cp_tx_data);
                option.cross_auto_bin_max = 0;
            }
        endgroup

        function new (string name = "spi_slave_coverage_collector", uvm_component parent = null);
            super.new(name, parent);
            SPI_SLAVE_Cross_Group = new;
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
                cov_fifo.get(spi_slave_item_cov);        
                SPI_SLAVE_Cross_Group.sample();
            end
        endtask
    endclass
endpackage