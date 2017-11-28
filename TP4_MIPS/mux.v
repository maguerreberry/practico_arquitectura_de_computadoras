`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2017 07:24:28 PM
// Design Name: 
// Module Name: mux
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


module mux #(
	parameter len = 32
	) (
	input [len-1:0] in1,
	input [len-1:0] in2,
	input select,
	output [len-1:0] out_mux
    );

    assign out_mux = (select) ? (in1) : (in2);    

endmodule
