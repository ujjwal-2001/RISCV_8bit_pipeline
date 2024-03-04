module Data_Memory #(parameter ADDRESS_LINE=8,  parameter MEM_SIZE=256)
(
    input wire clock,
    input wire reset,
    input wire [7:0] write_data,
    input wire [ADDRESS_LINE-1:0] address,
    input wire mem_write,
    input wire mem_read,
    output wire [7:0] read_data
);

    reg [7:0] memory[MEM_SIZE-1:0];

    assign read_data = mem_read ? memory[address] : 8'b0;
    integer i = 0;
    always@(posedge clock) begin
        if(reset)begin
            for( i=0; i<MEM_SIZE; i=i+1)begin
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