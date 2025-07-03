`timescale 1ns / 1ps

// SEXT1 module
module SEXT1 (
    input   wire          sext1_rst,
    input   wire          sext1_clk,

    input   wire  [2:0]   sext1_op,
    input   wire  [31:0]  inst,

    output  wire  [31:0]  sext1_ext,
);


always @(posedge sext1_rst or posedge sext1_clk) begin
    if (sext1_rst) begin
        sext1_ext <= 0;
    end else begin
        // inst[21:10]
        if (sext1_op == 1) begin
            sext1_ext <= {20{inst[21]}, inst[21:10]};
        end

        // inst[25:10] {2'b0}
        else if (sext1_op == 2) begin
            sext1_ext <= {14{inst[25]}, inst[25:10], 2'b0};
        end

        // inst[9:0] | inst[25:10] | {2'b0}
        else if (sext1_op == 3) begin
            sext1_ext <= {4{inst[9]}, inst[9:0], inst[25:10], 2'b0};
        end

        // default set to zero
        else begin
            sext1_ext <= 0;
        end
    end

end

endmodule
