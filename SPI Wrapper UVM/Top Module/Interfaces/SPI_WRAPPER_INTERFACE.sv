interface spi_wrapper_if (clk);
    input clk;

    // signals
    // inputs
    logic rst_n;
    logic MOSI;
    logic ss_n;
    // outputs
    logic MISO;

    // design module
    modport DUT (
        input clk, rst_n, MOSI, ss_n,
        output MISO
    );
endinterface