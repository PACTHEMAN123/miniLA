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
    wire            we;
    wire            hang;
    wire            wb_ena;

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

    // Dram sel
    wire [1:0]      dram_sel;
    wire [31:0]     dram_addr;
    wire [31:0]     dram_wdata;

`ifdef RUN_TRACE
    wire [4:0]      wb_reg;
    wire [31:0]     wb_value;
`endif


    PC myPC (
        .pc_rst     (cpu_rst),
        .pc_clk     (cpu_clk),
        .din        (npc),
        .pc         (pc)
    );

    assign inst_addr = pc[31:2];

    NPC myNPC (
        .br         (alu_f),
        .pc         (pc),
        .alu_c      (alu_c),
        .sext       (sext1_ext),
        .npc_op     (npc_op),
        .npc        (npc),
        .pc4        (pc4)
    );

    ALU myALU (
        .inst       (inst),
        .alu_op     (alu_op),
        .pc         (pc),
        .rf_rD1     (rf_rD1),
        .rf_rD2     (rf_rD2),
        .sext1      (sext1_ext),
        .zext       (zext_ext),
        .alu_sel    (alu_sel),
        .alu_c      (alu_c),
        .alu_f      (alu_f)
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
        .rdo        (Bus_rdata),
        .rf_rD1     (rf_rD1),
        .rf_rD2     (rf_rD2)
`ifdef RUN_TRACE
        ,
        .debug_wb_reg (wb_reg),
        .debug_wb_value (wb_value)
`endif
    );

    SEXT1 mySEXT1 (
        .sext1_op   (sext1_op),
        .inst       (inst),
        .sext1_ext  (sext1_ext)
    );

    SEXT2 mySEXT2 (
        .sext2_sel   (sext2_sel),
        .rdo        (Bus_rdata),
        .sext2_ext  (sext2_ext)
    );

    ZEXT myZEXT (
        .inst       (inst),
        .zext_ext   (zext_ext)
    );

    Controller myController (
        .inst       (inst),
        .alu_op     (alu_op),
        .alu_sel    (alu_sel),
        .npc_op     (npc_op),
        .rf_sel     (rf_sel),
        .wD_sel     (wD_sel),
        .sext1_op   (sext1_op),
        .sext2_sel  (sext2_sel),
        .Bus_we     (we),
        .dram_sel   (dram_sel)
`ifdef RUN_TRACE
        ,
        .wb_ena     (wb_ena)   
`endif
    );

    DramSel myDramSel (
        .dram_sel   (dram_sel),
        .alu_c      (alu_c),
        .rf_rD2     (rf_rD2),
        .dram_addr  (dram_addr),
        .dram_wdata (dram_wdata)
    );

    assign Bus_addr = dram_addr;
    assign Bus_we   = we;
    assign Bus_wdata = dram_wdata;

`ifdef RUN_TRACE
    // Debug Interface
    reg have_inst;
    always @(cpu_rst) begin
        have_inst <= 1'b1;
    end

    // the pc that is currently executing
    reg [31:0] current_pc;
    reg [4:0] current_wb_reg;
    reg [31:0] current_wb_value;
    reg         current_wb_ena;
    always @(posedge cpu_clk or posedge cpu_rst) begin
        if (cpu_rst) begin
            current_pc <= 0;
        end else if (cpu_clk) begin
            current_pc <= pc;
            current_wb_reg <= wb_reg;
            current_wb_value <= wb_value;
            current_wb_ena  <= wb_ena;
        end
    end

    assign debug_wb_have_inst = have_inst;
    assign debug_wb_pc        = current_pc;
    assign debug_wb_ena       = current_wb_ena;
    assign debug_wb_reg       = current_wb_reg;
    assign debug_wb_value     = current_wb_value;
`endif

endmodule
