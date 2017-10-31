`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:01:09 PM
// Design Name: 
// Module Name: arithmetic_unit
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


module arithmetic_unit(
    input Op,
    input [15:0] A,
    input [15:0] B,

    output [15:0] Out
    );
	
	assign Out = Op ? (A-B) : (A+B);
	
endmodule
