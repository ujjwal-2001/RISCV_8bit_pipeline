// `include "ALU.v"
// `include "MUX_2to1.v"
// `include "ALU_Control.v"
`timescale 1ns / 1ps

module EXE #(parameter PC_SIZE=10)
(
    input wire [PC_SIZE-1:0] PC_out,
    input wire [7:0] data1,
    input wire [7:0] data2,
    input wire [11:0] immediate,
    input wire [9:0] funct, // {funct7, funct3}
    input wire [1:0] alu_op,
    input wire alu_src,
    input wire branch_in,
    input wire mem_read_in,
    input wire mem_to_reg_in,
    input wire mem_write_in,
    output wire [PC_SIZE-1:0] PC_jump,
    output wire zero,
    output wire [7:0] ALU_result,
    output wire branch_out,
    output wire mem_read_out,
    output wire mem_to_reg_out,
    output wire mem_write_out
);

    wire [3:0] alu_control_wire;
    wire [7:0] selected_data2;

    assign PC_jump = PC_out + immediate;
    assign branch_out = branch_in;
    assign mem_read_out = mem_read_in;
    assign mem_to_reg_out = mem_to_reg_in;
    assign mem_write_out = mem_write_in;

    ALU_Control ALU_Control(
        .funct(funct),
        .alu_op(alu_op),
        .alu_control(alu_control_wire)
    );

    MUX_2to1 #(.N(8)) MUX_Data2(
        .D0(data2),
        .D1(immediate[7:0]),
        .S0(alu_src),
        .Y(selected_data2)
    );

    ALU ALU(
        .data1(data1),
        .data2(selected_data2),
        .ALU_control(alu_control_wire),
        .ALU_result(ALU_result),
        .zero(zero)
    );

endmodule