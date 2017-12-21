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
	parameter NB =  $clog2(len),
	parameter len_exec_bus = 11,
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2
	)(
	input clk,
	input reset,

	input [len-1:0] in_pc_branch,
	input [len-1:0] in_reg1,
	input [len-1:0] in_reg2,
	input [len-1:0] in_sign_extend,
	input [NB-1:0] in_rt,
	input [NB-1:0] in_rd,
	input [NB-1:0] in_shamt,

	input [len_exec_bus-1:0] execute_bus,
	input [len_mem_bus-1:0] memory_bus,
	input [len_wb_bus-1:0] writeBack_bus,

	// entradas para cortocircuito
	input register_write_3_4,	// flag
	input register_write_4_5,	// flag
	input [NB-1:0] rd_3_4,		// registro ya calculado, a forwardear
	input [NB-1:0] rd_4_5,		// registro ya calculado, a forwardear
	input [NB-1:0] in_rs,		// registro de instr siguiente que puede necesitar forwarding

	input [len-1:0] in_mem_forw,
	input [len-1:0] in_wb_forw,
	input flush,
	
	output reg [len-1:0] out_pc_branch,
	output reg [len-1:0] out_alu,
	output reg zero_flag,
	output reg [len-1:0] out_reg2,
	output reg [NB-1:0] out_write_reg,

	// señales de control
	output reg [len_mem_bus-1:0] memory_bus_out,
	output reg [len_wb_bus-1:0] writeBack_bus_out
    );

	wire [1:0] connect_mux1_forwarding;
    wire [len-1:0] mux1_alu_forwarding;
	wire [1:0] connect_mux2_forwarding;
    wire [len-1:0] mux2_alu_forwarding;

	wire [len-1:0] connect_aluop1 = execute_bus[10] ? (in_pc_branch) : (execute_bus[7] ? ({{27{1'b 0}}, in_shamt}) : mux1_alu_forwarding);
	wire [len-1:0] connect_aluop2 = execute_bus[10] ? (1'b 1) : (execute_bus[6] ? in_sign_extend : mux2_alu_forwarding);
	wire [len-1:0] connect_alu_out;
	wire connect_zero_flag;


	alu #(
		.lenghtIN(32),
		.lenghtOP(4)
		)
		u_alu(
			.A(connect_aluop1),
			.B(connect_aluop2),
			.OPCODE(execute_bus[3:0]),
	
			.RESULT_OUT(connect_alu_out),
			.zero_flag(connect_zero_flag)
		);

	forwarding_unit #(
		.len(len)
		)
		u_forwarding_unit(
			.register_write_3_4(register_write_3_4),	// flag
			.register_write_4_5(register_write_4_5),	// flag
			.rd_3_4(rd_3_4),		// registro ya calculado, a forwardear
			.rd_4_5(rd_4_5),		// registro ya calculado, a forwardear
			.rs_2_3(in_rs),		// registro de instr siguiente que puede necesitar forwarding
			.rt_2_3(in_rt),		// registro de instr siguiente que puede necesitar forwarding

			.control_muxA(connect_mux1_forwarding),
			.control_muxB(connect_mux2_forwarding)
		);

	mux_forwarding #(.len(32))
		u_mux_forwarding1(
			.in_reg(in_reg1),			//entrada desde registros
			.in_mem_forw(in_mem_forw),	//salida de alu de clock anterior
			.in_wb_forw(in_wb_forw),	//salida del mux final de writeback
			.select(connect_mux1_forwarding),
			.out_mux(mux1_alu_forwarding)
			);
	
	mux_forwarding #(.len(32))
		u_mux_forwarding2(
			.in_reg(in_reg2),			//entrada desde registros
			.in_mem_forw(in_mem_forw),	//salida de alu de clock anterior
			.in_wb_forw(in_wb_forw),	//salida del mux final de writeback
			.select(connect_mux2_forwarding),
			.out_mux(mux2_alu_forwarding)
			);

	always @(reset)
	begin
		out_pc_branch = 0;
		out_alu = 0;
		zero_flag = 0;
		out_reg2 = 0;
		out_write_reg = 0;
		memory_bus_out = 0;
		writeBack_bus_out = 0;
	end

	always @(posedge clk) 
	begin
		if (flush) 
		begin
			memory_bus_out <= 0;
			writeBack_bus_out <= 0;
			out_pc_branch <= 0;
			out_alu <= 0;
			out_reg2 <= 0;
			out_write_reg <= 0;
			zero_flag <= 0;
		end
		else
		begin		
			memory_bus_out <= memory_bus;
			writeBack_bus_out <= writeBack_bus;
			out_pc_branch <= in_pc_branch + in_sign_extend;
			out_alu <= connect_alu_out;
			out_reg2 <= in_reg2;
			out_write_reg <= execute_bus[9] ? (5'b 11111) : (execute_bus[8] ? in_rd : in_rt);
			zero_flag <= connect_zero_flag;
		end
	end

endmodule
