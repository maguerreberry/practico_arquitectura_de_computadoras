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


module io #(
	parameter len_opcode = 5,
    parameter len_acc = 16
	) (
    input clk,
    input [len_opcode-1:0] in_opcode,
    input [len_acc-1:0] in_acc,
    input 

    output reg [len_pc-1:0] ciclos = 0,
    output [len_acc-1:0] acc
    );

    assign acc = in_acc;

    always @(negedge clk) begin
        if (in_opcode != 0) begin
            ciclos = ciclos + 1;
		end

endmodule
