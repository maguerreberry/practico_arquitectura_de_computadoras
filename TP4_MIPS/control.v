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


module control(
    input [5:0] opcode,
    output reg RegDst,
    output reg [1:0] ALUOp,
    output reg ALUSrc,
    output reg Branch,
    output reg MemRead,
    output reg MemWrite,
    output reg RegWrite,
    output reg MemtoReg
    );

	always @(*) 
	begin
		case(opcode)
			6'b 000000: 
			begin //R-type
				RegDst = 1;
				ALUOp[1] = 1;
				ALUOp[0] = 0;
				ALUSrc = 0;
				Branch = 0;
				MemRead = 0;
				MemWrite = 0;
				RegWrite = 1;
				MemtoReg = 0;
			end			
			6'b 100011: 
			begin //LOAD
				RegDst = 0;
				ALUOp[1] = 0;
				ALUOp[0] = 0;
				ALUSrc = 1;
				Branch = 0;
				MemRead = 1;
				MemWrite = 0;
				RegWrite = 1;
				MemtoReg = 1;
			end
			6'b 101011: 
			begin //STORE
				RegDst = 0;
				ALUOp[1] = 0;
				ALUOp[0] = 0;
				ALUSrc = 1;
				Branch = 0;
				MemRead = 0;
				MemWrite = 1;
				RegWrite = 0;
				MemtoReg = 0;
			end
			6'b 000100: 
			begin //BRANCH
				RegDst = 0;
				ALUOp[1] = 0;
				ALUOp[0] = 1;
				ALUSrc = 0;
				Branch = 1;
				MemRead = 0;
				MemWrite = 0;
				RegWrite = 0;
				MemtoReg = 0;			
			end
			default: 
			begin
				RegDst = 0;
				ALUOp[1] = 0;
				ALUOp[0] = 0;
				ALUSrc = 0;
				Branch = 0;
				MemRead = 0;
				MemWrite = 0;
				RegWrite = 0;
				MemtoReg = 0;			
			end		
		endcase
	end

endmodule
