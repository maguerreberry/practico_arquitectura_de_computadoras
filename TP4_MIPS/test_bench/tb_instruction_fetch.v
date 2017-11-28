`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2017 08:03:30 PM
// Design Name: 
// Module Name: tb_instruction_fetch
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

`define LEN 32

module tb_instruction_fetch(

    );
	
	reg clk;
	reg reset;
	reg in_pc_enable;
	reg in_pc_src;
	reg [`LEN-1:0] in_pc_jump;
	wire [`LEN-1:0] out_pc_jump;
	wire [`LEN-1:0] out_instruction;
	
	instruction_fetch #(
		.len(`LEN)	
		)
		u_instruction_fetch (
			.clk(clk),
			.reset(reset),
			.in_pc_src(in_pc_src),
			.in_pc_jump(in_pc_jump),
			.out_pc_jump(out_pc_jump),
			.out_instruction(out_instruction)
		);

	initial
	begin
		clk = 0;
		reset = 1;
		#15
		reset = 0;
		in_pc_src = 0;
	end

	always 
		#5 clk = ~clk;


endmodule
