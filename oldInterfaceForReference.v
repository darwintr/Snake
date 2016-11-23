`include "control.v"
`include "datapath.v"
`include "drawBlack.v"

module ramInterface(dirInControl, clk, reset_n, colour_in, colour_out, x_out, y_out, plot, HEX0, HEX1, HEX2, HEX3);
	input [3:0] dirInControl;
	input clk;
	input reset_n;
	input [2:0] colour_in;
	output [2:0] colour_out;
	output [7:0] x_out;
	output [6:0] y_out;
	output plot;
	output [3:0] HEX0, HEX1, HEX2, HEX3;
	
	wire gameClock;
	//DIRECTIONAL DATA.
	wire [2:0] dir;
	wire wren;
	wire ld;
	wire update;
	wire row;
	
	assign HEX3 = x_out[7:4];
	assign HEX2 = x_out[3:0];
	assign HEX1 = {1'b0, y_out[6:4]};
	assign HEX0 = y_out[3:0];


	dirControl directionalControl(
		clk,
		dirInControl,
		reset_n,
		dir
	);
	//END DIRECTIONAL DATA



	//RATE DIVIDERS
	rate_divider gameTick (
		clk,
		reset_n,
		31'd25_000_000, 
		gameClock
	);



	control controlUnit(
		gameClock,
        reset_n, 
        clk,
		  colour_in,
        wren,
        ld,
        update,
		  colour_out,
		  row
	);

	datapath dataPathUnit(
		clk,
		wren,
		ld,
		dir,
		update,
		reset_n,
		row,
		x_out,
		y_out
	);
	
	assign plot = wren;

	
	
endmodule


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

module rate_divider(
		input clk,
		input reset_n,
		input [31:0] val,
		output en
	);
	wire [31:0] top_rate = val;
	reg [31:0] curr;

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
