`timescale 1ns / 1ps

// SEXT1 module
module SEXT1 (
    input   wire  [2:0]   sext1_op,
    input   wire  [31:0]  inst,

    output  wire  [31:0]  sext1_ext
);

    assign sext1_ext =  (sext1_op == `SEXT1_12) ? {{20{inst[21]}}, inst[21:10]} :
                        (sext1_op == `SEXT1_16) ? {{14{inst[25]}}, inst[25:10], 2'b0} :
                        (sext1_op == `SEXT1_28) ? {{4{inst[9]}}, inst[9:0], inst[25:10], 2'b0} :
                        {32'b0};

endmodule
