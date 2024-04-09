
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
    .rw(rw),
    .PC_write(PC_write),
    .write_reg_data(write_reg_data)
);

always #13 clock = ~clock;

initial begin
    clock = 0;
    reset = 1; reset_IF_memory = 1;
    #26 reset_IF_memory = 0;
    PC_write = 0;
    instruction_in = 32'h00000000;

    // writing instructions to instruction memory
    rw = 0; 
    
    #80 reset = 0; 
    
    #26 PC_write = 10'd1; instruction_in = 32'b000000000000_00101_000_00001_0000011; // ld r1, 0, r5 :  r1 = MEM[0+r5]
    #26 PC_write = 10'd2; instruction_in = 32'b000000000000_00110_000_00010_0000011; // ld r2, 0, r6 :  r2 = MEM[0+r6]
    #26 PC_write = 10'd3; instruction_in = 32'b000000000000_00001_000_00011_0000011; // ld r3, 0, r1 :  r3 = MEM[0+r1]

    #26 PC_write = 10'd7; instruction_in = 32'b0000000_00011_00010_111_00100_0110011; // and r4, r2, r3 : r4 = r2 & r3
    
    #26 PC_write = 10'd8; instruction_in = 32'b0000000_00010_00100_000_01010_1100011; // beq r4, r2, 8 : if(r4 == r2) PC = PC + 10
    
    #26 PC_write = 10'd12; instruction_in = 32'b0100000_00010_00011_000_00011_0110011; // sub r3, r2, r3 : r3 = r2 - r3
    #26 PC_write = 10'd13; instruction_in = 32'b0000000_00011_00001_000_00000_0100011; // sd r3, 0, r1 : MEM[0+r1] = r3 
    #26 PC_write = 10'd14; instruction_in = 32'b000000000110_00000_000_00000_1101111;  // jal 4 : PC = PC + 5

    #26 PC_write = 10'd18; instruction_in = 32'b0000000_00010_00011_000_00011_0110011; // add r3, r2, r3 : r3 = r2 + r3
    #26 PC_write = 10'd19; instruction_in = 32'b0000000_00011_00001_000_00000_0100011; // sd r3, 0, r1 : MEM[0+r1] = r3 
    
    #26 PC_write = 10'd20; instruction_in = 32'b0000000_00010_00001_000_00001_0110011; // add r1, r2, r1 : r1 = r2 + r1
    #26 PC_write = 10'd21; instruction_in = 32'b001111101110_00000_000_00000_1101111;  // jal 4 : PC = PC + 238



    #10 reset = 1;
    #10 reset = 0; rw = 1; // reading instructions from instruction memory


end
endmodule
