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


module hazard_detection_unit #(
	parameter len = 32,
	parameter NB = $clog2(len)
	)(
	input mem_read_2_3,
	input [NB-1:0] rt_2_3,
	input [NB-1:0] rs_1_2,
	input [NB-1:0] rt_1_2,


    );


endmodule
