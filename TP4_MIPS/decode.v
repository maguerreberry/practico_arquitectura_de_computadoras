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


module decode #(
	parameter len = 32,
	parameter NB =  $clog2(len)
	)(
	input clk,
	input reset,
	input [len-1:0] in_pc_jump,
	input [len-1:0] in_instruccion,
	input RegWrite,
	input [len-1:0] write_data,
	input [NB-1:0] write_register,

	output reg [len-1:0] out_pc_jump,
	output reg [len-1:0] out_reg1,
	output reg [len-1:0] out_reg2,
	output reg [len-1:0] out_sign_extend,
	output reg [NB-1:0] out_rt,
	output reg [NB-1:0] out_rd,

	output reg [3:0] execute_bus,
	output reg [2:0] memory_bus,
	output reg [1:0] writeBack_bus
    );

	wire [3:0] connect_execute_bus;
	wire [2:0] connect_memory_bus ;
	wire [1:0] connect_writeBack_bus;	

	wire [len-1:0] connect_out_reg1;
	wire [len-1:0] connect_out_reg2;

	control #()
		u_control(
			.opcode(in_instruccion[31:26]),
			.execute_bus(connect_execute_bus),
			.memory_bus(connect_memory_bus),
			.writeBack_bus(connect_writeBack_bus),
			.reset(reset)
			);

	registers #(
		.width(32),
		.lenght(32),
		.NB($clog2(len))
		)
		u_registers(
			.clk(clk),
			.RegWrite(RegWrite),
			.read_register_1(in_instruccion[25:21]),
			.read_register_2(in_instruccion[20:16]),
			.write_register(write_register),
			.write_data(write_data),

			.read_data_1(connect_out_reg1),
			.read_data_2(connect_out_reg2)
			);

	always @(*) 
	begin
		out_pc_jump <= in_pc_jump;
		out_reg1 <= connect_out_reg1; 
		out_reg2 <= connect_out_reg2;
		out_sign_extend <= $signed(in_instruccion[15:0]);
		out_rt <= in_instruccion [20:16];
		out_rd <= in_instruccion [15:11];
		execute_bus <= connect_execute_bus;
		memory_bus <= connect_memory_bus;
		writeBack_bus <= connect_writeBack_bus;
	end

endmodule
