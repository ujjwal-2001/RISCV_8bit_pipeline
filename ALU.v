module ALU 
(
    input wire [7:0] data1,
    input wire [7:0] data2,
    input wire [3:0] ALU_control,
    output wire [31:0] ALU_result,
    output wire zero
);

    parameter AND = 4'b0000;
    parameter OR = 4'b0001;
    parameter ADD = 4'b0010;
    parameter SUBTRACT = 4'b0110;

    always@(*)
    begin
        case(ALU_control)
            AND: ALU_result = data1 & data2;
            OR: ALU_result = data1 | data2;
            ADD: ALU_result = data1 + data2;
            SUBTRACT: ALU_result = data1 - data2;
            default: ALU_result = 0;
        endcase
    end

endmodule