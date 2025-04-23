package spi_slave_agent_pkg;
    import spi_slave_config_obj_pkg::*;
    import spi_slave_driver_pkg::*;
    import spi_slave_monitor_pkg::*;
    import spi_slave_seq_item_pkg::*;
    import spi_slave_sequencer_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_slave_agent extends uvm_agent;
        `uvm_component_utils(spi_slave_agent)

        spi_slave_config_obj spi_slave_cfg; // configuration object
        spi_slave_driver drv; // driver
        spi_slave_monitor mon; // monitor
        spi_slave_sequencer sqr; // sequencer
        
        uvm_analysis_port #(spi_slave_seq_item) agt_ap; // will be used to connect scoreboard and coverage collector

        function new (string name = "spi_slave_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(spi_slave_config_obj)::get(this,"","CFG_S", spi_slave_cfg)) begin // CFG_S is specific to Slave Agent
                    `uvm_fatal("build_phase","agent error");
            end
            // creation
            // only create driver & sequencer if this is the active monitor
            if (spi_slave_cfg.active_or_passive == UVM_PASSIVE) begin
                drv = spi_slave_driver::type_id::create("driver", this); 
                sqr = spi_slave_sequencer::type_id::create("sqr", this);
            end
            // create monitor and agent analysis point anyway
            mon = spi_slave_monitor::type_id::create("mon", this);
            agt_ap = new("agt_ap", this); // connection point
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            // connect driver only if this is the active agent
            if (spi_slave_cfg.active_or_passive == UVM_PASSIVE) begin
                drv.spi_slave_vif = spi_slave_cfg.spi_slave_vif;
                drv.seq_item_port.connect(sqr.seq_item_export);
            end
            // always connect the monitor
            mon.spi_slave_vif = spi_slave_cfg.spi_slave_vif;
            mon.mon_ap.connect(agt_ap); // connect monitor share point with agent share point so the monitor will be able to get data from the scoreboard and the cov collector
        endfunction
    endclass
endpackage