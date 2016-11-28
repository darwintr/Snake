`include "ram_title.v"
`include "ram_gameover.v"
module DrawBlack (
		input clk,
		input rst,
		input showTitle,
		input showBlack,
		input showGameOver,
		input flash,
		output reg [7:0] x,
		output reg [6:0] y,
		output reg [2:0] colourOut
	);
	
	wire [2:0] red, black, title_ram_out, gameover_ram_out;
	reg [14:0] address;

	assign red = 3'b100;
	assign black = 3'b0;

	ram_title title (
		.address(address),
		.clock(clk),
		.data(3'b0),
		.wren(1'b0),
		.q(title_ram_out)
		);

	ram_gameover gameover (
		.address(address),
		.clock(clk),
		.data(3'b0),
		.wren(1'b0),
		.q(gameover_ram_out)
		);

	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			address <= 0;
		end
		else begin
			if (showTitle || showGameOver || flash)
			address <= address + 1;
		end
	end

	always @(*)
	begin
		if (showGameOver)
			colourOut = red;
		else if (showBlack)
			colourOut = black;
		else if (showTitle)
			colourOut = title_ram_out;
		else if (flash)
			colourOut = title_ram_out == 3'b100 ? black : title_ram_out;
		x = address % 8'd160;
		y = address / 8'd160;
	end
endmodule