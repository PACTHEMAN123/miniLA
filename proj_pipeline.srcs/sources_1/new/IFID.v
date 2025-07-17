`timescale 1ns / 1ps

// before IF.ID
// pc and npc


module (
    input wire rst,
    input wire clk,

    // signals
    input wire rf_sel_in,

    output wire rf_sel_out,

    // modules
    // todos: the write back connection
    input wire [31:0] inst_in,
    output wire [31:0] inst_out,

);

    always @(posedge rst or posedge clk) begin
        if (rst) begin
            inst_out <= 32'b0;
        end else begin
            inst_out <= inst_in;
        end
    end


endmodule