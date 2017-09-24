`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2017 08:57:43 PM
// Design Name: 
// Module Name: tb_baud_rate_gen
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


module tb_baud_rate_gen();

	reg CLK_100MHZ;	
	wire CLK_TICK;
    
    baud_rate_gen #() 
    u_baud_rate_gen (.CLK_100MHZ(CLK_100MHZ),
    	.CLK_TICK(CLK_TICK));
    
    initial
    begin
    	CLK_100MHZ = 0;    
    	// CLK_TICK = 0;
    end

	always 
		#5 CLK_100MHZ = ~CLK_100MHZ;

endmodule
