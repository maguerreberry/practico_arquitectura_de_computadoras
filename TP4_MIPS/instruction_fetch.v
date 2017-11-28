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
	input in_pc_src,
	input [len-1:0] in_pc_jump,

	output reg [len-1:0] out_pc_jump,
	output reg [len-1:0] out_instruction
    );

    wire [len-1:0] connect_sumador_mux; 
    wire [len-1:0] connect_mux_pc;
    wire [len-1:0] connect_pc_sumador_mem;
    wire [len-1:0] connect_mem_out;


	mux #(
		.len(len)
		)
		u_mux(
			.in1(in_pc_jump),
			.in2(connect_sumador_mux),
			.select(in_pc_src),
			.out_mux(connect_mux_pc)
			); 

	pc #(
		.len(len)
		)
		u_pc(
			.In(connect_mux_pc),
			.clk(clk),
			.reset(reset),
			.Out(connect_pc_sumador_mem)
			);

	ram_instrucciones #(
		.RAM_WIDTH(len),
		.RAM_DEPTH(2048),
		.RAM_PERFORMANCE("LOW_LATENCY"),
		// .INIT_FILE("/home/facundo/Desktop/practico_arquitectura_de_computadoras/TP3_BIP/TP3_BIP.srcs/sources_1/new/program.hex")
        .INIT_FILE("E:/Drive/Facultad/quinto/Arquitectura_de_Computadoras/TP4_MIPS/program.hex")
		)
		u_ram_instrucciones(
			.addra(connect_pc_sumador_mem),
			.clka(clk),
			.douta(connect_mem_out)
			); 

	sumador #(
		.len1(len),
		.len2(1)
		)
		u_sumador(
			.In1(connect_pc_sumador_mem),
			.In2(1),
			.Out(connect_sumador_mux)
			); 

	always @(*) 
	begin
		out_pc_jump <= connect_sumador_mux;
		out_instruction <= connect_mem_out;
	end
endmodule
