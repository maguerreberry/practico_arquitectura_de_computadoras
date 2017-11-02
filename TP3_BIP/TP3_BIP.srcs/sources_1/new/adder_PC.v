`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:12:21 PM
// Design Name: 
// Module Name: adder_PC
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


module adder_PC #(
	parameter len = 16,
	parameter sumando = 1
	) (
    input [len-1:0] In,
    output reg [len-1:0] Out
    );

    always@(*)
    begin
      Out = sumando + In;
    end

endmodule
