`include "ram_title.v"
module DrawBlack(
		input clk,
		input rst,
		input showTitle,
		input showBlack,
		input showGameOver,
		output reg [7:0] x,
		output reg [6:0] y,
		output reg [2:0] colourOut
	);
	
	wire [2:0] red, black, title_ram_out;
	wire red_wren, black_wren, title_wren;
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

	reg [7:0] count_x;
	reg [6:0] count_y;

	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			count_x <= 0;
			count_y <= 0;
			address <= 0;
		end
		else begin
			if (count_x > 159)
			begin
				count_x <= 0;
				count_y <= count_y + 1;
			end
			else
				count_x <= count_x + 1;
			address <= {count_x, count_y};
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
		x = count_x;
		y = count_y;
	end
endmodule