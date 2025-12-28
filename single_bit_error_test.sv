`timescale 1ns/1ps

module single_bit_error_test;

  reg  [7:0]  data_in;
  wire [12:0] code_out;
  reg  [12:0] corrupted_code;
  wire [7:0]  data_out;
  wire        error;

  integer i, bit_pos;

  // Encoder
  hamming_encoder enc (
    .data_in (data_in),
    .code_out(code_out)
  );

  // Decoder
  hamming_decoder dec (
    .hamming_bits (corrupted_code),
    .data_out     (data_out),
    .error        (error)
  );

  initial begin
    // VCD setup
    $dumpfile("single_bit_error_test.vcd");
    $dumpvars(0, single_bit_error_test);

    $display("Starting 4.3 Single-Bit Error Injection Test");

    // Loop over all input values
    for (i = 0; i < 256; i = i + 1) begin
      data_in = i[7:0];
      #1; // allow encoder to settle

      // Flip each bit one at a time
      for (bit_pos = 0; bit_pos < 13; bit_pos = bit_pos + 1) begin
        corrupted_code = code_out ^ (13'b1 << bit_pos);
        #1; // allow decoder to settle

        // Check correction
        if (data_out !== data_in) begin
          $display(
            "FAIL: data mismatch input=%02h bit_flipped=%0d decoded=%02h",
            data_in, bit_pos, data_out
          );
          $finish;
        end

        // Check error flag
        if (error !== 1'b1) begin
          $display(
            "FAIL: error flag not set input=%02h bit_flipped=%0d",
            data_in, bit_pos
          );
          $finish;
        end
      end
    end

    $display("PASS: 4.3 Single-Bit Error Injection Test");
    $finish;
  end

endmodule
