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
	
	always @(posedge clk, negedge reset_n)
	begin
		if (!reset_n)
			dirOut <= 3'b0;
		else
		begin
			if (input1 == 1'b0)
			begin
				dirOut[1] <= 0;
				dirOut[2] <= 1;
			end
			else if (input2 == 1'b0)
			begin
				dirOut[1] <= 1;
				dirOut[2] <= 1;
			end
			else if (input3 == 1'b0)
			begin
				dirOut[0] <= 0;
				dirOut[2] <= 0;
			end
			else if (input4 == 1'b0)
			begin
				dirOut[0] <= 1;
				dirOut[2] <= 0;
			end
		end
	end
endmodule


