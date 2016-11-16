`include "ramWrapper.v"
`include "ram.v"

module ramInterface(dirControl, clk, reset_n, x_out,	y_out, plot, status);
	input [3:0] dirControl;
	input clk;
	input reset_n;
	output [7:0] x_out;
	output [6:0] y_out;;
	output plot;
	output [1:0] status;


	wire gameClock;
	wire fourClock;
	//DIRECTIONAL DATA.
	wire [1:0] dir;
	wire [10:0] address;
	wire wren;
	dirControl directionalControl(
		dirControl,
		dir
	);
	//END DIRECTIONAL DATA



	//RATE DIVIDERS
	rate_divider gameClock (
		clk,
		reset_n,
		20'd200,
		//20'd138889, 
		gameClock
	);

	rate_divider everyFour (
		clk,
		reset_n,
		20'd4,
		fourClock
	);
	wire [16:0] q;
	ramControl ramPart1(
		fourClock, //THIS CLOCK IS RATE DIVIDED BY 4!
		reset_n,
		gameClock,
		dir,
		q,
		wren,
		data,
		address
	);

	ramDataPath ramOut(
		address,
		wren,
		data,
		x_out,
		y_out,
		type,
		q
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

module rate_divider(
		input clk,
		input reset_n,
		input [19:0] val,
		output en
	);
	wire [19:0] top_rate = val;
	reg [19:0] curr;

	always @(posedge clk)
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