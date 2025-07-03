`timescale 1ns / 1ps

// zero extend module
module ZEXT (
    input   wire          zext_rst,
    input   wire          zext_clk,

    input   wire  [11:0]  inst,

    output  wire  [31:0]  zext_ext
);

always @(posedge zext_rst or posedge zext_clk) begin
    if (zext_rst) begin
        zext_ext <= 0;
    end else begin
        zext_ext <= {20'b0', inst};
    end
end

