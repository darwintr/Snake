
`include "SnakeFSM.v"
`include "SnakeDatapath.v"
`include "Movement.v"

module snakeInterface(
	input [3:0] dirInControl,
	input clk,
	input rst,
	input [2:0] colour_in,
	output [7:0] x_out,
	output [6:0] y_out,
	output [2:0] colour_out,
	output plot,
	output reg [3:0] HEX0, HEX1, HEX2, HEX3,
	output [9:0] LEDR
);
	wire gameClock;
	//DIRECTIONAL DATA.
	wire fromBlack = 1'b1; //THIS IS THE ENABLE 
							//Signal for draw black.
	reg [7:0] head_x;
	reg [6:0] head_y;
	wire [1:0] cnt_status;
	wire [2:0] dirContOut;
	wire [14:0] head;
	wire isDead;	

	assign LEDR[0] = isDead;
	always @(*) begin
		head_x = head[14:7];
		head_y = head[6:0];
		HEX3 = head_x[7:4];
		HEX2 = head_x[3:0];
		HEX1 = {1'b0, head_y[6:4]};
		HEX0 = head_y[3:0];
	end

	rate_divider gameTick (
		clk,
		rst,
		32'd100,
		//32'd10_000_000, 
		gameClock
	);

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
		head,
		length_inc
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
