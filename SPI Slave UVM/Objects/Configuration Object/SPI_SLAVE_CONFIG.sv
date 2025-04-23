package spi_slave_config_obj_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_slave_config_obj extends uvm_object;
        `uvm_object_utils(spi_slave_config_obj)

        // virtual interface
        virtual spi_slave_if spi_slave_vif;
        // constructor
        function new(string name = "spi_slave_config_obj");
            super.new(name);
        endfunction
    endclass
endpackage