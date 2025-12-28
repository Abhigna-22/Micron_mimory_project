`timescale 1ns/1ps

module double_error_detection_tb;

  reg  [7:0]  data_in;
  wire [12:0] code_out;
  reg  [12:0] corrupted_code;
  wire [7:0]  data_out;
  wire        error;
  wire undefined_data;

  integer i, bit_pos1,bit_pos2;

  // Encoder
  hamming_encoder enc (
    .data_in (data_in),
    .code_out(code_out)
  );

  // Decoder
  hamming_decoder dec (
    .hamming_bits (corrupted_code),
    .data_out     (data_out),
    .error        (error),
    .undefined_data(undefined_data)
  );

// For double-bit errors:
//  - error must be asserted
//  - undefined_data must be asserted
//  - data must not be silently trusted

  initial begin
        // VCD setup
        $dumpfile("double_error_detection_tb.vcd");
        $dumpvars(0, double_error_detection_tb);

        $display("Starting 4.4 double-Bit Error detection Test");

        // Loop over all input values
        for (i = 0; i < 256; i = i + 1) begin
            data_in = i[7:0];
            #1; // allow encoder to settle
            
            for (bit_pos1 = 0; bit_pos1 < 13; bit_pos1 = bit_pos1 + 1) begin    
                
                for(bit_pos2 =bit_pos1+1; bit_pos2 < 13; bit_pos2 = bit_pos2 + 1) begin        
                    
                    corrupted_code = code_out ^((13'b1 << bit_pos1)|(13'b1 << bit_pos2));      
                    #1; // allow decoder to settle                                             
                    
                    // Check correction                                                                                                                           
                    if (error !== 1'b1 ) begin
                        $display("FAIL: double bit error not detected input=%02h bits=%0d %02d",data_in, bit_pos1, bit_pos2);            
                        $finish;
                    end

                    // Must NOT silently correct
                    if ((data_out === data_in) && (undefined_data === 1'b0)) begin
                        $display(
                        "FAIL: double-bit error silently corrected input=%02h bits=%0d,%0d",
                        data_in, bit_pos1, bit_pos2
                        );
                        $display("input data=%b , output data=%b",data_in,data_out);
                        $display("corrupted_code = %b", corrupted_code);

                        $finish;
                    end
                    if (undefined_data !== 1'b1) begin
                        $display("FAIL: double-bit error not marked undefined input=%02h bits=%0d,%0d",);
                        $finish;
                    end
                end
            end
        end

        $display("PASS: 4.4 Double-Bit Error Detection Test");
        $finish;
    end
    

endmodule
