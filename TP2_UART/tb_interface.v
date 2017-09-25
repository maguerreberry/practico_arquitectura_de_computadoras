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

module tb_interface();
	
    reg clk,
    reg reset,
    reg rx_done_tick,
//  reg tx_done_tick,
    reg [LEN_DATA-1:0] rx_data_in,
    reg [LEN_DATA-1:0] alu_data_in,

    wire tx_start,
    wire [LEN_DATA-1 : 0] A,
    wire [LEN_DATA-1 : 0] B,
    wire [5 : 0] OPCODE,
    wire [LEN_DATA-1:0] data_out 

	interface_circuit #()
    u_interface_circuit(
            .clk(clk),
            .reset(reset),
            .rx_done_tick(rx_done_tick),
            .rx_data_in(rx_data_in),
            .alu_data_in(alu_data_in),

            .tx_start(tx_start),
            .A(A),
            .B(B),
            .OPCODE(OPCODE),
            .data_out(data_out) 
		);

	initial
	begin
    	clk = 0;
    	reset = 1;
    	#10
    	reset = 0;
        
        rx_data_in = 8'b00000001;
        rx_done_tick = 1;
        #10

        rx_done_tick = 0;
        rx_data_in = 8'b00000010;
        rx_done_tick = 1;
        #10        

        rx_done_tick = 0;
        rx_data_in = 8'b00100000;
        rx_done_tick = 1;
        #10

        rx_done_tick = 0;

        #10

        data_out = 8'b00000011;

	end

	always 
		#5 clk = ~clk;


endmodule
