
module highscoreSystem(
	input [1:0] decider,
	input en,
	input rst,
	input increment,
	output reg [3:0] hex2_out, hex3_out, hex1_out, hex5_out
);
	reg [10:0] curr_score;
	
	reg [10:0] first;
	reg [10:0] second;
	reg [10:0] third;
	reg [10:0] displayVal;

	reg num1, num2, num3;


	always @(posedge increment, negedge rst)
	begin
		if (!rst)
		begin
			curr_score <= 0;
			first <= 0;
			second <= 0;
			third <= 0;
			end
		else
		begin
			if (en) begin
				if (first)
				begin
					first <= curr_score;
				end
				else if (second)
				begin
					second <= curr_score;
				end
				else if (third)
				begin
					third <= curr_score;
				end
			end

			curr_score <= curr_score + 1;
			if (curr_score > first)
			begin

				num1 <= 1;
				if (first != second)
					first <= second;
			end
			else if (curr_score > second)
			begin
				if (third != second)
					third <= second;
				num2 <= 1;
			end
			else if (curr_score > third)
			begin
				num3 <= 1;
			end
		end
	end
	localparam self = 2'b00, one = 2'b01, two = 2'b10, three = 2'b11;
	always @(*)
	begin
		if (!en)
		begin
			displayVal = curr_score; 
		end
		else begin
			case (decider)
				self: displayVal = curr_score;
				one: displayVal = first;
				two: displayVal = second;
				third: displayVal = third; 
			endcase
			hex5_out = {2'b0, self};
		end

		hex1_out = displayVal%10;
		hex2_out = (displayVal/10)%10;
		hex3_out = (displayVal/100)%10;
	end

	
endmodule