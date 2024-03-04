// `include "IF.v"
// `include "ID.v"
// `include "EXE.v"
// `include "MEM.v"
// `include "WB.v"

module RISC_V #(parameter PC_SIZE=10, 
parameter DATA_MEM_SIZE=256, parameter ADDRESS_LINE=8)
(
    input wire clock,
    input wire reset,
    input wire reset_IF_memory,
    input wire [PC_SIZE-1:0] PC_write,
    input wire [31:0] instruction_in,
    output wire [31:0] write_reg_data
);

    wire [PC_SIZE-1:0] PC_jump;
    wire [PC_SIZE-1:0] PC_out;
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

    wire branch_EXE_out;
    wire mem_read_EXE_out;
    wire mem_to_reg_EXE_out;
    wire mem_write_EXE_out;
    wire [7:0] ALU_result;
    wire zero;

    wire mem_to_reg_MEM_out;

    IF #(.PC_SIZE(PC_SIZE)) IF(
        .clock(clock),
        .reset(reset),
        .reset_memory(reset_IF_memory),
        .PC_jump(PC_jump),
        .PC_out(PC_out),
        .PCScr(PCScr),
        .PC_write(PC_write),
        .instruction_in(instruction_in),
        .instruction_out(instruction_out)
    );

    ID ID(
        .clock(clock),
        .reset(reset),
        .instruction(instruction_out),
        .write_reg_data(write_reg_data),
        .branch(branch_ID_out),
        .mem_read(mem_read_ID_out),
        .mem_to_reg(mem_to_reg_ID_out),
        .alu_op(alu_op),
        .mem_write(mem_write_ID_out),
        .alu_src(alu_src),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .immediate(immediate),
        .funct(funct)
    );

    EXE #(.PC_SIZE(PC_SIZE)) EXE(
        .PC_out(PC_out),
        .data1(read_data1),
        .data2(read_data2),
        .immediate(immediate),
        .funct(funct),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .branch_in(branch_ID_out),
        .mem_read_in(mem_read_ID_out),
        .mem_to_reg_in(mem_to_reg_ID_out),
        .mem_write_in(mem_write_ID_out),
        .PC_jump(PC_jump),
        .zero(zero),
        .ALU_result(ALU_result),
        .branch_out(branch_EXE_out),
        .mem_read_out(mem_read_EXE_out),
        .mem_to_reg_out(mem_to_reg_EXE_out),
        .mem_write_out(mem_write_EXE_out)
    );

    MEM #(.ADDRESS_LINE(ADDRESS_LINE), .DATA_MEM_SIZE(DATA_MEM_SIZE)) MEM(
        .clock(clock),
        .reset(reset),
        .branch(branch_EXE_out),
        .mem_read(mem_read_EXE_out),
        .mem_to_reg_in(mem_to_reg_EXE_out),
        .mem_write(mem_write_EXE_out),
        .zero(zero),
        .ALU_result_in(ALU_result),
        .write_data(write_reg_data),
        .ALU_result_out(ALU_result),
        .read_data(read_data1),
        .mem_to_reg_out(mem_to_reg_MEM_out),
        .PCScr(PCScr)
    );

    WB WB(
        .read_data(read_data1),
        .ALU_result(ALU_result),
        .mem_to_reg(mem_to_reg_WB_out),
        .write_data(write_reg_data)
    );

endmodule