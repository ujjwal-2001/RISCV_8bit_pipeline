`timescale 1ns / 1ps

module Registers
(   
    input wire clock,
    input wire reset,
    input wire [4:0] read_reg1, // Read resister 1
    input wire [4:0] read_reg2, // Read resister 2
    input wire [4:0] write_reg, // Write resister 
    input wire [7:0] write_reg_data, // Write resister data
    input wire reg_write,   // Control signal for writing to register
    output reg [7:0] read_data1, // Read data 1
    output reg [7:0] read_data2 // Read data 2
);

    reg [7:0] registers[31:0]; // 32 registers, each 8-bit wide
    integer i=0;
    always@(posedge clock) begin
        if(reset)begin
            for( i=0; i<32; i=i+1)begin
                registers[i] <= 0;
            end
            read_data1 <= 0;
            read_data2 <= 0;
        end
        else begin
            if(reg_write)begin
                registers[write_reg] <= write_reg_data;
            end
            read_data1 <= registers[read_reg1];
            read_data2 <= registers[read_reg2];
        end
    end

endmodule