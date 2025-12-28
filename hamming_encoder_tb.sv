module hamming_encoder_tb();
reg [7:0] data_in;
wire [12:0] code_out;

hamming_encoder DUT(.data_in(data_in),.code_out(code_out));
initial begin
    // VCD setup
    $dumpfile("hamming_encoder.vcd");
    $dumpvars(0, hamming_encoder_tb);



    data_in=8'h0;  // number of 1's for 0000_0000-> 0
                   //                   | p0 | d7 d6 d5 d4 | p8 | d3 d2 d1 | p4 | d0 | p2 p1 |
    #10            // EXPECTED OUTCOME->| 0  | 0  0  0  0  | 0  | 0  0  0  | 0  | 0  | 0  0  |
$display("input number = %h, ENCODED = %b_%b_%b_%b_%b_%b",
   data_in,
   code_out[12],        // p0
   code_out[11:8],      // d7..d4
   code_out[7],         // p8
   code_out[6:4],       // d3..d1
   code_out[3],         // p4
   code_out[2:0]        // d0 p2 p1
);  




    data_in=8'hff; // number of 1's for 1111_1111->8
                   //                   | 13 | 12 11 10  9 |  8 |  7  6  5 |  4 |  3 |  2  1 |
                   //                   | p0 | d7 d6 d5 d4 | p8 | d3 d2 d1 | p4 | d0 | p2 p1 |
    #10            // EXPECTED OUTCOME->| 0  | 1  1  1  1  | 0  | 1  1  1  | 0  | 1  | 1  1  |

$display("input number = %h, ENCODED = %b_%b_%b_%b_%b_%b",
   data_in,
   code_out[12],        // p0
   code_out[11:8],      // d7..d4
   code_out[7],         // p8
   code_out[6:4],       // d3..d1
   code_out[3],         // p4
   code_out[2:0]        // d0 p2 p1
);  




    data_in=8'haf; // number of 1's for 1010_1111->6   
                   //                   | 13 | 12 11 10  9 |  8 |  7  6  5 |  4 |  3 |  2  1 |
                   //                   | p0 | d7 d6 d5 d4 | p8 | d3 d2 d1 | p4 | d0 | p2 p1 |
    #15            // EXPECTED OUTCOME->| 1  | 1  0  1  0  | 0  | 1  1  1  | 0  | 1  | 0  1  |
$display("input number = %h, ENCODED = %b_%b_%b_%b_%b_%b",
   data_in,
   code_out[12],        // p0
   code_out[11:8],      // d7..d4
   code_out[7],         // p8
   code_out[6:4],       // d3..d1
   code_out[3],         // p4
   code_out[2:0]        // d0 p2 p1
);  


    data_in=8'hab;  // number of 1's for 1010_1011->5  
                   //                   | 13 | 12 11 10  9 |  8 |  7  6  5 |  4 |  3 |  2  1 |
                   //                   | p0 | d7 d6 d5 d4 | p8 | d3 d2 d1 | p4 | d0 | p2 p1 |
    #15            // EXPECTED OUTCOME->| 0  | 1  0  1  0  | 0  | 1  0  1  | 1  | 1  | 1  1  |
$display("input number = %h, ENCODED = %b_%b_%b_%b_%b_%b",
   data_in,
   code_out[12],        // p0
   code_out[11:8],      // d7..d4
   code_out[7],         // p8
   code_out[6:4],       // d3..d1
   code_out[3],         // p4
   code_out[2:0]        // d0 p2 p1
);


    data_in=8'hba;  // number of 1's for 1011_1010->5  
                   //                   | 13 | 12 11 10  9 |  8 |  7  6  5 |  4 |  3 |  2  1 |
                   //                   | p0 | d7 d6 d5 d4 | p8 | d3 d2 d1 | p4 | d0 | p2 p1 |
    #15            // EXPECTED OUTCOME->| 1  | 1  0  1  1  | 1  | 1  0  1  | 1  | 0  | 0  0  |
$display("input number = %h, ENCODED = %b_%b_%b_%b_%b_%b",
   data_in,
   code_out[12],        // p0
   code_out[11:8],      // d7..d4
   code_out[7],         // p8
   code_out[6:4],       // d3..d1
   code_out[3],         // p4
   code_out[2:0]        // d0 p2 p1
);


    data_in=8'haa;  // number of 1's for 1010_1010->4 
                   //                   | 13 | 12 11 10  9 |  8 |  7  6  5 |  4 |  3 |  2  1 |
                   //                   | p0 | d7 d6 d5 d4 | p8 | d3 d2 d1 | p4 | d0 | p2 p1 |
    #15            // EXPECTED OUTCOME->| 1  | 1  0  1  0  | 0  | 1  0  1  | 1  | 0  | 0  0  |
$display("input number = %h, ENCODED = %b_%b_%b_%b_%b_%b",
   data_in,
   code_out[12],        // p0
   code_out[11:8],      // d7..d4
   code_out[7],         // p8
   code_out[6:4],       // d3..d1
   code_out[3],         // p4
   code_out[2:0]        // d0 p2 p1
);


    data_in=8'h11;  // number of 1's for 0001_0001->2
                   //                   | 13 | 12 11 10  9 |  8 |  7  6  5 |  4 |  3 |  2  1 |
                   //                   | p0 | d7 d6 d5 d4 | p8 | d3 d2 d1 | p4 | d0 | p2 p1 |
    #15            // EXPECTED OUTCOME->| 1  | 0  0  0  1  | 1  | 0  0  0  | 0  | 1  | 1  0  |
$display("input number = %h, ENCODED = %b_%b_%b_%b_%b_%b",
   data_in,
   code_out[12],        // p0
   code_out[11:8],      // d7..d4
   code_out[7],         // p8
   code_out[6:4],       // d3..d1
   code_out[3],         // p4
   code_out[2:0]        // d0 p2 p1
);


    data_in=8'h82;  // number of 1's for 1000_0010->2 
                   //                   | 13 | 12 11 10  9 |  8 |  7  6  5 |  4 |  3 |  2  1 |
                   //                   | p0 | d7 d6 d5 d4 | p8 | d3 d2 d1 | p4 | d0 | p2 p1 |
    #15            // EXPECTED OUTCOME->| 1  | 1  0  0  0  | 1  | 0  0  1  | 0  | 0  | 0  1  |
$display("input number = %h, ENCODED = %b_%b_%b_%b_%b_%b",
   data_in,
   code_out[12],        // p0
   code_out[11:8],      // d7..d4
   code_out[7],         // p8
   code_out[6:4],       // d3..d1
   code_out[3],         // p4
   code_out[2:0]        // d0 p2 p1
);
    $finish;
end
endmodule
