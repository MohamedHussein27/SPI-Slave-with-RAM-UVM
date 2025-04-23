module ram (ram_if.DUT ramif);
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;
    logic clk;
    logic rst_n;
    logic rx_valid;
    logic [9:0] din;
    logic [7:0] dout;
    logic tx_valid;

    // assigning signals to be interfaced
    // inputs
    assign clk = ramif.clk;
    assign rst_n = ramif.rst_n;
    assign rx_valid = ramif.rx_valid;
    assign din = ramif.din;
    // outputs
    assign ramif.dout = dout;
    assign ramif.tx_valid = tx_valid;

    // Creating the memory array
    reg [ADDR_SIZE-1:0] memory [MEM_DEPTH-1:0]; //address size is the same as memory width

    reg [7:0] addr_wr; // Write address for writing data
    reg [7:0] addr_re; // Read address for reading data 
    
    always @(posedge clk) begin  
        if (!rst_n) begin   //making the reset synchronous so the memory is synthesized as a block
            dout <= 8'h00;
            tx_valid <= 1'b0;
            addr_wr <= 8'h00;
            addr_re <= 8'h00;
        end else begin
            if (rx_valid) begin // Once rx_valid is high, then the din bus is completed
                case (din[9:8])
                    2'b00: begin
                        addr_wr <= din[7:0]; // Write address
                        tx_valid <= 1'b0;
                    end
                    2'b01: begin
                        memory[addr_wr] <= din[7:0]; // Write data in the address specified earlier
                        tx_valid <= 1'b0;
                    end
                    2'b10: begin
                        addr_re <= din[7:0]; // Read address
                        tx_valid <= 1'b0;
                    end
                    2'b11: begin // Read data in the address specified earlier and then send the data in dout and make tx_valid high
                        dout <= memory[addr_re];
                        tx_valid <= 1'b1;
                    end
                endcase
            end
        end
    end
endmodule