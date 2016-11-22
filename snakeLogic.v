`include "ram.v"
`include "snakeMovement.v"



module snakeLogic(clk, rst, dirIn, go, length, colour_in, x, y, plotEn, colour_out);
	input clk;
	input rst;
	input [2:0] colour_in;
	input go;
	input [3:0] dirIn;
	input [10:0] length;

	output [7:0] x;
	output [6:0] y;
	output plotEn;
	output [2:0] colour_out;
	wire [1:0] cnt_status;
	wire [2:0] dirContOut;
	wire isDead;

	dirControl dirModule(
			.clk(clk),
			.dir(dirIn),
			.reset_n(rst),
			.dirOut(dirContOut)
		);



	controlMovement control(
			clk,
			rst,
			colour_in,
			length, 
			go,
			ld_head,
			ld_q_def,
			inc_address,
			rst_address,
			draw_q,
			cnt_status,
			update_head,
			ld_head_into_prev,
			ld_q_into_curr,
			ld_prev_into_q,
			ld_curr_into_prev,
			colour_out,
			draw_curr
		);

	datapath dp(
			clk,
			rst,
			ld_head,
			ld_q_def,
			inc_address,
			rst_address,
			draw_q,
			cnt_status,
			update_head,
			ld_head_into_prev,
			ld_q_into_curr,
			ld_prev_into_q,
			ld_curr_into_prev,
			draw_curr,
			dirContOut,
			isDead,
			plotEn,
			x,
			y
		);


endmodule 
//dirOut[1] == 0 => up and dirOut[0] == 0 => Left.
module dirControl(
		input clk,
		input [3:0] dir,
		input reset_n,
		output reg [2:0] dirOut
	);
	
	wire input1 = dir[3];
	wire input2 = dir[2];
	wire input3 = dir[1];
	wire input4 = dir[0];
	
	always @(posedge clk, negedge reset_n)
	begin
		if (!reset_n)
			dirOut <= 0;
		if (input1 == 0)
		begin
			dirOut[1] <= 0;
			dirOut[2] <= 1;
		end
		else if (input2 == 0)
		begin
			dirOut[1] <= 1;
			dirOut[2] <= 1;
		end
		else if (input3 == 0)
		begin
			dirOut[0] <= 0;
			dirOut[2] <= 0;
		end
		else if (input4 == 0)
		begin
			dirOut[0] <= 1;
			dirOut[2] <= 0;
		end
	end
endmodule


module datapath(
	input clk,
	input rst,

	input ld_head,
	input ld_q_def,
	input inc_address,
	input rst_address,
	input draw_q,
	input [1:0] cnt_status,
	input update_head,
	input ld_head_into_prev,
	input ld_q_into_curr,
	input ld_prev_into_q,
	input ld_curr_into_prev,
	input draw_curr,
	input [2:0] dir,
	
	output reg isDead,
	output reg plotEn,
	output reg [7:0] x,
	output reg [6:0] y
	
);
	wire [14:0] ram_out;
	reg [14:0] ram_in;
	reg ram_wren;
	reg [10:0] address;
	reg [14:0] curr, prev, head;

	ram r0(
		.address(address),
		.clock(clk),
		.data(ram_in),
		.wren(ram_wren),
		.q(ram_out)
	);

	localparam def_x = 8'd60, def_y =7'd60;


	always @(posedge clk, negedge rst) begin
		if (!rst) begin
			address <= 0;
			curr <= 0;
			prev <= 0;
			head <= 0;
		end
		else begin
			if (ld_head)
				head <= {def_x, def_y};
			if (update_head)
			begin
				if (dir[2]) begin
					if (dir[1])
						head[6:0] <= head[6:0] + 1;
					else
						head[6:0] <= head[6:0] - 1;			
				end
				else if (!dir[2]) begin
					if (dir[0])
						head[14:7] <= head[14:7] + 1;
					else 
						head[14:7] <= head[14:7] - 1;
			end
			end
			if (inc_address)
				address <= address + 1;
			if (rst_address)
				address <= 0;
			if (ld_head_into_prev)
				prev <= head;
			if (ld_q_into_curr)
				curr <= ram_out;
			if (ld_curr_into_prev)
				prev <= curr;
		end
	end

	always @(*) begin
		ram_in = 0;
		ram_wren = 0;
		isDead = 0;
		plotEn = 0;
		x = 0;
		y = 0;
		if (ld_q_def)
		begin
			ram_in = {def_x, def_y + address[6:0]};
			ram_wren = 1;
		end
		if (draw_q)
		begin
			plotEn = 1;
			x = ram_out[14:7] + cnt_status[1];
			y = ram_out[6:0] + cnt_status[0];
		end
		if (draw_curr)
		begin
			plotEn = 1;
			x = curr[14:7] + cnt_status[1];
			y = curr[6:0] + cnt_status[0];
		end
		if (ld_prev_into_q)
		begin
			ram_wren = 1;
			ram_in = prev;
		end
	end
endmodule