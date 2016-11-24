
`include "snakeLogic.v"

`include "food.v"

module snakeInterface(dirInControl, clk, reset_n, colour_in, colour_out, x_out, y_out, plot, HEX0, HEX1, HEX2, HEX3, LEDR);
	input [3:0] dirInControl;
	input clk;
	input reset_n;
	input [2:0] colour_in;
	output [7:0] x_out;
	output [6:0] y_out;
	output [2:0] colour_out;
	output plot;
	output [3:0] HEX0, HEX1, HEX2, HEX3;
	output [9:0] LEDR;
	
	wire gameClock;
	//DIRECTIONAL DATA.
	
	wire [7:0] head_x;
	wire [6:0] head_y;
	
	assign HEX3 = head_x[7:4];
	assign HEX2 = head_x[3:0];
	assign HEX1 = {1'b0, head_y[6:4]};
	assign HEX0 = head_y[3:0];
	//RATE DIVIDERS
	rate_divider gameTick (
		clk,
		reset_n,
		//32'd100,
		32'd10_000_000, 
		gameClock
	);
	snakeLogic sl(
		.clk(clk),
		.rst(reset_n),
		.colour_in(colour_in),
		.go(gameClock),
		.dirIn(dirInControl),
		.x(x_out),
		.y(y_out),
		.plotEn(plot),
		.colour_out(colour_out),
		.head_x(head_x),
		.head_y(head_y),
		.isDead(LEDR[0])
	);



	
endmodule

module rate_divider(
		input clk,
		input reset_n,
		input [31:0] val,
		output en
	);
	wire [31:0] top_rate = val;
	reg [31:0] curr;

	always @(posedge clk, negedge reset_n)
	begin
		if (!reset_n)
			curr <= top_rate;
		else if (curr > 0) 
		begin
			curr <= curr - 1'b1;
		end
		else
			curr <= top_rate;
	end

	assign en = ~|curr;
endmodule
