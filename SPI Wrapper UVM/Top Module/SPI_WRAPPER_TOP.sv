import spi_wrapper_test_pkg::*;
import spi_wrapper_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module spi_wrapper_top();
    bit clk;

    initial begin
        forever #10 clk = ~clk;
    end

    spi_wrapper_if spi_wrapperif (clk);
    spi_slave_if spi_slaveif (clk);
    ram_if ramif (clk);
    spi_wrapper DUT (spi_wrapperif);

    // binding assertions
    bind ram ram_sva ram_assertions (ramif);
    bind spi_slave spi_slave_sva spi_slave_assertions (spi_slaveif);

    // setting the virtual interface to be accessible by the test
    initial begin
        uvm_config_db #(virtual spi_wrapper_if)::set(null, "uvm_test_top", "spi_wrapper_V", spi_wrapperif);
        uvm_config_db #(virtual spi_slave_if)::set(null, "uvm_test_top", "spi_slave_V", spi_slaveif);
        uvm_config_db #(virtual ram_if)::set(null, "uvm_test_top", "ram_V", ramif);
        run_test ("spi_wrapper_test");
    end

    //=============================
    // Slave Interface Connections
    //=============================
    assign spi_slaveif.rst_n     = spi_wrapperif.rst_n;
    assign spi_slaveif.MOSI      = spi_wrapperif.MOSI;
    assign spi_slaveif.ss_n      = spi_wrapperif.ss_n;
    assign spi_slaveif.MISO      = spi_wrapperif.MISO;

    assign spi_slaveif.tx_valid  = DUT.tx_valid;
    assign spi_slaveif.tx_data   = DUT.txdata;
    assign spi_slaveif.rx_valid  = DUT.rx_valid;
    assign spi_slaveif.rx_data   = DUT.rxdata;

    //=============================
    // RAM Interface Connections
    //=============================
    assign ramif.rst_n           = spi_wrapperif.rst_n;
    assign ramif.tx_valid        = DUT.tx_valid;
    assign ramif.din             = DUT.rxdata;
    assign ramif.dout            = DUT.txdata;
    assign ramif.rx_valid        = DUT.rx_valid;

endmodule