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

`define lenghtIN 8
`define lenghtOP 6

module alu(
	//inputs
	A,
	B,
	OPCODE,

	//output
	RESULT_OUT  
    );

	parameter lenghtIN = `lenghtIN; 	
	parameter lenghtOP = `lenghtOP;

	input signed [lenghtIN-1 : 0] A;
	input signed [lenghtIN-1 : 0] B;
	input signed [lenghtOP-1 : 0] OPCODE;

	output reg [lenghtIN - 1 : 0] RESULT_OUT; 

	always @(*)
	begin
		case (OPCODE)
			6'b 100000: RESULT_OUT = A + B;
			6'b 100010: RESULT_OUT = A - B;
			6'b 100100: RESULT_OUT = A & B;
			6'b 100101: RESULT_OUT = A | B;
			6'b 100110: RESULT_OUT = A ^ B;
			6'b 000011: RESULT_OUT = A >>> B;
			6'b 000010: RESULT_OUT = A >> B;
			6'b 100111: RESULT_OUT = ~(A | B);
			default: RESULT_OUT = 0;
		endcase	
	end

	endmodule
