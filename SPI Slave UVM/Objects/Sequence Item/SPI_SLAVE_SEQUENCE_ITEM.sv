package spi_slave_seq_item_pkg;
    import spi_slave_shared_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class spi_slave_seq_item extends uvm_sequence_item;
        `uvm_object_utils(spi_slave_seq_item)

        // spi_slave constraints
        bit clk;
        rand bit rst_n;
        rand bit MOSI;
        rand bit tx_valid;
        rand bit ss_n;
        rand bit [7:0] tx_data;
        logic MISO;
        logic rx_valid;
        logic [9:0] rx_data;

        bit read_add_array [2] = '{0, 1};

        function new(string name = "spi_slave_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf(
                "%s rst_n = 0b%0b , MOSI = 0b%0b , ss_n = 0b%0b , tx_valid = 0b%0b , MISO = 0b%0b , tx_data = 0x%02h , rx_valid = 0b%0b , rx_data = 0x%03h",
                super.convert2string(), rst_n, MOSI, ss_n, tx_valid, tx_data, MISO, rx_valid, rx_data
            );
        endfunction



        function string convert2string_stimulus();
            return $sformatf(
                "%s rst_n = 0b%0b , MOSI = 0b%0b , ss_n = 0b%0b , tx_valid = 0b%0b , tx_data = 0x%02h",
                super.convert2string(), rst_n, MOSI, ss_n, tx_valid, tx_data
            );
        endfunction




        // constraints
        constraint reset_con {
            rst_n dist {0:/1, 1:/99}; // reset is less to occur
        }

        constraint ss_n_con { // making ss_n high only in the end of each state
            if(state_finished){
                    ss_n == 1;
                }
                else{
                    ss_n == 0;
                }
        }
        
        // MOSI constraints
        constraint MOSI_write_con { // this constraint is to make the MOSI set the first bit by zero as it's a write state
            if(ns == WRITE && write_constraint){
                MOSI == 0;
            }
        }
        constraint MOSI_read_add_con {
            if(ns == READ_ADD && read_add_constraint){
                MOSI == read_add_array[1-i];
            }
        }
        constraint MOSI_read_data_con {
            if(ns == READ_DATA && read_data_constraint){
                MOSI == 1;
            }
        }

        constraint tx_valid_con {
            if(tx_flag){
                tx_valid == 1;
            }
            else{
                tx_valid == 0;
            }
        }
        constraint MOSI_con {
            MOSI dist {0:/60, 1:/40}; // writing is more frequently than reading
        }
    endclass
endpackage