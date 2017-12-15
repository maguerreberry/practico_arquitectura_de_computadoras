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
	input [len-1:0] in_pc_branch,
	input [len-1:0] in_instruccion,
	input RegWrite,
	input [len-1:0] write_data,
	input [NB-1:0] write_register,

	output reg [len-1:0] out_pc_branch,
	output [len-1:0] out_pc_jump,
	output [len-1:0] out_reg1,
	output [len-1:0] out_reg2,
	output reg [len-1:0] out_sign_extend,
	output reg [NB-1:0] out_rt,
	output reg [NB-1:0] out_rd,
	output reg [NB-1:0] out_rs,
	output reg [NB-1:0] out_shamt,

	// señales de control
	output flag_jump,
	output flag_jump_register,
	output reg [8:0] execute_bus,
	output reg [7:0] memory_bus,
	output reg [1:0] writeBack_bus,

	//señal de control de riesgos
	output stall_flag
    );

	wire [8:0] connect_execute_bus;
	wire [7:0] connect_memory_bus ;
	wire [1:0] connect_writeBack_bus;	

	wire [len-1:0] connect_out_reg1;
	wire [len-1:0] connect_out_reg2;

	assign flag_jump = connect_execute_bus[5];
	assign flag_jump_register = connect_execute_bus[4];
	
	assign out_pc_jump = {in_pc_branch[31:28], (in_instruccion[25:0] << 2)};
	
    assign out_reg1 = connect_out_reg1; 
    assign out_reg2 = connect_out_reg2;

    wire mux_control;
    wire [18:0] mux_out = mux_control ? 0 : {connect_execute_bus, connect_memory_bus, connect_writeBack_bus};

    assign stall_flag = mux_control;

	control #()
		u_control(
			.clk(clk),
			.opcode(in_instruccion[31:26]),
			.execute_bus(connect_execute_bus),
			.memory_bus(connect_memory_bus),
			.writeBack_bus(connect_writeBack_bus),
			.reset(reset),
			.opcode_lsb(in_instruccion[5:0])
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

	hazard_detection_unit #(
		.len(32)
		)
		u_hazard(
			.mem_read_2_3(memory_bus[1]),
			.rt_2_3(out_rt),
			.rs_1_2(in_instruccion [25:21]),
			.rt_1_2(in_instruccion [20:16]),

			.stall_flag(mux_control)
			);

	always @(posedge clk) 
	begin
		out_pc_branch <= in_pc_branch;
		out_sign_extend <= $signed(in_instruccion[15:0]);
		out_rt <= in_instruccion [20:16];
		out_rd <= in_instruccion [15:11];
		out_rs <= in_instruccion [25:21];
		out_shamt <= in_instruccion [10:6];
		execute_bus <= mux_out[18:10];
		memory_bus <= mux_out[9:2];
		writeBack_bus <= mux_out[1:0];
		
		
	end

endmodule