package spi_wrapper_test_pkg;
    import spi_wrapper_shared_pkg::*;
    import spi_wrapper_config_obj_pkg::*;
    import spi_slave_config_obj_pkg::*;
    import ram_config_obj_pkg::*;
    import spi_wrapper_env_pkg::*;
    import spi_wrapper_reset_sequence_pkg::*;
    import spi_wrapper_randomized_sequence_pkg::*;
    import spi_wrapper_read_address_sequence_pkg::*;
    import spi_wrapper_read_data_sequence_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_wrapper_test extends uvm_test;
        `uvm_component_utils(spi_wrapper_test)

        spi_wrapper_env env; // environment object    
        virtual spi_wrapper_if spi_wrapper_vif; // virtual interface
        
        // configuration objects
        spi_wrapper_config_obj spi_wrapper_cfg;
        spi_slave_config_obj spi_slave_cfg;
        ram_config_obj ram_cfg;

        // sequences
        spi_wrapper_reset_sequence reset_seq; // reset sequence
        spi_wrapper_randomized_sequence randomized_seq; // randomized sequence
        spi_wrapper_read_address_sequence read_address_seq; // read_address sequence
        spi_wrapper_read_data_sequence read_data_seq; // read_data sequence

        // construction function
        function new(string name = "spi_wrapper_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        // build both environmnet, Sequences and configuration objects 
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // building environment
            env  = spi_wrapper_env::type_id::create("env", this);

            // building configuration objects
            ram_cfg = ram_config_obj::type_id::create("ram_cfg");
            spi_slave_cfg = spi_slave_config_obj::type_id::create("spi_slave_cfg");
            spi_wrapper_cfg = spi_wrapper_config_obj::type_id::create("spi_wrapper_cfg");
            
            // sequences creation
            reset_seq = spi_wrapper_reset_sequence::type_id::create("reset_seq", this);
            randomized_seq = spi_wrapper_randomized_sequence::type_id::create("randomized_seq", this);
            read_address_seq = spi_wrapper_read_address_sequence::type_id::create("read_address_seq", this);
            read_data_seq = spi_wrapper_read_data_sequence::type_id::create("read_data_seq", this);

            //getting the real interface and assign it to the virtual one in the configuration object
            // Ram
            if (!uvm_config_db #(virtual ram_if)::get(this,"","ram_V", ram_cfg.ram_vif))
                `uvm_fatal("build_phase", "test unable");
            ram_cfg.active_or_passive = UVM_PASSIVE; // RAM Agent is passive agent
            // setting the entire object to be visible by all under the spi_wrapper_test umbrella
            uvm_config_db #(ram_config_obj)::set(this,"*","CFG_R", ram_cfg);
            
            // SPI Slave
            if (!uvm_config_db #(virtual spi_slave_if)::get(this,"","spi_slave_V", spi_slave_cfg.spi_slave_vif))
                `uvm_fatal("build_phase", "test unable");
            spi_slave_cfg.active_or_passive = UVM_PASSIVE; // SPI Slave Agent is passive agent
            // setting the entire object to be visible by all under the spi_wrapper_test umbrella
            uvm_config_db #(spi_slave_config_obj)::set(this,"*","CFG_S", spi_slave_cfg);
            
            
            if (!uvm_config_db #(virtual spi_wrapper_if)::get(this,"","spi_wrapper_V", spi_wrapper_cfg.spi_wrapper_vif))
                `uvm_fatal("build_phase", "test unable");
            spi_wrapper_cfg.active_or_passive = UVM_ACTIVE;
            // setting the entire object to be visible by all under the spi_wrapper_test umbrella
            uvm_config_db #(spi_wrapper_config_obj)::set(this,"*","CFG_W", spi_wrapper_cfg);
        endfunction
        // run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this); // incerement static var.
            // reset sequence
            `uvm_info("run_phase", "reset asserted", UVM_LOW)
            reset_seq.start(env.wrapper_agt.sqr);
            `uvm_info("run_phase", "reset dasserted", UVM_LOW)

            // randomized sequence
            `uvm_info("run_phase", "randomized asserted", UVM_MEDIUM)
            randomized_seq.start(env.wrapper_agt.sqr);
            `uvm_info("run_phase", "randomized dasserted", UVM_LOW)

            // directed tests to test MISO signal having the correct output when it is a real memory value rather than an unknown signal
            repeat(10) begin
                // reset sequence
                `uvm_info("run_phase", "reset asserted", UVM_LOW)
                reset_seq.start(env.wrapper_agt.sqr);
                `uvm_info("run_phase", "reset dasserted", UVM_LOW)

                // read address sequence
                `uvm_info("run_phase", "read_address asserted", UVM_MEDIUM)
                read_address_seq.start(env.wrapper_agt.sqr);
                `uvm_info("run_phase", "read_address dasserted", UVM_LOW)

                // read data sequence
                `uvm_info("run_phase", "read_data asserted", UVM_MEDIUM)
                read_data_seq.start(env.wrapper_agt.sqr);
                `uvm_info("run_phase", "read_data dasserted", UVM_LOW)
            end
            phase.drop_objection(this); // decrement static var.
        endtask
    endclass: spi_wrapper_test
endpackage