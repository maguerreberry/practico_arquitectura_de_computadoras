`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2017 05:16:44 PM
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


module control_top(
	input CLK100MHZ,
    output [1:0] SelA,
    output SelB,
    output WrAcc,
    output Op,
    output WrRam,
    output RdRam,
    output [10:0] operand
    );
    
	wire [15:0] output_program_mem;
	wire connect_WrPC;
	wire [10:0] connect_PC_adder;
	wire [10:0] connect_adder_PC;

	assign operand = output_program_mem [10:0]; 	
	
	decoder #()
		u_decoder(
			.opcode(output_program_mem[15:11]),
			.WrPC(connect_WrPC),
			.SelA(SelA),
			.SelB(SelB),
			.WrAcc(WrAcc),
			.Op(Op),
			.WrRam(WrRam),
			.RdRam(RdRam)
			);

	ram_instrucciones #(
			.RAM_WIDTH(16),
			.RAM_DEPTH(2048),
			.RAM_PERFORMANCE("LOW_LATENCY"),
			// .INIT_FILE("program.hex")
			.INIT_FILE("/home/facundo/Desktop/practico_arquitectura_de_computadoras/TP3_BIP/TP3_BIP.srcs/sources_1/new/program.hex")
			)
		u_ram_instrucciones(
			.addra(connect_PC_adder),
			.clka(CLK100MHZ),
			.ena(1),
			.douta(output_program_mem)
			);

	PC #(
		.len(11))
		u_PC(
			.In(connect_adder_PC),
			.enable(connect_WrPC),
			.clk(CLK100MHZ),
			.Out(connect_PC_adder)
			);

	adder_PC #(
		.len(11),
		.sumando(1)
		)
		u_adder_PC(
			.In(connect_PC_adder),
			.Out(connect_adder_PC)
			);

endmodule
