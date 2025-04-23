import ram_test_pkg::*;
import ram_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module ram_top();
    bit clk;

    initial begin
        forever #10 clk = ~clk;
    end

    ram_if ramif (clk);
    ram DUT (ramif);

    // binding assertions
    bind ram ram_sva ram_assertions (ramif);
    // setting the virtual interface to be accessible by the test
    initial begin
        uvm_config_db #(virtual ram_if)::set(null, "uvm_test_top", "ram_V", ramif);
        run_test ("ram_test");
    end
endmodule