`timescale 1ns / 1ps

// before IF.ID
// pc and npc


module IFID (
    input wire rst,
    input wire clk,

    // signals
    input wire        flush,
    input wire        stop,
    
    // modules
    // todos: the write back connection
    input wire [31:0] inst_in,
    output reg [31:0] inst_out,
    input wire [31:0] pc_in,
    output reg [31:0] pc_out,
    input wire [31:0] pc4_in,
    output reg [31:0] pc4_out
);

    always @(posedge rst or posedge clk) begin
        if (rst) begin
            inst_out <= 32'b0;
            pc_out <= 32'b0;
            pc4_out <= 32'b0;
        end else if (flush) begin
            inst_out <= 32'b0;
            pc_out <= 32'b0;
            pc4_out <= 32'b0;
        end else if (stop) begin
            inst_out <= inst_out;
            pc_out <= pc_out;
            pc4_out <= pc4_out;
        end else begin
            inst_out <= inst_in;
            pc_out <= pc_in;
            pc4_out <= pc4_in;
        end
    end


endmodule