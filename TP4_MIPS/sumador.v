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


module sumador #(
	parameter len1 = 32, // tener en cuenta que en el In1 simepre va la entrada mas grande
    parameter len2 = 32
    ) (
    input [len1-1:0] In1,
    input [len2-1:0] In2,
    output [len1-1:0] Out
    );

    assign Out = In1 + In2; 

    // always@(*)
    // begin
    //   Out = In1 + In2;
    // end

endmodule
