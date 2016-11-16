`include "control.v"
`include "datapath.v"

module ramInterface(dirControl, clk, reset_n, x_out, y_out, plot);
	input [3:0] dirControl;
	input clk;
	input reset_n;
	output [7:0] x_out;
	output [6:0] y_out;
	output plot;


	wire gameClock;
	//DIRECTIONAL DATA.
	wire [2:0] dir;
	wire wren;
	wire ld;
	wire update;

	assign plot = wren;

	dirControl directionalControl(
		dirControl,
		reset_n,
		dir
	);
	//END DIRECTIONAL DATA



	//RATE DIVIDERS
	rate_divider gameTick (
		clk,
		reset_n,
		20'd80,
		//20'd3_333_333, 
		gameClock
	);



	control controlUnit(
		gameClock,
        reset_n, 
        clk,
        wren,
        ld,
        update
	);

	datapath dataPathUnit(
		clk,
		wren,
		ld,
		dir,
		update,
		reset_n,
		x_out,
		y_out
	);	


	
endmodule



//dirOut[1] == 0 => up and dirOut[0] == 0 => Left.
module dirControl(
		input [3:0] dir,
		input reset_n,
		output reg [2:0] dirOut
	);

	always @(negedge reset_n)
	begin
		dirOut <= 0;
	end
	// LEFT
	always @(negedge dir[3])
	begin
		dirOut[1] <= 0;
		dirOut[2] <= 1;
	end

	// RIGHT
	always @(negedge dir[2])
	begin
		dirOut[1] <= 1;
		dirOut[2] <= 1;
	end

	// UP
	always @(negedge dir[1])
	begin
		dirOut[0] <= 0;
		dirOut[2] <= 0;
	end

	// DOWN
	always @(negedge dir[0])
	begin
		dirOut[0] <= 1;
		dirOut[2] <= 0;
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