`timescale 1ns / 1ps

module hamming_encoder(
    input [7:0] data_in,   // 8-bit data input
    output [12:0] code_out  // 11-bit Hamming code output
);
    
    // Calculate parity bits
    wire p1, p2, p4,p8;  //since the number of data bits are 8 the number of parity bits will be 4-> 2^4>8+4+1
    wire p0;
/* parity encoding -CORRECT

1	0001	p1=3^5^7^9^11=>D0^D1^D3^D6
2	0010	p2=3^6^7^10^11=>D0^D2^D3^D5^D6
3	0011	D0
4	0100	p4=4^5^6^7^12=> D1^D2^D3^D7
5	0101	D1
6	0110	D2
7	0111	D3
8	1000	p8=8^9^10^11^12=> D4^D5^D6^D7
9	1001	D4
10	1010	D5
11	1011	D6
12	1100	D7
*///     [d0, d1, d2, d3]  [p1, p2 , d0, p4, d1, d2, d3]->[p1, p2 , d0, p4, d1, d2, d3]
//eg-12->[ 1   1   0   0]->[__, __ , 1 , __, 1,  0,  0,]->[0 , 1  , 1 , 1 , 1,  0,  0,]


    // Parity bit calculations
                //D0            D1          D3          D4          D6          
    assign p1 = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6];
    //          //D0            D2          D3          D5          D6   
    assign p2 = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6];
    //          D1              D2          D3          D7
    assign p4 = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7];
    //          D4              D5          D6          D7
    assign p8 = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7];


    // Assign the Hamming code output
    assign p0=p1^p2^data_in[0]^p4^data_in[1]^data_in[2]^data_in[3]^p8^data_in[4]^data_in[5]^data_in[6]^data_in[7];
    assign code_out = {p0, data_in[7],data_in[6],data_in[5],data_in[4],p8,data_in[3],data_in[2],data_in[1],p4,data_in[0],p2,p1};

endmodule
