`timescale 1ns / 1ps

module TOP_tb();

reg clock;
reg reset;
reg reset_IF_memory;
reg [31:0] instruction_in;
reg [9:0] PC_write;

TOP top(
    .clock(clock),
    .reset(reset),
    .PC_write(PC_write),
    .instruction_in(instruction_in)
);

always #5 clock = ~clock;

initial begin
    clock = 0;
    reset = 1; reset_IF_memory = 1;
    #10 reset = 0; reset_IF_memory = 0;
    #10 PC_write = 10'd1; instruction_in = 32'hffffffff;
    #10 PC_write = 10'd2; instruction_in = 32'habcbffff;
    #10 PC_write = 10'd4; instruction_in = 32'h12345678;
    #10 PC_write = 10'd5; instruction_in = 32'h12345677;
    #10 PC_write = 10'd6; instruction_in = 32'h11111111;
    #10 reset = 1;
    #10 reset = 0;
end
endmodule
