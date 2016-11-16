module datapath (
	input clk,
	input plot,
	input ld,
	input [2:0] dir,
	input update,
	input reset_n,
	output reg [7:0] x,
	output reg [6:0] y
);
	
	reg row, col; //Counters
	reg [7:0] initialx;
	reg [6:0] initialy;	
	always@(posedge clk)
	begin
		if (!reset_n) begin
			x <= 0;
			y <= 0;
			initialx <= 0;
			initialy <= 0;
			row <= 1'b0;
			col <= 1'b0;
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
			else begin
				if (dir[0])
					initialx <= initialx + 1;
				else 
					initialy <= initialy + 1;
			end
		end
		else if (plot)
		begin
			x <= initialx + col;
			y <= initialy + row;

			if (row)
				col <= col + 1;
			row <= row + 1;
		end
	end 

endmodule

