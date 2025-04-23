package spi_slave_test_pkg;
    import spi_slave_shared_pkg::*;
    import spi_slave_config_obj_pkg::*;
    import spi_slave_env_pkg::*;
    import spi_slave_reset_sequence_pkg::*;
    import spi_slave_main_sequence_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_slave_test extends uvm_test;
        `uvm_component_utils(spi_slave_test)

        spi_slave_env env; // environment object
        spi_slave_config_obj spi_slave_cfg; // configuration object     
        virtual spi_slave_if spi_slave_vif; // virtual interface
        // sequences
        spi_slave_reset_sequence reset_seq; // reset sequence
        spi_slave_main_sequence main_seq; // main sequence


        // construction function
        function new(string name = "spi_slave_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        // build both environmnet, Sequences and configuration objects 
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env  = spi_slave_env::type_id::create("env", this);
            spi_slave_cfg = spi_slave_config_obj::type_id::create("spi_slave_cfg");
            // sequences creation
            reset_seq = spi_slave_reset_sequence::type_id::create("reset_seq", this);
            main_seq = spi_slave_main_sequence::type_id::create("main_seq", this);

            //getting the real interface and assign it to the virtual one in the configuration object
            if (!uvm_config_db #(virtual spi_slave_if)::get(this,"","spi_slave_V", spi_slave_cfg.spi_slave_vif))
                `uvm_fatal("build_phase", "test unable");

            // setting the entire object to be visible by all under the spi_slave_test umbrella
            uvm_config_db #(spi_slave_config_obj)::set(this,"*","CFG", spi_slave_cfg);
        endfunction
        // run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this); // incerement static var.
            // reset sequence
            `uvm_info("run_phase", "reset asserted", UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "reset dasserted", UVM_LOW)

            `uvm_info("run_phase", "main asserted", UVM_MEDIUM)
            main_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "main dasserted", UVM_LOW)
            phase.drop_objection(this); // decrement static var.
        endtask
    endclass: spi_slave_test
endpackage