`define SELECT instruction[6:5]

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
    always@(*)begin
      
        case(`SELECT)
            2'b00: immediate = instruction[31:20];  // l-type instruction
            2'b01: immediate = 0;   // R-type instruction
            2'b10: immediate = {instruction[31:25], instruction[11:7]}; // S-type instruction
            2'b11: immediate =  {instruction[31:25], instruction[11:7]}; // SB-type instruction
            default: immediate = 0;
        endcase

    end

endmodule