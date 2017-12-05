`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2017 03:37:45 PM
// Design Name: 
// Module Name: mux_PC
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


module mux_PC #(
	parameter len = 32
	) (
	input [len-1:0] jump,
	input [len-1:0] branch,
	input [len-1:0] register,
	input [len-1:0] pc,
	input [1:0] select,
	output reg [len-1:0] out_mux_PC
    );

    always @(*) 
    begin
    	case (select)
    		2'b 00: out_mux_PC <= pc; 
    		2'b 01: out_mux_PC <= branch;
    		2'b 10: out_mux_PC <= register;
    		2'b 11: out_mux_PC <= jump;
    	endcase
   	end
	    
endmodule
