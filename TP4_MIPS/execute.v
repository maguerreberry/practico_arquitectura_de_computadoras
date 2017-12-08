`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2017 07:52:59 PM
// Design Name: 
// Module Name: decode
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


module execute #(
	parameter len = 32,
	parameter NB =  $clog2(len)
	)(
	input clk,
	// input reset,

	input [len-1:0] in_pc_branch,
	input [len-1:0] in_reg1,
	input [len-1:0] in_reg2,
	input [len-1:0] in_sign_extend,
	input [NB-1:0] in_rt,
	input [NB-1:0] in_rd,
	input [NB-1:0] in_shamt,

	input [8:0] execute_bus,
	input [2:0] memory_bus,
	input [1:0] writeBack_bus, 

	output reg [len-1:0] out_pc_branch,
	output reg [len-1:0] out_alu,
	output reg zero_flag,
	output reg neg_flag,
	output reg [len-1:0] out_reg2,
	output reg [NB-1:0] out_write_reg,

	// señales de control
	output reg [2:0] memory_bus_out,
	output reg [1:0] writeBack_bus_out
    );

	wire [len-1:0] connect_aluop1 = execute_bus[7] ? ({{27{1'b 0}}, in_shamt}) : in_reg1;
	wire [len-1:0] connect_aluop2 = execute_bus[6] ? in_sign_extend : in_reg2;
	wire [len-1:0] connect_alu_out;
	wire connect_zero_flag;
	wire connect_neg_flag;


	alu #(
		.lenghtIN(32),
		.lenghtOP(4)
		)
		u_alu(
			.A(connect_aluop1),
			.B(connect_aluop2),
			.OPCODE(execute_bus[3:0]),
	
			.RESULT_OUT(connect_alu_out),
			.zero_flag(connect_zero_flag),
			.neg_flag(connect_neg_flag)
		);

	always @(posedge clk) 
	begin
		memory_bus_out <= memory_bus;
		writeBack_bus_out <= writeBack_bus;
		out_pc_branch <= in_pc_branch + (in_sign_extend << 2);
		out_alu <= connect_alu_out;
		out_reg2 <= in_reg2;
		out_write_reg <= execute_bus[8] ? in_rd : in_rt;
		zero_flag <= connect_zero_flag;
		neg_flag <= connect_neg_flag;
	end

endmodule
