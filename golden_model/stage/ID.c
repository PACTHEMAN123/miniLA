#include "../include/cpu.h"
#include "../include/bin.h"
#include <stdint.h>
#define pair(x, y) (((x) << 3) | (y))
#define PAIR_ENTRY(x, y, OP) case pair(x,y): ret.alu_op = OP; break
extern riscv32_CPU_state cpu;

ID2EX ID_2R(IF2ID inst) {
    ID2EX ret;
    return ret;
}

ID2EX ID_3R(IF2ID inst) {
    // 10 instructions
    //ADD/SLT/SLTU/AND/OR/XOR/SLL/SRL/SUB/SRA
    ID2EX ret;
    ret.inst_raw_split.inst_raw = inst.inst;
    ret.next_pc = inst.pc + 4;
    ret.pc = inst.pc;
    ret.inst = inst.inst;

    switch (ret.inst_raw_split.r3.opcode)
    {
    case 0b00000000000100000:{ret.alu_op = OP_ADD;break;}
    case 0b00000000000100010:{ret.alu_op = OP_SUB;break;}
    case 0b00000000000100100:{ret.alu_op = OP_SLT;break;}
    case 0b00000000000100101:{ret.alu_op = OP_SLTU;break;}
    case 0b00000000000101000:{ret.alu_op = OP_NOR;break;}
    case 0b00000000000101001:{ret.alu_op = OP_AND;break;}
    case 0b00000000000101010:{ret.alu_op = OP_OR;break;}
    case 0b00000000000101011:{ret.alu_op = OP_XOR;break;}
    case 0b00000000000101110:{ret.alu_op = OP_SLL;break;}
    case 0b00000000000101111:{ret.alu_op = OP_SRL;break;}
    case 0b00000000000110000:{ret.alu_op = OP_SRA;break;}
    case 0b00000000001010100:{ret.alu_op = OP_BREAK;break;}
    case 0b00000000001010110:{ret.alu_op = OP_SYSCALL;break;}
    
    default:ret.alu_op = OP_INVALID;
    }

    // switch (pair(ret.inst_raw_split.r.funct7, ret.inst_raw_split.r.funct3)) {
    //     PAIR_ENTRY(0, 0, OP_ADD);
    //     PAIR_ENTRY(0, 1, OP_SLL);
    //     PAIR_ENTRY(0, 2, OP_SLT);
    //     PAIR_ENTRY(0, 3, OP_SLTU);
    //     PAIR_ENTRY(0, 4, OP_XOR);
    //     PAIR_ENTRY(0, 5, OP_SRL);
    //     PAIR_ENTRY(0, 6, OP_OR);
    //     PAIR_ENTRY(0, 7, OP_AND);
    //     PAIR_ENTRY(32, 0, OP_SUB);
    //     PAIR_ENTRY(32, 5, OP_SRA);
    //     default: ret.alu_op = OP_INVALID;
    // }

    //寄存�?    ret.src1.type = OP_TYPE_REG;
    ret.src1.value = cpu.gpr[ret.inst_raw_split.r3.rk];//�?�?

    ret.src2.type = OP_TYPE_REG;
    ret.src2.value = cpu.gpr[ret.inst_raw_split.r3.rj];//前rk后rj
    
    ret.dst = ret.inst_raw_split.r3.rd;

    //使能
    ret.is_jmp = 0;
    ret.is_branch = 0;
    ret.is_mem = 0;
    ret.wb_sel = WB_ALU;
    ret.wb_en = 1;

    return ret;
}


// ID2EX ID_R(IF2ID inst) {
//     // 10 instructions
//     //ADD/SLT/SLTU/AND/OR/XOR/SLL/SRL/SUB/SRA
//     ID2EX ret;
//     ret.inst_raw_split.inst_raw = inst.inst;
//     ret.next_pc = inst.pc + 4;
//     ret.pc = inst.pc;
//     ret.inst = inst.inst;

//     switch (pair(ret.inst_raw_split.r.funct7, ret.inst_raw_split.r.funct3)) {
//         PAIR_ENTRY(0, 0, OP_ADD);
//         PAIR_ENTRY(0, 1, OP_SLL);
//         PAIR_ENTRY(0, 2, OP_SLT);
//         PAIR_ENTRY(0, 3, OP_SLTU);
//         PAIR_ENTRY(0, 4, OP_XOR);
//         PAIR_ENTRY(0, 5, OP_SRL);
//         PAIR_ENTRY(0, 6, OP_OR);
//         PAIR_ENTRY(0, 7, OP_AND);
//         PAIR_ENTRY(32, 0, OP_SUB);
//         PAIR_ENTRY(32, 5, OP_SRA);
//         default: ret.alu_op = OP_INVALID;
//     }

//     ret.is_jmp = 0;
//     ret.is_branch = 0;
//     ret.is_mem = 0;

//     ret.src1.type = OP_TYPE_REG;
//     ret.src1.value = cpu.gpr[ret.inst_raw_split.r.rs1];

//     ret.src2.type = OP_TYPE_REG;
//     ret.src2.value = cpu.gpr[ret.inst_raw_split.r.rs2];
    
//     ret.dst = ret.inst_raw_split.r.rd;
//     ret.wb_sel = WB_ALU;
//     ret.wb_en = 1;

//     return ret;
// }

/*
ID2EX ID_I_LOAD(IF2ID inst) {
    // LOAD
    ID2EX ret;
    ret.inst_raw_split.inst_raw = inst.inst;
    ret.alu_op = OP_ADD;
    ret.next_pc = inst.pc + 4;
    ret.pc = inst.pc;
    ret.inst = inst.inst;
    switch (ret.inst_raw_split.i.funct3) {
        case 0: ret.mem_op = MEM_LB; break;
        case 1: ret.mem_op = MEM_LH; break;
        case 2: ret.mem_op = MEM_LW; break;
        case 4: ret.mem_op = MEM_LBU; break;
        case 5: ret.mem_op = MEM_LHU; break;
        default: ret.mem_op = MEM_LW; break;
    }

    ret.is_jmp = 0;
    ret.is_branch = 0;
    ret.is_mem = 1;

    ret.src1.type = OP_TYPE_REG;
    ret.src1.value = cpu.gpr[ret.inst_raw_split.r.rs1];

    ret.src2.type = OP_TYPE_IMM;
    ret.src2.value = ret.inst_raw_split.i.simm11_0;
    
    ret.dst = ret.inst_raw_split.r.rd;
    ret.wb_sel = WB_LOAD;
    ret.wb_en = 1;

    return ret;
}
*/

ID2EX ID_2RI12(IF2ID inst) {
    // 9 instructions
    // ADDI/SLTI/SLTIU/ANDI/ORI/XORI
    // SLLI/SRLI/SRAI
    ID2EX ret;
    ret.inst_raw_split.inst_raw = inst.inst;//按位分解
    ret.next_pc = inst.pc + 4;
    ret.pc = inst.pc;
    ret.inst = inst.inst;
    ret.is_mem = 0;

    switch (ret.inst_raw_split.r2i12.opcode) {
        case 0b0000001010:  // addi.w
        case 0b0010100000:  // ld.b
        case 0b0010101000:  // ld.bu
        case 0b0010100001:  // ld.h
        case 0b0010101001:  // ld.hu
        case 0b0010100010:  // ld.w
        case 0b0010100100:  // st.b
        case 0b0010100101:  // st.h
        case 0b0010100110:  // st.w
            ret.alu_op = OP_ADD; break;
        //case 0b: ret.alu_op = OP_SLL; break;
        case 0b0000001000: ret.alu_op = OP_SLT; break;
        case 0b0000001001: ret.alu_op = OP_SLTU; break;
        case 0b0000001111: ret.alu_op = OP_XOR; break;
        //case 0b: if(ret.inst_raw_split.s.simm11_5 == 0) ret.alu_op = OP_SRL;
        //        else ret.alu_op = OP_SRA;
        //        break;
        case 0b0000001110: ret.alu_op = OP_OR; break;
        case 0b0000001101: ret.alu_op = OP_AND; break;
        default:     switch (ret.inst_raw_split.r2i8.opcode) {
                            case 0b000000000010000: ret.alu_op = OP_SLL; break;
                            case 0b000000000010001: ret.alu_op = OP_SRL; break;
                            case 0b000000000010010: ret.alu_op = OP_SRA; break;
                            default: ret.alu_op = OP_INVALID; break;
                    }
        //ret.alu_op = OP_INVALID; break;
    }

    if ((ret.inst_raw_split.r2i12.opcode & 0xa0) == 0xa0){
        ret.is_mem = 1;
        switch (ret.inst_raw_split.r2i12.opcode) {
            case 0b0010100000: ret.mem_op = MEM_LB;  ret.wb_sel = WB_LOAD; ret.wb_en = 1; break;     // ld.b
            case 0b0010101000: ret.mem_op = MEM_LBU; ret.wb_sel = WB_LOAD; ret.wb_en = 1; break;     // ld.bu
            case 0b0010100001: ret.mem_op = MEM_LH;  ret.wb_sel = WB_LOAD; ret.wb_en = 1; break;     // ld.h
            case 0b0010101001: ret.mem_op = MEM_LHU; ret.wb_sel = WB_LOAD; ret.wb_en = 1; break;     // ld.hu
            case 0b0010100010: ret.mem_op = MEM_LW;  ret.wb_sel = WB_LOAD; ret.wb_en = 1; break;     // ld.w
            case 0b0010100100: ret.mem_op = MEM_SB;  ret.wb_en = 0; break;     // st.b
            case 0b0010100101: ret.mem_op = MEM_SH;  ret.wb_en = 0; break;     // st.h
            case 0b0010100110: ret.mem_op = MEM_SW;  ret.wb_en = 0; break;     // st.w
            default: ret.mem_op = MEM_INVALID;
        }
    } else {
        ret.wb_sel = WB_ALU;
        ret.wb_en = 1;
    }

    //寄存�?
    ret.src1.type = OP_TYPE_IMM;
    if (ret.inst_raw_split.r2i12.opcode == 0b0000001101 ||      // andi
        ret.inst_raw_split.r2i12.opcode == 0b0000001110 ||      // ori
        ret.inst_raw_split.r2i12.opcode == 0b0000001111)        // xori
        ret.src1.value = ret.inst_raw_split.r2i12.i12;
    else
        ret.src1.value = ret.inst_raw_split.r2si12.si12;

    // if(ret.inst_raw_split.r2i8.opcode > 0b000000000100000)//2ri12
        // ret.src1.value = ret.inst_raw_split.r2i12.i12;
    // else
        // ret.src1.value = ret.inst_raw_split.r2i8.i8l;

    ret.src2.type = OP_TYPE_REG;
    ret.src2.value = cpu.gpr[ret.inst_raw_split.r2i12.rj];

    ret.dst = ret.inst_raw_split.r2i12.rd;
    ret.store_val = cpu.gpr[ret.inst_raw_split.r2i12.rd];

    //使能
    ret.is_jmp = 0;
    ret.is_branch = 0;

    return ret;
}


// ID2EX ID_I(IF2ID inst) {
//     // 9 instructions
//     // ADDI/SLTI/SLTIU/ANDI/ORI/XORI
//     // SLLI/SRLI/SRAI
//     ID2EX ret;
//     ret.inst_raw_split.inst_raw = inst.inst;
//     ret.next_pc = inst.pc + 4;
//     ret.pc = inst.pc;
//     ret.inst = inst.inst;

//     switch (ret.inst_raw_split.i.funct3) {
//         case 0: ret.alu_op = OP_ADD; break;
//         case 1: ret.alu_op = OP_SLL; break;
//         case 2: ret.alu_op = OP_SLT; break;
//         case 3: ret.alu_op = OP_SLTU; break;
//         case 4: ret.alu_op = OP_XOR; break;
//         case 5: if(ret.inst_raw_split.s.simm11_5 == 0) ret.alu_op = OP_SRL;
//                 else ret.alu_op = OP_SRA;
//                 break;
//         case 6: ret.alu_op = OP_OR; break;
//         case 7: ret.alu_op = OP_AND; break;
//         default: ret.alu_op = OP_INVALID; break;
//     }

//     ret.is_jmp = 0;
//     ret.is_branch = 0;
//     ret.is_mem = 0;

//     ret.src1.type = OP_TYPE_REG;
//     ret.src1.value = cpu.gpr[ret.inst_raw_split.r.rs1];

//     ret.src2.type = OP_TYPE_IMM;
//     ret.src2.value = ret.inst_raw_split.i.simm11_0;
    
//     ret.dst = ret.inst_raw_split.r.rd;
//     ret.wb_sel = WB_ALU;
//     ret.wb_en = 1;

//     return ret;
// }


/*
ID2EX ID_S(IF2ID inst) {
    // 1 instruction
    // STORE
    ID2EX ret;
    ret.inst_raw_split.inst_raw = inst.inst;
    ret.next_pc = inst.pc + 4;
    ret.pc = inst.pc;
    ret.inst = inst.inst;

    ret.is_jmp = 0;
    ret.is_branch = 0;
    ret.is_mem = 1;

    ret.alu_op = OP_ADD;

    switch (ret.inst_raw_split.s.funct3) {
        case 0: ret.mem_op = MEM_SB; break;
        case 1: ret.mem_op = MEM_SH; break;
        case 2: ret.mem_op = MEM_SW; break;
        default: ret.mem_op = MEM_SW; break;
    }

    ret.src1.type = OP_TYPE_REG;
    ret.src1.value = cpu.gpr[ret.inst_raw_split.r.rs1];

    ret.src2.type = OP_TYPE_IMM;
    ret.src2.value = (ret.inst_raw_split.s.simm11_5 << 5 ) | (ret.inst_raw_split.s.imm4_0 );

    ret.store_val = cpu.gpr[ret.inst_raw_split.r.rs2];
    
    ret.wb_en = 0;

    return ret;
}
*/

ID2EX ID_2RI16(IF2ID inst) {
    // 6 instructions
    // BEQ/BNE/BLT/BLTU/BGE/BGEU
    //jiirl
    ID2EX ret;
    ret.inst_raw_split.inst_raw = inst.inst;
    int32_t imm = (ret.inst_raw_split.r2i16.si16 << 2);
    ret.dst = ret.inst_raw_split.r2i16.rd;
    ret.next_pc = inst.pc + imm;
    ret.pc = inst.pc;
    ret.inst = inst.inst;

    ret.alu_op = OP_ADD;

    switch (ret.inst_raw_split.r2i16.opcode) {
        case 0b010110: ret.br_op = BR_EQ; break;
        case 0b010111: ret.br_op = BR_NEQ; break;
        case 0b011000: ret.br_op = BR_LT; break;
        case 0b011001: ret.br_op = BR_GE; break;
        case 0b011010: ret.br_op = BR_LTU; break;
        case 0b011011: ret.br_op = BR_GEU; break;
    }

    ret.src1.type = OP_TYPE_REG;
    ret.src1.value = cpu.gpr[ret.inst_raw_split.r2i12.rj];

    ret.src2.type = OP_TYPE_REG;
    ret.src2.value = cpu.gpr[ret.inst_raw_split.r2i12.rd];

    ret.is_jmp = 0;
    ret.is_branch = 1;
    ret.is_mem = 0;
    ret.wb_en = 0;

    if (ret.inst_raw_split.r2i16.opcode == 0b010011) // jirl
    {
        ret.is_jmp = 1;
        ret.is_branch = 0;
        ret.is_mem = 0;
        ret.wb_en = 1;
        ret.wb_sel = WB_PC;
        ret.next_pc = cpu.gpr[ret.inst_raw_split.r2i16.rj] + (ret.inst_raw_split.r2i16.si16<<2);
    }

    return ret;
}



// ID2EX ID_B(IF2ID inst) {
//     // 6 instructions
//     // BEQ/BNE/BLT/BLTU/BGE/BGEU
//     ID2EX ret;
//     ret.inst_raw_split.inst_raw = inst.inst;
//     uint32_t imm = (ret.inst_raw_split.b.simm12 << 12) | (ret.inst_raw_split.b.imm11 << 11) | (ret.inst_raw_split.b.imm10_5 << 5) | (ret.inst_raw_split.b.imm4_1 << 1);
//     ret.next_pc = inst.pc + imm;
//     ret.pc = inst.pc;
//     ret.inst = inst.inst;

//     ret.is_jmp = 0;
//     ret.is_branch = 1;
//     ret.is_mem = 0;

//     ret.alu_op = OP_ADD;

//     switch(ret.inst_raw_split.b.funct3) {
//         case 0: ret.br_op = BR_EQ; break;
//         case 1: ret.br_op = BR_NEQ ; break;
//         case 4: ret.br_op = BR_LT; break;
//         case 5: ret.br_op = BR_GE; break;
//         case 6: ret.br_op = BR_LTU; break;
//         case 7: ret.br_op = BR_GEU; break;
//     }

//     ret.src1.type = OP_TYPE_REG;
//     ret.src1.value = cpu.gpr[ret.inst_raw_split.r.rs1];

//     ret.src2.type = OP_TYPE_REG;
//     ret.src2.value = cpu.gpr[ret.inst_raw_split.r.rs2];

//     ret.wb_en = 0;

//     return ret;
// }

ID2EX ID_2RI14(IF2ID inst) {
    // 2 instructions
    // LUI/AUIPC
    ID2EX ret;
    ret.inst_raw_split.inst_raw = inst.inst;
    ret.next_pc = inst.pc + 4;
    ret.pc = inst.pc;
    ret.inst = inst.inst;

    ret.alu_op = OP_ADD;

    if(ret.inst_raw_split.r2i14.opcodeh == 0b0001010) {//lu12i.w
        ret.src1.value = 0;
    } else {
        ret.src1.value = inst.pc;
    }
    uint32_t imm = (ret.inst_raw_split.r2i14.rj) | (ret.inst_raw_split.r2i14.i14 << 5) | (ret.inst_raw_split.r2i14.opcodel<<19);
    ret.src2.value = (imm << 12);
    
    ret.dst = ret.inst_raw_split.r2i14.rd;

    ret.is_jmp = 0;
    ret.is_branch = 0;
    ret.is_mem = 0;
    ret.wb_sel = WB_ALU;
    ret.wb_en = 1;

    return ret;
}

ID2EX ID_I26(IF2ID inst) {
    // JAL/JALR
    ID2EX ret;
    ret.inst_raw_split.inst_raw = inst.inst;
    ret.next_pc = inst.pc + 4;
    ret.pc = inst.pc;
    ret.inst = inst.inst;

    ret.is_jmp = 1;
    ret.is_branch = 0;
    ret.is_mem = 0;

    ret.alu_op = OP_ADD;
    // uint32_t jimm = (ret.inst_raw_split.i26.i26l << 9) | (ret.inst_raw_split.i26.i26h) ;
    uint32_t jimm = ret.inst_raw_split.i26.i26l | (ret.inst_raw_split.i26.i26h << 16) ;
    ret.next_pc = inst.pc + (jimm<<2);
    if(ret.inst_raw_split.i26.opcode == 0b010100) {  // bl
        ret.next_pc = inst.pc + (jimm<<2);
        ret.dst = 1;
        ret.wb_sel = WB_PC;
        ret.wb_en = 1;
    // } else { // JALR
    //     ret.next_pc = cpu.gpr[ret.inst_raw_split.r.rs1] + ret.inst_raw_split.i.simm11_0;
    }

    // ret.dst = 1;
    // ret.wb_sel = WB_PC;
    ret.wb_en = 0;

    return ret;
}


// ID2EX ID_U(IF2ID inst) {
//     // 2 instructions
//     // LUI/AUIPC
//     ID2EX ret;
//     ret.inst_raw_split.inst_raw = inst.inst;
//     ret.next_pc = inst.pc + 4;
//     ret.pc = inst.pc;
//     ret.inst = inst.inst;

//     ret.is_jmp = 0;
//     ret.is_branch = 0;
//     ret.is_mem = 0;

//     ret.alu_op = OP_ADD;

//     if(ret.inst_raw_split.u.opcode6_2 == 0xd) {
//         ret.src1.value = 0;
//     } else {
//         ret.src1.value = inst.pc;
//     }
//     ret.src2.value = (ret.inst_raw_split.u.imm31_12 << 12);
    
//     ret.dst = ret.inst_raw_split.u.rd;
//     ret.wb_sel = WB_ALU;
//     ret.wb_en = 1;

//     return ret;
// }

// ID2EX ID_J(IF2ID inst) {
//     // JAL/JALR
//     ID2EX ret;
//     ret.inst_raw_split.inst_raw = inst.inst;
//     ret.next_pc = inst.pc + 4;
//     ret.pc = inst.pc;
//     ret.inst = inst.inst;

//     ret.is_jmp = 1;
//     ret.is_branch = 0;
//     ret.is_mem = 0;

//     ret.alu_op = OP_ADD;
//     uint32_t jimm = (ret.inst_raw_split.j.simm20 << 20) | (ret.inst_raw_split.j.imm19_12 << 12) | (ret.inst_raw_split.j.imm11 << 11) | (ret.inst_raw_split.j.imm10_1  << 1);
//     if(ret.inst_raw_split.j.opcode6_2 == 0x1b) {  // JAL 
//         ret.next_pc = inst.pc + jimm;
//     } else { // JALR
//         ret.next_pc = cpu.gpr[ret.inst_raw_split.r.rs1] + ret.inst_raw_split.i.simm11_0;
//     }

//     ret.dst = ret.inst_raw_split.j.rd;
//     ret.wb_sel = WB_PC;
//     ret.wb_en = 1;

//     return ret;
// }

ID2EX ID(IF2ID inst) {
    ID2EX ret;
    ret.inst_raw_split.inst_raw = inst.inst;
    ret.next_pc = inst.pc + 4;
    ret.pc = inst.pc;
    ret.inst = inst.inst;
    ret.wb_en = 0;
    // Log("OpCode is %8.8x",  ((ret.inst_raw_split.i.opcode6_2) << 2) | (ret.inst_raw_split.i.opcode1_0) );
    if ((ret.inst_raw_split.inst_raw & 0x40000000) == 0x40000000){ //beq-bl
        if (((ret.inst_raw_split.inst_raw & 0x20000000 ) == 0x20000000)
            || ((ret.inst_raw_split.inst_raw & 0x08000000 ) == 0x08000000)) //beq-jirl
            ret = ID_2RI16(inst);
        else
            ret = ID_I26(inst);//b-bl
    } else {//rd-pca
        if(((ret.inst_raw_split.inst_raw & 0x04000000 ) == 0x04000000))
            ret = ID_2RI14(inst);//cs-pca
        else {
            // if (((ret.inst_raw_split.inst_raw & 0x08000000 ) == 0x08000000))//ldb-ld
            //     printf("pass");
            //     //ret = ID_S(inst);
            // else {
                if (((ret.inst_raw_split.inst_raw & 0x02000000 ) == 0x02000000)
                    | ((ret.inst_raw_split.inst_raw & 0x00400000 ) == 0x00400000) //slti-xori | slli- srai
                    | ((ret.inst_raw_split.inst_raw & 0x28000000 ) == 0x28000000)) //ld st
                    ret = ID_2RI12(inst);
                else {
                    if (((ret.inst_raw_split.inst_raw & 0x00200000 ) == 0x00200000)
                        | ((ret.inst_raw_split.inst_raw & 0x00100000 ) == 0x00100000))//add-break
                        ret = ID_3R(inst);
                    else
                        ret = ID_2R(inst);//rd-rd
                }
            // }
        }
    }
    return ret;
}


// ID2EX ID(IF2ID inst) {
//     ID2EX ret;
//     ret.inst_raw_split.inst_raw = inst.inst;
//     ret.next_pc = inst.pc + 4;
//     ret.pc = inst.pc;
//     ret.inst = inst.inst;
//     ret.wb_en = 0;
//     Log("OpCode is %8.8x",  ((ret.inst_raw_split.i.opcode6_2) << 2) | (ret.inst_raw_split.i.opcode1_0) );
//     switch( (ret.inst_raw_split.inst_raw)  ) { // 32�?//         case 0x73:        // ecall, treat as halt
//             ret.alu_op = OP_ECALL;
//             break;
//         case B8(00110111):
//         case B8(00010111):
//             ret = ID_U(inst);
//             break;
//         case B8(01101111):
//         case B8(01100111):
//             ret = ID_J(inst);
//             Log("Jump target = %8.8x", ret.next_pc);
//             break;
//         case B8(01100011):
//             ret = ID_B(inst);
//             Log("Branch target = %8.8x", ret.next_pc);
//             break;
//         case B8(00000011):
//             ret = ID_I_LOAD(inst);
//             break;
//         case B8(00100011):
//             ret = ID_S(inst);
//             break;
//         case B8(00010011):
//             ret = ID_I(inst);
//             break;
//         case B8(00110011):
//             ret = ID_R(inst);
//             break;
//         default:
//             ret.alu_op = OP_INVALID;
//             break;
//     }
//     return ret;
// }

