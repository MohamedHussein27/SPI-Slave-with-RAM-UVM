package spi_wrapper_coverage_collector_pkg;
    import spi_wrapper_shared_pkg::*;
    import spi_wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_wrapper_coverage_collector extends uvm_component;
        `uvm_component_utils(spi_wrapper_coverage_collector)
        uvm_analysis_export #(spi_wrapper_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(spi_wrapper_seq_item) cov_fifo;

        spi_wrapper_seq_item spi_wrapper_item_cov;


        // cover group
        covergroup SPI_WRAPPER_Cross_Group;
            // cover points
            cp_ss_n: coverpoint spi_wrapper_item_cov.ss_n{ // how many states started and ended
                bins state_start = (1 => 0);
                bins state_end   = (0 => 1);
            }
        endgroup

        function new (string name = "spi_wrapper_coverage_collector", uvm_component parent = null);
            super.new(name, parent);
            SPI_WRAPPER_Cross_Group = new;
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
                cov_fifo.get(spi_wrapper_item_cov);        
                SPI_WRAPPER_Cross_Group.sample();
            end
        endtask
    endclass
endpackage