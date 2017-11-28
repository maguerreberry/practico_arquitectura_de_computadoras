`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:13:55 PM
// Design Name: 
// Module Name: PC
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


module pc#(
    parameter len = 32
    ) (
    input [len-1:0] In,
    input clk,
    input reset,

    output reg [len-1:0] Out = 0
    );

    always @(posedge clk) begin
		if (reset) begin
          Out = 0;
        end
        else begin
	   		Out = In;
	   	end
	end

endmodule
