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


module decoder(
    input [4:0] opcode,
    output reg WrPC,
    output reg [1:0] SelA,
    output reg SelB,
    output reg WrAcc,
    output reg Op,
    output reg WrRam,
    output reg RdRam
    );

	always @(*) 
	begin
		case(opcode)
			5'b 00000: 
			begin //HALT
				WrPC <= 0;
				SelA <= 0;
				SelB <= 0;
				WrAcc <= 0;
				Op <= 0;
				WrRam <= 0;
				RdRam <= 0;
			end
			5'b 00001: 
			begin //STORE
				WrPC <= 1;
				SelA <= 0;
				SelB <= 0;
				WrAcc <= 0;
				Op <= 0;
				WrRam <= 1;
				RdRam <= 0;			 	
			end 
			5'b 00010: //LOAD VAR
			begin
				WrPC <= 1;
				SelA <= 0;
				SelB <= 0;
				WrAcc <= 1;
				Op <= 0;
				WrRam <= 0;
				RdRam <= 1;
			end
			5'b 00011: 
			begin //LOAD IMM
				WrPC <= 1;
				SelA <= 1;
				SelB <= 0;
				WrAcc <= 1;
				Op <= 0;
				WrRam <= 0;
				RdRam <= 0;
			end
			5'b 00100: //ADD VAR
			begin
				WrPC <= 1;
				SelA <= 2;
				SelB <= 0;
				WrAcc <= 1;
				Op <= 0;
				WrRam <= 0;
				RdRam <= 1;				
			end
			5'b 00101: 
			begin //ADD IMM
				WrPC <= 1;
				SelA <= 2;
				SelB <= 1;
				WrAcc <= 1;
				Op <= 0;
				WrRam <= 0;
				RdRam <= 0;				
			end
			5'b 00110: 
			begin //SUB VAR
				WrPC <= 1;
				SelA <= 2;
				SelB <= 0;
				WrAcc <= 1;
				Op <= 1;
				WrRam <= 0;
				RdRam <= 1;								
			end
			5'b 00111: 
			begin //SUB IMM
				WrPC <= 1;
				SelA <= 2;
				SelB <= 1;
				WrAcc <= 1;
				Op <= 1;
				WrRam <= 0;
				RdRam <= 0;								
			end
			default: 
			begin
				WrPC <= 0;
				SelA <= 0;
				SelB <= 0;
				WrAcc <= 0;
				Op <= 0;
				WrRam <= 0;
				RdRam <= 0;
			end		
		endcase
	end

endmodule
