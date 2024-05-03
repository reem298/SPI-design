module SPI(input MOSI,input SS_n, input [7:0] tx_data,
  input tx_valid, input clk, input rst_n, output reg MISO,
   output reg [9:0] rx_data, output reg rx_valid);
parameter IDLE=3'b000, WRITE=3'b001,READ_ADDRESS=3'b010, READ_DATA=3'b011, CHK_CMD=3'b100;
reg [4:0] cs, ns;
reg read_chk;


// state memory
always @(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
  cs<=IDLE;
  read_chk<=0;
  end
  else begin
    cs<=ns;
    if(ns==READ_ADDRESS)
    read_chk<=1;
    else if(ns==READ_DATA)
    read_chk<=0;
  end
end


//next state
always @(*) begin
	case(cs)
		IDLE: begin
		if(SS_n) ns=IDLE;
		else ns=CHK_CMD;
		end

		CHK_CMD:begin
		if(SS_n) ns=IDLE;
		else if (~SS_n&& ~MOSI) ns=WRITE;
		else if (~SS_n&& MOSI&& ~read_chk) ns=READ_ADDRESS;
		else if (~SS_n&& MOSI&& read_chk) ns=READ_DATA;
		end

		WRITE: begin
		if(SS_n) ns=IDLE;
		else ns=WRITE;
		end

		READ_ADDRESS:begin
		if(SS_n) ns=IDLE;
		else ns=READ_ADDRESS;
		end

		READ_DATA:begin
		if(SS_n) ns=IDLE;
		else ns=READ_DATA;
		end

	endcase
end


//output logic
integer i=0,count=0;
always @(posedge clk) begin
	case(cs)
		CHK_CMD:begin
		 rx_data<=0;
		 rx_valid<=0;
		 MISO<=0;
		end

		IDLE:begin
		 rx_data<=0;
		 rx_valid<=0;
		 MISO<=0;
		end

     WRITE:begin 
        rx_data<={rx_data[8:0],MOSI};
        if(count<9) begin
        	rx_valid<=0;
          MISO<=0; 
          count<=count+1;
           end
        else
        rx_valid<=1;
        count<=0;
        end

		    READ_ADDRESS:begin
             rx_data<={rx_data[8:0],MOSI};
             if(count<9) begin
              rx_valid<=0;
             MISO<=0;
             count<=count+1;
             end
             else
             rx_valid<=1;
             count<=0;          
            end

		READ_DATA:begin
			//series to parallel
		rx_data<={rx_data[8:0],MOSI}; 
             if(count<9) begin
             rx_valid<=0;
             count<=count+1;
             end
             else begin
             rx_valid<=1;
             count<=0;
             end
             //parallel to series
             if(tx_valid)begin
              MISO<=tx_data[7-i];
              i<=i+1;
              if(i==7) 
              i<=0;
              end
             else 
              MISO<=0;
            end  

	endcase
end


endmodule