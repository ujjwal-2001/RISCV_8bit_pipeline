// `include "RISC_V.v"

module TOP #(parameter PC_SIZE=10, parameter INST_MEM_SIZE=1024, 
parameter DATA_MEM_SIZE=256, parameter ADDRESS_LINE=8)
(
    input wire clock,
    input wire reset,
    input wire reset_IF_memory,
    input wire [31:0] instruction_in,
    input wire [PC_SIZE-1:0] PC_write
);

    RISC_V #(.PC_SIZE(PC_SIZE), 
    .DATA_MEM_SIZE(DATA_MEM_SIZE), .ADDRESS_LINE(ADDRESS_LINE)) 
        RISC_V(
            .clock(clock),
            .reset(reset),
            .reset_IF_memory(reset_IF_memory),
            .instruction_in(instruction_in),
            .PC_write(PC_write)
    );

endmodule