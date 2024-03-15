`timescale 1ns / 1ps

module MUX_2to1 #(parameter N=32)
(
    input wire [N-1:0] D0,
    input wire [N-1:0] D1,
    input wire S0,
    output wire [N-1:0] Y
);

    // N-Bit MUX

    assign Y = (S0)? D1 : D0;

endmodule