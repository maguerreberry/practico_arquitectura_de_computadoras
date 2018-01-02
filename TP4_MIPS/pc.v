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
    input enable,

    output reg [len-1:0] Out
    );

    always @(posedge clk, negedge reset)
    begin
        if(!reset) begin
            Out = {len{1'b 0}}; 
        end
        else begin
            if(enable)
    	   		Out = In;
        end
	end

endmodule
