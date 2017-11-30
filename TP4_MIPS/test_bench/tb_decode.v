`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2017 08:03:30 PM
// Design Name: 
// Module Name: tb_instruction_fetch
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

`define LEN 32

module tb_decode(

    );
	
	reg clk;
	reg reset;
	reg in_pc_enable;
	reg in_pc_src;
	reg [`LEN-1:0] in_pc_jump = `LEN'b11111111000000001111111100000000;
	reg [`LEN-1:0] in_instruccion;
	reg [`LEN-1:0] datos_a_escribir;
	reg write_enable;
	reg [$clog2(`LEN)-1:0] registro_a_escribir;
	
	decode #(
		.len(`LEN)
		)
		u_decode (
			.clk(clk),
			.in_pc_jump(in_pc_jump),
			.in_instruccion(in_instruccion),
			.RegWrite(write_enable),
			.write_data(datos_a_escribir),
			.write_register(registro_a_escribir),
			.reset(reset)
		);

	initial
	begin
		clk = 0;
		reset = 0;

		write_enable = 1;
		registro_a_escribir = 0;
		datos_a_escribir = `LEN'h4;
		// escribo en el registro 0 el valor 4
		
		#30

		registro_a_escribir = 1;
		datos_a_escribir = `LEN'h7;
		// escribo en el registro 1 el valor 7

		#30

		write_enable = 0;
		in_instruccion = `LEN'b10001100000000011101100100000101;
		// elijo el registro 0 y 1 para ver su salida. 
		// en los 16 lsb pongo bits aleatorios para ver que extienda el signo

		#20
		reset = 1;
	end

	always 
		#5 clk = ~clk;


endmodule
