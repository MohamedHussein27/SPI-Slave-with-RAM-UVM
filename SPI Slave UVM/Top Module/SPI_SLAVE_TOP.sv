import spi_slave_test_pkg::*;
import spi_slave_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module spi_slave_top();
    bit clk;

    initial begin
        forever #10 clk = ~clk;
    end

    spi_slave_if spi_slaveif (clk);
    spi_slave DUT (spi_slaveif);

    // binding assertions
    bind spi_slave spi_slave_sva spi_slave_assertions (spi_slaveif);
    // setting the virtual interface to be accessible by the test
    initial begin
        uvm_config_db #(virtual spi_slave_if)::set(null, "uvm_test_top", "spi_slave_V", spi_slaveif);
        run_test ("spi_slave_test");
    end
endmodule