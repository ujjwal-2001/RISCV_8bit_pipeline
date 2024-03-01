module ALU 
(
    input wire [7:0] data1,
    input wire [7:0] data2,
    input wire [3:0] ALU_control,
    output wire [31:0] ALU_result,
    output wire zero
);

    always@(*)
    begin
        case(ALU_control)
            default: ALU_result = 0;
        endcase
    end

endmodule