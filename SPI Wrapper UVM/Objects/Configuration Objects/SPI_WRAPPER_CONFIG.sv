package spi_wrapper_config_obj_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_wrapper_config_obj extends uvm_object;
        `uvm_object_utils(spi_wrapper_config_obj)

        uvm_active_passive_enum active_or_passive; 

        // virtual interface
        virtual spi_wrapper_if spi_wrapper_vif;
        // constructor
        function new(string name = "spi_wrapper_config_obj");
            super.new(name);
        endfunction
    endclass
endpackage