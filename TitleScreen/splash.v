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
		output reg go,
		output reg wren
	);
	localparam
		TITLE = 4'b0000, 
		WAIT = 4'b0001, 
		GAMEOVERWAIT = 4'b0010,
		DRAWBLACK = 4'b0011,
		DRAWGAMEOVER = 4'b0100,
		DRAWRED = 4'b0101,
		DRAWTITLE = 4'b0110,
		GAMEOVERFLASH = 4'b0111,
		RESTARTWAIT = 4'b1000;

	reg [2:0] curr_state, next_state;
	reg [14:0] counter; 				//19119
	localparam IBELIEVEINMYCODE = 32'd19119;
	always @(*)
	begin
		case (curr_state)
			DRAWTITLE: next_state = counter == IBELIEVEINMYCODE ? TITLE : DRAWTITLE;
			TITLE: next_state = ~start ? TITLE : DRAWBLACK;
			WAIT: next_state = isDead ? DRAWGAMEOVER : WAIT;
			DRAWBLACK: next_state = counter == IBELIEVEINMYCODE ? WAIT : DRAWBLACK;
			DRAWGAMEOVER: next_state = counter == IBELIEVEINMYCODE ? GAMEOVERWAIT : DRAWGAMEOVER;
			GAMEOVERWAIT:
			begin
				if (~start)
			 		next_state = RESTARTWAIT;
			 	else if (tick)
			 		next_state = DRAWRED;
			 	else
			 		next_state = GAMEOVERWAIT;
			end 
			DRAWRED: next_state = counter == IBELIEVEINMYCODE ? GAMEOVERFLASH : DRAWRED;
			GAMEOVERFLASH:
			begin
				if (~start)
			 		next_state = RESTARTWAIT;
			 	else if (tick)
			 		next_state = DRAWGAMEOVER;
			 	else
			 		next_state = GAMEOVERFLASH;
			end
			RESTARTWAIT: next_state = start ? DRAWTITLE : RESTARTWAIT;
		endcase
	end

	always @(*)
	begin
		go = 0;
		drawBlack = 0;
		showGameOver = 0;
		showTitle = 0;
		flash = 0;
		wren = 0;
		case (curr_state)
			DRAWTITLE:
			begin
				showTitle = 1;
				wren = 1;
			end
			DRAWBLACK:
		   begin
				drawBlack = 1;
				wren = 1;
			end
			DRAWRED:
			begin 
				flash = 1;
				wren = 1;
			end
			WAIT: go = 1;
			DRAWGAMEOVER: 
			begin
				showGameOver = 1;
				wren = 1;
			end
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
			if (counter == IBELIEVEINMYCODE)
				counter <= 0;
			else
				if (curr_state == DRAWBLACK || curr_state == DRAWGAMEOVER ||
						curr_state == DRAWRED || curr_state == DRAWTITLE)
					counter <= counter + 1;
		end
	end

endmodule