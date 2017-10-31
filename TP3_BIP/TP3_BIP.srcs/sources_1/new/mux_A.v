`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:08:25 PM
// Design Name: 
// Module Name: mux_A
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


module mux_A(
    input [15:0] out_memory,
    input [15:0] out_alu,
    input [15:0] out_sign_extend,
    input [1:0] SelA,

    output reg [15:0] Out
    );

    always @(*)
      case (SelA)
         2'b00: Out = out_memory;
         2'b01: Out = out_sign_extend;
         2'b10: Out = out_alu;
         2'b11: Out = 0;
      endcase
					
endmodule
