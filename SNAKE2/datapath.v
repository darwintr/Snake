module datapath (
	input clk,
	input plot,
	input ld,
	input [2:0] dir,
	input update,
	input reset_n,
	input row,
	output reg [7:0] x,
	output reg [6:0] y
);
	
	reg [2:0] cnt;
	reg [7:0] initialx;
	reg [6:0] initialy;	
	always@(posedge clk, negedge reset_n)
	begin
		if (!reset_n) begin
			x <= 0;
			y <= 0;
			initialx <= 0;
			initialy <= 0;
			cnt <= 0;
		end
		else if (ld)
		begin
			initialx <= 8'd50;
			initialy <= 7'd30;
		end
		else if (update)
		begin
			if (dir[2]) begin
				if (dir[1])
					initialy <= initialy + 1;
				else
					initialy <= initialy - 1;				
			end
			else if (!dir[2]) begin
				if (dir[0])
					initialx <= initialx + 1;
				else 
					initialx <= initialx - 1;
			end
			cnt <= 0;
		end
		else if (plot)
		begin
			x <= row;
			y <= initialy + cnt;
			cnt <= cnt + 1;
			
		end
	end 

endmodule

