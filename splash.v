module splash(
		input clk,
		input rst,
		input isDead,
		input start,
		output reg showTitle,
		output reg drawBlack,
		output reg showGameOver,
		output reg go
	);
	
	localparam
		TITLE = 3'b000, 
		WAIT = 3'b001, 
		GAMEOVER = 3'b010,
		DRAWBLACK = 3'b011,
		DRAWRED = 3'b100;

	reg [2:0] curr_state, next_state;
	reg [14:0] counter; 				//19119

	always @(*)
	begin
		case (curr_state)
			TITLE: next_state = start ? TITLE : DRAWBLACK;
			WAIT: next_state = isDead ? DRAWRED : WAIT;
			DRAWBLACK: next_state = counter == 100 ? WAIT : DRAWBLACK;
			DRAWRED: next_state = counter == 100 ? GAMEOVER : DRAWRED;
			GAMEOVER: next_state = ~start ? TITLE : GAMEOVER;
		endcase
	end

	always @(*)
	begin
		go = 0;
		drawBlack = 0;
		showGameOver = 0;
		showTitle = 0;
		case (curr_state)
			TITLE: showTitle = 1;
			DRAWBLACK: drawBlack = 1;
			WAIT: go = 1;
			DRAWRED: showGameOver = 1;
		endcase
	end

	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			curr_state <= TITLE;
			counter <= 0;
		end
		else
		begin
			curr_state <= next_state;
			if (counter == 100)
				counter <= 0;
			else
				if (curr_state == DRAWBLACK || curr_state == DRAWRED)
					counter <= counter + 1;
		end
	end

endmodule