module control(
		input [3:0] dirControl,
		input clk,
		input reset_n;
		output reg [7:0] x_out,
		output reg [6:0] y_out,
		output reg go,
		output reg [1:0] status,
		output refresh
	);

	//COUNTERS
	reg [2:0] count_to_5;
	reg [12:0] count_lx4p1;
	reg [10:0] snake_length;
	
	reg [10:0] temp_length;

	//DEFAULT POSITION
	localparam DEFAULT_X, DEFAULT_Y;

	//DIRECTIONAL DATA.
	wire [1:0] dir;
	dirControl directionalControl(
		dirControl,
		dir
	);
	//END DIRECTIONAL DATA


	//RATE DIVIDERS
	rate_divider refresh_60 (
		clk,
		reset_n,
		20'd833333,
		refresh
	);



	
	reg [1:0] status_in;
	
	localparam RESET_RAM = 2'b0, REFRESH_RAM_VAL = 2'b01, CLEAR_SCREEN = 2'b10, DRAW = 2'b11;
	reg [1:0] curr_state, next_state;

	//STATE TABLE
	//TODO
	always @(*)
	begin
		
	end
	
	always @(posedge clk)
	begin
		if (!reset_n)
		begin
			snake_length <= 11'd6;
			temp_length <= 0;
			curr_state = REFRESH_RAM_VAL;
			count_to_5 <= 3'd4;
			count_lx4p1 <= snake_length * 4 + 1'b1;
			status_in <= 2'b0;
			x_out <= 0;
			y_out <= 0;
			status <= 0;
			go <= 0;

		end


	end




	


endmodule

module ramWrapper(
		input [7:0] x_in,
		input [6:0] y_in,
		input reg [10:0] address,
		input clk,
		input reset_n,
		input status_in,
		input reset_ram,
		input reg wren,
		output status_out
	);

	ram ramUnit(
		count_to_6,
		clk,
		{status_in, x_out, y_out},
		wren,
		status_out
	);

	reg [3:0] count_to_6;
	reg [7:0] x_out; 
	reg [6:0] y_out;


	always @(posedge clk)
	begin
		if (!reset_n)
		begin
			count_to_6 <= 0;
		end
		if (reset_ram)
		begin
			if (count_to_6 == 4'b0110)
				count_to_6 <= 0;
			//SET VALUES TO DEFAULT FOR ADDRESS
			address <= count_to_6;
			wren <= 1'b1;
			x_out <= 8'd20;
			y_out <= 7'd15 + count_to_6;
			if (count_to_6 == 0)
				status_in <= 2'b11;
			else
				status_in <= 2'b01;

			count_to_6 <= count_to_6 + 1'b1;
		end

		else 
		begin
			x_out <= x_in;
			y_out <= y_in;		
		end
	end

endmodule

//dirOut[1] == 0 => up and dirOut[0] == 0 => Left.
module dirControl(
		input [3:0] dir,
		output reg [1:0] dirOut
	);
	always @(negedge dir[3])
	begin
		dirOut[1] <= 0;
	end

	always @(negedge dir[2])
	begin
		dirOut[1] <= 1;
	end

	always @(negedge dir[1])
	begin
		dirOut[0] <= 0;
	end

	always @(negedge dir[0])
	begin
		dirOut[0] <= 1;
	end

endmodule

module rate_divider(
		input clk,
		input reset_n,
		input [19:0] val,
		output en
	);
	wire [19:0] top_rate = val;
	reg [19:0] curr;

	always @(posedge clk)
	begin
		if (!reset_n)
			curr <= top_rate;
		else if (curr > 0) 
		begin
			curr <= curr - 1'b1;
		end
		else
			curr <= top_rate;
	end

	assign en = ~|curr;

endmodule