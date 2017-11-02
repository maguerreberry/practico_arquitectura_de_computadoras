`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:11:11 PM
// Design Name: 
// Module Name: signal_extend
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


module signal_extend#(
	parameter len_in = 11,
	parameter len_out = 16
	) (
    input [len_in-1:0] In,
    output reg [len_out-1:0] Out
    );

    always@(*)
    begin 
        Out <= $signed(In);
    end

endmodule
