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


module mux_B(
    input [15:0] out_ram,
    input [15:0] out_sign_extend,
    input SelB,
    output [15:0] Out
    );

    assign Out = (SelB) ? out_sign_extend : out_ram;

endmodule
