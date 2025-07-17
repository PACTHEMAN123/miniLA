`timescale 1ns / 1ps

module MEMWB (
    input wire rst,
    input wire clk,

    // signals
    input wire [2:0] wD_sel_in,
    output wire [2:0] wD_sel_out,
    input wire wb_ena_in,
    output wire wb_ena_out,

    // modules
    input wire [31:0] alu_c_in,
    output reg [31:0] alu_c_out,

    input wire [31:0] sext2_in,
    output reg [31:0] sext2_out,

    input wire [31:0] pc4_in,
    output reg [31:0] pc4_out,

    input wire [31:0] rdo_in,
    output reg [31:0] rdo_out
);

    always @(posedge rst or posedge clk) begin
        if (rst) begin
            wD_sel_out <= 3'b0;
            alu_c_out <= 32'b0;
            sext2_out <= 32'b0;
            pc4_out <= 32'b0;
            rdo_out <= 32'b0;
        end else begin
            wD_sel_out <= wD_sel_in;
            alu_c_out <= alu_c_in;
            sext2_out <= sext2_in;
            pc4_out <= pc4_in;
            rdo_out <= rdo_in;
        end
    end


endmodule