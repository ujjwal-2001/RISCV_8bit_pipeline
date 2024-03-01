`timescale 1ns / 1ps

module TOP_tb();

wire clock;
wire reset;

RISC_V RISC_V(
    .clock(clock),
    .reset(reset)
);

always #5 clock = ~clock;

initial begin
    clock = 0;
    reset = 1;
    #10 reset = 0;

endmodule
