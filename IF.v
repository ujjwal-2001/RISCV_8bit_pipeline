// `include "Program_Counter.v"
// `include "Instruction_Memory.v"
// `include "MUX_2to1.v"

module IF #(parameter PC_SIZE=32)
(
    input wire clock,
    input wire reset,
    input wire PCScr,
    input wire [PC_SIZE-1:0] PC_jump,
    output wire [PC_SIZE-1:0] PC_out,
    output wire [31:0] instruction
);

    wire [PC_SIZE-1:0] PC_in;
    reg [PC_SIZE-1:0] PC_next;

    always@(posedge clock) begin
        PC_next <= PC_out + 1;
    end

    MUX_2to1 PC_MUX(
        .D0(PC_next),
        .D1(PC_jump),
        .S0(PCScr),
        .Y(PC_in)
    );

    Program_Counter PC(
        .clock(clock),
        .reset(reset),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );

    Instruction_Memory IM(
        .read_address(PC_out),
        .instruction(instruction),
        .reset(reset)
    );

endmodule