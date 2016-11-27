`include "HighScore/DecimalCounter.v"
`include "SnakeLogic/SnakeFSM.v"
`include "SnakeLogic/SnakeDatapath.v"
`include "SnakeLogic/Movement.v"
`include "HighScore/highscoreSystem.v"
module snakeInterface(
	input [3:0] dirInControl,
	input clk,
	input rst,
	input [2:0] colour_in,
	output [7:0] x_out,
	output [6:0] y_out,
	output [2:0] colour_out,
	output plot,
	output [3:0] hex0_out, hex1_out, hex2_out, hex3_out,
	output ledr_out
);

	assign hex0_out = 0;
	assign hex1_out = 0;


	wire lock;
	wire gameClock;
	wire fromBlack = 1'b1; 
	wire isDead;	
	wire [12:0] shiftVal;
	
	highscoreSystem highScores(

	);

	decimalTimer outputTimer(
		secondsClock,
		rst,
		shiftVal
	);

	rate_divider secondsTick (
		clk,
		rst,
		32'd100,		
		//32'd50_000_000,
		secondsClock
	);

	wire [31:0] upperLim = 32'd50_000_000/32'd4 - shiftVal << 32'd11;

	rate_divider gameTick (
		clk,
		rst,
		32'd100,
		//upperLim,
		gameClock
	);


	//PRIVATE FIELDS, NO TOUCHY.
	wire [3:0] cnt_status;
	wire [2:0] dirContOut;

	dirControl dirModule(
		.clk(clk),
		.dir(dirInControl),
		.reset_n(rst),
		.lockVal(lock),
		.dirOut(dirContOut)
	);

	controlMovement control(
		clk,
		rst,
		colour_in,
		length_inc, 
		gameClock,
		fromBlack,
		isDead,
		ld_head,
		ld_q_def,
		inc_address,
		rst_address,
		draw_q,
		cnt_status,
		update_head,
		ld_head_into_prev,
		ld_q_into_curr,
		ld_prev_into_q,
		ld_curr_into_prev,
		colour_out,
		draw_curr,
		food_en,
		check_inc
	);

	datapath dp(
		clk,
		rst,
		lock,
		check_inc,
		ld_head,
		ld_q_def,
		inc_address,
		rst_address,
		draw_q,
		cnt_status,
		update_head,
		ld_head_into_prev,
		ld_q_into_curr,
		ld_prev_into_q,
		ld_curr_into_prev,
		draw_curr,
		food_en,
		dirContOut,
		isDead, //TIS THE DEAD SIGNAL!
		plot,	
		x_out,
		y_out,
		length_inc
	);

	assign ledr_out = isDead;
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
