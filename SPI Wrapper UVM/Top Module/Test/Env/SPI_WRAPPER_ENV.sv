package spi_wrapper_env_pkg;
    import spi_wrapper_seq_item_pkg::*;
    import spi_wrapper_sequencer_pkg::*;
    import spi_wrapper_agent_pkg::*;
    import spi_wrapper_coverage_collector_pkg::*;
    import spi_wrapper_scoreboard_pkg::*;
    import spi_slave_agent_pkg::*;
    import spi_slave_coverage_collector_pkg::*;
    import spi_slave_scoreboard_pkg::*;
    import ram_agent_pkg::*;
    import ram_coverage_collector_pkg::*;
    import ram_scoreboard_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class spi_wrapper_env extends uvm_env;
        `uvm_component_utils (spi_wrapper_env)

        //wrapper  agent, scoreboard and wrapper_coverage collector
        spi_wrapper_agent wrapper_agt;
        spi_wrapper_scoreboard wrapper_sb;
        spi_wrapper_coverage_collector wrapper_cov;

        //slave  agent, scoreboard and slave_coverage collector
        spi_slave_agent slave_agt;
        spi_slave_scoreboard slave_sb;
        spi_slave_coverage_collector slave_cov;

        //ram  agent, scoreboard and ram_coverage collector
        ram_agent ram_agt;
        ram_scoreboard ram_sb;
        ram_coverage_collector ram_cov;
    
        // construction
        function new (string name = "spi_wrapper_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            // wrapper package
            wrapper_agt = spi_wrapper_agent::type_id::create("wrapper_agt",this);            
            wrapper_sb = spi_wrapper_scoreboard::type_id::create("wrapper_sb", this);
            wrapper_cov = spi_wrapper_coverage_collector::type_id::create("wrapper_cov", this);
            // slave package
            slave_agt = spi_slave_agent::type_id::create("slave_agt",this);            
            slave_sb = spi_slave_scoreboard::type_id::create("slave_sb", this);
            slave_cov = spi_slave_coverage_collector::type_id::create("slave_cov", this);
            // ram package            
            ram_agt = ram_agent::type_id::create("ram_agt",this);            
            ram_sb = ram_scoreboard::type_id::create("ram_sb", this);
            ram_cov = ram_coverage_collector::type_id::create("ram_cov", this);
        endfunction

        // connection between agent and scoreboard and between agent and wrapper_coverage collector
        function void connect_phase (uvm_phase phase);
            // wrapper related sb & cov
            wrapper_agt.agt_ap.connect(wrapper_sb.sb_export);
            wrapper_agt.agt_ap.connect(wrapper_cov.cov_export);
            // slave related sb & cov
            slave_agt.agt_ap.connect(slave_sb.sb_export);
            slave_agt.agt_ap.connect(slave_cov.cov_export);
            // ram related sb $ cov
            ram_agt.agt_ap.connect(ram_sb.sb_export);
            ram_agt.agt_ap.connect(ram_cov.cov_export);       
        endfunction
    endclass
endpackage