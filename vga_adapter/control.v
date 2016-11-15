module control(
		input [3:0] dirControl,
		input clk,
		input reset_n;
		input [2:0] colour_in,
		output reg [7:0] x_out,
		output reg [6:0] y_out,
		output go,
		output reg [2:0] colour_out
	);
	wire [1:0] dir;
	dirControl u0(
		dirControl,
		dir
	);
	
	
	


endmodule

//dirOut[1] == 0 => up and dirOut[0] == 0 => Left.
module dirControl(
		input [3:0] dir,
		output reg [1:0] dirOut
	);
	always @(negedge dir[3])
	begin
		dirOut[1] <= 0;
	end

	always @(negedge dir[2])
	begin
		dirOut[1] <= 1;
	end

	always @(negedge dir[1])
	begin
		dirOut[0] <= 0;
	end

	always @(negedge dir[0])
	begin
		dirOut[0] <= 1;
	end

endmodule