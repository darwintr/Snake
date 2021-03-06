`include "Interface.v"
//RESETN = SW[0]

//KEY[3:0] will be directions. LEFT UP DOWN RIGHT

//COLOR is SW[9:7](Changes body color, head will always be red)


module Snake
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5,
		LEDR
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output  [9:0]   LEDR;
	output  [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [2:0] colour;
	//RESET
	wire rst = SW[0];
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(rst),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
	
	wire [3:0] HEX0_out, HEX1_out, HEX2_out, HEX3_out, HEX4_out, HEX5_out;
	wire [7:0] x;
	wire [6:0] y;
	
	snakeInterface si(
		.SW(SW[2:1]),	
		.dirInControl(KEY[3:0]),
		.clk(CLOCK_50),
		.rst(rst),
		.colour_in(SW[9:7]),
		.colour_out(colour),
		.x_out(x),
		.y_out(y),
		.plot(writeEn),
		.hex0_out(HEX0_out),
		.hex1_out(HEX1_out),
		.hex2_out(HEX2_out),
		.hex3_out(HEX3_out),
		.hex4_out(HEX4_out),
		.hex5_out(HEX5_out),
		.ledr_out(LEDR[0])
		);
	hex_decoder_with_u u0(
		HEX5_out,
		HEX5
	);
		
	hex_decoder u1(
		HEX0_out,
		HEX0
	);

	hex_decoder u2(
		HEX1_out,
		HEX1
	);
	
	hex_decoder u3(
		HEX2_out,
		HEX2
	);
	
	
	hex_decoder u5(
		HEX4_out,
		HEX4
	);

	
	hex_decoder u4(
		HEX3_out,
		HEX3
	);
endmodule


module hex_decoder_with_u(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0001;
			4'h1: segments = 7'b000_1001;
            default: segments = 7'b100_1000;
        endcase
endmodule 

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule 