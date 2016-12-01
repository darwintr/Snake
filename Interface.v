`include "TitleScreen/DrawScreen.v"
`include "HighScore/DecimalCounter.v"
`include "SnakeLogic/SnakeFSM.v"
`include "SnakeLogic/SnakeDatapath.v"
`include "SnakeLogic/Movement.v"
`include "HighScore/highscoreSystem.v"
`include "TitleScreen/splash.v"


module snakeInterface(
	input [2:1] SW,
	input [3:0] dirInControl,
	input clk,
	input rst,  
	input [2:0] colour_in,
	output reg [7:0] x_out,
	output reg [6:0] y_out,
	output reg [2:0] colour_out,
	output plot,
	output [3:0] hex0_out, hex1_out, hex2_out, hex3_out, hex4_out, hex5_out,
	output ledr_out
);
	wire [7:0] snake_x_out, dbx;
	wire [6:0] snake_y_out, dby;
	wire [2:0] snake_colour_out, dbcolour;

	wire lock;
	wire gameClock;
	wire fromBlack; 
	wire isDead;	
	wire [31:0] shiftVal;
	wire drawBlack;

	splash splasher(
			clk,
			rst,
			isDead,
			&dirInControl,
			secondsClock,
			showTitle,
			drawBlack,
			showGameOver,
			flash,
			fromBlack,
			splasherWren
		);

	DrawBlack dbu(
			clk,
			rst,
			showTitle,
			drawBlack,
			showGameOver,
			flash,
			dbx,
			dby,
			dbcolour
		);

	highscoreSystem highScores(
		SW[2:1],
		clk,
		rst,
		isDead,
		length_inc,
		hex0_out,
		hex1_out,
		hex2_out,
		hex3_out,
		hex5_out
	);
	wire reset_ram;
	decimalTimer outputTimer(
		secondsClock,
		rst,
		~reset_ram,
		shiftVal
	);

	rate_divider secondsTick (
		clk,
		rst,
		//32'd100,		
		32'd50_000_000,
		secondsClock
	);

	reg [31:0] upperLim;
	
	always @(*)
	begin
		if (shiftVal == 32'd0)
			upperLim = 32'd10_000_000;
		else if (shiftVal == 32'd1)
			upperLim = 32'd9_000_000;
		else if (shiftVal == 32'd2)
			upperLim = 32'd8_000_000;
		else if (shiftVal == 32'd3)
			upperLim = 32'd7_000_000;
		else if (shiftVal == 32'd4)
			upperLim = 32'd6_000_000;
		else
			upperLim = 32'd5_000_000;

	end
	
	assign hex4_out = shiftVal;
	rate_divider gameTick (
		clk,
		rst,
		//32'd100,
		upperLim,
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
		draw_curr,
		food_en,
		check_inc,
		reset_ram
	);

	datapath dp(
		clk,
		rst,
		lock,
		check_inc,
		colour_in,
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
		reset_ram,
		isDead, //TIS THE DEAD SIGNAL!
		snake_plot,	
		snake_x_out,
		snake_y_out,
		snake_colour_out,
		length_inc
	);

	assign plot = snake_plot | splasherWren;

	always @(*)
	begin
		x_out = 0;
		y_out = 0;
		colour_out = 0;
		if (snake_plot)
		begin
			x_out = snake_x_out;
			y_out = snake_y_out;
			colour_out = snake_colour_out;
		end

		if (splasherWren)
		begin
			x_out = dbx;
			y_out = dby;
			colour_out = dbcolour;
		end
	end
	
	assign ledr_out = fromBlack; 
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
