`timescale 1ns / 1ps

module Switch(
    input wire switch_clk,
    input wire switch_rst,
    input wire [31:0] switch_addr,
    input wire [15:0] sw,
    output wire [31:0] rdata_sw2bridge
);
    
    assign rdata_sw2bridge = {16'b0, sw};

endmodule