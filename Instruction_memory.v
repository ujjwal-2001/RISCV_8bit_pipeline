module Instruction_memory #(parameter PC_SIZE=32, parameter MEM_SIZE=1024)
(
    input wire [PC_SIZE-1:0] read_address,
    input wire reset,
    output wire [31:0] instruction
);

    reg [PC_SIZE-1:0] Memory[MEM_SIZE-1:0]; // MEM_SIZE, 8-bit memory locations

    assign instruction = Memory[read_address];

    always@(posedge reset)begin // Reseting memory
        for(integer i=0; i<MEM_SIZE; i=i+1)begin
            Memory[i] = 0;
        end
    end


endmodule