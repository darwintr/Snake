module control(
		input [3:0] dirControl,
		input clk,
		input reset_n;
		output reg [7:0] x_out,
		output reg [6:0] y_out,
		output reg go,
		output reg [1:0] status,
	);
	wire [1:0] dir;
	dirControl directionalControl(
		dirControl,
		dir
	);
	
	ram ramUnit(
		
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