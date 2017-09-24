`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2017 07:02:12 PM
// Design Name: 
// Module Name: tb_uart
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

`define NBITS 8
`define NUM_TICKS 16

module tb_uart(

    );

	reg CLK_100MHZ;
	reg reset;
	reg tx_start;
	reg [`NBITS-1 : 0] data_in;

	wire [`NBITS-1 : 0] data_out;
	wire rx_done_tick;
	wire tx_done_tick;
	
	uart #()
	u_uart(
			.CLK_100MHZ(CLK_100MHZ),
			.reset(reset),
			.tx_start(tx_start),
			.data_in(data_in),
			.data_out(data_out),
			.rx_done_tick(rx_done_tick),
			.tx_done_tick(tx_done_tick)
		);

	initial
	begin
    	CLK_100MHZ = 0;
    	reset = 1;
    	#10
    	reset = 0;
        
    	data_in = 8'b 10101010;
    	
    	tx_start = 1;
    	#10
    	tx_start = 0;
	end

	always 
		#5 CLK_100MHZ = ~CLK_100MHZ;


endmodule
