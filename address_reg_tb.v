`timescale 1ns/1ps

module address_reg_tb;

    reg  [1:0] in_address;
    wire [3:0] out_address;
    reg clk;
    //reg reset;

    address_decoder DUT (
        .clk(clk),
        //.reset(reset),
        .in_address(in_address),
        .out_address(out_address)
    );

    // 20 ns clock
    initial clk = 0;
    always #10 clk = ~clk;

    integer i;

    initial begin
        in_address = 0;
        //reset = 1;

        $dumpfile("addr_reg.vcd");
        $dumpvars(0, address_reg_tb);

        // Hold reset for 2 cycles
        // repeat (2) @(posedge clk);
        // reset = 0;

        // Apply addresses cycle by cycle
        for (i = 0; i < 4; i = i + 1) begin
            @(posedge clk);
            in_address = i[1:0];
        end

        // Observe outputs
        repeat (3) @(posedge clk);

        $finish;
    end

endmodule
