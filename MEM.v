// `include "Data_Memory.v"

module MEM  #(parameter ADDRESS_LINE=8,  parameter DATA_MEM_SIZE=256)
(
    input wire clock,
    input wire reset,
    input wire branch,
    input wire mem_read,
    input wire mem_to_reg_in,
    input wire mem_write,
    input wire zero,
    input wire [7:0] ALU_result_in,
    input wire [7:0] write_data,
    output wire [7:0] ALU_result_out,
    output wire [7:0] read_data,
    output wire mem_to_reg_out,
    output wire PCScr
);

    assign PCScr = branch & zero;
    assign mem_to_reg_out = mem_to_reg_in;
    assign ALU_result_out = ALU_result_in;

    Data_Memory  #(.ADDRESS_LINE(ADDRESS_LINE),.MEM_SIZE(DATA_MEM_SIZE)) DM(
        .clock(clock),
        .reset(reset),
        .write_data(write_data),
        .address(ALU_result_in),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );


endmodule