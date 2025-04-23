package ram_test_pkg;
    import ram_config_obj_pkg::*;
    import ram_env_pkg::*;
    import ram_reset_sequence_pkg::*;
    import ram_main_sequence_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class ram_test extends uvm_test;
        `uvm_component_utils(ram_test)

        ram_env env; // environment object
        ram_config_obj ram_cfg; // configuration object     
        virtual ram_if ram_vif; // virtual interface
        // sequences
        ram_reset_sequence reset_seq; // reset sequence
        ram_main_sequence main_seq; // main sequence


        // construction function
        function new(string name = "ram_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        // build both environmnet, Sequences and configuration objects 
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env  = ram_env::type_id::create("env", this);
            ram_cfg = ram_config_obj::type_id::create("ram_cfg");
            // sequences creation
            reset_seq = ram_reset_sequence::type_id::create("reset_seq", this);
            main_seq = ram_main_sequence::type_id::create("main_seq", this);

            //getting the real interface and assign it to the virtual one in the configuration object
            if (!uvm_config_db #(virtual ram_if)::get(this,"","ram_V", ram_cfg.ram_vif))
                `uvm_fatal("build_phase", "test unable");

            // setting the entire object to be visible by all under the ram_test umbrella
            uvm_config_db #(ram_config_obj)::set(this,"*","CFG", ram_cfg);
        endfunction
        // run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this); // incerement static var.
            // reset sequence
            `uvm_info("run_phase", "reset asserted", UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "reset dasserted", UVM_LOW)

            // main sequence
            `uvm_info("run_phase", "main asserted", UVM_MEDIUM)
            main_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "main dasserted", UVM_LOW)
            
            phase.drop_objection(this); // decrement static var.
        endtask
    endclass: ram_test
endpackage