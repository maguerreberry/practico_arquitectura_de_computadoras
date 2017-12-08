`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:15:44 PM
// Design Name: 
// Module Name: decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module forwarding_unit #(
	parameter len = 32,
	parameter NB = $clog2(len)
	)(
	input register_write_3_4,	// flag
	input register_write_4_5,	// flag
	input [NB-1:0] rd_3_4,		// registro ya calculado, a forwardear
	input [NB-1:0] rd_4_5,		// registro ya calculado, a forwardear
	input [NB-1:0] rs_2_3,		// registro de instr siguiente que puede necesitar forwarding
	input [NB-1:0] rt_2_3,		// registro de instr siguiente que puede necesitar forwarding
    
	output [1:0] control_muxA,	// control mux entrada A de la ALU 
	output [1:0] control_muxB 	// control mux entrada B de la ALU
    );

	// manejo primer mux
	assign control_muxA = (register_write_4_5 == 1 & rd_4_5 == rs_2_3 & (register_write_3_4 == 0 | rd_3_4 != rs_2_3)) ? 2'b10
						: (register_write_3_4 == 1 & rd_3_4 == rs_2_3) ? 2'b01
							/* default */	: 2'b00;

	// manejo segundo mux
	assign control_muxB = (register_write_4_5 == 1 & rd_4_5 == rt_2_3 & (register_write_3_4 == 0 | rd_3_4 != rt_2_3)) ? 2'b10
						: (register_write_3_4 == 1 & rd_3_4 == rt_2_3) ? 2'b01
							/* default */	: 2'b00;

endmodule
