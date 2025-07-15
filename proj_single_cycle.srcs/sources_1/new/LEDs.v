`timescale 1ns / 1ps

module LEDs(
    input wire led_clk,
    input wire led_rst,
    input wire [31:0] led_addr,
    input wire led_we,
    // from cpu
    input wire [31:0] led_raw_wdata,
    // to leds
    output wire [15:0] led_wdata
);

    reg[15:0] leds;

    assign led_wdata = leds;

    always @(posedge led_clk or posedge led_rst) begin
        if (led_rst) begin
            leds <= 16'b0;
        end else begin
            if (led_we) begin
                leds <= led_raw_wdata[15:0];
            end
        end
    end


endmodule