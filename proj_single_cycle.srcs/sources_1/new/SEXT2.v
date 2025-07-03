`timescale 1ns / 1ps

// sext2 will only be used in
// sign extend DRAM.rom
module SEXT2 (
    input   wire          sext2_rst,
    input   wire          sext2_clk,

    input   wire          sext2_sel,
    input   wire  [31:0]  rdo,

    output  wire  [31:0]  sext2_ext,
);

always @(posedge sext2_clk or posedge sext2_rst) begin
    if (sext2_rst) begin
        sext2_ext <= 0;
    end else if begin
        // rdo[7:0]
        if (sext2_sel) begin
            sext2_ext <= {24'b0, rdo[7:0]};
        end 

        // rdo[15:0]
        else begin
            sext2_ext <= {16'b0, rdo[15:0]};
        end
end

endmodule
