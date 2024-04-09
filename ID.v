`timescale 1ns / 1ps

module ID #(parameter PC_SIZE=10)
(
    input wire clock,
    input wire reset,
    input wire [PC_SIZE-1:0] PC_out_in,
    input wire [31:0] instruction,
    input wire [7:0] write_reg_data,
    input wire reg_write_in,
    input wire [4:0] write_register_in,
    output reg [4:0] rs1 ,
    output reg [4:0] rs2 ,
    output reg [4:0] write_register_out,
    output reg reg_write_out,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg [PC_SIZE-1:0] PC_out_out,
    output wire [7:0] read_data1,
    output wire [7:0] read_data2,
    output reg [11:0] immediate,
    output reg [9:0] funct
);

    wire [6:0] OPCODE ;
    wire [2:0] FUNCT3 ;
    wire [6:0] FUNCT7 ;
    wire [4:0] RD ;
    wire [4:0] RS1 ;
    wire [4:0] RS2 ;
    wire branch_wire;
    wire mem_read_wire;
    wire mem_to_reg_wire;
    wire [1:0] alu_op_wire;
    wire mem_write_wire;
    wire alu_src_wire;
    wire reg_write_wire;
    wire [11:0] immediate_wire;
    wire [9:0] funct_wire;


    assign OPCODE = instruction[6:0];
    assign FUNCT3 =  instruction[14:12];
    assign FUNCT7 = instruction[31:25];
    assign RS1 = instruction[19:15];
    assign RS2 = instruction[24:20];
    assign RD = instruction[11:7];

    assign funct_wire = {FUNCT7 ,FUNCT3};

    always@(posedge clock)begin
        if(reset)begin
            PC_out_out <= 0;
            branch <= 0;
            mem_read <= 0;
            mem_to_reg <= 0;
            alu_op <= 0;
            mem_write <= 0;
            alu_src <= 0;
            immediate <= 0;
            funct <= 0;
            reg_write_out <=0;
            write_register_out <= 0;
            rs1 <= 0;
            rs2 <= 0;
        end else begin
            PC_out_out <= PC_out_in;
            branch <= branch_wire;
            mem_read <= mem_read_wire;
            mem_to_reg <= mem_to_reg_wire;
            alu_op <= alu_op_wire;
            mem_write <= mem_write_wire;
            alu_src <= alu_src_wire;
            immediate <= immediate_wire;
            funct <= funct_wire;
            reg_write_out <= reg_write_wire;
            write_register_out <= RD;
            rs1 <= RS1;
            rs2 <= RS2;
        end
    end

    Control CU(
        .opcode(OPCODE),
        .branch(branch_wire),
        .mem_read(mem_read_wire),
        .mem_to_reg(mem_to_reg_wire),
        .alu_op(alu_op_wire),
        .mem_write(mem_write_wire),
        .alu_src(alu_src_wire),
        .reg_write(reg_write_wire)
    );

    Registers RB(
        .clock(clock),
        .reset(reset),
        .read_reg1(RS1),
        .read_reg2(RS2),
        .write_reg(write_register_in),
        .write_reg_data(write_reg_data),
        .reg_write(reg_write_in),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    Imm_Gen Immediate_Generator(
        .instruction(instruction),
        .immediate(immediate_wire)
    );


endmodule