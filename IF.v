// `include "Program_Counter.v"
// `include "Instruction_Memory.v"
// `include "MUX_2to1.v"

module IF #(parameter PC_SIZE=10)
(
    input wire clock,
    input wire reset,
    input wire PCScr,
    input wire reset_memory,
    input wire [PC_SIZE-1:0] PC_jump,
    input wire [PC_SIZE-1:0] PC_write,
    input wire [31:0] instruction_in,
    output wire [PC_SIZE-1:0] PC_out,
    output wire [31:0] instruction_out
);

    reg [PC_SIZE-1:0] PC_in;
    wire [PC_SIZE-1:0] PC_next;

    assign PC_next = PC_out + 1;

    always@(*) begin
        if(PCScr) begin
            PC_in = PC_jump;
        end
        else begin
            PC_in = PC_next;
        end
    end

    Program_Counter #(.PC_SIZE(PC_SIZE)) PC(
        .clock(clock),
        .reset(reset),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );

    Instruction_Memory #(.PC_SIZE(PC_SIZE)) IM(
        .read_address(PC_out),
        .write_address(PC_write),
        .instruction_out(instruction_out),
        .instruction_in(instruction_in),
        .reset_memory(reset_memory),
        .clock(clock)
    );

endmodule