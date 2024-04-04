`timescale 1ns / 1ps

module ALU_Control
(
    input wire [1:0] alu_op,
    input wire [9:0] funct,     // {funct7, funct3}
    output reg [3:0] alu_control 
);

    /* INSTRUCTIONS */
//     alu_op    |                   funct7                  |        funct3      |       alu_control     |
//   [1]   [0]   |   [9]   [8]   [7]   [6]   [5]   [4]   [3] |  [2]   [1]   [0]   |   [3]  [2]  [1]  [0]  |
//   0     0     |   x     x     x     x     x     x     x  |   x     x     x     |   0    0    1    0    |  // ld sd
//   0     1     |   x     x     x     x     x     x     x  |   x     x     x     |   0    1    1    0    |  // beq
//   1     0     |   0     0     0     0     0     0     0  |   0     0     0     |   0    0    1    0    |  // add
//   1     0     |   0     1     0     0     0     0     0  |   0     0     0     |   0    1    1    0    |  // sub
//   1     0     |   0     0     0     0     0     0     0  |   1     1     1     |   0    0    0    0    |  // and
//   1     0     |   0     0     0     0     0     0     0  |   1     1     0     |   0    0    0    1    |  // or
//   1     0     |   0     0     0     0     0     0     0  |   1     1     0     |   0    0    1    1    |  // xor
//   1     0     |   0     0     0     0     0     0     0  |   1     1     0     |   0    1    0    0    |  // not
//   1     1     |   x     x     x     x     x     x     x  |   x     x     x     |   1    1    0    0    |  // jal

    parameter AND = 4'b0000;
    parameter OR = 4'b0001;
    parameter ADD = 4'b0010;
    parameter XOR = 4'b0011;
    parameter NOT = 4'b0100;
    parameter SUBTRACT = 4'b0110;
    parameter JUMP = 4'b1100;

    always @* begin
        casex(alu_op)
            2'b00: alu_control = ADD;
            2'b01: alu_control = SUBTRACT;
            2'b10: case(funct)
                10'b0000000000: alu_control = ADD;
                10'b0100000000: alu_control = SUBTRACT;
                10'b0000000111: alu_control = AND;
                10'b0000000110: alu_control = OR;
                10'b0000000011: alu_control = XOR;
                10'b0000000100: alu_control = NOT;
                default: alu_control = AND;
                endcase
            2'b11: alu_control = JUMP;
            default: alu_control = AND;   
        endcase      
    end

endmodule