`timescale 1ns / 1ps

module RISC_V #(parameter PC_SIZE=10, 
parameter DATA_MEM_SIZE=256, parameter ADDRESS_LINE=8)
(
    input wire clock,
    input wire reset,
    input wire rw,
    input wire reset_IF_memory,
    input wire [PC_SIZE-1:0] PC_write,
    input wire [31:0] instruction_in,
    output wire [7:0] write_reg_data
);

    wire [PC_SIZE-1:0] PC_jump;
    wire [PC_SIZE-1:0] PC_out_IF_out;
    wire PCScr;
    wire [31:0] instruction_out;

    wire branch_ID_out;
    wire mem_read_ID_out;
    wire mem_to_reg_ID_out;
    wire [1:0] alu_op;
    wire mem_write_ID_out;
    wire alu_src;
    wire [7:0] read_data1;
    wire [7:0] read_data2;
    wire [11:0] immediate;
    wire [9:0] funct;
    wire [PC_SIZE-1:0] PC_out_ID_out;
    wire reg_write_ID_out;
    wire [4:0] write_register_ID_out;

    wire branch_EXE_out;
    wire mem_read_EXE_out;
    wire mem_to_reg_EXE_out;
    wire mem_write_EXE_out;
    wire [7:0] ALU_result;
    wire [7:0] ALU_result_MEM_out;
    wire [7:0] mem_read_data;
    wire zero;
    wire [7:0] write_data_EXE_out;
    wire reg_write_EXE_out;
    wire [4:0] write_register_EXE_out;

    wire mem_to_reg_MEM_out;
    wire [7:0] write_reg_data_wire;
    wire [4:0] write_register_MEM_out;

    wire reg_write_WB_out;

    wire [1:0] fwd_A;
    wire [1:0] fwd_B;
    wire [4:0] rs1;
    wire [4:0] rs2;

    assign write_reg_data = write_reg_data_wire;

    IF #(.PC_SIZE(PC_SIZE)) IF(
        .clock(clock),
        .reset(reset),
        .reset_memory(reset_IF_memory),
        .PC_jump(PC_jump),
        .PC_out(PC_out_IF_out),
        .rw(rw),
        .PCScr(PCScr),
        .PC_write(PC_write),
        .instruction_in(instruction_in),
        .instruction_out(instruction_out)
    );

    ID #(.PC_SIZE(PC_SIZE)) ID(
        .clock(clock),
        .reset(reset),
        .PC_out_in(PC_out_IF_out),
        .instruction(instruction_out),
        .write_reg_data(write_reg_data_wire),
        .branch(branch_ID_out),
        .reg_write_in(reg_write_WB_out),
        .write_register_in(write_register_MEM_out),
        .write_register_out(write_register_ID_out),
        .rs1(rs1),
        .rs2(rs2),
        .mem_read(mem_read_ID_out),
        .mem_to_reg(mem_to_reg_ID_out),
        .alu_op(alu_op),
        .mem_write(mem_write_ID_out),
        .alu_src(alu_src),
        .reg_write_out(reg_write_ID_out),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .immediate(immediate),
        .PC_out_out(PC_out_ID_out),
        .funct(funct)
    );

    EXE #(.PC_SIZE(PC_SIZE)) EXE(
        .clock(clock),
        .reset(reset),
        .PC_out(PC_out_ID_out),
        .data1(read_data1),
        .data2(read_data2),
        .immediate(immediate),
        .funct(funct),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .fwd_A(fwd_A),
        .fwd_B(fwd_B),
        .ex_mem_alu_result(ALU_result),
        .wb_write_data(write_reg_data_wire),
        .branch_in(branch_ID_out),
        .mem_read_in(mem_read_ID_out),
        .mem_to_reg_in(mem_to_reg_ID_out),
        .mem_write_in(mem_write_ID_out),
        .reg_write_in(reg_write_ID_out),
        .write_register_in(write_register_ID_out),
        .PC_jump(PC_jump),
        .zero(zero),
        .ALU_result(ALU_result),
        .branch_out(branch_EXE_out),
        .mem_read_out(mem_read_EXE_out),
        .mem_to_reg_out(mem_to_reg_EXE_out),
        .mem_write_out(mem_write_EXE_out),
        .write_data(write_data_EXE_out),
        .reg_write_out(reg_write_EXE_out),
        .write_register_out(write_register_EXE_out)
    );

    MEM #(.ADDRESS_LINE(ADDRESS_LINE), .DATA_MEM_SIZE(DATA_MEM_SIZE)) MEM(
        .clock(clock),
        .reset(reset),
        .reg_write_in(reg_write_EXE_out),
        .branch(branch_EXE_out),
        .mem_read(mem_read_EXE_out),
        .mem_to_reg_in(mem_to_reg_EXE_out),
        .mem_write(mem_write_EXE_out),
        .zero(zero),
        .ALU_result_in(ALU_result),
        .write_register_in(write_register_EXE_out),
        .write_data(write_data_EXE_out),
        .ALU_result_out(ALU_result_MEM_out),
        .read_data(mem_read_data),
        .mem_to_reg_out(mem_to_reg_MEM_out),
        .PCScr(PCScr),
        .reg_write_out(reg_write_WB_out),
        .write_register_out(write_register_MEM_out)
    );

    WB WB(
        .read_data(mem_read_data),
        .ALU_result(ALU_result_MEM_out),
        .mem_to_reg(mem_to_reg_MEM_out),
        .write_data(write_reg_data_wire)
    );

    Forwarding_Unit Forwarding_Unit(
    .reg_RS1(rs1),
    .reg_RS2(rs2),
    .ex_mem_reg_RD(write_register_EXE_out),
    .mem_wb_reg_RD(write_register_MEM_out),
    .ex_mem_regwrite(reg_write_EXE_out),
    .mem_wb_regwrite(reg_write_WB_out),
    .fwd_A(fwd_A),
    .fwd_B(fwd_B)
    );

endmodule