`timescale 1ns / 1ps

module EXMEM (
    input wire rst,
    input wire clk,

    // signals
    input wire wb_ena_in,
    input wire wb_ena_out,
    input wire [2:0] wD_sel_in,
    output wire [2:0] wD_sel_out,
    input wire [1:0] dram_sel_in,
    output wire [1:0] dram_sel_out,

    // modules
    input wire [31:0] alu_c_in,
    output wire [31:0] alu_c_out,

    input wire [1:0] addr_mode_in,
    output wire [1:0] addr_mode_out,

    input wire [31:0] rf_rD2_in,
    output wire [31:0] rf_rD2_out
);

    always @(posedge rst or posedge clk) begin
        if (rst) begin
            wD_sel_out <= 0;
            dram_sel_out <= 0;
            alu_c_out <= 0;
            addr_mode_out <= 0;
            rf_rD2_out <= 0;
        end else begin
            wD_sel_out <= wD_sel_in;
            dram_sel_out <= dram_sel_in;
            alu_c_out <= alu_c_in;
            addr_mode_out <= addr_mode_in;
            rf_rD2_out <= rf_rD2_in;
        end
    end


endmodule