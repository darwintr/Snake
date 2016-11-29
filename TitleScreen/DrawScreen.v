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

	always @(posedge clk)
	begin
		if (!rst)
		begin
			address <= 15'b0;
		end
		else begin
			if (showTitle || showGameOver || flash || showBlack)
				address <= address + 1;
		end
		if (address == 15'd19119)
			address <= 15'b0;
	end

	always @(*)
	begin
		colourOut = black;
		if (showGameOver)
			colourOut = red;
		else if (showBlack)
			colourOut = black;
		else if (showTitle)
			colourOut = title_ram_out;
		else if (flash)
			colourOut = gameover_ram_out == 1'b100 ? black : gameover_ram_out;
		x = address % 8'd160;
		y = address / 8'd160;
		
	end
endmodule