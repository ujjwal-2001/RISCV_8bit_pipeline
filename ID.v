// `include "Registers.v"
// `include "Control.v"
// `include "Imm_Gen.v"

// MACROS
`define OPCODE instruction[6:0]
`define FUNCT3 instruction[14:12]
`define FUNCT7 instruction[31:25]
`define RS1 instruction[19:15]
`define RS2 instruction[24:20]
`define RD instruction[11:7]

module ID 
(
    input wire clock,
    input wire reset,
    input wire [31:0] instruction,
    input wire [7:0] write_reg_data,
    output wire branch,
    output wire mem_read,
    output wire mem_to_reg,
    output wire [1:0] alu_op,
    output wire mem_write,
    output wire alu_src,
    output wire [7:0] read_data1,
    output wire [7:0] read_data2,
    output wire [11:0] immediate,
    output wire [6:0] funct7,
    output wire [2:0] funct3
);

    wire reg_write;

    Control CU(
        .opcode(`OPCODE),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    Registers RB(
        .clock(clock),
        .reset(reset),
        .read_reg1(`RS1),
        .read_reg2(`RS2),
        .write_reg(`RD),
        .write_reg_data(write_reg_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    Imm_Gen Immediate_Generator(
        .instruction(instruction),
        .immediate(immediate)
    );


endmodule