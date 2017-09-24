`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2017 05:30:54 PM
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

`define lenghtIN 8
`define lenghtOP 6

module top(
	//inputs
	SW,
	but_izq,	
	but_center,	
	SW_OP,
	CLK100MHZ,

	//output
	LED
    );

    parameter lenghtIN = `lenghtIN; 	
    parameter lenghtOP = `lenghtOP;
    
	input [lenghtIN - 1 : 0] SW; 
	input but_izq; 
	input but_center;
	input SW_OP;
	input CLK100MHZ;

	output [lenghtIN - 1 : 0] LED; 

	reg signed [lenghtIN-1 : 0] A = 0;
	reg signed [lenghtIN-1 : 0] B = 0;
	reg [lenghtOP-1 : 0] OPCODE = 0;
//	reg [lenghtIN-1 : 0] RESULT_OUT = 0;

	alu #(.lenghtIN(lenghtIN), .lenghtOP(lenghtOP))
	u_alu(
		.A(A),
		.B(B),
		.OPCODE(OPCODE),
		.RESULT_OUT(LED)
		);

	always @(posedge CLK100MHZ)
	begin
		if (but_izq == 1'b1) begin
			A = SW;			
		end
		else if (but_center == 1'b1) begin
			B = SW;			
		end
		else if (SW_OP == 1'b1) begin
			OPCODE = SW;
		end
		else begin
			A = A;	
			B = B;
			OPCODE = OPCODE;
		end
	end


endmodule
