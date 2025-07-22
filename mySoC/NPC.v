`timescale 1ns / 1ps

// NPC module
module NPC (
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
    assign pc4 = pc + 4;

    assign npc =    (npc_op == `NPC_PC_4) ? pc + 4 :
                    (npc_op == `NPC_PC_OFF) ? pc + sext :
                    (npc_op == `NPC_PC_OFF_BR) ? (br ? pc + sext : pc + 4) :
                    (npc_op == `NPC_OFF) ? alu_c :
                    32'b0;

endmodule
