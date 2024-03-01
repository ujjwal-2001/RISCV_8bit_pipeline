module Mux_2to1 
(
    input wire D0,
    input wire D1,
    input wire S0,
    output wire Y
);

    assign Y = (S0) ? D1 : D0;

endmodule