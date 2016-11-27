module decimalTimer(
	input clk,
	input rst,
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
			count <= count + 1;
			if (count%100 == 0)
				shiftVal <= shiftVal + 1;
		end
	end



endmodule