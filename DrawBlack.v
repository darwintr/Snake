`include "ram.v"

module DrawBlack(
		input clk,
		input rst,
		input showTitle,
		input showGameOver,
		output reg [7:0] x,
		output reg [6:0] y,
		output reg [2:0] colourOut
	);
	
	wire [2:0] red_ram_out, black_ram_out, title_ram_out;
	wire red_wren, black_wren, title_wren;
	wire [10:0] address;

	ramRed red (
		.address(address),
		.clock(clk),
		.data(0),
		.wren(0)
		.q(red_ram_out)
		);

	ramBlack black (
		.address(address),
		.clock(clk),
		.data(0),
		.wren(0),
		.q(black_ram_out)
		);

	//ramTitle title ();

	reg [7:0] count_x;
	reg [6:0] count_y;



	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			count_x <= 0;
			count_y <= 0;
			x <= 0;
			y <= 0;
			colourOut <= 0;
		end
		else begin
			
		end
	end



endmodule