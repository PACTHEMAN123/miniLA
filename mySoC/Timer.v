`timescale 1ns / 1ps

module Timer (
    input wire timer_rst,
    input wire timer_clk,
    input wire [31:0] timer_addr,
    input wire timer_we,
    input wire [31:0] timer_raw_wdata,
    output reg [31:0] timer_wdata
);

    reg [31:0] value;
    reg [31:0] div;
    reg [31:0] cnt;

    always @(*) begin
        case (timer_addr[2:0])
            3'b000: timer_wdata = value;
            default: timer_wdata = 32'hffffffff;
        endcase
    end

    always @(posedge timer_clk or posedge timer_rst) begin
        if (timer_rst) begin
            value <= 32'b0;
            div <= 32'b0;
            cnt <= 32'b0;
        end else begin
            if (timer_we) begin
                case (timer_addr[2:0])
                    3'b000: value <= timer_raw_wdata;
                    3'b100: div <= timer_raw_wdata;
                endcase
            end

            if (cnt < div) begin
                cnt <= cnt + 1;
            end else begin
                value <= value + 1;
                cnt <= 32'b0;
            end
        end
    end


endmodule