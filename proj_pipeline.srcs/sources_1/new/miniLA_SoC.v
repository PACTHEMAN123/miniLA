`timescale 1ns / 1ps

`include "defines.vh"

module miniLA_SoC (
    input  wire         fpga_rstn,   // Low active
    input  wire         fpga_clk,

    input  wire [15:0]  sw,
    input  wire [ 4:0]  button,
    output wire [ 7:0]  dig_en,
    output wire         DN_A0, DN_A1,
    output wire         DN_B0, DN_B1,
    output wire         DN_C0, DN_C1,
    output wire         DN_D0, DN_D1,
    output wire         DN_E0, DN_E1,
    output wire         DN_F0, DN_F1,
    output wire         DN_G0, DN_G1,
    output wire         DN_DP0, DN_DP1,
    output wire [15:0]  led

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst, // 当前时钟周期是否有指令写回 (对单周期CPU，可在复位后恒置1)
    output wire [31:0]  debug_wb_pc,        // 当前写回的指令的PC (若wb_have_inst=0，此项可为任意值)
    output              debug_wb_ena,       // 指令写回时，寄存器堆的写使能 (若wb_have_inst=0，此项可为任意值)
    output wire [ 4:0]  debug_wb_reg,       // 指令写回时，写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output wire [31:0]  debug_wb_value      // 指令写回时，写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
`endif
);

    wire        pll_lock;
    wire        pll_clk;
    wire        cpu_clk;

    // Interface between CPU and IROM
`ifdef RUN_TRACE
    wire [15:0] inst_addr;
`else
    wire [13:0] inst_addr;
`endif
    wire [31:0] inst;

    // Interface between CPU and Bridge
    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_we;
    wire [31:0] Bus_wdata;
    
    // Interface between bridge and DRAM
    // wire         rst_bridge2dram;
    wire         clk_bridge2dram;
    wire [31:0]  addr_bridge2dram;
    wire [31:0]  rdata_dram2bridge;
    wire         we_bridge2dram;
    wire [31:0]  wdata_bridge2dram;
    
    // Interface between bridge and peripherals
    // TODO: 在此定义总线桥与外设I/O接口电路模块的连接信号
    // Interface between bridge and LEDS
    wire         rst_bridge2led;
    wire         clk_bridge2led;
    wire [31:0]  addr_bridge2led;
    wire         we_bridge2led;
    wire [31:0]  wdata_bridge2led;

    // Interface between bridge and digit LEDS
    wire         rst_bridge2dig;
    wire         clk_bridge2dig;
    wire [31:0]  addr_bridge2dig;
    wire         we_bridge2dig;
    wire [31:0]  wdata_bridge2dig;
    wire [7:0]   dig_dn;

    assign DN_A1 = DN_A0;
    assign DN_B1 = DN_B0;
    assign DN_C1 = DN_C0;
    assign DN_D1 = DN_D0;
    assign DN_E1 = DN_E0;
    assign DN_F1 = DN_F0;
    assign DN_G1 = DN_G0;
    assign DN_DP1 = DN_DP0;

    assign DN_A0 = dig_dn[0];
    assign DN_B0 = dig_dn[1];
    assign DN_C0 = dig_dn[2];
    assign DN_D0 = dig_dn[3];
    assign DN_E0 = dig_dn[4];
    assign DN_F0 = dig_dn[5];
    assign DN_G0 = dig_dn[6];
    assign DN_DP0 = dig_dn[7];

    // Interface between bridge and swtiches
    wire         rst_bridge2switch;
    wire         clk_bridge2switch;
    wire [31:0]  addr_bridge2switch;
    wire [31:0]  rdata_switch2bridge;

    // Interface between bridge and buttoms
    wire         rst_bridge2buttoms;
    wire         clk_bridge2buttoms;
    wire [31:0]  addr_bridge2buttoms;
    wire         we_bridge2buttoms;
    wire [31:0]  rdata_buttoms2bridge;

    // Interface between bridge and timers
    wire         rst_bridge2timer;
    wire         clk_bridge2timer;
    wire [31:0]  addr_bridge2timer;
    wire         we_bridge2timer;
    wire [31:0]  wdata_bridge2timer;
    wire [31:0]  rdata_timer2bridge;

    
    

    
`ifdef RUN_TRACE
    // Trace调试时，直接使用外部输入时钟
    assign cpu_clk = fpga_clk;
`else
    // 下板时，使用PLL分频后的时钟
    assign cpu_clk = pll_clk & pll_lock;
    cpuclk Clkgen (
        // .resetn     (fpga_rstn),
        .clk_in1    (fpga_clk),
        .clk_out1   (pll_clk),
        .locked     (pll_lock)
    );
`endif
    
    myCPU Core_cpu (
        .cpu_rst            (!fpga_rstn),
        .cpu_clk            (cpu_clk),

        // Interface to IROM
        .inst_addr          (inst_addr),
        .inst               (inst),

        // Interface to Bridge
        .Bus_addr           (Bus_addr),
        .Bus_rdata          (Bus_rdata),
        .Bus_we             (Bus_we),
        .Bus_wdata          (Bus_wdata)

`ifdef RUN_TRACE
        ,// Debug Interface
        .debug_wb_have_inst (debug_wb_have_inst),
        .debug_wb_pc        (debug_wb_pc),
        .debug_wb_ena       (debug_wb_ena),
        .debug_wb_reg       (debug_wb_reg),
        .debug_wb_value     (debug_wb_value)
`endif
    );
    
    IROM Mem_IROM (
        .a          (inst_addr),
        .spo        (inst)
    );
    
    Bridge Bridge (       
        // Interface to CPU
        .rst_from_cpu       (!fpga_rstn),
        .clk_from_cpu       (cpu_clk),
        .addr_from_cpu      (Bus_addr),
        .we_from_cpu        (Bus_we),
        .wdata_from_cpu     (Bus_wdata),
        .rdata_to_cpu       (Bus_rdata),
        
        // Interface to DRAM
        // .rst_to_dram    (rst_bridge2dram),
        .clk_to_dram        (clk_bridge2dram),
        .addr_to_dram       (addr_bridge2dram),
        .rdata_from_dram    (rdata_dram2bridge),
        .we_to_dram         (we_bridge2dram),
        .wdata_to_dram      (wdata_bridge2dram),
        
        // Interface to 7-seg digital LEDs
        .rst_to_dig         (rst_bridge2dig),
        .clk_to_dig         (clk_bridge2dig),
        .addr_to_dig        (addr_bridge2dig),
        .we_to_dig          (we_bridge2dig),
        .wdata_to_dig       (wdata_bridge2dig),

        // Interface to LEDs
        .rst_to_led         (rst_bridge2led),
        .clk_to_led         (clk_bridge2led),
        .addr_to_led        (addr_bridge2led),
        .we_to_led          (we_bridge2led),
        .wdata_to_led       (wdata_bridge2led),

        // Interface to switches
        .rst_to_sw          (rst_bridge2switch),
        .clk_to_sw          (clk_bridge2switch),
        .addr_to_sw         (addr_bridge2switch),
        .rdata_from_sw      (rdata_switch2bridge),

        // Interface to buttons
        .rst_to_btn         (rst_bridge2buttoms),
        .clk_to_btn         (clk_bridge2buttoms),
        .addr_to_btn        (addr_bridge2buttoms),
        .rdata_from_btn     (rdata_buttoms2bridge),

        // Interface to timer
        .rst_to_timer       (rst_bridge2timer),
        .clk_to_timer       (clk_bridge2timer),
        .addr_to_timer      (addr_bridge2timer),
        .we_to_timer        (we_bridge2timer),
        .wdata_to_timer     (wdata_bridge2timer),
        .rdata_from_timer   (rdata_timer2bridge)
    );

    DRAM Mem_DRAM (
        .clk                (clk_bridge2dram),
        .a                  (addr_bridge2dram[15:2]),
        .spo                (rdata_dram2bridge),
        .we                 (we_bridge2dram),
        .d                  (wdata_bridge2dram)
    );
    
    // TODO: 在此实例化你的外设I/O接口电路模块
    //
    DigLEDs #(.FREQ(50000)) DigLEDs(
        .dig_clk            (clk_bridge2dig),
        .dig_rst            (rst_bridge2dig),
        .dig_addr           (addr_bridge2dig),
        .dig_we             (we_bridge2dig),
        .dig_wdata          (wdata_bridge2dig),
        .dig_en             (dig_en),
        .dig_dn             (dig_dn)
    );

    LEDs LEDs (
        .led_clk            (clk_bridge2led),
        .led_rst            (rst_bridge2led),
        .led_addr           (addr_bridge2led),
        .led_we             (we_bridge2led),
        .led_raw_wdata      (wdata_bridge2led),
        .led_wdata          (led)
    );

    Switch Switch (
        .switch_clk         (clk_bridge2switch),
        .switch_rst         (rst_bridge2switch),
        .switch_addr        (addr_bridge2switch),
        .sw                 (sw),
        .rdata_sw2bridge    (rdata_switch2bridge)
    );

    Timer Timer (
        .timer_clk          (clk_bridge2timer),
        .timer_rst          (rst_bridge2timer),
        .timer_addr         (addr_bridge2timer),
        .timer_we           (we_bridge2timer),
        .timer_raw_wdata    (wdata_bridge2timer),
        .timer_wdata        (rdata_timer2bridge)
    );
endmodule
