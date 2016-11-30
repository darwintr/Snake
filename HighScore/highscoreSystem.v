
module highscoreSystem(
	input [1:0] decider,
	input clk,
	input rst,
	input isDead,
	input increment,
	output reg [3:0] hex0_out, hex1_out, hex2_out, hex3_out, hex5_out
);
	reg [10:0] curr_score;
	
	reg [10:0] first;
	reg [10:0] second;
	reg [10:0] third;
	reg [10:0] displayVal;

	reg num1, num2, num3;

	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			first <= 0;
			second <= 0;
			third <= 0;
		end
		else if (isDead)
		begin
			if (curr_score > first)
			begin
				if (first != second)
					first <= second;
			end
			else if (curr_score > second)
			begin
				if (third != second)
					third <= second;
			end
			else if (curr_score > third)
			begin
				third <= curr_score;
			end

		end
	end

	always @(posedge increment, negedge rst)
	begin
		if (!rst)
		begin
			curr_score <= 0;
		end
		else if (isDead)
		begin
			curr_score <= 0;
		end
		else
		begin


			curr_score <= curr_score + 1;
			
		end
	end
	localparam self = 2'b00, one = 2'b01, two = 2'b10, three = 2'b11;	

	always @(*)
	begin
		case (decider)
			self: displayVal = curr_score;
			one: displayVal = first;
			two: displayVal = second;
			three: displayVal = third; 
		endcase
		hex5_out = {2'b0, decider};
		hex0_out = 0;
		hex1_out = displayVal%10;
		hex2_out = (displayVal/10)%10;
		hex3_out = (displayVal/100)%10;
	end

endmodule