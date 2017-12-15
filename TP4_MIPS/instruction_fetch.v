`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2017 07:31:11 PM
// Design Name: 
// Module Name: instruction_fetch
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


module instruction_fetch #(
	parameter len = 32
	) (
	input clk,
	input reset,
	input [2:0] in_pc_src,
	input [len-1:0] in_pc_jump,
	input [len-1:0] in_pc_branch,
	input [len-1:0] in_pc_register,
	input stall_flag,

	output reg [len-1:0] out_pc_branch,
	output [len-1:0] out_instruction
    );

    wire [len-1:0] connect_sumador_mux; 
    wire [len-1:0] connect_mux_pc;
    wire [len-1:0] connect_pc_sumador_mem;

	mux_PC #(
		.len(len)
		)
		u_mux_PC(
			.jump(in_pc_jump),
			.branch(in_pc_branch),
			.register(in_pc_register),
			.pc(connect_sumador_mux),
			.select(in_pc_src),
			.out_mux_PC(connect_mux_pc)
		); 

	pc #(
		.len(len)
		)
		u_pc(
			.In(connect_mux_pc),
			.clk(clk),
			.reset(reset),
			.enable(stall_flag),
			// .enable(1),
			.Out(connect_pc_sumador_mem)
			);

	ram_instrucciones #(
		.RAM_WIDTH(len),
		.RAM_DEPTH(2048),
		.RAM_PERFORMANCE("LOW_LATENCY"),
		// .INIT_FILE("/home/facundo/Desktop/practico_arquitectura_de_computadoras/TP4_MIPS/program.hex")
        .INIT_FILE("E:/Drive/Facultad/quinto/Arquitectura_de_Computadoras/TP4_MIPS/program.hex")
		)
		u_ram_instrucciones(
			.addra(connect_pc_sumador_mem),
			.clka(clk),
			.ena(stall_flag),
			// .ena(!reset),
			.douta(out_instruction)
			); 

	sumador #(
		.len1(len),
		.len2(3)
		)
		u_sumador(
			.In1(connect_pc_sumador_mem),
			.In2(4),
			.Out(connect_sumador_mux)
			); 

	always @(posedge clk) 
	begin
		if (stall_flag) 
		begin
			out_pc_branch <= connect_sumador_mux;
		end
	end
	
endmodule
