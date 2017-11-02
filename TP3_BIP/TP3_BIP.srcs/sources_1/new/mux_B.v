`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:10:19 PM
// Design Name: 
// Module Name: mux_B
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


module mux_B#(
	parameter len = 16
	) (
    input [len-1:0] out_ram,
    input [len-1:0] out_sign_extend,
    input SelB,
    
    output [len-1:0] Out
    );

    assign Out = (SelB) ? out_sign_extend : out_ram;

endmodule
