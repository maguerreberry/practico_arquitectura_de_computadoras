`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:03:14 PM
// Design Name: 
// Module Name: accumulator
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


module accumulator(
    input [15:0] In,
    input clk,
    input WrAcc,
    output reg [15:0] Out = 0
    );

	always @(posedge clk)
	begin
		if (WrAcc) begin
			Out = In;
		end
	end

endmodule
