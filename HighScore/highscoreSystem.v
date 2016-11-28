
module highscoreSystem(
	input rst,
	input increment,
	output [3:0] hex2_out, hex3_out, hex1_out
);
	reg [11:0] curr_score;
	
	

		
	always @(posedge increment, negedge rst)
	begin
		if (!rst)
			curr_score <= 0;
		else
			curr_score <= curr_score + 1;
	end

	assign hex1_out = curr_score%10;
	assign hex2_out = (curr_score/10)%10;
	assign hex3_out = (curr_score/100)%10;
endmodule