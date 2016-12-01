module decimalTimer(
	input clk,
	input rst,
	input en,
	output reg [31:0] shiftVal
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
			if (en)
			begin	
				if (count%15 == 0)
					shiftVal <= shiftVal + 32'd1;
				count <= count + 1;
			end
			else begin
				shiftVal <= 0;
				count <= 0;
			end
		end
	end



endmodule