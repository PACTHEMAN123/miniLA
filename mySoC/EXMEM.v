`timescale 1ns / 1ps

module EXMEM (
    input wire rst,
    input wire clk,

    // signals
    input wire sext2_sel_in,
    output reg sext2_sel_out,
    input wire wb_ena_in,
    output reg wb_ena_out,
    input wire [2:0] wD_sel_in,
    output reg [2:0] wD_sel_out,
    input wire [1:0] dram_sel_in,
    output reg [1:0] dram_sel_out,
    input wire [1:0] npc_op_in,
    output reg [1:0] npc_op_out,
    input wire [4:0] wb_reg_in,
    output reg [4:0] wb_reg_out,
    input wire [31:0] wb_reg_value_in,
    output reg [31:0] wb_reg_value_out,

    input wire [31:0] wb_value_in,
    output reg [31:0] wb_value_out,

    // modules
    input wire [31:0] alu_c_in,
    output reg [31:0] alu_c_out,

    input wire [1:0] addr_mode_in,
    output reg [1:0] addr_mode_out,

    input wire        have_inst_in,
    output reg        have_inst_out,

    input wire [31:0] rf_rD2_in,
    output reg [31:0] rf_rD2_out,

    input wire [31:0] sext1_in,
    output reg [31:0] sext1_out,

    input wire [31:0] pc_in,
    output reg [31:0] pc_out,

    input wire [31:0] pc4_in,
    output reg [31:0] pc4_out,

    input wire [31:0] inst_in,
    output reg [31:0] inst_out
);

    always @(posedge rst or posedge clk) begin
        if (rst) begin
            wb_ena_out <= 0;
            wD_sel_out <= 0;
            dram_sel_out <= 0;
            alu_c_out <= 0;
            addr_mode_out <= 0;
            rf_rD2_out <= 0;
            sext1_out <= 0;
            npc_op_out <= 2'b00;
            pc_out <= 32'b0;
            pc4_out <= 32'b0;
            inst_out <= 32'b0;
            have_inst_out <= 0'b0;
            wb_reg_out <= 0;
            wb_reg_value_out <= 0;
            wb_value_out <= 0;
            sext2_sel_out <= 0;
        end else begin
            wb_ena_out <= wb_ena_in;
            wD_sel_out <= wD_sel_in;
            dram_sel_out <= dram_sel_in;
            alu_c_out <= alu_c_in;
            addr_mode_out <= addr_mode_in;
            rf_rD2_out <= rf_rD2_in;
            sext1_out <= sext1_in;
            npc_op_out <= npc_op_in;
            pc_out <= pc_in;
            pc4_out <= pc4_in;
            inst_out <= inst_in;
            have_inst_out <= have_inst_in;
            wb_reg_out <= wb_reg_in;
            wb_reg_value_out <= wb_reg_value_in;
            wb_value_out <= wb_value_in;
            sext2_sel_out <= sext2_sel_in;
        end
    end


endmodule