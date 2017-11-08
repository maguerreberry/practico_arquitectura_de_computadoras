`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2017 05:47:04 PM
// Design Name: 
// Module Name: tb_top
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


module tb_control_top(

    );
	
	reg clk = 0;
	wire [10:0] connect_PC_adder;
	wire [15:0] output_program_mem;

	
	control_top #()
	u_control_top(
		.CLK100MHZ(clk),
		.Addr(connect_PC_adder),
		.Data(output_program_mem)
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
			.clka(clk),
			.douta(output_program_mem)
			);

	always #5 clk = ~clk;
endmodule
