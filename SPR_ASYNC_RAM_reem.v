module SPR_ASYNC #(parameter MEM_DEPTH = 256, ADDR_SIZE = 8)(input [9:0]din, input rx_valid, output reg [7:0] dout, output reg tx_valid, 
    input clk, input rst_n);

reg [ADDR_SIZE-1:0] write_address;
reg [ADDR_SIZE-1:0] read_address;
reg[7:0] mem[MEM_DEPTH-1:0]; //memory size

always @(posedge clk ) begin
if(~rst_n)  begin 
dout<=8'b0;
tx_valid<=0;
end 

else if (rx_valid) begin
case(din[9:8])
2'b00: write_address<=din[7:0];
2'b01: mem[write_address]<=din[7:0];
2'b10: begin 
    read_address<=din[7:0];
    tx_valid<=1;
    end

2'b11: begin
 dout<=mem[read_address];
	   tx_valid<=1;
        end
   endcase
  end	
 end

endmodule