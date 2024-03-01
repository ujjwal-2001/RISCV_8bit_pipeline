module Data_Memory #(parameter ADDRESS_LINE=16)
(
    input wire clock,
    input wire reset,
    input wire [7:0] write_data,
    input wire [ADDRESS_LINE-1:0] address,
    input wire mem_write,
    input wire mem_read,
    output wire [7:0] read_data
);

    reg [7:0] memory[1024:0];

    assign read_data = mem_read ? memory[address] : 8'b0;

    always@(posedge clock) begin
        if(reset)begin
            for(integer i=0; i<1024; i=i+1)begin
                memory[i] <= 0;
            end
        end
        else begin
            if(mem_write)begin
                memory[address] <= write_data;
            end
        end
    end
    

endmodule