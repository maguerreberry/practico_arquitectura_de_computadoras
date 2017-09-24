`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2017 09:26:45 PM
// Design Name: 
// Module Name: top
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

`define LEN_DATA 8

module top
(
	input CLK_100MHZ,
	input reset,
	input rx,
	output tx
);

	wire connect_A;
	wire connect_B;
	wire connect_OPCODE;
	wire connect_RESULT_OUT;



	alu #(
		.lenghtIN(`LEN_DATA),
		.lenghtOP(6)
		)
		u_alu
		(
			.A(connect_A),
			.B(connect_B),
			.OPCODE(connect_OPCODE),
			.RESULT_OUT(connect_RESULT_OUT)  
	    );
	
	interface_circuit #(
		.LEN_DATA(`LEN_DATA)
		)
		u_interface_circuit 
		( 
			.clk(CLK_100MHZ),
		 	.reset(reset),
		 	.rx_done_tick(),
		 	.rx_data_in(),
		 	.alu_data_in(connect_RESULT_OUT),
		
		 	.tx_start(),
			.A(connect_A),
			.B(connect_B),
			.OPCODE(connect_OPCODE),
		 	.data_out() 
		); 

	uart #(
		.NBITS(`LEN_DATA),
		.NUM_TICKS(16),
		.BAUD_RATE(9600)
		)
		u_uart
			(
				.CLK_100MHZ(CLK_100MHZ),
				.reset(reset),
				.tx_start(tx_start),
				.rx(rx),
				.data_in(data_in),
			
				.data_out(data_out),
				.rx_done_tick(rx_done_tick),
				.tx(tx),
				.tx_done_tick(tx_done_tick)
			);

endmodule
