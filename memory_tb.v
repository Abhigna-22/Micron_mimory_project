`timescale 1ps/1ps

module memory_tb();

localparam width = 4;
localparam data_width=8;

reg clk, write_enb,read_enb,reset;
reg [width-1:0]address; 
reg [data_width-1:0] data_in;
wire[data_width-1:0] data_out;

memory #(.width(width),
             .data_width(data_width))
          DUT  (.clk(clk),
            .reset(reset),
             .write_enb(write_enb),
             .read_enb(read_enb), 
             .address(address), 
             .data_in(data_in),
             .data_out(data_out));

//clock generation 
always #5 clk=~clk;

initial
begin
    $dumpfile("memory_sim.vcd");
    $dumpvars(0, memory_tb);
    // Initial conditions
        clk       = 0;
        reset     = 1;
        write_enb = 0;
        address   = 0;
        data_in   = 0;
        read_enb  = 0;
    
    // TC1: reset
        //#5 reset=1;
        #5 reset=0;

    // TC2: Write 0xA5 to address 3
        write_enb=1'b1;
        address=4'h3;
        data_in=8'hA5;
        #10;
    // disable write
        write_enb=0;
        #10;
    // Read address 3
        address=4'h3; read_enb=1;
        #10;
    //TC3: multiple writes
        write_enb=1;read_enb=0;
        address=4'h1; data_in=8'h11;#10;
        address=4'h2; data_in=8'h22;#10;
        address=4'h3; data_in=8'h33;#10;
        write_enb=0;

    //read back
        address=4'h1;read_enb=1;#10;        
        address=4'h2;read_enb=0;#10;
        address=4'h3;read_enb=1;#10;

    // TC4: Read-after-write
        write_enb=1;read_enb=0;
        address=4'h5;
        data_in=8'h5;
        #10;
        write_enb=0;
        address=4'h5;read_enb=1;
        #10;
        read_enb=0;
        //finish
        #20;
        $finish;
end
endmodule


