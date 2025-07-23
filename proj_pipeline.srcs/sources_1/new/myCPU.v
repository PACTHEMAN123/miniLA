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

    //////////////////////////// WIRES ///////////////////
    /// IF
    wire [1:0]  npc_op;
    wire [31:0]     pc;
    

    /// IF.ID
    wire [31:0] IFID_inst_in = inst;
    wire [31:0] IFID_inst_out;
    wire [31:0] IFID_pc4_in;
    wire [31:0] IFID_pc4_out;
    wire [31:0] IFID_pc_in = pc;
    wire [31:0] IFID_pc_out;

    /// ID
    wire    rf_sel;
    wire [2:0] sext1_op;
    wire [2:0]  wD_sel;
    wire [31:0] zext_ext;
    wire [31:0] rf_rD1;
    wire [31:0] rf_rD2;
    wire [4:0]  wb_reg =    (IDEX_wb_ena_in == 0) ? 5'b0 : 
                            (wD_sel == `WD_PC4_R1) ? 5'b00001 :
                            IFID_inst_out[4:0];
    wire [31:0] wb_reg_value;
    wire    read1;
    wire    read2;

    /// ID.EX
    wire        IDEX_sext2_sel_in;
    wire        IDEX_sext2_sel_out;
    wire [1:0]  IDEX_npc_op_in = npc_op;
    wire [1:0]  IDEX_npc_op_out;
    wire [2:0]  IDEX_wD_sel_in = wD_sel;
    wire [2:0]  IDEX_wD_sel_out;
    wire        IDEX_wb_ena_in;
    wire        IDEX_wb_ena_out;
    wire [1:0]  IDEX_dram_sel_in;
    wire [1:0]  IDEX_dram_sel_out;
    wire [2:0]  IDEX_alu_sel_in;
    wire [2:0]  IDEX_alu_sel_out;
    wire [3:0]  IDEX_alu_op_in;
    wire [3:0]  IDEX_alu_op_out;
    wire [1:0]  IDEX_addr_mode_in;
    wire [1:0]  IDEX_addr_mode_out;
    wire        IDEX_have_inst_in;
    wire        IDEX_have_inst_out;
    wire [4:0]  IDEX_wb_reg_in = wb_reg;
    wire [4:0]  IDEX_wb_reg_out;
    wire [31:0] IDEX_wb_reg_value_in = wb_reg_value;
    wire [31:0] IDEX_wb_reg_value_out;

    wire [31:0] IDEX_inst_in = IFID_inst_out;
    wire [31:0] IDEX_inst_out;
    wire [31:0] IDEX_sext1_in;
    wire [31:0] IDEX_sext1_out;
    wire [31:0] IDEX_rD1_in = (!forward_op1) ? rf_rD1 : forward_rD1;
    wire [31:0] IDEX_rD1_out;
    wire [31:0] IDEX_rD2_in = (!forward_op2) ? rf_rD2: forward_rD2;
    wire [31:0] IDEX_rD2_out;
    wire [31:0] IDEX_zext_in;
    wire [31:0] IDEX_zext_out;
    wire [31:0] IDEX_pc_in = IFID_pc_out;
    wire [31:0] IDEX_pc_out;
    wire [31:0] IDEX_pc4_in = IFID_pc4_out;
    wire [31:0] IDEX_pc4_out;

    /// EX
    wire [31:0]     alu_c;
    wire            alu_f;

    /// EX.MEM
    wire        EXMEM_sext2_sel_in = IDEX_sext2_sel_out;
    wire        EXMEM_sext2_sel_out;
    wire        EXMEM_wb_ena_in = IDEX_wb_ena_out;
    wire        EXMEM_wb_ena_out;
    wire [2:0]  EXMEM_wD_sel_in = IDEX_wD_sel_out;
    wire [2:0]  EXMEM_wD_sel_out;
    wire [1:0]  EXMEM_dram_sel_in = IDEX_dram_sel_out;
    wire [1:0]  EXMEM_dram_sel_out;
    wire [1:0]  EXMEM_addr_mode_in = IDEX_addr_mode_out;
    wire [1:0]  EXMEM_addr_mode_out;
    wire [1:0]  EXMEM_npc_op_in = IDEX_npc_op_out;
    wire [1:0]  EXMEM_npc_op_out;
    wire        EXMEM_have_inst_in = IDEX_have_inst_out;
    wire        EXMEM_have_inst_out;
    wire [4:0]  EXMEM_wb_reg_in = IDEX_wb_reg_out;
    wire [4:0]  EXMEM_wb_reg_out;
    wire [31:0] EXMEM_wb_reg_value_in = IDEX_wb_reg_value_out;
    wire [31:0] EXMEM_wb_reg_value_out;
    wire [31:0] EXMEM_wb_value_in = EX_wb_value;
    wire [31:0] EXMEM_wb_value_out;

    wire [31:0] EXMEM_pc4_in = IDEX_pc4_out;
    wire [31:0] EXMEM_pc4_out;
    wire [31:0] EXMEM_alu_c_in = alu_c;
    wire [31:0] EXMEM_alu_c_out;
    wire        EXMEM_alu_f_in = alu_f;
    wire        EXMEM_alu_f_out;
    wire [31:0] EXMEM_rD2_in = IDEX_rD2_out;
    wire [31:0] EXMEM_rD2_out;
    wire [31:0] EXMEM_sext1_in = IDEX_sext1_in;
    wire [31:0] EXMEM_sext1_out;
    wire [31:0] EXMEM_pc_in = IDEX_pc_out;
    wire [31:0] EXMEM_pc_out;
    wire [31:0] EXMEM_inst_in = IDEX_inst_out;
    wire [31:0] EXMEM_inst_out;

    /// MEM
    wire [31:0] sext2_ext;

    /// MEM.WB
    wire [2:0] MEMWB_wD_sel_in = EXMEM_wD_sel_out;
    wire [2:0] MEMWB_wD_sel_out;
    wire MEMWB_wb_ena_in = EXMEM_wb_ena_out;
    wire MEMWB_wb_ena_out;
    wire [1:0] MEMWB_npc_op_in = EXMEM_npc_op_out;
    wire [1:0] MEMWB_npc_op_out;
    wire MEMWB_have_inst_in = EXMEM_have_inst_out;
    wire MEMWB_have_inst_out;
    wire [4:0] MEMWB_wb_reg_in = EXMEM_wb_reg_out;
    wire [4:0] MEMWB_wb_reg_out;
    wire [31:0] MEMWB_wb_value_in = MEM_wb_value;
    wire [31:0] MEMWB_wb_value_out;

    wire [31:0] MEMWB_alu_c_in = EXMEM_alu_c_out;
    wire [31:0] MEMWB_alu_c_out;
    wire        MEMWB_alu_f_in = EXMEM_alu_f_out;
    wire        MEMWB_alu_f_out;
    wire [31:0] MEMWB_sext2_in = sext2_ext;
    wire [31:0] MEMWB_sext2_out;
    wire [31:0] MEMWB_pc4_in = EXMEM_pc4_out;
    wire [31:0] MEMWB_pc4_out;
    wire [31:0] MEMWB_rdo_in = dram_rdata;
    wire [31:0] MEMWB_rdo_out;
    wire [31:0] MEMWB_sext1_in = EXMEM_sext1_out;
    wire [31:0] MEMWB_sext1_out;
    wire [31:0] MEMWB_pc_in = EXMEM_pc_out;
    wire [31:0] MEMWB_pc_out;
    wire [31:0] MEMWB_inst_in = EXMEM_inst_out;
    wire [31:0] MEMWB_inst_out;

    /// MEM
    wire            dram_we;
    wire [31:0]     dram_addr;
    wire [31:0]     dram_rdata;
    wire [31:0]     dram_wdata;

    /// hazard control
    wire            jump =  (IDEX_npc_op_out == `NPC_PC_4) ? 1'b0 :
                            (IDEX_npc_op_out == `NPC_PC_OFF) ? 1'b1 :
                            (IDEX_npc_op_out == `NPC_PC_OFF_BR) ? alu_f :
                            (IDEX_npc_op_out == `NPC_OFF) ? 1'b1 :
                            1'b0;
    wire            control_hazard = jump;
    wire            IDEX_flush_ctrl = control_hazard;
    wire            IFID_flush = control_hazard;
    wire            forward_op1;
    wire            forward_op2;
    wire [31:0]     forward_rD1;
    wire [31:0]     forward_rD2;
    wire            PC_stop;
    wire            IFID_stop;
    wire            IDEX_flush_data;
    wire            IDEX_flush = IDEX_flush_data | IDEX_flush_ctrl;
   

`ifdef RUN_TRACE
    // wire [4:0]      wb_reg;
    wire [31:0]     wb_value_debug;
`endif

//////////////////////////////////////////////////////////////

/////////////////////// IF ///////////////////////////
    wire [31:0]     npc;
    PC myPC (
        .pc_rst     (cpu_rst),
        .pc_clk     (cpu_clk),
        .stop       (PC_stop),
        .din        (npc),
        .pc         (pc)
    );

    assign inst_addr = pc[31:2];
    


    NPC myNPC (
        .br         (alu_f),
        .pc         (pc),
        .EX_pc      (IDEX_pc_out),
        .alu_c      (alu_c),
        .sext       (IDEX_sext1_out),
        .npc_op     (IDEX_npc_op_out),
        .npc        (npc),
        .pc4        (IFID_pc4_in)
    );

    

    IFID myIFID (
        .rst        (cpu_rst),
        .clk        (cpu_clk),
        .inst_in    (IFID_inst_in),
        .inst_out   (IFID_inst_out),
        .pc_in      (IFID_pc_in),
        .pc_out     (IFID_pc_out),
        .pc4_in     (IFID_pc4_in),
        .pc4_out    (IFID_pc4_out),
        .stop       (IFID_stop),
        .flush      (IFID_flush)
    );
    
////////////////////// ID /////////////////////////////
    RF myRF (
        .rf_rst     (cpu_rst),
        .rf_clk     (cpu_clk),
        .inst1      (IFID_inst_out),
        .inst2      (MEMWB_inst_out),
        .rf_sel     (rf_sel),
        .wD_sel     (MEMWB_wD_sel_out),
        .wb_reg     (MEMWB_wb_reg_out),
        .alu_c      (MEMWB_alu_c_out),
        .sext2      (MEMWB_sext2_out),
        .pc4        (MEMWB_pc4_out),
        .rdo        (MEMWB_rdo_out),
        .rf_rD1     (rf_rD1),
        .rf_rD2     (rf_rD2),
        .wb_ena     (MEMWB_wb_ena_out),
        .ID_wb_reg  (wb_reg),
        .ID_wb_reg_value (wb_reg_value)
    `ifdef RUN_TRACE
        ,
        // .debug_wb_reg (wb_reg),
        .debug_wb_value (wb_value_debug)
    `endif
    );
    
    
    Controller myController (
        .inst       (IFID_inst_out),
        .alu_op     (IDEX_alu_op_in),
        .alu_sel    (IDEX_alu_sel_in),
        .npc_op     (npc_op),
        .rf_sel     (rf_sel),
        .wD_sel     (wD_sel),
        .sext1_op   (sext1_op),
        .sext2_sel  (IDEX_sext2_sel_in),
        .dram_sel   (IDEX_dram_sel_in),
        .addr_mode  (IDEX_addr_mode_in),
        .wb_ena     (IDEX_wb_ena_in),
        .have_inst  (IDEX_have_inst_in),
        .read1      (read1),
        .read2      (read2)
    );

    
    SEXT1 mySEXT1 (
        .sext1_op   (sext1_op),
        .inst       (IFID_inst_out),
        .sext1_ext  (IDEX_sext1_in)
    );

    
    ZEXT myZEXT (
        .inst       (IFID_inst_out),
        .zext_ext   (IDEX_zext_in)
    );

    

    IDEX myIDEX (
        .rst        (cpu_rst),
        .clk        (cpu_clk),
        .flush      (IDEX_flush),
        .sext2_sel_in(IDEX_sext2_sel_in),
        .sext2_sel_out(IDEX_sext2_sel_out),
        .wD_sel_in  (IDEX_wD_sel_in),
        .wD_sel_out (IDEX_wD_sel_out),
        .wb_ena_in  (IDEX_wb_ena_in),
        .wb_ena_out (IDEX_wb_ena_out),
        .dram_sel_in(IDEX_dram_sel_in),
        .dram_sel_out(IDEX_dram_sel_out),
        .alu_sel_in (IDEX_alu_sel_in),
        .alu_sel_out(IDEX_alu_sel_out),
        .alu_op_in  (IDEX_alu_op_in),
        .alu_op_out (IDEX_alu_op_out),
        .addr_mode_in(IDEX_addr_mode_in),
        .addr_mode_out(IDEX_addr_mode_out),
        .have_inst_in(IDEX_have_inst_in),
        .have_inst_out(IDEX_have_inst_out),
        .wb_reg_in  (IDEX_wb_reg_in),
        .wb_reg_out (IDEX_wb_reg_out),
        .wb_reg_value_in(IDEX_wb_reg_value_in),
        .wb_reg_value_out(IDEX_wb_reg_value_out),
        .inst_in    (IDEX_inst_in),
        .inst_out   (IDEX_inst_out),
        .sext1_in   (IDEX_sext1_in),
        .sext1_out  (IDEX_sext1_out),
        .rf_rD1_in  (IDEX_rD1_in),
        .rf_rD1_out (IDEX_rD1_out),
        .rf_rD2_in  (IDEX_rD2_in),
        .rf_rD2_out (IDEX_rD2_out),
        .zext_in    (IDEX_zext_in),
        .zext_out   (IDEX_zext_out),
        .pc_in      (IDEX_pc_in),
        .pc_out     (IDEX_pc_out),
        .pc4_in     (IDEX_pc4_in),
        .pc4_out    (IDEX_pc4_out),
        .npc_op_in  (IDEX_npc_op_in),
        .npc_op_out (IDEX_npc_op_out)
    );

////////////////////// EX /////////////////////////////
    ALU myALU (
        .inst       (IDEX_inst_out),
        .alu_op     (IDEX_alu_op_out),
        .pc         (IDEX_pc_out),
        .rf_rD1     (IDEX_rD1_out),
        .rf_rD2     (IDEX_rD2_out),
        .sext1      (IDEX_sext1_out),
        .zext       (IDEX_zext_out),
        .alu_sel    (IDEX_alu_sel_out),
        .alu_c      (alu_c),
        .alu_f      (alu_f)
    );

    // early write back value for data-forward
    wire [31:0]     EX_wb_value =  (IDEX_wD_sel_out == `WD_ALU) ? alu_c :
                                (IDEX_wD_sel_out == `WD_INST) ? {IDEX_inst_out[24:5], 12'b0} :
                                (IDEX_wD_sel_out == `WD_PC4_RD) ? IDEX_pc4_out :
                                (IDEX_wD_sel_out == `WD_PC4_R1) ? IDEX_pc4_out :
                                32'b0; 

    EXMEM myEXMEM (
        .rst        (cpu_rst),
        .clk        (cpu_clk),
        .sext2_sel_in(EXMEM_sext2_sel_in),
        .sext2_sel_out(EXMEM_sext2_sel_out),
        .wb_ena_in  (EXMEM_wb_ena_in),
        .wb_ena_out (EXMEM_wb_ena_out),
        .wD_sel_in  (EXMEM_wD_sel_in),
        .wD_sel_out (EXMEM_wD_sel_out),
        .dram_sel_in (EXMEM_dram_sel_in),
        .dram_sel_out(EXMEM_dram_sel_out),
        .alu_c_in   (EXMEM_alu_c_in),
        .alu_c_out  (EXMEM_alu_c_out),    
        .addr_mode_in(EXMEM_addr_mode_in),
        .addr_mode_out(EXMEM_addr_mode_out),
        .wb_reg_in  (EXMEM_wb_reg_in),
        .wb_reg_out (EXMEM_wb_reg_out),
        .wb_reg_value_in(EXMEM_wb_reg_value_in),
        .wb_reg_value_out(EXMEM_wb_reg_value_out),
        .wb_value_in(EXMEM_wb_value_in),
        .wb_value_out(EXMEM_wb_value_out),
        .have_inst_in(EXMEM_have_inst_in),
        .have_inst_out(EXMEM_have_inst_out),
        .rf_rD2_in  (EXMEM_rD2_in),
        .rf_rD2_out (EXMEM_rD2_out),
        .sext1_in   (EXMEM_sext1_in),
        .sext1_out  (EXMEM_sext1_out),
        .npc_op_in  (EXMEM_npc_op_in),
        .npc_op_out (EXMEM_npc_op_out),
        .pc_in      (EXMEM_pc_in),
        .pc_out     (EXMEM_pc_out),
        .pc4_in     (EXMEM_pc4_in),
        .pc4_out    (EXMEM_pc4_out),
        .inst_in    (EXMEM_inst_in),
        .inst_out   (EXMEM_inst_out)
    );

////////////////////// MEM ////////////////////////////
    DramSel myDramSel (
        .dram_sel   (EXMEM_dram_sel_out),
        .alu_c      (EXMEM_alu_c_out),
        .addr_mode  (EXMEM_addr_mode_out),
        .dram_addr  (dram_addr),
        .dram_rdata_raw (Bus_rdata),
        .dram_rdata (dram_rdata),
        .rf_rD2     (EXMEM_rD2_out),
        .dram_wdata (dram_wdata),
        .dram_we    (dram_we)
    );

    assign Bus_addr = dram_addr;
    assign Bus_we   = dram_we;
    assign Bus_wdata = dram_wdata;

    SEXT2 mySEXT2 (
        .sext2_sel  (EXMEM_sext2_sel_out),
        .dram_rdata (dram_rdata),
        .sext2_ext  (sext2_ext)
    );

    wire [31:0] MEM_wb_value =  (EXMEM_wD_sel_out == `WD_ALU) ? EXMEM_alu_c_out :
                                (EXMEM_wD_sel_out == `WD_SEXT2) ? sext2_ext :
                                (EXMEM_wD_sel_out == `WD_DRAM_8) ? {EXMEM_wb_reg_value_out[31:8], dram_rdata[7:0]} :
                                (EXMEM_wD_sel_out == `WD_DRAM_16) ? {EXMEM_wb_reg_value_out[31:16], dram_rdata[15:0]} :
                                (EXMEM_wD_sel_out == `WD_DRAM_32) ? dram_rdata :
                                (EXMEM_wD_sel_out == `WD_INST) ? {EXMEM_inst_out[24:5], 12'b0} :
                                (EXMEM_wD_sel_out == `WD_PC4_RD) ? EXMEM_pc4_out :
                                (EXMEM_wD_sel_out == `WD_PC4_R1) ? EXMEM_pc4_out :
                                32'b0; 

    MEMWB myMEMWB (
        .rst        (cpu_rst),
        .clk        (cpu_clk),
        .wD_sel_in  (MEMWB_wD_sel_in),
        .wD_sel_out (MEMWB_wD_sel_out),
        .wb_ena_in  (MEMWB_wb_ena_in),
        .wb_ena_out (MEMWB_wb_ena_out),
        .have_inst_in(MEMWB_have_inst_in),
        .have_inst_out(MEMWB_have_inst_out),
        .wb_reg_in  (MEMWB_wb_reg_in),
        .wb_reg_out (MEMWB_wb_reg_out),
        .wb_value_in(MEMWB_wb_value_in),
        .wb_value_out(MEMWB_wb_value_out),
        .alu_c_in   (MEMWB_alu_c_in),
        .alu_c_out  (MEMWB_alu_c_out),
        .sext2_in   (MEMWB_sext2_in),
        .sext2_out  (MEMWB_sext2_out),
        .pc4_in     (MEMWB_pc4_in),
        .pc4_out    (MEMWB_pc4_out),
        .rdo_in     (MEMWB_rdo_in),
        .rdo_out    (MEMWB_rdo_out),
        .sext1_in   (MEMWB_sext1_in),
        .sext1_out  (MEMWB_sext1_out),
        .npc_op_in  (MEMWB_npc_op_in),
        .npc_op_out (MEMWB_npc_op_out),
        .pc_in      (MEMWB_pc_in),
        .pc_out     (MEMWB_pc_out),
        .inst_in    (MEMWB_inst_in),
        .inst_out   (MEMWB_inst_out)
    );

///////////////////// WB //////////////////////////////


///////////////////// HARZARD /////////////////////////
    DataHazard myDataHazard (
        .inst       (IFID_inst_out),
        .rf_sel     (rf_sel),
        .EX_wb_reg  (IDEX_wb_reg_out),
        .EX_wb_ena  (IDEX_wb_ena_out),
        .EX_wb_value(EX_wb_value),
        .EX_wD_sel  (IDEX_wD_sel_out),
        .MEM_wb_reg (EXMEM_wb_reg_out),
        .MEM_wb_ena (EXMEM_wb_ena_out),
        .MEM_wb_value(MEM_wb_value),
        .WB_wb_reg  (MEMWB_wb_reg_out),
        .WB_wb_ena  (MEMWB_wb_ena_out),
        .WB_wb_value(MEMWB_wb_value_out),
        .read1      (read1),
        .read2      (read2),
        .forward_op1(forward_op1),
        .forward_op2(forward_op2),
        .forward_rD1(forward_rD1),
        .forward_rD2(forward_rD2),
        .PC_stop    (PC_stop),
        .IFID_stop  (IFID_stop),
        .IDEX_flush (IDEX_flush_data)
    );



`ifdef RUN_TRACE
    // Debug Interface
    // reg have_inst;
    // always @(cpu_rst) begin
    //     have_inst <= 1'b1;
    // end

    // the pc that is currently executing
    // reg [31:0] current_pc;
    // reg [4:0] current_wb_reg;
    // reg [31:0] current_wb_value;
    // reg         current_wb_ena;
    // always @(posedge cpu_clk or posedge cpu_rst) begin
    //     if (cpu_rst) begin
    //         current_pc <= 0;
    //     end else if (cpu_clk) begin
    //         current_pc <= MEMWB_pc_out;
    //         current_wb_reg <= wb_reg;
    //         current_wb_value <= wb_value;
    //         current_wb_ena  <= MEMWB_wb_ena_out;
    //     end
    // end

    assign debug_wb_have_inst = MEMWB_have_inst_out;
    assign debug_wb_pc        = MEMWB_pc_out;
    assign debug_wb_ena       = MEMWB_wb_ena_out;
    assign debug_wb_reg       = MEMWB_wb_reg_out;
    assign debug_wb_value     = wb_value_debug;
`endif

endmodule
