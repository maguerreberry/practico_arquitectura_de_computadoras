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
	parameter NB = $clog2(len),
	parameter len_exec_bus = 11,
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2
	)(
	input clk,
	input reset,
	input [len-1:0] in_pc_branch,
	input [len-1:0] in_instruccion,
	input RegWrite,
	input [len-1:0] write_data,
	input [NB-1:0] write_register,
	input flush,
	input halt_flag_d,

	output reg [len-1:0] out_pc_branch,
	output [len-1:0] out_pc_jump,	
	output [len-1:0] out_pc_jump_register,	
	output [len-1:0] out_reg1,
	output [len-1:0] out_reg2,
	output reg [len-1:0] out_sign_extend,
	output reg [NB-1:0] out_rt,
	output reg [NB-1:0] out_rd,
	output reg [NB-1:0] out_rs,
	output reg [NB-1:0] out_shamt,

	output [len-1:0] out_reg1_recolector,	// para recolector en modo debug
	output reg out_halt_flag_d,

	// señales de control
	output flag_jump,
	output flag_jump_register,
	output reg [len_exec_bus-1:0] execute_bus,
	output reg [len_mem_bus-1:0] memory_bus,
	output reg [len_wb_bus-1:0] writeBack_bus,

	//señal de control de riesgos
	output stall_flag
    );

	wire [len_exec_bus-1:0] connect_execute_bus;
	wire [len_mem_bus-1:0] connect_memory_bus ;
	wire [len_wb_bus-1:0] connect_writeBack_bus;	

	wire [len-1:0] 	connect_out_wire_reg1,
					connect_out_reg1,
					connect_out_reg2;

    wire mux_control;
    wire [(len_exec_bus+len_wb_bus+len_mem_bus)-1:0] mux_out = mux_control ? 0 : {connect_execute_bus, connect_memory_bus, connect_writeBack_bus};

	assign flag_jump = (flush) ? (0) : (connect_execute_bus[5]);
	assign flag_jump_register = (flush) ? (0) : (connect_execute_bus[4]);
	
	assign out_pc_jump = (flush) ? (0) : ({in_pc_branch[31:28], {2'b 00, (in_instruccion[25:0])}});
	assign out_pc_jump_register = (flush) ? (0) : (connect_out_wire_reg1);

	assign out_reg1_recolector = connect_out_wire_reg1; // para recolector en modo debug
	
    assign out_reg1 = (flush) ? (0) : (connect_out_reg1); 
    assign out_reg2 = (flush) ? (0) : (connect_out_reg2);

    assign stall_flag = (flush) ? (0) : (mux_control);

	control #()
		u_control(
			.opcode(in_instruccion[31:26]),
			.execute_bus(connect_execute_bus),
			.memory_bus(connect_memory_bus),
			.writeBack_bus(connect_writeBack_bus),
			.opcode_lsb(in_instruccion[5:0])
			);

	registers #(
		.width(32),
		.lenght(32),
		.NB($clog2(len))
		)
		u_registers(
			.clk(clk),
			.reset(reset),
			.RegWrite(RegWrite),
			.read_register_1(in_instruccion[25:21]),
			.read_register_2(in_instruccion[20:16]),
			.write_register(write_register),
			.write_data(write_data),

			.wire_read_data_1(connect_out_wire_reg1),
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

	always @(posedge clk, posedge reset) 
	begin
		if (reset) begin
			out_pc_branch <= 0;
			out_sign_extend <= 0;
			out_rt <= 0;
			out_rd <= 0;
			out_rs <= 0;
			out_shamt <= 0;
			execute_bus <= 0;
			memory_bus <= 0;
			writeBack_bus <= 0;
			out_halt_flag_d <= 0;
		end

		else begin
			out_halt_flag_d <= halt_flag_d;

			if(flush)
			begin
				out_pc_branch <= 0;
				out_sign_extend <= 0;
				out_rt <= 0;
				out_rd <= 0;
				out_rs <= 0;
				out_shamt <= 0;
				execute_bus <= 0;
				memory_bus <= 0;
				writeBack_bus <= 0;
			end
			else 
			begin			
				out_pc_branch <= in_pc_branch;
				out_sign_extend <= $signed(in_instruccion[15:0]);
				out_rt <= in_instruccion [20:16];
				out_rd <= in_instruccion [15:11];
				out_rs <= in_instruccion [25:21];
				out_shamt <= in_instruccion [10:6];
				execute_bus <= mux_out[(len_mem_bus+len_wb_bus+len_exec_bus)-1:len_mem_bus+len_wb_bus];
				memory_bus <= mux_out[(len_mem_bus+len_wb_bus)-1:len_wb_bus];
				writeBack_bus <= mux_out[len_wb_bus-1:0];		
			end	
		end
	end

endmodule