`timescale 1ns / 1ps

// the register file
module RF (
    input   wire          rf_rst,
    input   wire          rf_clk,

    input   wire  [31:0]  inst,

    // possible rR1 & rR2
    input   wire rf_sel,

    input   wire wb_ena,

    // possible wD
    input   wire  [2:0]   wD_sel,
    input   wire  [31:0]  alu_c,
    input   wire  [31:0]  sext2,
    input   wire  [31:0]  pc4,
    input   wire  [31:0]  rdo,

    output  wire  [31:0]  rf_rD1,
    output  wire  [31:0]  rf_rD2

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // the 32 32-bits registers
    reg  [31:0]  register [0:31];

    // extract the inst
    wire [4:0] reg1 = inst[9:5];    // rj
    wire [4:0] reg2 = inst[14:10];  // rk
    wire [4:0] reg3 = inst[4:0];    // rd

    

    // read operation is non-block
    // read out the register1
    assign rf_rD1 = register[reg1];

    // read out the register2
    assign rf_rD2 = (rf_sel == `RD_RK) ? register[reg2] :
                    (rf_sel == `RD_RD) ? register[reg3] :
                    32'b0;

    // write operation is blocked
    // write the dst register
    wire [4:0] wb_reg = (wD_sel != `WD_PC4_R1) ? reg3 :
                    5'b00001;

    wire [31:0] wb_value = 
                        (wD_sel == `WD_ALU) ? alu_c :
                        (wD_sel == `WD_SEXT2) ? sext2 :
                        (wD_sel == `WD_DRAM_8) ? {register[wb_reg][31:8], rdo[7:0]} :
                        (wD_sel == `WD_DRAM_16) ? {register[wb_reg][31:16], rdo[15:0]} :
                        (wD_sel == `WD_DRAM_32) ? rdo :
                        (wD_sel == `WD_INST) ? {inst[24:5], 12'b0} :
                        (wD_sel == `WD_PC4_RD) ? pc4 :
                        (wD_sel == `WD_PC4_R1) ? pc4 :
                        32'b0; 


    always @(posedge rf_rst or posedge rf_clk) begin
        if (rf_rst) begin
            // TODO: do nothing?
            register[0] <= 32'b0;
        end else begin
            if (wb_ena && wb_reg != 0) begin
                // dont modify r0
                register[wb_reg] <= wb_value;
            end
        end
    end

`ifdef RUN_TRACE
    assign debug_wb_reg = wb_reg;
    assign debug_wb_value = wb_value;
`endif

endmodule
