module Forwarding_Unit (
    input wire [4:0] reg_RS1,
    input wire [4:0] reg_RS2,
    input wire [4:0] ex_mem_reg_RD,
    input wire [4:0] mem_wb_reg_RD,
    input wire ex_mem_regwrite,
    input wire mem_wb_regwrite,
    output reg [1:0] fwd_A,
    output reg [1:0] fwd_B
);

    fwd_A = 00;
    fwd_B = 00;

    always@(*) begin
        // forwarding condition for EX hazard
        if(ex_mem_regwrite && (ex_mem_reg_RD != 0)) begin
            if((ex_mem_reg_RD == reg_RS1)) begin
                fwd_A = 10;
            end
            if((ex_mem_reg_RD == reg_RS2)) begin
                fwd_B = 10;
            end
        end
        // forwarding condition for MEM hazard
        if(mem_wb_regwrite && (mem_wb_reg_RD != 0)) begin
            if (!(ex_mem_regwrite && (ex_mem_reg_RD != 0))) begin
                if((ex_mem_reg_RD == reg_RS1) && (mem_wb_reg_RD == reg_RS1)) begin
                    fwd_A = 01;
                end
                if((ex_mem_reg_RD == reg_RS2) && (mem_wb_reg_RD == reg_RS2)) begin
                    fwd_B = 01;
                end
            end
        end
    end

endmodule