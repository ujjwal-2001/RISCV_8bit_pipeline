// `include "Registers.v"
// `include "Control.v"
// `include "Imm_Gen.v"

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
    output wire [9:0] funct
);

    wire reg_write;
    wire [6:0] OPCODE ;
    wire [2:0] FUNCT3 ;
    wire [6:0] FUNCT7 ;
    wire [4:0] RS1 ;
    wire [4:0] RS2 ;
    wire [4:0] RD ;

    assign OPCODE = instruction[6:0];
    assign FUNCT3 =  instruction[14:12];
    assign FUNCT7 = instruction[31:25];
    assign RS1 = instruction[19:15];
    assign RS2 = instruction[24:20];
    assign RD = instruction[11:7];

    assign funct = {FUNCT7 ,FUNCT3};

    Control CU(
        .opcode(OPCODE),
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
        .read_reg1(RS1),
        .read_reg2(RS2),
        .write_reg(RD),
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