`timescale 1ns / 1ps

`include "defines.vh"

module ALU (
    input wire [31:0] inst,

    // ALU operation
    input wire alu_op,

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
    output wire alu_f,
);

    // choose the input
    assign A =  (alu_sel == ASEL_INST_20) ? pc : rf_rD1;

    assign B =  (alu_sel == ASEL_RD2) ? rf_rD2 :
                (alu_sel == ASEL_RD2_5) ? {27'b0, rf_rD2[4:0]} :
                (alu_sel == ASEL_INST_5) ? {27'b0, inst[14:10]} :
                (alu_sel == ASEL_INST_20) ? {inst[24:5], 12'b0} :
                (alu_sel == ASEL_SEXT1) ? sext1 :
                (alu_sel == ASEL_ZEXT) ? zext :
                {31'b0};

    assign C =  (ALU_ADD) ? A + B :
                (ALU_SUB) ? A - B :
                (ALU_OR) ? A | B :
                (ALU_XOR) ? A ^ B :
                (ALU_AND) ? A & B :
                (ALU_SL) ? A << B[4:0] :
                (ALU_SRL) ? A >> B[4:0] :
                (ALU_SRA) ? A >>> B[4:0] :
                {31'b0};

    assign f = 

`define ALU_ADD         4'b0001
`define ALU_SUB         4'b0010
`define ALU_OR          4'b0011
`define ALU_XOR         4'b0100
`define ALU_SL          4'b0101
`define ALU_SRL         4'b0110
`define ALU_SRA         4'b0111
`define ALU_SCMP        4'b1000
`define ALU_UCMP        4'b1001


endmodule
