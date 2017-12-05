`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2017 07:21:59 PM
// Design Name: 
// Module Name: alu
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

module alu #(
	parameter lenghtIN = 32,
	parameter lenghtOP = 4
	)(
	//inputs
	A,
	B,
	OPCODE,

	//output
	RESULT_OUT  
    );

	input signed [lenghtIN-1 : 0] A;
	input signed [lenghtIN-1 : 0] B;
	input signed [lenghtOP-1 : 0] OPCODE;

	output reg [lenghtIN - 1 : 0] RESULT_OUT; 

	always @(*)
	begin
		case (OPCODE)
			4'b 0000: RESULT_OUT = B << A; //shift left
			4'b 0001: RESULT_OUT = B >> A; //shift right logico
			4'b 0010: RESULT_OUT = B >>> A; //shift right aritmetico
			4'b 0011: RESULT_OUT = A + B; //add
			4'b 0100: RESULT_OUT = A - B; //sub
			4'b 0101: RESULT_OUT = A & B; //and
			4'b 0110: RESULT_OUT = A | B; //or
			4'b 0111: RESULT_OUT = A ^ B; //xor
			4'b 1000: RESULT_OUT = ~(A | B); //nor




			default: RESULT_OUT = 0;
		endcase	
	end

	endmodule
