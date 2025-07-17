`timescale 1ns / 1ps

module IDEX (
    input wire rst,
    input wire clk,

    // signal
    // todo
    input wire [2:0] alu_sel_in,
    input wire [3:0] alu_op_in,
    output wire [2:0] alu_sel_out,
    output wire [3:0] alu_op_out,

    // modules
    input wire [31:0] inst_in,
    input wire [31:0] sext1_in,
    input wire [31:0] rf_rD1_in,
    input wire [31:0] rf_rD2_in,
    input wire [31:0] zext_in,
    input wire [31:0] pc_in,

    output wire [31:0] inst_out,
    output wire [31:0] sext1_out,
    output wire [31:0] rf_rD1_out,
    output wire [31:0] rf_rD2_out,
    output wire [31:0] zext_out,
    output wire [31:0] pc_out,
);

    always @(posedge rst or posedge clk) begin
        if (rst) begin
            alu_sel_out <= 0;
            alu_op_out <= 0;
            inst_out <= 0;
            sext_out <= 0;
            rf_rD1_out <= 0;
            rf_rD2_out <= 0;
            zext_out <= 0;
            pc_out <= 0;
        end else begin
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