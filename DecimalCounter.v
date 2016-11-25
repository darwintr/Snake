module decimalTimer(
	input clk,
	input rst,
	output reg [3:0] hex0_out, hex1_out, hex2_out, hex3_out
);

	reg [12:0] count;
	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			count <= 0;
		end
		else begin
			count <= count + 1;
		end
	end

	always @(*)
	begin
		hex0_out = count%10;
		hex1_out = count/10%10;
		hex2_out = count/100%10;
		hex3_out = count/1000;
	end

endmodule