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
	input inc_address,
	input ld_q_prev,
	input update_prev,
	input ld_q_curr,
	input ld_prev_q,
	output reg ld_curr_prev,
	output reg inc_address
	output [15:0] currLoc,
	output [7:0] x,
	output [6:0] y
	
);





endmodule