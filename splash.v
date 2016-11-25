module splash(
		input clk,
		input rst,
		input isDead,
		input start,
		output reg showTitle,
		output reg drawBlack,
		output reg showGameOver
	);
	
	localparam
		TITLE = 2'b00, 
		WAIT = 2'b01, 
		GAMEOVER = 2'b10,
		DRAWBLACK = 2'b11;

	reg [1:0] curr_state, next_state;
	reg [14:0] counter; 				//19119

	always @(*)
	begin
		case (curr_state)
			TITLE: next_state = start ? TITLE : WAIT;
			WAIT: next_state = isDead ? GAMEOVER : WAIT;
			DRAWBLACK: next_state = counter == 19119 ? GAMEOVER : DRAWBLACK;
			GAMEOVER: next_state = start ? TITLE : GAMEOVER;
		endcase
	end

	always @(*)
	begin
		showTitle = 0;
		showGameOver = 0;
		case (curr_state)
			TITLE: 
			begin
				showTitle = 1;
				drawBlack = 0;
			end
			GAMEOVER: 
			begin 
				showGameOver = 1;
				drawBlack = 0;
			end
			DRAWBLACK: drawBlack = 1;
			default drawBlack = 0;
		endcase
	end

	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			curr_state <= TITLE;
		end
		else
		begin
			curr_state <= next_state;
			if (counter == 19119)
				counter <= 0;
			else
				counter <= counter + 1;
		end
	end

endmodule