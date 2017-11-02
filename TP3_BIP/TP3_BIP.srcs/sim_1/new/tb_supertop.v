`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2017 02:44:26 PM
// Design Name: 
// Module Name: tb_supertop
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


module tb_supertop(

    );

	reg clk = 0;

	super_top #()
		u_super_top(.CLK100MHZ(clk));

	always #5 clk = ~clk;

endmodule
