`timescale 1ns / 1ps


// PC module
module PC (
    input   wire          pc_rst,
    input   wire          pc_clk,
    input   wire          stop,
    input   wire  [31:0]  din,
    output  reg   [31:0]  pc
);

always @(posedge pc_clk or posedge pc_rst) begin
    if (pc_rst) begin
        pc <= 32'b0;
    end 
    
    else if (stop) begin
        pc <= pc;
    end
    
    else if (pc_clk) begin
        pc <= din;
    end
end


endmodule
