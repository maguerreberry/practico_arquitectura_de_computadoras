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

`define lenghtIN 8
`define lenghtOP 6

module tb_alu(
    );
	
	reg [`lenghtIN - 1 : 0] SW; 
	reg but_izq;
	reg but_center;
	reg SW_OP;
	reg CLK100MHZ;
	
	wire [`lenghtIN - 1 : 0] LED; 

	top #(.lenghtIN(`lenghtIN), .lenghtOP(`lenghtOP))
	u_top(
		.SW(SW),
		.but_izq(but_izq),
		.but_center(but_center),
		.SW_OP(SW_OP),
		.CLK100MHZ(CLK100MHZ),

		.LED(LED)
		);

	initial begin
		CLK100MHZ = 0;
		
		// Test ADD

		SW = `lenghtIN'h01;
		but_izq = 1;

		#10

		but_izq = 0;
		SW = `lenghtIN'h02;
		but_center = 1;

		#10

		but_center = 0;
		SW = `lenghtOP'b 100000;
		SW_OP = 1; 

		// LEDs -> 0000 0011 -> 2 + 1 = 3

		#10

		// Test ADD Overflow
		
		SW_OP = 0; 		
		SW = `lenghtIN'h01;
		but_izq = 1;

		#10

		but_izq = 0;
		SW = `lenghtIN'd0127;
		but_center = 1;

		#10

		but_center = 0;
		SW = `lenghtOP'b 100000;
		SW_OP = 1; 

		// LEDs -> 1000 0010 -> 127 + 1 = -128 (Overflow)

		#10

		// Test SUB

		SW_OP = 0;
		SW = `lenghtIN'h03;
		but_izq = 1;

		#10

		but_izq = 0;
		SW = `lenghtIN'h05;
		but_center = 1;

		#10

		but_center = 0;
		SW = `lenghtOP'b 100010;
		SW_OP = 1; 

		// LEDs -> 1111 1110 -> 3 - 5 = -2

		#10

		// Test AND

		SW_OP = 0;
		SW = `lenghtIN'b11111111;
		but_izq = 1;

		#10

		but_izq = 0;
		SW = `lenghtIN'b00001111;
		but_center = 1;

		#10

		but_center = 0;
		SW = `lenghtOP'b 100100;
		SW_OP = 1; 

		// LEDs -> 0000 1111

		#10

		// Test OR

		SW_OP = 0;
		SW = `lenghtIN'b00000001;
		but_izq = 1;

		#10

		but_izq = 0;
		SW = `lenghtIN'b00001111;
		but_center = 1;

		#10

		but_center = 0;
		SW = `lenghtOP'b 100101;
		SW_OP = 1; 

		// LEDs -> 0000 1111

		#10

		// Test XOR

		SW_OP = 0;
		SW = `lenghtIN'b11111111;
		but_izq = 1;

		#10

		but_izq = 0;
		SW = `lenghtIN'b00001111;
		but_center = 1;

		#10

		but_center = 0;
		SW = `lenghtOP'b 100110;
		SW_OP = 1; 

		// LEDs -> 1111 0000

		#10

		// Test SRA (Shift Right Aritmetico)

		SW_OP = 0;
		SW = `lenghtIN'b10001000;
		but_izq = 1;

		#10

		but_izq = 0;
		SW = `lenghtIN'd2;
		but_center = 1;

		#10

		but_center = 0;
		SW = `lenghtOP'b 000011;
		SW_OP = 1; 

		// LEDs -> 1110 0010 -> -120 / 4 = -30

		#10

		// Test SRL (Shift Right Logico)

		SW_OP = 0;
		SW = `lenghtIN'd100;
		but_izq = 1;

		#10

		but_izq = 0;
		SW = `lenghtIN'd2;
		but_center = 1;

		#10

		but_center = 0;
		SW = `lenghtOP'b 000010;
		SW_OP = 1; 

		// LEDs -> 0001 1001 -> 100 / 4 = 25

		#10

		// Test NOR

		SW_OP = 0;
		SW = `lenghtIN'b00001111;
		but_izq = 1;

		#10

		but_izq = 0;
		SW = `lenghtIN'b00000011;
		but_center = 1;

		#10

		but_center = 0;
		SW = `lenghtOP'b 100111;
		SW_OP = 1; 

		// LEDs -> 1111 0000

	end

	always
		#5 CLK100MHZ = ~CLK100MHZ;
		
endmodule