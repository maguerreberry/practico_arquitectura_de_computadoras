`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2017 08:20:41 PM
// Design Name: 
// Module Name: baud_rate_gen
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


module baud_rate_gen(
	input CLK_100MHZ,
	
	output reg CLK_TICK = 1'b 0
    );

parameter BAUD_RATE = 9600;
parameter CLK_RATE = 100000000;
localparam NUM_TICKS = 16;

parameter RATE_CLK_OUT = CLK_RATE / (BAUD_RATE * NUM_TICKS);
parameter LEN_ACUM = $clog2(RATE_CLK_OUT); 

reg [LEN_ACUM - 1 : 0] acumulator = 0;

always @(posedge CLK_100MHZ) 
begin
	acumulator = acumulator + 1;
	
	if (acumulator == (RATE_CLK_OUT)) 
	begin
		CLK_TICK = 1;
		acumulator = 0;
	end
	else
	   CLK_TICK = 0;
end

endmodule