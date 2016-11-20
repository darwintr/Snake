`include "ram.v"

module controlDraw(
	
);

endmodule;

//dirOut[1] == 0 => up and dirOut[0] == 0 => Left.
module dirControl(
		input clk,
		input [3:0] dir,
		input reset_n,
		output reg [2:0] dirOut
	);
	
	wire input1 = dir[3];
	wire input2 = dir[2];
	wire input3 = dir[1];
	wire input4 = dir[0];
	
	always @(posedge clk)
	begin
		if (!reset_n)
			dirOut <= 0;
			
		if (input1 == 0)
		begin
			dirOut[1] <= 0;
			dirOut[2] <= 1;
		end
		else if (input2 == 0)
		begin
			dirOut[1] <= 1;
			dirOut[2] <= 1;
		end
		else if (input3 == 0)
		begin
			dirOut[0] <= 0;
			dirOut[2] <= 0;
		end
		else if (input4 == 0)
		begin
			dirOut[0] <= 1;
			dirOut[2] <= 0;
		end
	end
endmodule


module datapath(
	input clk,
	input rst,

	input update_head,
	input drawQ,
	input ld_head,
	input ld_def,
	input drawCurr,
	input rowNum,
	input colNum,
	input ld_head_prev,
	input ld_q_curr,
	input ld_prev_q,
	input ld_curr_prev,
	input inc_address,
	input rst_address,
	input ld_curr_prev,
	input inc_address,
	input [2:0] dirIn,
	
	output reg isDead,
	output reg plotEn,
	output reg [7:0] x,
	output reg [6:0] y
	
);

	reg [10:0] address;
	reg [14:0] curr, prev, head;


endmodule