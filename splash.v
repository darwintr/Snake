module splash(
		input clk,
		input rst,
		input isDead,
		input start,
		output reg showTitle,
		output reg showGameOver
	);
	
	localparam TITLE = 2'b00, WAIT = 2'b01, GAMEOVER = 2'b10;
	wire curr_state, next_state

	always @(*)
	begin
		case (curr_state)
			TITLE: next_state = start ? TITLE : WAIT;
			WAIT: next_state = isDead ? GAMEOVER : WAIT;
			GAMEOVER: next_state = rst ? TITLE : GAMEOVER;
		endcase
	end

	always @(*)
	begin
		showTitle = 0;
		showGameOver = 0;
		case (curr_state)
			TITLE: showTitle = 1;
			GAMEOVER: showGameOver = 1;
		endcase
	end

	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			curr_state <= TITLE;
			showTitle <= 0;
			showGameOver <= 0;
		end
		else
		begin
			curr_state <= next_state;
		end
	end

endmodule