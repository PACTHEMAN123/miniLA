`timescale 1ns / 1ps

`include "defines.vh"

module ALU (
    input wire [31:0] inst,

    // ALU operation
    input wire [3:0] alu_op,

    // possible A
    input wire [31:0] pc,
    input wire [31:0] rf_rD1,

    // possible B
    input wire [31:0] rf_rD2,
    input wire [31:0] sext1,
    input wire [31:0] zext,

    // possible combination of A & B
    input wire [2:0] alu_sel,

    output wire [31:0] alu_c,
    output wire alu_f
);

    // choose the input
    wire [31:0] A =  (alu_sel == `ASEL_INST_20) ? pc : rf_rD1;
    

    wire [31:0] B =  (alu_sel == `ASEL_RD2) ? rf_rD2 :
                (alu_sel == `ASEL_RD2_5) ? {27'b0, rf_rD2[4:0]} :
                (alu_sel == `ASEL_INST_5) ? {27'b0, inst[14:10]} :
                (alu_sel == `ASEL_INST_20) ? {inst[24:5], 12'b0} :
                (alu_sel == `ASEL_SEXT1) ? sext1 :
                (alu_sel == `ASEL_ZEXT) ? zext :
                {32'b0};

    wire [31:0] shifted = A >> B[4:0];
    wire [31:0] sign_mask = ~(32'hFFFFFFFF >> B[4:0]);
    wire [31:0] sra = shifted | (A[31] ? sign_mask : 32'b0);

    // calculate output
    assign alu_c =  (alu_op == `ALU_ADD) ? A + B :
                (alu_op == `ALU_SUB) ? A - B :
                (alu_op == `ALU_OR) ? A | B :
                (alu_op == `ALU_XOR) ? A ^ B :
                (alu_op == `ALU_AND) ? A & B :
                (alu_op == `ALU_SL) ? A << B[4:0] :
                (alu_op == `ALU_SRL) ? A >> B[4:0] :
                (alu_op == `ALU_SRA) ?  sra :
                (alu_op == `ALU_EQ) ? A == B :
                (alu_op == `ALU_NEQ) ? A != B :
                (alu_op == `ALU_LT_S) ? $signed(A) < $signed(B) :
                (alu_op == `ALU_LT_U) ? A < B :
                (alu_op == `ALU_GE_S) ? $signed(A) >= $signed(B) :
                (alu_op == `ALU_GE_U) ? A >= B :
                {32'b0};

    // compare output
    assign alu_f =  (alu_op == `ALU_EQ) ? A == B :
                (alu_op == `ALU_NEQ) ? A != B :
                (alu_op == `ALU_LT_S) ? $signed(A) < $signed(B) :
                (alu_op == `ALU_LT_U) ? A < B :
                (alu_op == `ALU_GE_S) ? $signed(A) >= $signed(B) :
                (alu_op == `ALU_GE_U) ? A >= B :
                {1'b0};

endmodule
