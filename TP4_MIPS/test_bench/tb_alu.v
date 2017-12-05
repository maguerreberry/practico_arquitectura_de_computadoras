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

`define lenghtIN 32
`define lenghtOP 4

module tb_alu(
    );
	
	reg [`lenghtIN-1 : 0] A;
	reg [`lenghtIN-1 : 0] B;
	reg [`lenghtOP-1 : 0] OPCODE;
	reg CLK100MHZ;

	alu #(.lenghtIN(`lenghtIN), .lenghtOP(`lenghtOP))
	u_alu(
		.A(A),
		.B(B),
		.OPCODE(OPCODE)
		);

	initial begin
		CLK100MHZ = 0;

		A = `lenghtIN'h3;
		B = `lenghtIN'h15;
		OPCODE = `lenghtOP'b0000; //shift left

		#10

		A = `lenghtIN'h2;
		B = `lenghtIN'h15;
		OPCODE = `lenghtOP'b0001; //shift right logico

		#10

		A = `lenghtIN'h2;
		B = -`lenghtIN'h15;
		OPCODE = `lenghtOP'b0010; //shift right aritmetico

		#10

		A = `lenghtIN'h10;
		B = `lenghtIN'h20;
		OPCODE = `lenghtOP'b0011; //add

		#10

		A = `lenghtIN'h2;
		B = -`lenghtIN'h15;
		OPCODE = `lenghtOP'b0100; //sub

		#10

		A = `lenghtIN'hF0;
		B = `lenghtIN'hE4;
		OPCODE = `lenghtOP'b0101; //and

		#10

		A = `lenghtIN'h0F;
		B = `lenghtIN'h41;
		OPCODE = `lenghtOP'b0110; //or

		#10

		A = `lenghtIN'hFB;
		B = `lenghtIN'h64;
		OPCODE = `lenghtOP'b0111; //xor


		#10

		A = `lenghtIN'hFF;
		B = `lenghtIN'hFF;
		OPCODE = `lenghtOP'b0100; //sub


		#10

		A = `lenghtIN'hF0;
		B = `lenghtIN'h31;
		OPCODE = `lenghtOP'b1000; //nor
		#10

		A = `lenghtIN'h4;
		B = `lenghtIN'h5;
		OPCODE = `lenghtOP'b0100; //sub

	end

	always
		#5 CLK100MHZ = ~CLK100MHZ;
		
endmodule