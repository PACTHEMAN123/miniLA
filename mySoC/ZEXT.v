`timescale 1ns / 1ps

// zero extend module
module ZEXT (
    input   wire  [31:0]  inst,

    output  wire  [31:0]  zext_ext
);

    assign zext_ext = {20'b0, inst[21:10]};

endmodule