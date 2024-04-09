`timescale 1ns / 1ps

module MEM  #(parameter ADDRESS_LINE=8,  parameter DATA_MEM_SIZE=256)
(
    input wire clock,
    input wire reset,
    input wire reg_write_in,
    input wire branch,
    input wire mem_read,
    input wire mem_to_reg_in,
    input wire mem_write,
    input wire zero,
    input wire [7:0] ALU_result_in,
    input wire [7:0] write_data,
    input wire [4:0] write_register_in,
    output reg [4:0] write_register_out,
    output reg [7:0] ALU_result_out,
    output reg [7:0] read_data,
    output reg mem_to_reg_out,
    output wire PCScr,
    output reg reg_write_out
);

    wire [7:0] read_data_wire;

    assign PCScr = branch & zero ;

    always@(posedge clock)begin
        if(reset)begin
            mem_to_reg_out <= 0;
            ALU_result_out <= 0;
            reg_write_out <= 0;
            read_data <= 0;
            write_register_out <= 0;
        end else begin
            mem_to_reg_out <= mem_to_reg_in;
            ALU_result_out <= ALU_result_in;
            reg_write_out <= reg_write_in;
            read_data <= read_data_wire;
            write_register_out <= write_register_in;
        end
    end

    Data_Memory  #(.ADDRESS_LINE(ADDRESS_LINE),.MEM_SIZE(DATA_MEM_SIZE)) DM(
        .clock(clock),
        .reset(reset),
        .write_data(write_data),
        .address(ALU_result_in),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data_wire)
    );


endmodule