`include "defines.vh"

module DataHazard (
    input wire [31:0] inst,
    input wire rf_sel,

    input wire [4:0] EX_wb_reg,
    input wire EX_wb_ena,
    input wire [2:0] EX_wD_sel,
    input wire [31:0] EX_wb_value,

    input wire [4:0] MEM_wb_reg,
    input wire MEM_wb_ena,
    input wire [31:0] MEM_wb_value,

    input wire [4:0] WB_wb_reg,
    input wire WB_wb_ena,
    input wire [31:0] WB_wb_value,

    input wire read1,
    input wire read2,

    output wire forward_op1,
    output wire forward_op2,
    output wire [31:0] forward_rD1,
    output wire [31:0] forward_rD2,
    output wire PC_stop,
    output wire IFID_stop,
    output wire IDEX_flush
);

    wire [4:0] r1 = inst[9:5];
    wire [4:0] r2 = (rf_sel == `RD_RK) ? inst[14:10] :
                    (rf_sel == `RD_RD) ? inst[4:0] :
                    5'b0;

    wire RAW_A_r1 = (r1 == EX_wb_reg) && EX_wb_ena && read1 && (EX_wb_reg != 5'b0);
    wire RAW_A_r2 = (r2 == EX_wb_reg) && EX_wb_ena && read2 && (EX_wb_reg != 5'b0);

    wire RAW_B_r1 = (r1 == MEM_wb_reg) && MEM_wb_ena && read1 && (MEM_wb_reg != 5'b0);
    wire RAW_B_r2 = (r2 == MEM_wb_reg) && MEM_wb_ena && read2 && (MEM_wb_reg != 5'b0);

    wire RAW_C_r1 = (r1 == WB_wb_reg) && WB_wb_ena && read1 && (WB_wb_reg != 5'b0);
    wire RAW_C_r2 = (r2 == WB_wb_reg) && WB_wb_ena && read2 && (WB_wb_reg != 5'b0);

    wire load_use = (RAW_A_r1 || RAW_A_r2) && (
                    (EX_wD_sel == `WD_SEXT2) ||
                    (EX_wD_sel == `WD_DRAM_8) ||
                    (EX_wD_sel == `WD_DRAM_16) ||
                    (EX_wD_sel == `WD_DRAM_32));

    assign forward_op1 = RAW_A_r1 | RAW_B_r1 | RAW_C_r1;
    assign forward_op2 = RAW_A_r2 | RAW_B_r2 | RAW_C_r2;

    assign forward_rD1 =    (RAW_A_r1) ? EX_wb_value :
                            (RAW_B_r1) ? MEM_wb_value :
                            (RAW_C_r1) ? WB_wb_value :
                            32'b0;

    assign forward_rD2 =    (RAW_A_r2) ? EX_wb_value :
                            (RAW_B_r2) ? MEM_wb_value :
                            (RAW_C_r2) ? WB_wb_value :
                            32'b0;
    

    assign PC_stop = load_use ? 1'b1 : 1'b0;
    assign IFID_stop = load_use ? 1'b1 : 1'b0;
    assign IDEX_flush = load_use ? 1'b1 : 1'b0;

endmodule