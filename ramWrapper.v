`include "ram.v"


module ramDataPath(
	input [10:0] address,
	input wren,
	input [16:0] data,
	output [7:0] x,
	output [6:0] y,
	output [1:0] type,
	output [16:0] q
);	

	assign type = q[16:15];
	assign x = q[14:7];
	assign y = q[6:0];

	ram u0(
		address,
		clk,
		data,
		wren,
		q
	);
endmodule





module ramControl(
	input clk, //THIS CLOCK IS RATE DIVIDED BY 4!
	input reset_n,
	input go,
	input [1:0] dir,
	input [16:0] q,
	output reg wren,
	output reg [16:0] data,
	output reg [10:0] address
);
	
	localparam
		L_DEFAULT = 3'b000, 
		STORE_INI = 3'b001, 
		UPDATE_PREV = 3'b010,
		STORE_REG_INTO_CURR = 3'b011,
		STORE_PREV_INTO_REG = 3'b100,
		STORE_CURR_INTO_PREV = 3'b101,
		WAIT = 3'b110;

	wire [10:0] defaultLength = 11'd6;
	reg [2:0] currState, nextState;
	reg [10:0] currentLength;
	reg [10:0] resetCount;
	reg [10:0] cnt;

	always @(*)
	begin: stateTable
		case (currState)
			L_DEFAULT: nextState = resetCount == defaultLength ? STORE_INI : L_DEFAULT;
			STORE_INI: nextState = UPDATE_PREV;
			UPDATE_PREV: nextState = STORE_REG_INTO_CURR;
			STORE_REG_INTO_CURR: nextState = STORE_PREV_INTO_REG;
			STORE_PREV_INTO_REG: nextState = STORE_CURR_INTO_PREV;
			STORE_CURR_INTO_PREV: nextState = cnt == currentLength ? WAIT : STORE_REG_INTO_CURR;
			WAIT: nextState = go ? STORE_INI : WAIT;
		default: nextState = L_DEFAULT;
		endcase
	end

	always @(posedge clk or posedge go)
	begin
		if (!reset_n)
		begin
			cnt <= 0;
			address <= 0;
			currentLength <= defaultLength;
			resetCount <= 0;
			currState <= L_DEFAULT;
		end

		if (go)
			currState = STORE_INI;
		else
			currState <= nextState;


		//-------------GROUP-----------
		if (currState == L_DEFAULT)
		begin
			resetCount <= resetCount + 1;
			address <= resetCount;
		end
		else if (currState == STORE_CURR_INTO_PREV)
		begin
			cnt <= cnt + 1;
			address <= resetCount;
		end
		else begin
			resetCount <= 0;
			address <= 0;
		end
		//---------------GROUP-----------
		if (currState == WAIT)
			cnt <= 0;
	end
	
	wire [7:0] defaultX = 8'd20;
	wire [6:0] defaultY = 7'd10;
	//00 is body, 01 is head
	wire [1:0] defaultType = address == 0 ? 2'b01 : 2'b00; 
	
	reg [16:0] curr, prev;

	
	always @(posedge clk)
	begin
		if (reset_n)
		begin
			curr <= 0;
			prev <= 0;
			data <= 0;
			wren <= 0;
		end
		else
		begin
			case (currState)
				L_DEFAULT: begin
					
					data <= {defaultType, {defaultX, defaultY + address[6:0]}};
					wren <= 1;
				end
				STORE_INI: begin	
					wren <= 0;
					prev <= q;
				end
				UPDATE_PREV: begin
					wren <= 0;
	//dirOut[1] == 0 => up and dirOut[0] == 0 => Left.
					prev[14:7] <= prev[14:7] + dir[0] ? 1 : - 1;
					prev[6:0] <= prev[6:0] + dir[1] ? -1 : 1;
				end
				STORE_REG_INTO_CURR: begin
					curr <= q;
					wren <= 0;
				end
				STORE_PREV_INTO_REG: begin
					data <= prev;
					wren <= 1;
				end
				STORE_CURR_INTO_PREV: begin
					prev <= curr;
					wren <= 0;
				end
				WAIT: begin
					wren <= 0;
				end
			endcase
		end
	end	
endmodule
