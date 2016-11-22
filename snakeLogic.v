`include "movementReader.v"
`include "snakeMovement.v"
`include "snakedatapath.v"


module snakeLogic(clk, rst, dirIn, go, length, colour_in, x, y, plotEn, colour_out);
	input clk;
	input rst;
	input [2:0] colour_in;
	input go;
	input [3:0] dirIn;
	input [10:0] length;

	output [7:0] x;
	output [6:0] y;
	output plotEn;
	output [2:0] colour_out;
	wire [1:0] cnt_status;
	wire [2:0] dirContOut;
	wire isDead;

	dirControl dirModule(
			.clk(clk),
			.dir(dirIn),
			.reset_n(rst),
			.dirOut(dirContOut)
		);



	controlMovement control(
			clk,
			rst,
			colour_in,
			length, 
			go,
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
			draw_curr
		);

	datapath dp(
			clk,
			rst,
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
			dirContOut,
			isDead,
			plotEn,
			x,
			y
		);


endmodule 
