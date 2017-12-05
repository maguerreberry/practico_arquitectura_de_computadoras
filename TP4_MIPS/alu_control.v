`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:15:44 PM
// Design Name: 
// Module Name: decoder
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


module alu_control(
	input clk,
    input [5:0] opcode_lsb,
    input [2:0] aluop,

    output reg [3:0] alu_code
    );

	always @(posedge clk) 
	begin
		case(aluop)
			3'b000 : 
			begin //R-type
				case(opcode_lsb)
					6'b000000 : alu_code <= 4'b0000; // sll
					6'b000010 : alu_code <= 4'b0001; // srl
					6'b000011 : alu_code <= 4'b0010; // sra
					6'b000100 : alu_code <= 4'b0000; // sllv
					6'b000110 : alu_code <= 4'b0001; // srlv
					6'b000111 : alu_code <= 4'b0010; // srav
					6'b100001 : alu_code <= 4'b0011; // addu
					6'b100011 : alu_code <= 4'b0100; // subu
					6'b100100 : alu_code <= 4'b0101; // and
					6'b100101 : alu_code <= 4'b0110; // or
					6'b100110 : alu_code <= 4'b0111; // xor
					6'b100111 : alu_code <= 4'b1000; // nor
					6'b101010 :	alu_code <= 4'b0100; // slt

				endcase
			end			
			3'b001 : alu_code <= 4'b0011; //sumar
			3'b010 : alu_code <= 4'b0101; //and
			3'b011 : alu_code <= 4'b0110; //or
			3'b100 : alu_code <= 4'b0111; //xor
			3'b101 : alu_code <= 4'b0000; //shift left
			3'b110 : alu_code <= 4'b0100; //restar 
			3'b111 : alu_code <= 4'b1001; // INSTRUCCION LUI -> SHIFT 16 IZQUIERDA
			default: alu_code <= 4'bxxxx;	
		endcase
	end

endmodule
