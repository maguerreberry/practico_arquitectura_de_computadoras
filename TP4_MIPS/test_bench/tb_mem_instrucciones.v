`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2017 07:24:24 PM
// Design Name: 
// Module Name: tb_alu
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

`define len 32
`define NB $clog2(`len)

module tb_mem_instrucciones(
    );

	reg CLK100MHZ;
	reg wea;
	reg [31:0] addra;
	reg [31:0] dina;

	ram_instrucciones #(
		.RAM_WIDTH(`len),
		.RAM_DEPTH(2048),
		// .INIT_FILE("/home/facundo/Desktop/practico_arquitectura_de_computadoras/TP4_MIPS/program.hex"),
        // .INIT_FILE("E:/Drive/Facultad/quinto/Arquitectura_de_Computadoras/TP4_MIPS/program.hex"),
		.RAM_PERFORMANCE("LOW_LATENCY")
		)
		u_ram_instrucciones(
			.addra(addra),
			.clka(CLK100MHZ),
			.reset(),
			.ena(1),
			.wea(wea),
			.dina(dina)
			); 	


	initial begin

		CLK100MHZ = 0;

		#10

		addra = 0;
		wea = 1;
		dina = 1;

	end

	always
		#5 CLK100MHZ = ~CLK100MHZ;
		
endmodule