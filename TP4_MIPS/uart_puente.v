`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2018 02:41:05 PM
// Design Name: 
// Module Name: uart_puente
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


module uart_puente(
	input CLK100MHZ,
	input SWITCH_RESET,
	input UART_TXD_IN,
	output UART_RXD_OUT,
	output [2:0] led,
	output [5:0] led_state
    );

	wire	tx_done,
			rx_done,
			tx_start;

	assign tx_start = rx_done;

	wire	[7:0]	data_puente;	

	uart #(
		.NBITS(8),
		.NUM_TICKS(16),
		.BAUD_RATE(9600),
		.CLK_RATE(30000000)
		)
		u_uart(
			.CLK_100MHZ(clk),
			.reset(SWITCH_RESET),
			.tx_start(tx_start),
			.rx(UART_TXD_IN),
			.data_in(data_puente),

			.data_out(data_puente),
			.rx_done_tick(rx_done),
			.tx(UART_RXD_OUT),
			.tx_done_tick(tx_done)
			);

	clk_wiz_0 
	u_clk_wiz_0
	(
		// Clock out ports
		.clk_out1(clk),     // output clk_out1
		// Status and control signals
		.reset(SWITCH_RESET), // input reset
		.locked(),       // output locked
		// Clock in ports
		.clk_in1(CLK100MHZ)      // input clk_in1
	);


endmodule
