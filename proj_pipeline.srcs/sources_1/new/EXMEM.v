`timescale 1ns / 1ps

module EXMEM (
    input wire rst,
    input wire clk,

    // signals
    input wire [1:0] dram_sel,

    // modules
    input wire [31:0] alu_c_in,
    input wire [1:0] addr_mode_in,
    input wire [31:0] rf_rD2_in,

    output wire [31:0] alu_c_out,
    output wire [1:0] addr_mode_out,
    output wire [31:0] rf_rD2_in,
);

    always @(posedge rst or posedge clk) begin
        if (rst) begin
            alu_c_out <= 0;
            addr_mode_out <= 0;
            rf_rD2_out <= 0;
        end else begin
            alu_c_out <= alu_c_in;
            addr_mode_out <= addr_mode_in;
            rf_rD2_out <= rf_rD2_in;
        end
    end


endmodule