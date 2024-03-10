
`timescale 1ns / 1ps

module TOP_tb();

reg clock;
reg reset;
reg rw;
reg reset_IF_memory;
reg [31:0] instruction_in;
reg [9:0] PC_write;
wire [7:0] write_reg_data;

TOP top(
    .clock(clock),
    .reset(reset),
    .reset_IF_memory(reset_IF_memory),
    .instruction_in(instruction_in),
    .PC_write(PC_write),
    .write_reg_data(write_reg_data)
);

always #5 clock = ~clock;

initial begin
    clock = 0;
    reset = 1; reset_IF_memory = 1;
    #10 reset_IF_memory = 0;
    PC_write = 0;
    instruction_in = 32'h00000000;

    // writing instructions to instruction memory
    rw = 0; 
    
    #80 reset = 0; 
    #10 PC_write = 10'd1; instruction_in = 32'b00000000001_00010_011_00001_0000011; // ld r1, 1, r2 => r1 = MEM[1+r2]
    #10 PC_write = 10'd2; instruction_in = 32'b00000000010_01010_011_00011_0000011; // ld r3, 2, r10 => r3 = MEM[2+r10]
    #10 PC_write = 10'd3; instruction_in = 32'b0000000_00001_00011_000_00110_0110011; // add r6, r1, r3
    #10 reset = 1;
    #10 reset = 0; rw = 1; // reading instructions from instruction memory


end
endmodule
