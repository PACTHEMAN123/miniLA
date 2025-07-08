`timescale 1ns / 1ps

// the most important module
// Controller
module Controller (
    input wire [31:0] inst,
    
    // ALU control signals
    output wire [3:0] alu_op,
    output wire [2:0] alu_sel,
    
    // NPC control signals
    output wire [1:0] npc_op,

    // RF control signals
    output wire rf_sel,
    output wire [2:0] wD_sel,

    // sext1 control signals
    output wire [2:0] sext1_op,

    // sext2 control signals
    output wire sext2_sel,

    // TODOS: debug interface
);

    assign opcode1 = inst[31:26];
    assign opcode2 = inst[25];
    assign opcode3 = inst[24:22];
    assign opcode4 = inst[21:15];

    always @(*) begin
        // 3R types
        if (opcode1 == 6'b0 && opcode2 == 1'b0 && opcode3 == 3'b0) begin
            npc_op <= NPC_PC_4;
            rf_sel <= RD_RK;
            wD_sel <= WD_ALu;

            alu_sel <= (opcode4 == 7'b0100000 |
                        opcode4 == 7'b0100010 |
                        opcode4 == 7'b0101001 |
                        opcode4 == 7'b0101010 |
                        opcode4 == 7'b0101011 |
                        opcode4 == 7'b0100100 |
                        opcode4 == 7'b0100101
                        ) ? ASEL_RD2 : ASEL_RD2_5;

            alu_op <=   (opcode4 == 7'b0100000) ? ALU_ADD :
                        (opcode4 == 7'b0100010) ? ALU_SUB :
                        (opcode4 == 7'b0101001) ? ALU_AND :
                        (opcode4 == 7'b0101010) ? ALU_OR :
                        (opcode4 == 7'b0101011) ? ALU_XOR :
                        (opcode4 == 7'b0101110) ? ALU_SL :
                        (opcode4 == 7'b0101111) ? ALU_SRL :
                        (opcode4 == 7'b0110000) ? ALU_SRA :
                        (opcode4 == 7'b0100100) ? ALU_LT_S :
                        (opcode4 == 7'b0100101) ? ALU_LT_U :
                        4'b0000; /* should not reach here */
        end
    end

    always @(*) begin
        // 2RI5 types
        if (opcode1 == 6'b0 && opcode2 == 1'b0 && opcode3 == 3'b001) begin
            npc_op <= NPC_PC_4;
            // no rD2
            wD_sel <= WD_ALU;
            alu_sel <= ASEL_INST_5;
            alu_op <=   (opcode4 == 7'b0000001) ? ALU_SL :
                        (opcode4 == 7'b0001001) ? ALU_SRL :
                        (opcode4 == 7'b0010001) ? ALU_SRA :
                        4'b0; /* should not reach here */
        end
    end

    always @(*) begin
        
    end




    
endmodule