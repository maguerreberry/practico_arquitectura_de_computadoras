`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2017 03:11:48 PM
// Design Name: 
// Module Name: top
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


module top#(
	parameter LEN = 32
	)(
	input clk,
	input reset
    );

    wire [LEN-1:0] connect_in_pc_branch;
    wire [LEN-1:0] connect_in_pc_jump;
    wire [LEN-1:0] connect_instruccion;

	instruction_fetch #(
		.len(LEN)
		)
		u_instruction_fetch(
			.clk(clk),
			.reset(reset),
			.in_pc_src(0),
			.in_pc_jump(connect_in_pc_jump),
			.in_pc_branch(),

			.out_pc_branch(connect_in_pc_branch),
			.out_instruction(connect_instruccion)
		);

	decode #(
		.len(LEN)
		)
		u_decode(
			.clk(clk),
			.reset(reset),
			.in_pc_branch(connect_in_pc_branch),
			.in_instruccion(connect_instruccion),
			.RegWrite(),
			.write_data(),
			.write_register(),
			
			.out_pc_branch(),
			.out_pc_jump(connect_in_pc_jump),
			.out_reg1(),
			.out_reg2(),
			.out_sign_extend(),
			.out_rt(),
			.out_rd(),

			.execute_bus(),
			.memory_bus(),
			.writeBack_bus()
		);

	

endmodule
