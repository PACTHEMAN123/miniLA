`timescale 1ns / 1ps

`include "defines.vh"

// Abstract layer of Dram
// should be responsible for handling:
// read/write in bytes/half-words/words
module DramSel (
    // indicate writes
    input wire  [1:0]   dram_sel,
    // raw addr
    input wire  [31:0]  alu_c,
    input wire  [1:0]   addr_mode,
    // Dram -> DramSel
    output wire [31:0]  dram_addr,
    // read from dram
    input wire  [31:0]  dram_rdata_raw, // Dram -> DramSel
    output wire [31:0]  dram_rdata,     // DramSel -> User
    // write to dram
    input wire  [31:0]  rf_rD2,         // User -> DramSel
    output wire [31:0]  dram_wdata,     // DramSel -> Dram
    output wire         dram_we  
);

    // notice that we seek addr in words
    wire [1:0] byte_offset = alu_c[1:0];
    wire [31:0] word_addr = {alu_c[31:2], 2'b0};
    assign dram_addr =  word_addr;

    wire [7:0] read_byte =  (byte_offset == 2'b00) ? dram_rdata_raw[7:0] :
                            (byte_offset == 2'b01) ? dram_rdata_raw[15:8] :
                            (byte_offset == 2'b10) ? dram_rdata_raw[23:16] :
                            dram_rdata_raw[31:24];

    wire [15:0] read_hw =   (byte_offset == 2'b00) ? dram_rdata_raw[15:0] :
                            dram_rdata_raw[31:16];

    
    assign dram_rdata = (addr_mode == `ADDR_BYTE) ? {24'b0, read_byte} :
                        (addr_mode == `ADDR_HW) ? {16'b0, read_hw} :
                        (addr_mode == `ADDR_WORD) ? dram_rdata_raw :
                        32'b0;

    wire [31:0] write_byte =    (byte_offset == 2'b00) ? {dram_rdata_raw[31:8], rf_rD2[7:0]} :
                                (byte_offset == 2'b01) ? {dram_rdata_raw[31:16], rf_rD2[7:0], dram_rdata_raw[7:0]} :
                                (byte_offset == 2'b10) ? {dram_rdata_raw[31:24], rf_rD2[7:0], dram_rdata_raw[15:0]} :
                                (byte_offset == 2'b11) ? {rf_rD2[7:0], dram_rdata_raw[23:0]} :
                                32'b0;
    
    
    wire [31:0] write_hw =      (byte_offset == 2'b00) ? {dram_rdata_raw[31:16], rf_rD2[15:0]} :
                                (byte_offset == 2'b10) ? {rf_rD2[15:0], dram_rdata_raw[15:0]} :
                                32'b0;

    assign dram_wdata = (dram_sel == `DRAM_W_8) ? write_byte :
                        (dram_sel == `DRAM_W_16) ? write_hw :
                        (dram_sel == `DRAM_W_32) ? rf_rD2 :
                        32'b0;

    assign dram_we =    (dram_sel == `DRAM_W_8 | dram_sel == `DRAM_W_16 | dram_sel == `DRAM_W_32) ? 1'b1 : 1'b0;
endmodule