#ifndef __DECODE_INFO__
#define __DECODE_INFO__

#include <stdint.h>

// decode
typedef union {

    struct 
    {
      uint32_t rd : 5;
      uint32_t rj : 5;
      uint32_t opcode : 22;
    } r2;
    
    struct 
    {
      uint32_t rd : 5;
      uint32_t rj : 5;
      uint32_t rk : 5;
      uint32_t opcode : 17;
    } r3;
    
    struct 
    {
      uint32_t rd : 5;
      uint32_t rj : 5;
      uint32_t i8l : 5;
      uint32_t i8h : 3;
      uint32_t opcode : 14;
    } r2i8;
    
    struct 
    {
      uint32_t rd     : 5;
      uint32_t rj     : 5;
      uint32_t i12    : 12;
      uint32_t opcode : 10;
    } r2i12;

    struct 
    {
      uint32_t rd     : 5;
      uint32_t rj     : 5;
      int32_t  si12   : 12;
      uint32_t opcode : 10;
    } r2si12;

    struct 
    {
      uint32_t rd : 5;
      uint32_t rj : 5;
      uint32_t i14: 14;
      uint32_t opcodel : 1;
      uint32_t opcodeh : 7;
    } r2i14;
    
    struct 
    {
      uint32_t rd     : 5;
      uint32_t rj     : 5;
      int32_t  si16   : 16;
      uint32_t opcode : 6;
    } r2i16;
      
    struct
    {
      uint32_t i26h : 10;
      uint32_t i26l : 16;
      uint32_t opcode : 6;
    } i26;
    

    // struct {
    //   uint32_t opcode1_0 : 2;//低位
    //   uint32_t opcode6_2 : 5;
    //   uint32_t rd        : 5;
    //   uint32_t funct3    : 3;
    //   uint32_t rs1       : 5;
    //   uint32_t rs2       : 5;
    //   uint32_t funct7    : 7;//高位
    // } r;
    // struct {
    //   uint32_t opcode1_0 : 2;
    //   uint32_t opcode6_2 : 5;
    //   uint32_t rd        : 5;
    //   uint32_t funct3    : 3;
    //   uint32_t rs1       : 5;
    //   int32_t  simm11_0  :12;
    // } i;
    // struct {
    //   uint32_t opcode1_0 : 2;
    //   uint32_t opcode6_2 : 5;
    //   uint32_t imm4_0    : 5;
    //   uint32_t funct3    : 3;
    //   uint32_t rs1       : 5;
    //   uint32_t rs2       : 5;
    //   int32_t  simm11_5  : 7;
    // } s;
    // struct {
    //   uint32_t opcode1_0 : 2;
    //   uint32_t opcode6_2 : 5;
    //   uint32_t imm11     : 1;
    //   uint32_t imm4_1    : 4;
    //   uint32_t funct3    : 3;
    //   uint32_t rs1       : 5;
    //   uint32_t rs2       : 5;
    //   uint32_t imm10_5   : 6;
    //   int32_t  simm12    : 1;
    // } b;
    // struct {
    //   uint32_t opcode1_0 : 2;
    //   uint32_t opcode6_2 : 5;
    //   uint32_t rd        : 5;
    //   uint32_t imm31_12  :20;
    // } u;
    // struct {
    //   uint32_t opcode1_0 : 2;
    //   uint32_t opcode6_2 : 5;
    //   uint32_t rd        : 5;
    //   uint32_t imm19_12  : 8;
    //   uint32_t imm11     : 1;
    //   uint32_t imm10_1   :10;
    //   int32_t  simm20    : 1;
    // } j;
    // struct {
    //   uint32_t pad7      :20;
    //   uint32_t csr       :12;
    // } csr;
    uint32_t inst_raw;
} Decodeinfo_raw;

#endif
