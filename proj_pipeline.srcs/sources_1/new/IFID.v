`timescale 1ns / 1ps

// before IF.ID
// pc and npc


module IFID (
    input wire rst,
    input wire clk,

    // signals
    
    // modules
    // todos: the write back connection
    input reg [31:0] inst_in,
    output reg [31:0] inst_out
);

    always @(posedge rst or posedge clk) begin
        if (rst) begin
            inst_out <= 32'b0;
        end else begin
            inst_out <= inst_in;
        end
    end


endmodule