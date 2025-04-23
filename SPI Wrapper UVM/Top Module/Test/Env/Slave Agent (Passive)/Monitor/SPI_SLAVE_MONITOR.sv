package spi_slave_monitor_pkg;
    import spi_slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"   
    class spi_slave_monitor extends uvm_monitor;
        `uvm_component_utils(spi_slave_monitor)

        virtual spi_slave_if spi_slave_vif; // virtual interface
        spi_slave_seq_item rsp_seq_item_main; // main sequence item used for reference model in scoreboard and for coverage collector
        uvm_analysis_port #(spi_slave_seq_item) mon_ap;

        function new(string name = "spi_slave_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        // building share point
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item_main = spi_slave_seq_item::type_id::create("rsp_seq_item_main");
                #20; // negedge
                // assigning interface data to class transaction object
                rsp_seq_item_main.rst_n = spi_slave_vif.rst_n;
                rsp_seq_item_main.MOSI = spi_slave_vif.MOSI;
                rsp_seq_item_main.tx_valid = spi_slave_vif.tx_valid;
                rsp_seq_item_main.ss_n = spi_slave_vif.ss_n;
                rsp_seq_item_main.tx_data = spi_slave_vif.tx_data;
                rsp_seq_item_main.rx_valid = spi_slave_vif.rx_valid;
                rsp_seq_item_main.rx_data  = spi_slave_vif.rx_data;
                mon_ap.write(rsp_seq_item_main);
                `uvm_info("run_phase", rsp_seq_item_main.convert2string(), UVM_HIGH);
            end
        endtask
    endclass
endpackage