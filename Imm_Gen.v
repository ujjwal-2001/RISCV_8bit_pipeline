`timescale 1ns / 1ps

module Imm_Gen
(
    input wire [31:0] instruction,
    output reg [11:0] immediate
);

    /* INSTRUCTIONS */
//     Name (Bit position)|-----31:25-----|---24:20---|---19:15---|-14:12-|---11:7----|------6:0------|
//                        | 6 5 4 3 2 1 0 | 4 3 2 1 0 | 4 3 2 1 0 | 2 1 0 | 4 3 2 1 0 | 6 5 4 3 2 1 0 |
//                        | + + + + + + + | + + + + + | + + + + + | + + + | + + + + + | + + + + + + + |
// (a) R-type             |     funct7    |    rs2    |    rs1    |funct3 |    rd     |    opcode     |                                                 
//                        | + + + + + + + | + + + + + | + + + + + | + + + | + + + + + | + + + + + + + |
// (b) I-type             |          immediate        |    rs1    |funct3 |    rd     |    opcode     |                                                 
//                        | + + + + + + + | + + + + + | + + + + + | + + + | + + + + + | + + + + + + + |
// (c) S-type             |  immed[11:5]  |    rs2    |    rs1    |funct3 |immed[4:0] |    opcode     |                                                 
//                        | + + + + + + + | + + + + + | + + + + + | + + + | + + + + + | + + + + + + + |
// (d) SB-type            |  immed[11:5]  |    rs2    |    rs1    |funct3 |immed[4:0] |    opcode     |                                                 
//                        | + + + + + + + | + + + + + | + + + + + | + + + | + + + + + | + + + + + + + |
// (e) UJ-type            |          immediate        | x x x x x | x x x | x x x x x |    opcode     |                                                 
//                        | + + + + + + + | + + + + + | + + + + + | + + + | + + + + + | + + + + + + + |
    always@(*)begin
      
        casex(instruction[6:0])
            7'b000_xxxx: immediate = instruction[31:20];  // I-type instruction
            7'b011_xxxx: immediate = 0;   // R-type instruction
            7'b010_xxxx: immediate = {instruction[31:25], instruction[11:7]}; // S-type instruction
            7'b110_0xxx: immediate = {instruction[31:25], instruction[11:7]}; // SB-type instruction
            7'b110_1xxx: immediate =  instruction[31:20]; // UJ-type instruction
            default: immediate = 0;
        endcase

    end

endmodule