`timescale 1ns / 1ps

module miniLA_sim();

    reg fpga_rstn;
    reg fpga_clk;
    reg [15:0] switch;
    reg [ 4:0] button;
    
    wire [ 7:0]  dig_en;
    wire         DN_A;
    wire         DN_B;
    wire         DN_C;
    wire         DN_D;
    wire         DN_E;
    wire         DN_F;
    wire         DN_G;
    wire         DN_DP;
    wire [15:0]  led;

    initial begin
        fpga_rstn = 0;
        fpga_clk  = 0;
        #23
        fpga_rstn = 1;
        switch    = 16'h00_00;
        button    = 5'h0;
        
        #8000
        switch = 1;
        
        #8000
        switch = 2;
        
        #16000
        switch = 3;
        
        wait(led[0] == 1'b1);
        switch = 0;
    end

    always #5 fpga_clk = !fpga_clk;

    miniLA_SoC DUT (
        .fpga_rstn  (fpga_rstn),
        .fpga_clk   (fpga_clk),
        .sw         (switch),
        .button     (button),
        .dig_en     (dig_en),
        .DN_A0      (DN_A),
        .DN_B0      (DN_B),
        .DN_C0      (DN_C),
        .DN_D0      (DN_D),
        .DN_E0      (DN_E),
        .DN_F0      (DN_F),
        .DN_G0      (DN_G),
        .DN_DP0     (DN_DP),
        .led        (led)
    );
    

endmodule