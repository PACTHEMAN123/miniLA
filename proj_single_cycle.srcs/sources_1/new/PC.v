`timescale 1ns / 1ps


// PC module
module PC (
    input   wire          pc_rst,
    input   wire          pc_clk,
    input   wire  [31:0]  din,
    output  wire  [31:0]  pc
);

always @(posedge pc_clk or posedge pc_rst) begin
    if (pc_rst) begin
        pc <= 0;
    end else begin
        pc <= din;
    end
end


endmodule
