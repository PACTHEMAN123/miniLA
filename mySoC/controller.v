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

    // dram control signals
    output wire Bus_we,
    output wire dram_sel,

    // check if inst valid
    output wire hang
);


    wire [5:0] opcode1 = inst[31:26];
    wire opcode2 = inst[25];
    wire [2:0] opcode3 = inst[24:22];
    wire [6:0] opcode4 = inst[21:15];

    // 3R
    wire ADDW   = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b000) && (opcode4 == 7'b0100000);
    wire SUBW   = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b000) && (opcode4 == 7'b0100010);
    wire AND    = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b000) && (opcode4 == 7'b0101001);
    wire OR     = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b000) && (opcode4 == 7'b0101010);
    wire XOR    = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b000) && (opcode4 == 7'b0101011);
    wire SLLW   = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b000) && (opcode4 == 7'b0101110);
    wire SRLW   = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b000) && (opcode4 == 7'b0101111);
    wire SRAW   = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b000) && (opcode4 == 7'b0110000);
    wire SLT    = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b000) && (opcode4 == 7'b0100100);
    wire SLTU   = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b000) && (opcode4 == 7'b0100101);

    // 2RI5 types
    wire SLLIW  = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b001) && (opcode4 == 7'b0000001);
    wire SRLIW  = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b001) && (opcode4 == 7'b0001001);
    wire SRAIW  = (opcode1 == 6'b0) && (opcode2 == 1'b0) && (opcode3 == 3'b001) && (opcode4 == 7'b0010001);

    // 2RI12 types
    wire ADDIW  = (opcode1 == 6'b0) && (opcode2 == 1'b1) && (opcode3 == 3'b010);
    wire ANDI   = (opcode1 == 6'b0) && (opcode2 == 1'b1) && (opcode3 == 3'b101);
    wire ORI    = (opcode1 == 6'b0) && (opcode2 == 1'b1) && (opcode3 == 3'b110);
    wire XORI   = (opcode1 == 6'b0) && (opcode2 == 1'b1) && (opcode3 == 3'b111);
    wire SLTI   = (opcode1 == 6'b0) && (opcode2 == 1'b1) && (opcode3 == 3'b000);
    wire SLTUI  = (opcode1 == 6'b0) && (opcode2 == 1'b1) && (opcode3 == 3'b001);
    wire LDB    = (opcode1 == 6'b001010) && (opcode2 == 1'b0) && (opcode3 == 3'b000);
    wire LDBU   = (opcode1 == 6'b001010) && (opcode2 == 1'b1) && (opcode3 == 3'b000);
    wire LDH    = (opcode1 == 6'b001010) && (opcode2 == 1'b0) && (opcode3 == 3'b001);
    wire LDHU   = (opcode1 == 6'b001010) && (opcode2 == 1'b1) && (opcode3 == 3'b001);
    wire LDW    = (opcode1 == 6'b001010) && (opcode2 == 1'b0) && (opcode3 == 3'b010);
    wire STB    = (opcode1 == 6'b001010) && (opcode2 == 1'b0) && (opcode3 == 3'b100);
    wire STH    = (opcode1 == 6'b001010) && (opcode2 == 1'b0) && (opcode3 == 3'b101);
    wire STW    = (opcode1 == 6'b001010) && (opcode2 == 1'b0) && (opcode3 == 3'b110);

    // 1RI20
    wire LU12IW = (opcode1 == 6'b000101) && (opcode2 == 1'b0);
    wire PCADDU = (opcode1 == 6'b000111) && (opcode2 == 1'b0);

    // 2RI16
    wire BEQ    = (opcode1 == 6'b010110);
    wire BNE    = (opcode1 == 6'b010111);
    wire BLT    = (opcode1 == 6'b011000);
    wire BLTU   = (opcode1 == 6'b011010);
    wire BGE    = (opcode1 == 6'b011001);
    wire BGEU   = (opcode1 == 6'b011011);
    wire JIRL   = (opcode1 == 6'b010011);

    // I26
    wire B      = (opcode1 == 6'b010100);
    wire BL     = (opcode1 == 6'b010101);

    assign alu_op =     (ADDW | ADDIW | LDB | LDBU | LDH | LDHU | LDW | STB | STH | STW) ? `ALU_ADD :
                        (SUBW) ? `ALU_SUB :
                        (OR | ORI) ? `ALU_OR :
                        (XOR | XORI) ? `ALU_XOR : 
                        (SLLW | SLLIW) ? `ALU_SL :
                        (SRLW | SRLIW) ? `ALU_SRL :
                        (SRAW | SRAIW) ? `ALU_SRA :
                        (AND | ANDI) ? `ALU_AND :
                        (BEQ) ? `ALU_EQ :
                        (BNE) ? `ALU_NEQ :
                        (SLT | SLTI | BLT) ? `ALU_LT_S :
                        (SLTU | SLTUI | BLTU) ? `ALU_LT_U :
                        (BGE) ? `ALU_GE_S :
                        (BGEU) ? `ALU_GE_U :
                        4'b0;

    assign alu_sel =    (ADDW | SUBW | AND | OR | XOR | SLT | SLTU) ? `ASEL_RD2 :
                        (SLLW | SRLW | SRAW) ? `ASEL_RD2_5 : 
                        (SLLIW | SRLIW | SRAIW) ? `ASEL_INST_5 :
                        (PCADDU) ? `ASEL_INST_20 :
                        (ADDIW | SLTI | SLTUI | LDB | LDBU | LDH | LDHU | LDW | STB | STH | STW | JIRL) ? `ASEL_SEXT1 :
                        (ANDI | ORI | XORI) ? `ASEL_ZEXT :
                        3'b000;
                    
    assign npc_op =     (ADDW | SUBW | AND | OR | XOR | SLLW 
                        | SRLW | SRAW | SLT | SLTU | SLLIW | SRLIW | SRAIW
                        | ADDIW | ANDI | ORI | XORI | SLTI | SLTUI
                        | LDB | LDBU | LDH | LDHU | LDW | STB | STH | STW
                        | LU12IW | PCADDU
                        ) ? `NPC_PC_4 :
                        (B | BL) ? `NPC_PC_OFF :
                        (BEQ | BNE | BLT | BLTU | BGE | BGEU) ? `NPC_PC_OFF_BR :
                        (JIRL) ? `NPC_PC_OFF :
                        2'b00;

    assign sext1_op =   (ADDIW | SLTI | SLTUI | LDB | LDBU | LDH | LDHU | LDW | STB | STH | STW) ? `SEXT1_12 :
                        (BEQ | BNE | BLT | BLTU | BGE | BGEU | JIRL) ? `SEXT1_16 :
                        (B | BL) ? `SEXT1_28 :
                        2'b00;

    assign sext2_sel =  (LDB) ? `SEXT2_8 :
                        (LDH) ? `SEXT2_16 :
                        1'b0;

    assign rf_sel =     (ADDW | SUBW | AND | OR | XOR | SLLW | SRLW | SRAW | SLT | SLTU) ? `RD_RK :
                        (BEQ | BNE | BLT | BLTU | BGE | BGEU) ? `RD_RD :
                        1'b0;

    assign wD_sel =     (ADDW | SUBW | AND | OR | XOR | SLLW | SRLW | SRAW | SLT | SLTU
                        | SLLIW | SRLIW | SRAIW
                        | ADDIW | ANDI | ORI | XORI | SLTI | SLTUI
                        | PCADDU) ? `WD_ALU :
                        (LDB | LDH) ? `WD_SEXT2 :
                        (LDBU) ? `WD_DRAM_8 :
                        (LDHU) ? `WD_DRAM_16 : 
                        (LDW) ? `WD_DRAM_32 :
                        (LU12IW) ? `WD_INST :
                        (JIRL) ? `WD_PC4_RD :
                        (BL) ? `WD_PC4_R1 :
                        3'b000;

    assign Bus_we =     (STB | STH | STW) ? 1'b1 :
                        1'b0;

    assign dram_sel =   (LDB | LDBU | LDH | LDHU | LDW) ? `DRAM_R :
                        (STB) ? `DRAM_W_8 :
                        (STH) ? `DRAM_W_16 :
                        (STW) ? `DRAM_W_32 :
                        2'b00;

    assign hang = !(ADDW | SUBW | AND | OR | XOR | SLLW | SRLW | SRAW | SLT | SLTU
                    | SLLIW | SRLIW | SRAIW
                    | ADDIW | ANDI | ORI | XORI | SLTI | SLTUI | LDB | LDBU | LDH | LDHU | LDW | STB | STH | STW
                    | LU12IW | PCADDU | 
                    | BEQ | BNE | BLT | BLTU | BGE | BGEU | JIRL
                    | B | BL);

endmodule