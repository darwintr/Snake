module decideDrawState(
		input [7:0] b_x,
		input [6:0] b_y,
		input [7:0] d_x,
		input [6:0] d_y,
		input [2:0] colour_in,
		input drawWren,
		input blackWren,
		output reg wren,
		output reg [7:0] x_out,
		output reg [6:0] y_out,
		output reg [2:0] colour_out
	);
	
	localparam black = 3'b000;

	always @(*)
	begin
		x_out = 0;
		y_out = 0;
		colour_out = black;
		if (blackWren)
		begin
			x_out = b_x;
			y_out = b_y;
		end
		else if (drawWren)
		begin
			x_out = d_x;
			y_out = d_y;
			colour_out = colour_in;
		end
		wren = drawWren | blackWren;
	end
	

endmodule