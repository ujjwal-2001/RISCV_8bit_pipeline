`timescale 1ns / 1ps

module ALU 
(
    input wire [7:0] data1,
    input wire [7:0] data2,
    input wire [3:0] ALU_control,
    output reg [7:0] ALU_result,
    output wire zero
);

    parameter AND = 4'b0000;
    parameter OR = 4'b0001;
    parameter ADD = 4'b0010;
    parameter XOR = 4'b0011;
    parameter NOT = 4'b0100;
    parameter SUBTRACT = 4'b0110;
    parameter JUMP = 4'b1100;

    assign zero = (ALU_result == 0) ? 1'b1 : 1'b0;

    always@(*)
    begin
        case(ALU_control)
            AND: ALU_result = data1 & data2;
            OR: ALU_result = data1 | data2;
            ADD: ALU_result = data1 + data2;
            SUBTRACT: ALU_result = data1 - data2;
            XOR: ALU_result = data1 ^ data2;
            NOT: ALU_result = ~ data1;
            JUMP: ALU_result = 0;
            default: ALU_result = 0;
        endcase
    end

endmodule