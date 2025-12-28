module exhaustive_encode_decode_test();
reg [7:0] data_in;

wire [12:0] interconnect_wire;
wire [7:0] data_out;
wire error;
integer i;

hamming_encoder enc(
    .data_in(data_in),   // 8-bit data input
    .code_out(interconnect_wire));

hamming_decoder dec(
    .hamming_bits(interconnect_wire),   // 13-bit Hamming code input
    .data_out(data_out), // 8-bit message bits data output
    .error(error));

initial begin
        // VCD setup
    $dumpfile("exhaustive_encode_decode_test.vcd");
    $dumpvars(0, exhaustive_encode_decode_test);


    $display("Starting 4.2 Exhaustive Encode–Decode Test");
    for(i=0;i<256;i++)begin
        data_in=i[7:0];
        #1;
        //assertion minimal style
        if(data_in!==data_out) begin
            $display("FAIL @ input=%02h decoded=%02h", data_in, data_out);
            $finish;
        end
         if(error!==1'b0)begin
            $display("FAIL (unexpected error) @ input=%02h, intermediate wire=%b", data_in, interconnect_wire);
            $finish;
        end       
    end
  $display("PASS: 4.2 Exhaustive Encode–Decode Test");
  $finish;
end

endmodule

