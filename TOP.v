`include "RISC_V.v"

module TOP #(parameter PC_SIZE=32, parameter INST_MEM_SIZE=1024, 
parameter DATA_MEM_SIZE=256, parameter ADDRESS_LINE=8)
(
    input wire clock,
    input wire reset
);

    RISC_V #(.PC_SIZE(PC_SIZE), .INST_MEM_SIZE(INST_MEM_SIZE), 
    .DATA_MEM_SIZE(DATA_MEM_SIZE), .ADDRESS_LINE(ADDRESS_LINE)) 
        RISC_V(
            .clock(clock),
            .reset(reset)
    );

endmodule