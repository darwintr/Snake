module splash(
		input clk,
		input rst,
		input isDead,
		input start,
		input tick,
		output reg showTitle,
		output reg drawBlack,
		output reg showGameOver,
		output reg flash,
		output reg go
	);
	
	localparam
		TITLE = 3'b000, 
		WAIT = 3'b001, 
		GAMEOVERWAIT = 3'b010,
		DRAWBLACK = 3'b011,
		DRAWGAMEOVER = 3'b100,
		DRAWRED = 3'b101,
		DRAWTITLE = 3'b110,
		GAMEOVERFLASH = 3'b111;

	reg [2:0] curr_state, next_state;
	reg [14:0] counter; 				//19119

	always @(*)
	begin
		case (curr_state)
			DRAWTITLE: next_state = counter == 19119 ? TITLE : DRAWTITLE;
			TITLE: next_state = start ? TITLE : DRAWBLACK;
			WAIT: next_state = isDead ? DRAWRED : WAIT;
			DRAWBLACK: next_state = counter == 19119 ? WAIT : DRAWBLACK;
			DRAWGAMEOVER: next_state = counter == 19119 ? GAMEOVERWAIT : DRAWGAMEOVER;
			GAMEOVERWAIT:
			begin
				if (~start)
			 		next_state = DRAWTITLE;
			 	else if (tick)
			 		next_state = DRAWRED;
			 	else
			 		next_state = GAMEOVERWAIT;
			end 
			DRAWRED: next_state = counter == 19119 ? GAMEOVERFLASH : DRAWRED;
			GAMEOVERFLASH:
			begin
				if (~start)
			 		next_state = DRAWTITLE;
			 	else if (tick)
			 		next_state = DRAWGAMEOVER;
			 	else
			 		next_state = GAMEOVERFLASH;
			end
		endcase
	end

	always @(*)
	begin
		go = 0;
		drawBlack = 0;
		showGameOver = 0;
		showTitle = 0;
		flash = 0;
		case (curr_state)
			DRAWTITLE: showTitle = 1;
			DRAWBLACK: drawBlack = 1;
			DRAWRED: flash = 1;
			WAIT: go = 1;
			DRAWGAMEOVER: showGameOver = 1;
		endcase
	end

	always @(posedge clk, negedge rst)
	begin
		if (!rst)
		begin
			curr_state <= DRAWTITLE;
			counter <= 0;
		end
		else
		begin
			curr_state <= next_state;
			if (counter == 19119)
				counter <= 0;
			else
				if (curr_state == DRAWBLACK || curr_state == DRAWGAMEOVER ||
						curr_state == DRAWRED || curr_state == DRAWTITLE)
					counter <= counter + 1;
		end
	end

endmodule