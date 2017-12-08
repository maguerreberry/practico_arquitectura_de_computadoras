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

    wire [LEN-1:0] connect_in_pc_branch_1_2,
				   connect_in_pc_branch_2_3,
				   connect_in_pc_branch_3_1,
				   connect_in_pc_jump,
				   connect_instruccion,
				   connect_reg1,
				   connect_reg2,
				   connect_sign_extend,
				   connect_alu_out,
				   connect_write_data_5_2,
				   connect_read_data,
				   connect_out_addr_mem,
				   connect_write_data_3_4,
				   connect_in_pc_branch_3_4,
				   connect_in_pc_branch_4_1;

	wire [NB-1:0] connect_rt,
				  connect_rd,
				  connect_shamt,
				  connect_write_reg_3_4,
				  connect_write_reg_4_2;

    wire [8:0] connect_execute_bus;
	
	wire [2:0] connect_memory_bus_2_3,
			   connect_memory_bus_3_4;
	
	wire [1:0] connect_writeBack_bus_2_3,
			   connect_out_writeBack_bus,
			   connect_writeBack_bus_3_4;
    
    wire connect_flag_jump,
         connect_flag_jump_register,
	     connect_zero_flag,
	     connect_branch_flag;

	assign connect_write_data_5_2 = (connect_out_writeBack_bus[0]) ? connect_read_data : connect_out_addr_mem;

	instruction_fetch #(
		.len(LEN)
		)
		u_instruction_fetch(
			.clk(clk),
			.reset(reset),
			.in_pc_src({connect_flag_jump, connect_flag_jump_register, connect_branch_flag}),
			.in_pc_jump(connect_in_pc_jump),
			.in_pc_branch(connect_in_pc_branch_4_1),
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
			.RegWrite(connect_out_writeBack_bus[1]),
			.write_data(connect_write_data_5_2),
			.write_register(connect_write_reg_4_2),
			
			.out_pc_branch(connect_in_pc_branch_2_3),
			.out_pc_jump(connect_in_pc_jump),
			.out_reg1(connect_reg1),
			.out_reg2(connect_reg2),
			.out_sign_extend(connect_sign_extend),
			.out_rt(connect_rt),
			.out_rd(connect_rd),
			.out_shamt(connect_shamt),

			.execute_bus(connect_execute_bus),
			.flag_jump(connect_flag_jump),
			.flag_jump_register(connect_flag_jump_register),
			.memory_bus(connect_memory_bus_2_3),
			.writeBack_bus(connect_writeBack_bus_2_3)
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
			.memory_bus(connect_memory_bus_2_3),
			.writeBack_bus(connect_writeBack_bus_2_3), 
		
			.out_pc_branch(connect_in_pc_branch_3_4),
			.out_alu(connect_alu_out),
			.zero_flag(connect_zero_flag),
			.neg_flag(),
			.out_reg2(connect_write_data_3_4),
			.out_write_reg(connect_write_reg_3_4),
		
			// señales de control
			.memory_bus_out(connect_memory_bus_3_4),
			.writeBack_bus_out(connect_writeBack_bus_3_4)
			);

	memory #(
		.len(LEN)
		)
		u_memory(
			.clk(clk),
			.in_addr_mem(connect_alu_out),
			.write_data(connect_write_data_3_4),
			
			.memory_bus(connect_memory_bus_3_4),
		    .in_writeBack_bus(connect_writeBack_bus_3_4),
			.in_write_reg(connect_write_reg_3_4),			
			.zero_flag(connect_zero_flag),
			.in_pc_branch(connect_in_pc_branch_3_4),

			//outputs		
			.read_data(connect_read_data),
			.pc_src(connect_branch_flag),
			.out_pc_branch(connect_in_pc_branch_4_1),
		    .out_writeBack_bus(connect_out_writeBack_bus),
			.out_addr_mem(connect_out_addr_mem),
			.out_write_reg(connect_write_reg_4_2)	
			);

endmodule
