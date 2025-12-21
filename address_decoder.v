module address_decoder (
    input        clk,
    //input        reset,
    input  [1:0] in_address,
    output [3:0] out_address
);

    

    // Decoder (combinational)
    initial begin
        case (in_address)
            2'b00: out_address = 4'b0001;
            2'b01: out_address = 4'b0010;
            2'b10: out_address = 4'b0100;
            2'b11: out_address = 4'b1000;
            default: out_address = 4'b0000;
        endcase
    end

endmodule
