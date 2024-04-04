`timescale 1ns / 1ps

module Control
(
    input wire [6:0] opcode,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write
);

//| Instruction | ALUSrc | Memto-Reg | Reg-Write | Mem-Read | Mem-Write | Branch | ALUOp1 | ALUOp0 |
//|-------------|--------|-----------|-----------|----------|-----------|--------|--------|--------|
//| R-format    |    0   |     0     |     1     |     0    |     0     |    0   |    1   |    0   |
//| ld          |    1   |     1     |     1     |     1    |     0     |    0   |    0   |    0   |
//| sd          |    1   |     X     |     0     |     0    |     1     |    0   |    0   |    0   |
//| beq         |    0   |     X     |     0     |     0    |     0     |    1   |    0   |    1   |
//| jal         |    1   |     0     |     1     |     0    |     0     |    1   |    1   |    1   |


    always @* begin
        case(opcode)
            7'b0110011: begin // R-format
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 2'b10;
                mem_write = 0;
                alu_src = 0;
                reg_write = 1;
            end
            7'b0000011: begin // ld
                branch = 0;
                mem_read = 1;
                mem_to_reg = 1;
                alu_op = 2'b00;
                mem_write = 0;
                alu_src = 1;
                reg_write = 1;
            end
            7'b0100011: begin // sd
                branch = 0;
                mem_read = 0;
                mem_to_reg = 1'bx;
                alu_op = 2'b00;
                mem_write = 1;
                alu_src = 1;
                reg_write = 0;
            end
            7'b1100011: begin // beq
                branch = 1;
                mem_read = 0;
                mem_to_reg = 1'bx;
                alu_op = 2'b01;
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
            end
            7'b1101111: begin // jal
                branch = 1;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 2'b11;
                mem_write = 0;
                alu_src = 1;
                reg_write = 1;
            end
            default: begin
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 2'b00;
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
            end
        endcase
    end
    
endmodule