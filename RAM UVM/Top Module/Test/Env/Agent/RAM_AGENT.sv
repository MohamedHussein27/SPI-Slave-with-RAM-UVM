package ram_agent_pkg;
    import ram_config_obj_pkg::*;
    import ram_driver_pkg::*;
    import ram_monitor_pkg::*;
    import ram_seq_item_pkg::*;
    import ram_reset_sequence_pkg::*;
    import ram_main_sequence_pkg::*;
    import ram_sequencer_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class ram_agent extends uvm_agent;
        `uvm_component_utils(ram_agent)

        ram_config_obj ram_cfg; // configuration object
        ram_driver drv; // driver
        ram_monitor mon; // monitor
        ram_sequencer sqr; // sequencer
        
        uvm_analysis_port #(ram_seq_item) agt_ap; // will be used to connect scoreboard and coverage collector

        function new (string name = "ram_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(ram_config_obj)::get(this,"","CFG", ram_cfg)) begin
                    `uvm_fatal("build_phase","agent error");
            end
            // creation
            drv = ram_driver::type_id::create("driver", this);
            mon = ram_monitor::type_id::create("mon", this);
            sqr = ram_sequencer::type_id::create("sqr", this);
            agt_ap = new("agt_ap", this); // connection point
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            drv.ram_vif = ram_cfg.ram_vif;
            mon.ram_vif = ram_cfg.ram_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap); // connect monitor share point with agent share point so the monitor will be able to get data from the scoreboard and the cov collector
        endfunction
    endclass
endpackage