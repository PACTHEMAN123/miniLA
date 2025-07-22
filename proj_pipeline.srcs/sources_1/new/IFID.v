`timescale 1ns / 1ps

// before IF.ID
// pc and npc


module IFID (
    input wire rst,
    input wire clk,

    // signals
    
    // modules
    // todos: the write back connection
    input wire [31:0] inst_in,
    output reg [31:0] inst_out,
    input wire [31:0] pc_in,
    output reg [31:0] pc_out
);

    always @(posedge rst or posedge clk) begin
        if (rst) begin
            inst_out <= 32'b0;
            pc_out <= 32'b0;
        end else begin
            inst_out <= inst_in;
            pc_out <= pc_in;
        end
    end


endmodule