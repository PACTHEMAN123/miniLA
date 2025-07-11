`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
`ifdef RUN_TRACE
    output wire [15:0]  inst_addr,
`else
    output wire [13:0]  inst_addr,
`endif
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // controller
    wire [3:0]      alu_op;
    wire [2:0]      alu_sel;
    wire [1:0]      npc_op;
    wire            rf_sel;
    wire [2:0]      wD_sel;
    wire [2:0]      sext1_op;
    wire            sext2_sel;

    // ALU
    wire [31:0]     alu_c;
    wire            alu_f;

    // RF
    wire [31:0]     rf_rD1;
    wire [31:0]     rf_rD2;

    // NPC
    wire [31:0]     npc;
    wire [31:0]     pc4;

    // PC
    wire [31:0]     pc;

    // EXT
    wire [31:0]     sext1_ext;
    wire [31:0]     sext2_ext;
    wire [31:0]     zext_ext;


    PC myPC (
        .pc_rst     (cpu_rst),
        .pc_clk     (cpu_clk),
        .din        (npc),
        .pc         (pc)
    );

    NPC myNPC (
        .br         (alu_f),
        .pc         (pc),
        .alu_c      (alu_c),
        .sext       (sext1_ext),
        .npc_op     (npc_op)
    );

    ALU myALU (
        .inst       (inst),
        .alu_op     (alu_op),
        .pc         (pc),
        .rf_rD1     (rf_rD1),
        .rf_rD2     (rf_rD2),
        .sext1      (sext1_ext),
        .zext       (zext_ext),
        .alu_sel    (alu_sel)
    );

    RF myRF (
        .rf_rst     (cpu_rst),
        .rf_clk     (cpu_clk),
        .inst       (inst),
        .rf_sel     (rf_sel),
        .wD_sel     (wD_sel),
        .alu_c      (alu_c),
        .sext2      (sext2_ext),
        .pc4        (pc4),
        .rdo        (Bus_rdata)
    );

    SEXT1 mySEXT1 (
        .sext1_op   (sext1_op),
        .inst       (inst)
    );

    SEXT2 mySEXT2 (
        .sext2_sel   (sext2_sel),
        .rdo        (Bus_rdata)
    );

    ZEXT myZEXT (
        .inst       (inst)
    );

    Controller myController (
        .inst       (inst)
    );

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1'b1;
    assign debug_wb_pc        = pc;
    assign debug_wb_ena       = 1'b0;
    assign debug_wb_reg       = inst[4:0];
    assign debug_wb_value     = 32'b0;
`endif

endmodule
