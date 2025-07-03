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
    assign reg1 = inst[9:5];
    assign reg2 = inst[14:10];
    assign reg3 = inst[4:0];
    
    // read out the register1
    always @(posedge rf_rst or posedge rf_clk) begin
        if (rf_rst) begin
            rf_rD1 <= 0;
        end else begin
            rf_rD1 <= register[reg1];
        end
    end

    // read out the register2
    always @(posedge rf_rst or posedge rf_clk) begin
        if (rf_rst) begin
            rf_rD2 <= 0;
        end else begin
            if (rf_sel) begin
                rf_rD2 <= register[reg2];
            end else begin
                rf_rD2 <= register[reg3];
        end
    end

    // write the dst register
    always @(posedge rf_rst or posedge rf_clk) begin
        if (rf_rst) begin
            // TODO: do nothing?
        end else begin
            // ALU.C
            if (wD_sel == 1) begin
                register[reg3] <= alu_c;
            end

            // sext2
            if (wD_sel == 2) begin
                register[reg3] <= sext2;
            end

            // rdo[7:0]
            if (wD_sel == 3) begin
                register[reg3][7:0] <= rdo[7:0];
            end

            // rdo[15:0]
            if (wD_sel == 4) begin
                register[reg3][15:0] <= rdo[15:0];
            end

            // rdo[31:0]
            if (wD_sel == 5) begin
                register[reg3] <= rdo;
            end

            // pc4
            if (wD_sel == 6) begin
                register[reg3] <= pc4;
            end

            // inst[24:5] | 12'b0
            if (wD_sel == 7) begin
                register[reg3] <= {inst[24:5], 12'b0};
            end
        end
    end

endmodule
