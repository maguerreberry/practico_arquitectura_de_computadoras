`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2017 07:24:28 PM
// Design Name: 
// Module Name: mux
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


module mux_forwarding #(
	parameter len = 32
	) (
	input [len-1:0] in_reg,			//entrada desde registros
	input [len-1:0] in_mem_forw,	//salida de alu de clock anterior
	input [len-1:0] in_wb_forw,		//salida del mux final de writeback
	input [1:0] select,
	output [len-1:0] out_mux
    );

    assign out_mux 	= (select == 2'b00) ? in_reg
    				: (select == 2'b01) ? in_mem_forw
    									: in_wb_forw;    
endmodule
