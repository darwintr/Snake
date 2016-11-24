module food(clk, rst, h_x, h_y, dirControl, en, out_x, out_y, f_colour, grow);
	input clk;
	input rst;
	input [7:0] h_x;
	input [6:0] h_y;
	input [3:0] dirControl;
	input en;
	output reg [7:0] out_x;
	output reg [6:0] out_y;
	output reg [2:0] f_colour;
	output reg [10:0] grow;

	wire [7:0] temp_x;
	wire [6:0] temp_y;

	cnt rng(
		.clk(clk),
		.rst(rst),
		.x(temp_x),
		.y(temp_y)
		);

	reg [7:0] x;
	reg [6:0] y;

	wire head_in_food = x == h_x && y == h_y;
	reg [1:0] food_cnt;

	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			x <= 0;
			y <= 0;
			out_x <= 0;
			out_y <= 0;
			food_cnt <= 0;
			grow <= 11'd6;
			f_colour <= 3'b010;
		end
		else if (head_in_food)
		begin
			x <= temp_x;
			y <= temp_y;
			f_colour <= {temp_y[1:0], 1'b1};
		end
		else
		begin
			if (en)
			begin
				x <= x - x%4;
				y <= y - y%4;
				food_cnt <= food_cnt + 1;
				out_x <= x + food_cnt[0];
				out_y <= y + food_cnt[1];
			end
		end
		if (head_in_food)
		begin
			if (grow < 11'd200)
			begin
				grow <= grow + 1;
			end
			//if grow 200 win
		end
	end
endmodule

module cnt(clk, rst, x, y);
	input clk;
	input rst;
	output reg [7:0] x;
	output reg [6:0] y;

	always @(posedge clk, negedge rst) begin
		if (!rst) begin
			x <= 0;
			y <= 0;
		end
		else begin
			x <= x > 8'd159 ? 0 : x + 1;
			y <= y > 7'd119 ? 0 : y + 1;
		end
	end
endmodule