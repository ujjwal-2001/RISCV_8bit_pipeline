`timescale 1ns / 1ps

module WB
(
    input wire [7:0] read_data,
    input wire [7:0] ALU_result,
    input wire mem_to_reg,
    output wire [7:0] write_data
);

    MUX_2to1 #(.N(8)) WriteBack_MUX(
        .D0(ALU_result),
        .D1(read_data),
        .S0(mem_to_reg),
        .Y(write_data)
    );
    
endmodule