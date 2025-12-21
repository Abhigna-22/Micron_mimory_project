module memory#(parameter width=4, data_width=8)
               (input clk, write_enb,read_enb, reset,
                input [width-1:0]address, 
                input [data_width-1:0] data_in,
                output reg[data_width-1:0]data_out);

reg [data_width-1:0] DRAM_block [0:(1<<width)-1]; //of data width is 8 then 1<<8= 1 0000 0000 -1=255


always@(posedge clk or posedge reset)begin
    if(reset==1) data_out<={data_width{1'b0}};

    else if(write_enb) begin DRAM_block[address]<=data_in; end

        //clock gating read operation
    else if(read_enb)
         data_out<=DRAM_block[address];

end
endmodule