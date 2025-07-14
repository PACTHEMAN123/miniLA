// Annotate this macro before synthesis
`define RUN_TRACE

// TODO: 在此处定义你的宏
// NPC control signals
`define NPC_PC_4        2'b00 // pc = pc + 4
`define NPC_PC_OFF      2'b01 // pc = pc + offset
`define NPC_PC_OFF_BR   2'b10 // pc = br ? pc + 4 : pc + offset
`define NPC_OFF         2'b11 // pc = offset

// RF control signals
// read register rD2
`define RD_RK           1'b0
`define RD_RD           1'b1
// write data
`define WD_ALU          3'b000
`define WD_SEXT2        3'b001
`define WD_DRAM_8       3'b010
`define WD_DRAM_16      3'b011
`define WD_DRAM_32      3'b100
`define WD_INST         3'b101
`define WD_PC4_RD       3'b110
`define WD_PC4_R1       3'b111

// ALU control signals
// alu_sels:
`define ASEL_RD2        3'b001
`define ASEL_RD2_5      3'b010
`define ASEL_INST_5     3'b011
`define ASEL_INST_20    3'b100
`define ASEL_SEXT1      3'b101
`define ASEL_ZEXT       3'b110

// alu_ops:
`define ALU_ADD         4'b0001
`define ALU_SUB         4'b0010
`define ALU_OR          4'b0011
`define ALU_XOR         4'b0100
`define ALU_SL          4'b0101
`define ALU_SRL         4'b0110
`define ALU_SRA         4'b0111
`define ALU_AND         4'b1000
`define ALU_EQ          4'b1001
`define ALU_NEQ         4'b1010
`define ALU_LT_S        4'b1011
`define ALU_LT_U        4'b1100
`define ALU_GE_S        4'b1101
`define ALU_GE_U        4'b1110

// Extentions
// sext1_ops
`define SEXT1_12        2'b01
`define SEXT1_16        2'b10
`define SEXT1_28        2'b11

// sext2_sels
`define SEXT2_8         1'b0
`define SEXT2_16        1'b1

// Dram
// dram sels
`define DRAM_R          2'b00
`define DRAM_W_8        2'b01
`define DRAM_W_16       2'b10
`define DRAM_W_32       2'b11

// dram address access mode
`define ADDR_BYTE       2'b01
`define ADDR_HW         2'b10
`define ADDR_WORD       2'b11


// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078
