`timescale 1ns/1ps
module SPR_ASYNC_TB();
reg [9:0]din;
reg rx_valid;
reg clk;
reg rst_n;
wire [7:0] dout;
wire tx_valid; 

//instantiation
SPR_ASYNC m1(din,rx_valid,dout,tx_valid,clk,rst_n);

//clock generation
initial begin 
clk=0;
forever 
#1 clk=~clk;
end

initial begin

	rst_n=0;
	#10;
	if(dout!=8'b0 && tx_valid!=0)
	$display("test faild");
	
	rst_n=1;
	rx_valid=0;
	#10
	if(dout!=8'b0)
    $display("test faild");

   //wirte
    rx_valid=1;
    din={2'b00,8'b0};
    #10
    //hold the value 8'b0 as write_address for the following operation


    din={2'b01,8'b01};
    #10
    //check the write_adress(8'b0) should have 8'b01


    //read address
    din={2'b10,8'b0};
    #10
    //check read_address should be 8'b0
     if (tx_valid!=1) 
    	$display("test faild");
	
     din={2'b11,8'b11};
    #10
     if (dout!=8'b01 && tx_valid!=1) 
    	$display("test faild");

     rx_valid = 0;
    #5	

    // Write operation to different address
    rx_valid = 1;
    din = {2'b01, 8'b11}; // Write to address 
    #10
    rx_valid = 0;
    #5	

    	
    rx_valid = 1;
    din = {2'b11, 8'b01}; // Read from address 
    #10
    rx_valid = 0;
    #5;
    
end


// Display output
  always @(posedge clk) begin
    if (tx_valid)
      $display("din:%b,rst_n:%b,clk:%b,tx_valid:%b,rx_valid:%b,dout: %b",din,rst_n,clk,tx_valid,rx_valid,dout);
      
  end

endmodule
	

