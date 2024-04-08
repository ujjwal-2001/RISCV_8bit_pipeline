`timescale 1ns / 1ps

module Data_Memory #(parameter ADDRESS_LINE=8,  parameter MEM_SIZE=256)
(
    input wire clock,
    input wire reset,
    input wire [7:0] write_data,
    input wire [ADDRESS_LINE-1:0] address,
    input wire mem_write,
    input wire mem_read,
    output wire [7:0] read_data
);

    reg [7:0] memory[MEM_SIZE-1:0];

    assign read_data = mem_read ? memory[address] : 8'b0;
    integer i = 0;
    always@(posedge clock) begin
        if(reset)begin
            for( i=0; i<MEM_SIZE; i=i+1)begin
                memory[i] <= 0;
            end
            memory[0] <= 1;
            memory[1] <= 6;
            memory[2] <= 10;
            memory[3] <= 11;
            memory[4] <= 14;
            memory[5] <= 4;
            memory[6] <= 8;
            memory[7] <= 0;
            memory[8] <= 1;
            memory[9] <= 3;
            memory[10] <= 5;
        end
        else begin
            if(mem_write)begin
                memory[address] <= write_data;
            end
        end
    end
    

endmodule