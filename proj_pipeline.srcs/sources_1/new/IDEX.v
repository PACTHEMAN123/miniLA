`timescale 1ns / 1ps

module IDEX (
    input wire rst,
    input wire clk,

    // signal
    // todo
    input wire wb_ena_in,
    input wire wb_ena_out,
    input wire [1:0] dram_sel_in,
    output wire [1:0] dram_sel_out,
    input wire [2:0] alu_sel_in,
    output wire [2:0] alu_sel_out,
    input wire [3:0] alu_op_in,
    output wire [3:0] alu_op_out,

    // modules
    input wire [31:0] inst_in,
    output reg [31:0] inst_out,

    input wire [31:0] sext1_in,
    output reg [31:0] sext1_out,

    input wire [31:0] rf_rD1_in,
    input wire [31:0] rf_rD2_in,
    output reg [31:0] rf_rD1_out,
    output reg [31:0] rf_rD2_out,

    input wire [31:0] zext_in,
    output reg [31:0] zext_out,

    input wire [31:0] pc_in,
    output reg [31:0] pc_out
);

    always @(posedge rst or posedge clk) begin
        if (rst) begin
            dram_sel_out <= 0;
            alu_sel_out <= 0;
            alu_op_out <= 0;
            inst_out <= 0;
            sext_out <= 0;
            rf_rD1_out <= 0;
            rf_rD2_out <= 0;
            zext_out <= 0;
            pc_out <= 0;
        end else begin
            dram_sel_out <= dram_sel_in;
            alu_sel_out <= alu_sel_in;
            alu_op_out <= alu_op_in;
            inst_out <= inst_in;
            sext1_out <= sext1_in;
            rf_rD1_out <= rf_rD1_in;
            rf_rD2_out <= rf_rD2_in;
            zext_out <= zext_in;
            pc_out <= pc_in;
        end
    end
    
endmodule