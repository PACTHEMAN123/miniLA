`timescale 1ns / 1ps

// NPC module
module NPC (
    input   wire          npc_rst,
    input   wire          npc_clk,
    input   wire          br,
    input   wire  [31:0]  pc,

    // possible offset
    input   wire  [31:0]  alu_c,
    input   wire  [31:0]  sext,

    // we can cover npc op in 4 conds
    input   wire  [1:0]   npc_op,

    output  wire  [31:0]  npc,
    output  wire  [31:0]  pc4
);

// pc4 = pc + 4
always @(posedge npc_clk or posedge npc_rst) begin
    if (npc_rst) begin
        pc4 <= 0;
    end else begin
        pc4 <= pc + 4;
    end
end

always @(posedge npc_clk or posedge npc_rst) begin
    if (npc_rst) begin
        // reset
        npc <= 0;
    end else begin
        // npc = pc + 4
        if (npc_op == 0) begin
            npc <= pc + 4;
        end

        // npc = br ? (pc + sext) : (pc + 4)
        else if (npc_op == 1) begin
            if (br) begin
                npc <= pc + sext;
            end else begin
                npc <= pc + 4;
            end
        end

        // npc = pc + sext
        else if (npc_op == 2) begin
            npc <= pc + sext;
        end

        // npc = pc + alu_c
        else begin
            npc <= pc + alu_c;
        end
    end
end


endmodule
