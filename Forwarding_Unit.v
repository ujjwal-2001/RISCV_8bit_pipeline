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

    always@(*) begin
        // forwarding condition for EX hazard
        if(ex_mem_regwrite && (ex_mem_reg_RD != 0)) begin
            if((ex_mem_reg_RD == reg_RS1)) begin
                fwd_A = 2'b10;
            end
            if((ex_mem_reg_RD == reg_RS2)) begin
                fwd_B = 2'b10;
            end
        end else if(mem_wb_regwrite && (mem_wb_reg_RD != 0)) begin // forwarding condition for MEM hazard
            if (!(ex_mem_regwrite && (ex_mem_reg_RD != 0))) begin
                if((ex_mem_reg_RD == reg_RS1) && (mem_wb_reg_RD == reg_RS1)) begin
                    fwd_A = 2'b01;
                end
                if((ex_mem_reg_RD == reg_RS2) && (mem_wb_reg_RD == reg_RS2)) begin
                    fwd_B = 2'b01;
                end
            end
        end else begin
            fwd_A = 0; 
            fwd_B = 0; 
        end
    end

endmodule