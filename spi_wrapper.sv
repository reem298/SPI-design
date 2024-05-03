module wrapper(input MOSI,input SS_n, input clk, input rst_n, output  MISO);

  wire tx_valid;
  wire [7:0] tx_data;
  wire [9:0] rx_data;
  wire rx_valid;

// instantiation 
SPI SPI(.MOSI(MOSI), .SS_n(SS_n),.tx_data(tx_data),.tx_valid(tx_valid),.clk(clk),.rst_n(rst_n),.MISO(MISO),.rx_data(rx_valid),.rx_valid(rx_valid));
SPR_ASYNC SPR_ASYNC(.din(rx_data),.rx_valid(rx_valid),.dout(tx_data),.tx_valid(tx_valid),.clk(clk),.rst_n(rst_n));
endmodule
