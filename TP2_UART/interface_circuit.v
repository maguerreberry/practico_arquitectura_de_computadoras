`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2017 08:23:13 PM
// Design Name: 
// Module Name: interface_circuit
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


module interface_circuit
#(
	parameter LEN_DATA = 8 // # buffer bits 
) 
( 
	input clk,
 	input reset,
 	input rx_done_tick,
// 	input tx_done_tick,
 	input [LEN_DATA-1:0] rx_data_in,
 	input [LEN_DATA-1:0] alu_data_in,

 	output reg tx_start,
	output reg [LEN_DATA-1 : 0] A,
	output reg [LEN_DATA-1 : 0] B,
	output reg [5 : 0] OPCODE,
 	output reg [LEN_DATA-1:0] data_out 
); 
	reg [1 : 0] counter_in = 2'b 00;
	
	always @(posedge clk , posedge reset) 
	begin
		if (reset) 
			begin 
				A = 0;
				B = 0;
				OPCODE = 0;
				counter_in = 0;
				tx_start = 1'b 0;	
				data_out = 0;		
			end 
		
		else
			begin		 	
				if (rx_done_tick) 
					begin
						case (counter_in)
							2'b 00: A = rx_data_in;
							2'b 01: B = rx_data_in;
							2'b 10: OPCODE = rx_data_in;
						endcase		
						counter_in = counter_in + 1'b 1;		
					end
			
				if (counter_in == 2'b 11)
					begin
						counter_in = 0;
						data_out = alu_data_in; 			
						tx_start = 1'b 1;
					end
				else
					begin
						tx_start = 1'b 0;				
					end		
			end 
    end
endmodule
