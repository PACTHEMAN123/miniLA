`timescale 1ns / 1ps

module DigLEDs #(
    parameter FREQ = 100
)(
    input wire dig_rst,
    input wire dig_clk,
    input wire [31:0] dig_addr,
    input wire dig_we,
    input wire [31:0] dig_wdata,
    output reg [7:0] dig_en,
    output reg [7:0] dig_dn
);
    reg [15:0] cnt;
    reg [31:0] data;
    reg [2:0] idx;

    always @(*) begin
        dig_en <= 8'b1 << idx;
        case (data[(idx * 4) +: 4])
            4'h0: dig_dn <= 8'b0011_1111;
            4'h1: dig_dn <= 8'b0000_0110;
            4'h2: dig_dn <= 8'b0101_1011;
            4'h3: dig_dn <= 8'b0100_1111;
            4'h4: dig_dn <= 8'b0110_0110;
            4'h5: dig_dn <= 8'b0110_1101;
            4'h6: dig_dn <= 8'b0111_1101;
            4'h7: dig_dn <= 8'b0000_0111;
            4'h8: dig_dn <= 8'b0111_1111;
            4'h9: dig_dn <= 8'b0110_1111;
            4'hA: dig_dn <= 8'b0111_0111;
            4'hB: dig_dn <= 8'b0111_1100;
            4'hC: dig_dn <= 8'b0011_1001;
            4'hD: dig_dn <= 8'b0101_1110;
            4'hE: dig_dn <= 8'b0111_1001;
            4'hF: dig_dn <= 8'b0111_0001;
            default: dig_dn <= 8'b0000_0000;
        endcase
    end

    always @(posedge dig_clk or posedge dig_rst) begin
        if (dig_rst) begin
            cnt <= FREQ;
            idx <= 3'b0;
            data <= 31'b0;
        end else begin
            if (dig_we) begin
                data <= dig_wdata;
            end
            if (cnt == 16'b0) begin
                cnt <= FREQ;
                idx <= idx + 1;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end

endmodule