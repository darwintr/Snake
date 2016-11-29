//dirOut[1] == 0 => up and dirOut[0] == 0 => Left.
module dirControl(
		input clk,
		input [3:0] dir,
		input reset_n,
		output reg lockVal,
		output reg [2:0] dirOut
	);
	
	wire input1 = dir[3];
	wire input2 = dir[2];
	wire input3 = dir[1];
	wire input4 = dir[0];
	
	always @(posedge clk, negedge reset_n)
	begin
		if (!reset_n)
		begin
			dirOut <= 3'b0;
			lockVal <= 0;
		end
		else
		begin
			if (~input2)
			begin
				dirOut[1] <= 0;
				dirOut[2] <= 1;
				lockVal <= 1;
			end
			else if (~input3)
			begin
				
				dirOut[1] <= 1;
				dirOut[2] <= 1;
				lockVal <= 1;
			end
			else if (~input1)
			begin
				dirOut[0] <= 0;
				dirOut[2] <= 0;
				lockVal <= 1;
			end
			else if (~input4)
			begin
				dirOut[0] <= 1;
				dirOut[2] <= 0;
				lockVal <= 1;
			end
			else
				lockVal <= 0;
			
		end
	end
endmodule


