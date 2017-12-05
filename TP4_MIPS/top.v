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
	parameter LEN = 32,
	parameter NB = $clog2(LEN)
	)(
	input clk,
	input reset
    );

    wire [LEN-1:0] connect_in_pc_branch_1_2;
    wire [LEN-1:0] connect_in_pc_branch_2_3;
    wire [LEN-1:0] connect_in_pc_branch_3_1;
    wire [LEN-1:0] connect_in_pc_jump;
    wire [LEN-1:0] connect_instruccion;
    wire [8:0] connect_execute_bus;
    wire [LEN-1:0] connect_reg1;
	wire [LEN-1:0] connect_reg2;
	wire [LEN-1:0] connect_sign_extend;
	wire [NB-1:0] connect_rt;
	wire [NB-1:0] connect_rd;
	wire [NB-1:0] connect_shamt;
	wire [2:0] connect_memory_bus;
	wire [1:0] connect_writeBack_bus;

	instruction_fetch #(
		.len(LEN)
		)
		u_instruction_fetch(
			.clk(clk),
			.reset(reset),
			.in_pc_src({connect_execute_bus[5:4],1'b 0}), //falta agregar el pc src del branch
			.in_pc_jump(connect_in_pc_jump),
			.in_pc_branch(),
			.in_pc_register(),

			.out_pc_branch(connect_in_pc_branch_1_2),
			.out_instruction(connect_instruccion)
		);

	decode #(
		.len(LEN)
		)
		u_decode(
			.clk(clk),
			.reset(reset),
			.in_pc_branch(connect_in_pc_branch_1_2),
			.in_instruccion(connect_instruccion),
			.RegWrite(),
			.write_data(),
			.write_register(),
			
			.out_pc_branch(connect_in_pc_branch_2_3),
			.out_pc_jump(connect_in_pc_jump),
			.out_reg1(connect_reg1),
			.out_reg2(connect_reg2),
			.out_sign_extend(connect_sign_extend),
			.out_rt(connect_rt),
			.out_rd(connect_rd),
			.out_shamt(connect_shamt),

			.execute_bus(connect_execute_bus),
			.memory_bus(connect_memory_bus),
			.writeBack_bus(connect_writeBack_bus)
		);

	execute #(
		.len(LEN)
		)
		u_execute(
			.clk(clk),
		
			.in_pc_branch(connect_in_pc_branch_2_3),
			.in_reg1(connect_reg1),
			.in_reg2(connect_reg2),
			.in_sign_extend(connect_sign_extend),
			.in_rt(connect_rt),
			.in_rd(connect_rd),
			.in_shamt(connect_shamt),
		
			.execute_bus(connect_execute_bus),
			.memory_bus(connect_memory_bus),
			.writeBack_bus(connect_writeBack_bus), 
		
			.out_pc_branch(connect_in_pc_branch_3_1),
			.out_alu(),
			.zero_flag(),
			.neg_flag(),
			.out_reg2(),
			.out_write_reg(),
		
			// señales de control
			.memory_bus_out(),
			.writeBack_bus_out()
	);

endmodule
