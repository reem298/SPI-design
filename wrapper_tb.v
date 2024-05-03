module wrapper_tb(); 
reg MOSI,SS_n, clk,rst_n;
wire MISO;

// Instantiation
wrapper spi_inst (.MOSI(MOSI),.SS_n(SS_n),
    .clk(clk),.rst_n(rst_n),.MISO(MISO));

// clock generator
initial begin 
clk=0;
forever 
#1 clk=~clk;
end

initial begin
//IDLE state
SS_n=1;
rst_n=0;
MOSI=$random;
#10

//CHK_CMD state
rst_n=1;
SS_n=0; //master is ready 
MOSI=0;

//WRITE state 00
#1 MOSI=0;
repeat (8) begin
   #1 MOSI=$random;
end
//rx_data[9:0] = MOSI
//rx_valid = 1
//ram should get rx_data as din
//din[9:8] for storing din[7:0] in write_address

SS_n=1;
//end of communication with master
#10

//back to IDLE
SS_n=0; //master is ready 
MOSI=0; //CHK_CMD

//WRITE state 01
#1 MOSI=1;
repeat (8) begin
   #1 MOSI=$random;
end
//rx_data[9:0] = MOSI
//rx_valid = 1
//ram should get rx_data as din
//din[9:8] for storing din[7:0] in mem[write_address] 
//(write_address = previous din[7:0])
SS_n=1;
//end of communication with master
#10

//back to IDLE
SS_n=0; //master is ready 
MOSI=1; //CHK_CMD

//READ state 10
#1 MOSI=0;
repeat (8) begin
   #1 MOSI=$random;
end
//rx_data[9:0] = MOSI
//rx_valid = 1
//ram should get rx_data as din
//din[9:8] for storing din[7:0] in read_address 
SS_n=1;
//end of communication with master
#10

//back to IDLE
SS_n=0; //master is ready 
MOSI=1; //CHK_CMD

//READ state 11
#1 MOSI=1;
repeat (8) begin
   #1 MOSI=$random;
end
//rx_data[9:0] = MOSI
//rx_valid = 1 but din[7:0] are dummy data
//ram should get rx_data as din
//din[9:8] for storing din[7:0] in mem[read_address]
//(read_address = previous din[7:0])
//tx-valid = 1 from RAM 
//tx_data = dout
//MISO = tx_data
#12
$display("MISO=%b", MISO);
SS_n=1;
//end of communication with master
#10;
$stop;
end
endmodule