package spi_wrapper_agent_pkg;
    import spi_wrapper_config_obj_pkg::*;
    import spi_wrapper_driver_pkg::*;
    import spi_wrapper_monitor_pkg::*;
    import spi_wrapper_seq_item_pkg::*;
    import spi_wrapper_sequencer_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_wrapper_agent extends uvm_agent;
        `uvm_component_utils(spi_wrapper_agent)

        spi_wrapper_config_obj spi_wrapper_cfg; // configuration object
        spi_wrapper_driver drv; // driver
        spi_wrapper_monitor mon; // monitor
        spi_wrapper_sequencer sqr; // sequencer
        
        uvm_analysis_port #(spi_wrapper_seq_item) agt_ap; // will be used to connect scoreboard and coverage collector

        function new (string name = "spi_wrapper_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(spi_wrapper_config_obj)::get(this,"","CFG_W", spi_wrapper_cfg)) begin // CFG_W is specific to Wrapper Agent
                    `uvm_fatal("build_phase","agent error");
            end
            // creation
            // only create driver & sequencer if this is the active monitor
            if (spi_wrapper_cfg.active_or_passive == UVM_ACTIVE) begin
                drv = spi_wrapper_driver::type_id::create("driver", this); 
                sqr = spi_wrapper_sequencer::type_id::create("sqr", this);
            end
            // create monitor and agent analysis point anyway
            mon = spi_wrapper_monitor::type_id::create("mon", this);
            agt_ap = new("agt_ap", this); // connection point
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            // connect driver only if this is the active agent
            if (spi_wrapper_cfg.active_or_passive == UVM_ACTIVE) begin
                drv.spi_wrapper_vif = spi_wrapper_cfg.spi_wrapper_vif;
                drv.seq_item_port.connect(sqr.seq_item_export);
            end
            // always connect the monitor
            mon.spi_wrapper_vif = spi_wrapper_cfg.spi_wrapper_vif;
            mon.mon_ap.connect(agt_ap); // connect monitor share point with agent share point so the monitor will be able to get data from the scoreboard and the cov collector
        endfunction
    endclass
endpackage