`timescale 1ns / 1ps

module EXE #(parameter PC_SIZE=10)
(
    input wire clock,
    input wire reset,
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
    input wire reg_write_in,
    input wire [1:0] fwd_A,
    input wire [1:0] fwd_B,
    input wire [4:0] write_register_in,
    input wire [7:0] wb_write_data,
    input wire [7:0] ex_mem_alu_result,
    output reg [4:0] write_register_out,
    output reg [PC_SIZE-1:0] PC_jump,
    output reg zero,
    output reg [7:0] ALU_result,
    output reg branch_out,
    output reg mem_read_out,
    output reg mem_to_reg_out,
    output reg mem_write_out,
    output reg [7:0] write_data,
    output reg reg_write_out
);

    wire [3:0] alu_control;
    wire [7:0] intermediate_data2;
    reg [7:0] selected_data2;
    wire [7:0] selected_data2_final;
    reg [7:0] selected_data1;
    wire [PC_SIZE-1:0] PC_jump_wire;
    wire [7:0] ALU_result_wire;
    wire zero_wire;

    assign PC_jump_wire = PC_out + immediate;
    assign selected_data2_final = (alu_src) ? intermediate_data2 : selected_data2;

    always@(posedge clock)begin
        if (reset)begin
            PC_jump <= 0;
            branch_out <= 0;
            mem_read_out <= 0;
            mem_to_reg_out <= 0;
            mem_write_out <= 0;
            reg_write_out <= 0;
            write_data <= 0;
            ALU_result <= 0;
            zero <= 0;
            write_register_out <= 0;
        end else begin
            PC_jump <= PC_jump_wire;
            branch_out <= branch_in;
            mem_read_out <= mem_read_in;
            mem_to_reg_out <= mem_to_reg_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            write_data <= selected_data2;
            ALU_result <= ALU_result_wire;
            zero <= zero_wire;
            write_register_out <= write_register_in;
         end
    end

    MUX_2to1 #(.N(8)) MUX_Data2(
        .D0(data2),
        .D1(immediate[7:0]),
        .S0(alu_src),
        .Y(intermediate_data2)
    );

    always@(*)begin
        case(fwd_A)                                     // Source
            2'b00: selected_data1 = data1;              // ID/EX
            2'b01: selected_data1 = wb_write_data;      // MEM/WB
            2'b10: selected_data1 = ex_mem_alu_result;  // EX/MEM
            default: selected_data1 = 8'b0;
        endcase

        casex(fwd_B)                                     // Source    
            2'b00: selected_data2 = intermediate_data2; // ID/EXE
            2'b01: selected_data2 = wb_write_data;      //  MEM/WB
            2'b10: selected_data2 = ex_mem_alu_result;  //  EX/MEM
            default: selected_data2 = 8'b0;
        endcase
    end
  

    ALU_Control ALU_Control(
        .funct(funct),
        .alu_op(alu_op),
        .alu_control(alu_control)
    );

    ALU ALU(
        .data1(selected_data1),
        .data2(selected_data2_final),
        .ALU_control(alu_control),
        .ALU_result(ALU_result_wire),
        .zero(zero_wire)
    );

endmodule