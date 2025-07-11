`timescale 1ns / 1ps

`include "defines.vh"

module DramSel (
    input wire  [1:0]   dram_sel,
    input wire  [31:0]  alu_c,
    input wire  [31:0]  rf_rD2,

    output wire [31:0]  dram_addr,
    output wire [31:0]  dram_wdata
);

    assign dram_addr =  alu_c;

    assign dram_wdata = (dram_sel == `DRAM_W_8) ? {24'b0, rf_rD2[7:0]} :
                        (dram_sel == `DRAM_W_16) ? {16'b0, rf_rD2[15:0]} :
                        (dram_sel == `DRAM_W_32) ? rf_rD2 :
                        32'b0;
endmodule