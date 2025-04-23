package spi_wrapper_driver_pkg;
    import spi_wrapper_shared_pkg::*;
    import spi_wrapper_config_obj_pkg::*;
    import spi_wrapper_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"    
    class spi_wrapper_driver extends uvm_driver #(spi_wrapper_seq_item);
        `uvm_component_utils(spi_wrapper_driver)

        virtual spi_wrapper_if spi_wrapper_vif; // virtual interface
        spi_wrapper_seq_item stim_seq_item; // sequence item

        function new(string name = "spi_wrapper_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item = spi_wrapper_seq_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);
                spi_wrapper_vif.rst_n = stim_seq_item.rst_n;
                spi_wrapper_vif.MOSI = stim_seq_item.MOSI;
                sampling_MOSI = stim_seq_item.MOSI;
                //slave_sampling_MOSI = stim_seq_item.MOSI;
                spi_wrapper_vif.ss_n = stim_seq_item.ss_n;
                #20;
                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage
            
