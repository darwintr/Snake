module datapath (
	input clk,
	input [7:0] x_in,
	input [6:0] y_in,
	input go,
	input reset_n,
	output reg [7:0] x,
	output reg [6:0] y
);
	
	reg [1:0] row, col; //Counters

	always@(posedge clk)
	begin
		if (!reset_n) begin
			x <= 0;
			y <= 0;
			row <= 1'b0;
			col <= 1'b0;
		end

		else if (go)
		begin
			x <= x_in + col;
			y <= y_in + row;

			if (&row)
				col <= col + 1;
			row <= row + 1;
		end
	end 

endmodule

