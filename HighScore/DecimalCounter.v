module decimalTimer(
	input clk,
	input rst,
	input en,
	output reg [12:0] shiftVal
);

	reg [12:0] count;
	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			count <= 0;
			shiftVal <= 0;

		end
		else begin
			if (!en)
				count <= count + 1;
			else begin
				count <= 0;
			end
			if (count%30 == 0)
				shiftVal <= shiftVal + 1;
		end
	end



endmodule