//this module is to connect between the SPI_SLAVE and RAM modules
module spi_wrapper (spi_wrapper_if.DUT spi_wrapperif);
    parameter MEM_DEPTH = 256 ;
    parameter ADDR_SIZE = 8;
    logic clk;
    logic rst_n;
    logic MOSI;
    logic ss_n;
    logic MISO;

    // internals
    logic [9:0] rxdata ;
    logic [7:0] txdata ;
    logic rx_valid , tx_valid ;
    // Slave & Ram interfaces
    spi_slave_if spi_slaveif (clk);
    ram_if ramif (clk);
    // Wrapper Interface
    // inputs
    //=============================
    // Wrapper Interface Inputs
    //=============================
    assign clk       = spi_wrapperif.clk;
    assign rst_n     = spi_wrapperif.rst_n;
    assign MOSI      = spi_wrapperif.MOSI;
    assign ss_n      = spi_wrapperif.ss_n;

    //=============================
    // Wrapper Interface Outputs
    //=============================
    assign spi_wrapperif.MISO = MISO;

    //=============================
    // Slave Interface Connections
    //=============================
    assign spi_slaveif.rst_n     = rst_n;
    assign spi_slaveif.MOSI      = MOSI;
    assign spi_slaveif.ss_n      = ss_n;
    assign spi_slaveif.tx_valid  = tx_valid;     // from internal logic
    assign spi_slaveif.tx_data   = txdata;       // from internal logic
    assign rx_valid              = spi_slaveif.rx_valid; // to internal logic
    assign rxdata                = spi_slaveif.rx_data;  // to internal logic
    assign MISO                  = spi_slaveif.MISO;

    //=============================
    // RAM Interface Connections
    //=============================
    assign ramif.rst_n           = rst_n;
    assign ramif.rx_valid        = rx_valid;     // from internal logic
    assign ramif.din             = rxdata;       // from internal logic
    assign tx_valid              = ramif.tx_valid; // to internal logic
    assign txdata                = ramif.dout;  // to internal logic


    spi_slave SPI(
        spi_slaveif
    );

    ram #(MEM_DEPTH,ADDR_SIZE) Ram (
        ramif
    );
endmodule