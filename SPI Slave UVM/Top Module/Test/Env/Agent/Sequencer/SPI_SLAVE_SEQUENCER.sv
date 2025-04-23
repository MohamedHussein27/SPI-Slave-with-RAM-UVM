package spi_slave_sequencer_pkg;
    import spi_slave_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_slave_sequencer extends uvm_sequencer #(spi_slave_seq_item);
        `uvm_component_utils(spi_slave_sequencer)

        function new (string name = "spi_slave_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass
endpackage