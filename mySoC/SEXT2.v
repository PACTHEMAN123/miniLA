`timescale 1ns / 1ps

`include "defines.vh"

// sext2 will only be used in
// sign extend DRAM.rom
module SEXT2 (
    input   wire          sext2_sel,
    input   wire  [31:0]  rdo,

    output  wire  [31:0]  sext2_ext
);

    assign sext2_ext =  (sext2_sel == `SEXT2_8) ? {{24{rdo[7]}}, rdo[7:0]} :
                        (sext2_sel == `SEXT2_16) ? {{16{rdo[15]}}, rdo[15:0]} :
                        {32'b0}; /* should not reach here */

endmodule
