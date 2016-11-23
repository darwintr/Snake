`include "drawBlack.v"
`include "snakeLogic.v"
`include "mux.v"
`include "food.v"
`include "movementReader.v"
`include "snakeMovement.v"

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
	output LEDR;
	
	wire gameClock;
	//DIRECTIONAL DATA.
	wire [2:0] dir;
	wire wren;
	wire ld;
	wire update;
	wire row;
	wire [7:0] head_x;
	wire [6:0] head_y;
	wire [10:0] length;

	wire [7:0] food_x, snake_x, black_x;
	wire [6:0] food_y, snake_y, black_y;

	wire [2:0] food_colour_out, snake_colour_out, black_colour_out;
	
	assign black_colour_out = 0;
	assign HEX3 = head_x[7:4];
	assign HEX2 = head_x[3:0];
	assign HEX1 = {1'b0, head_y[6:4]};
	assign HEX0 = head_y[3:0];

	//RATE DIVIDERS
	rate_divider gameTick (
		clk,
		reset_n,
		31'd25_000_000, 
		gameClock
	);

	snakeLogic sl(
		.clk(clk),
		.rst(out_reset_n),
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
		.head_y(head_y)
		);

	food f(
		.clk(clk),
		.rst(rst),
		.h_x(head_x),
		.h_y(head_y),
		.dirControl(dirInControl),
		.en(food_en),
		.out_x(food_x),
		.out_y(food_y),
		.f_colour(food_colour_out),
		.grow(length)
		);

	drawBlackControl dbc(
		clk,
		reset_n,
		dbWren,
		out_reset_n
		);
	
	reg [7:0] d_x;
	reg [6:0] d_y;
	reg [2:0] dds_colour;

	decideDrawState dds(
		.b_x(black_x),
		.b_y(black_y),
		.d_x(d_x),
		.d_y(d_y),
		.colour_in(dds_colour),
		.drawWren(food_en || wren),
		.blackWren(blackWren),
		.wren(plot),
		.x_out(x_out),
		.y_out(y_out)
	);

	always @(*)
	begin
		d_x = 0;
		d_y = 0;
		dds_colour = 0;
		if (food_en)
		begin
			d_x = food_x;
			d_y = food_y;
			dds_colour = food_colour_out;
		end
		if (wren)
		begin
			d_x = snake_x;
			d_y = snake_y;
			dds_colour = colour_in;
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

	always @(posedge clk)
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
