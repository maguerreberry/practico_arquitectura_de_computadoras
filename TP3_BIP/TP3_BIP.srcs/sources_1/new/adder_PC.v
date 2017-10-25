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


module adder_PC(
    input [10:0] one,
    input [10:0] In,
    output reg [10:0] Out
    );

    assign one = 11'b00000000001;

    always@(*)
        begin
          assign Out = one + In;
        end

endmodule
