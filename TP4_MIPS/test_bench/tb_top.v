`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2017 03:38:48 PM
// Design Name: 
// Module Name: tb_top
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


module tb_top(

    );
    
	reg clk;
	reg reset;

	reg flag = 0;

    top#(
    	.LEN(32)
 		)
        u_top(
        	.clk(clk),
        	.reset(reset)
        );

	initial
	begin
		clk = 0;
		reset = 1;
		#8
		reset = 0;
		#30
		flag = 1;
	end

	always 
	begin
		#5 clk = ~clk;
		// if(flag == 0)
		// #5 clk = clk;
		// else
		// #5 clk = ~clk;
	end
    
endmodule
