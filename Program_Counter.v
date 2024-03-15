`timescale 1ns / 1ps

module Program_Counter #(parameter PC_SIZE=32)
(   
    input wire clock,
    input wire reset,
    input wire [PC_SIZE-1:0] PC_in,
    output reg [PC_SIZE-1:0] PC_out
);

    always@(posedge clock) begin
        if(reset)begin
            PC_out <= 0;
        end
        else begin
            PC_out <= PC_in;
        end
    end

endmodule