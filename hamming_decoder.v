`timescale 1ns / 1ps

module hamming_decoder(
    input [12:0] hamming_bits,   // 13-bit Hamming code input
    output [7:0] data_out, // 8-bit message bits data output
    output error,       // Error flag
    output undefined_data
    );

    wire overall_parity_error;
    wire [7:0] intermediate_wire;
    assign overall_parity_error=hamming_bits[12]^(^hamming_bits[11:0]); //XOR of everything
/* parity encoding -CORRECT

1 [0]	0001	S1=1^3^5^7^9^11->[0]^[2]^[4]^[6]^[8]^[10]
2 [1]	0010	S2=2^3^6^7^10^11->[1]^[2]^[5]^[6]^[9]^[10]
3 [2]	0011	D0
4 [3]	0100	S4=4^5^6^7^12->[3]^[4]^[5]^[6]^[11]
5 [4]	0101	D1
6 [5]	0110	D2
7 [6]	0111	D3
8 [7]	1000	s8=8^9^10^11^12-> [7]^[8]^[9]^[10]^[11]
9 [8]	1001	D4
10[9]	1010	D5
11[10]	1011	D6
12[11]	1100	D7
13[12]          p0
*/  
    //[11]^[10]^[9]^[8]^[6]^[5]^[4]^[2]
    //[d7, d6,  d5, d4, p8, d3, d2, d1, p4, d0, p2, p1]
    // Calculate syndrome bits
    wire s1, s2, s4, s8;
              
    assign s1 = hamming_bits[0] ^ hamming_bits[2] ^ hamming_bits[4] ^ hamming_bits[6] ^ hamming_bits[8] ^ hamming_bits[10] ;     //p1 checking d3,d5,d7 and the parity type 
    assign s2 = hamming_bits[1] ^ hamming_bits[2] ^ hamming_bits[5] ^ hamming_bits[6] ^ hamming_bits[9] ^ hamming_bits[10];     //p2 checking d3,d6,d7 and the parity type 
    assign s4 = hamming_bits[3] ^ hamming_bits[4] ^ hamming_bits[5] ^ hamming_bits[6] ^ hamming_bits[11];     //p4 checking d5,d6,d7 and the parity type 
    assign s8 = hamming_bits[7] ^ hamming_bits[8] ^ hamming_bits[9] ^ hamming_bits[10] ^ hamming_bits[11];  //syndrome bit 4

    // if the syndrome bits are not zero then there is a bit error
    // Determine the error position
    wire [3:0] error_pos;
    
    assign error_pos = {s8,s4,s2,s1};   

    // ------------------------------------------------------------
    // Error classification
    // ------------------------------------------------------------
    wire no_error;
    wire single_bit_error;
    wire p0_error;
    wire double_bit_error;

    assign no_error         = (overall_parity_error == 0 && error_pos == 0);
    assign single_bit_error = (overall_parity_error == 1 && error_pos != 0);
    assign p0_error         = (overall_parity_error == 1 && error_pos == 0);
    assign double_bit_error = (overall_parity_error == 0 && error_pos != 0);

    
    assign error = single_bit_error | p0_error | double_bit_error;


    reg [12:0] corrected_code;  //taking a register corrected data to change the error positioned bit

        always @(*) begin
            corrected_code = hamming_bits;
            

        // Correct only single-bit errors (NOT double-bit)
                if (single_bit_error) begin
                    corrected_code[error_pos-1] = ~corrected_code[error_pos-1];
                end            

        end
 
        //[11]^[10]^[9]^[8]^[6]^[5]^[4]^[2]
    assign intermediate_wire = {corrected_code[11],corrected_code[10],corrected_code[9],corrected_code[8],corrected_code[6],corrected_code[5],corrected_code[4],corrected_code[2]};

    assign data_out=intermediate_wire;
    assign undefined_data=double_bit_error;
endmodule