module drawBlack(
		input clk,
		input reset_n,
		input plot,
		output reg [7:0] x,
		output reg [6:0] y
	);

	reg [7:0] row;
	reg [6:0] col;

	always @(posedge clk, negedge reset_n)
	begin
		if (!reset_n)
		begin
			x <= 0;
			y <= 0;
		end
		else if (plot)
		begin
			if (y == 7'd120)
			begin
				y <= 0;
			end
			if (x == 8'd160)
			begin
				x <= 0;
				y <= y + 1;
			end
			x <= x + 1;
			if (y >= 7'd120 && x >= 8'd160)
			begin
				x <= 0;
				y <= 0;
			end
		end
	end
endmodule

module drawBlackControl (
		input clk,
		input reset_n,
		output reg dbWren
	);
	reg [19:0] cnt; 
	wire[31:0] count_to = 32'd25_000_000;
	wire [31:0] cycles_needed = 32'd19_200;

	always @(posedge clk)
	begin
		dbWren <= 0;
		if (!reset_n)
			cnt <= 0;
		if (cnt >= count_to - cycles_needed)
			dbWren <= 1;
		if (cnt >= count_to)
			cnt <= 0;
		cnt <= cnt + 1;
	end

endmodule