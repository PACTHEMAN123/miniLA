// Annotate this macro before synthesis
// `define RUN_TRACE

// TODO: 在此处定义你的宏

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
`define ALU_SCMP        4'b1000
`define ALU_UCMP        4'b1001
`define ALU_AND         4'b1010


// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078
