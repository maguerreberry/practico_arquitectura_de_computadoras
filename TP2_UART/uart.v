`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2017 04:36:02 PM
// Design Name: 
// Module Name: uart
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

module uart
#(
	parameter NBITS = 8,
	parameter NUM_TICKS = 16,
	parameter BAUD_RATE = 38400,
	parameter CLK_RATE = 40000000
)
(
	input CLK_100MHZ,
	input reset,
	input tx_start,
	input rx,
	input [NBITS-1 : 0] data_in,

	output [NBITS-1 : 0] data_out,
	output rx_done_tick,
	output tx,
	output tx_done_tick
);

	wire connect_baud_rate_rx_tx; 

    baud_rate_gen #(.BAUD_RATE(BAUD_RATE), .CLK_RATE(CLK_RATE)) 
    u_baud_rate_gen (.reset(reset),
    	.CLK_100MHZ(CLK_100MHZ),
    	.CLK_TICK(connect_baud_rate_rx_tx));

    receiver #(.LEN_DATA(NBITS), .NUM_TICKS(NUM_TICKS)) 
    u_receiver (.clk(CLK_100MHZ),
				.reset(reset),
				.rx(rx),
				.tick(connect_baud_rate_rx_tx),

				.rx_done_tick(rx_done_tick),
				.data_out(data_out)
    			);

    transmisor #(.NBITS(NBITS), .NUM_TICKS(NUM_TICKS)) 
    u_transmisor (.clk(CLK_100MHZ),
				  .reset(reset),
				  .tx_start(tx_start),
				  .tick(connect_baud_rate_rx_tx),
				  .data_in(data_in),

				  .tx_done_tick(tx_done_tick),
				  .tx(tx)
    			);
endmodule	
			