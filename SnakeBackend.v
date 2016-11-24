
`include "snakeLogic.v"

`include "food.v"

module snakeInterface(dirInControl, clk, reset_n, colour_in, colour_out, x_out, y_out, plot, HEX0, HEX1, HEX2, HEX3, LEDR);
	input [3:0] dirInControl;
	input clk;
	input reset_n;
	input [2:0] colour_in;
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	output reg [2:0] colour_out;
	output reg plot;
	output [3:0] HEX0, HEX1, HEX2, HEX3;
	output [9:0] LEDR;
	
	wire gameClock;
	//DIRECTIONAL DATA.
	
	wire [7:0] head_x, food_x, snake_x;
	wire [6:0] head_y, food_y, snake_y;
	wire [10:0] length;
	wire [2:0] food_colour_out, snake_colour_out;
	
	
	assign HEX3 = head_x[7:4];
	assign HEX2 = head_x[3:0];
	assign HEX1 = {1'b0, head_y[6:4]};
	assign HEX0 = head_y[3:0];

	//RATE DIVIDERS
	rate_divider gameTick (
		clk,
		reset_n,
		32'd100,
		//32'd25_000_000, 
		gameClock
	);

	snakeLogic sl(
		.clk(clk),
		.rst(reset_n),
		.colour_in(colour_in),
		.go(gameClock),
		.dirIn(dirInControl),
	 	.length(length),
		.x(snake_x),
		.y(snake_y),
		.plotEn(wren),
		.food_en(food_en),
		.colour_out(snake_colour_out),
		.head_x(head_x),
		.head_y(head_y),
		.isDead(LEDR[0])
		);

	food f(
		.clk(clk),
		.rst(reset_n),
		.h_x(head_x),
		.h_y(head_y),
		.dirControl(dirInControl),
		.en(food_en),
		.out_x(food_x),
		.out_y(food_y),
		.f_colour(food_colour_out),
		.grow(length)
	);

	always @(*)
	begin
		plot = wren | food_en;
		x_out = 8'b0;
		y_out = 7'b0;
		colour_out = 0;
		if (wren)
		begin
			x_out = snake_x;
			y_out = snake_y;
			colour_out = snake_colour_out;
		end

		if (food_en)
		begin
			x_out = food_x;
			y_out = food_y;
		end
	end

	
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
