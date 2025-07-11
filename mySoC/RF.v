`timescale 1ns / 1ps

// the register file
module RF (
    input   wire          rf_rst,
    input   wire          rf_clk,

    input   wire  [31:0]  inst,

    // possible rR1 & rR2
    input   wire rf_sel,

    // possible wD
    input   wire  [2:0]   wD_sel,
    input   wire  [31:0]  alu_c,
    input   wire  [31:0]  sext2,
    input   wire  [31:0]  pc4,
    input   wire  [31:0]  rdo,

    output  wire  [31:0]  rf_rD1,
    output  wire  [31:0]  rf_rD2
);

    // the 32 32-bits registers
    reg  [31:0]  register [0:31];

    // extract the inst
    assign reg1 = inst[9:5];    // rj
    assign reg2 = inst[14:10];  // rk
    assign reg3 = inst[4:0];    // rd

    // read operation is non-block
    // read out the register1
    assign rf_rD1 = register[reg1];

    // read out the register2
    assign rf_rD2 = (rf_sel == `RD_RK) ? register[reg2] :
                    (rf_sel == `RD_RD) ? register[reg3] :
                    1'b0;

    // write operation is blocked
    // write the dst register
    always @(posedge rf_rst or posedge rf_clk) begin
        if (rf_rst) begin
            // TODO: do nothing?
        end else begin
            if (wD_sel == `WD_ALU) begin
                register[reg3] <= alu_c;
            end

            else if (wD_sel == `WD_SEXT2) begin
                register[reg3] <= sext2;
            end

            else if (wD_sel == `WD_DRAM_8) begin
                register[reg3][7:0] <= rdo[7:0];
            end

            else if (wD_sel == `WD_DRAM_16) begin
                register[reg3][15:0] <= rdo[15:0];
            end

            else if (wD_sel == `WD_DRAM_32) begin
                register[reg3] <= rdo;
            end

            else if (wD_sel == `WD_INST) begin
                register[reg3] <= {inst[24:5], 12'b0};
            end

            else if (wD_sel == `WD_PC4_RD) begin
                register[reg3] <= pc4;
            end

            else if (wD_sel == `WD_PC4_R1) begin
                register[1] <= pc4;
            end
        end
    end

endmodule
