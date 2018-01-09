`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2018 10:03:14 PM
// Design Name: 
// Module Name: tb_uart_posta
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


module tb_uart_posta(

    );

	reg clk;
	reg reset;

    reg UART_TXD_IN;

    localparam [7:0] StartSignal		= 8'b 00000001,
					 ContinuosSignal  	= 8'b 00000010,
					 StepByStepSignal   = 8'b 00000011,
					 ReProgramSignal 	= 8'b 00000101,
					 StepSignal			= 8'b 00000110;

    top_modular#(
    	.LEN(32),
        .estamos_en_test_bench(0)
 		)
        u_top_modular(
        	.CLK100MHZ(clk),
        	.SWITCH_RESET(reset),
        	.UART_TXD_IN       (UART_TXD_IN)
        );

	initial
	begin
		clk = 0;
		// reset = 1;
  //       #12
        // reset = 0;

        UART_TXD_IN = 1;

        #10

        UART_TXD_IN = 0; //bit start

        #(6510 * 16 / 4)

        UART_TXD_IN = 0;

        #(6510 * 16 / 4)

        UART_TXD_IN = 1;

        #(6510 * 16 / 4)

        UART_TXD_IN = 0;

        #(6510 * 16 / 4)

        UART_TXD_IN = 1;

        #(6510 * 16 / 4)
        UART_TXD_IN = 0;

        #(6510 * 16 / 4)

        UART_TXD_IN = 1;

        #(6510 * 16 / 4)
        UART_TXD_IN = 0;

        #(6510 * 16 / 4)

        UART_TXD_IN = 1;

        #(6510 * 16 / 4)

        UART_TXD_IN = 1; //bit stop

        #(10000)

        UART_TXD_IN = 1;

        #10

        UART_TXD_IN = 0; //bit start

        #(6510 * 16 / 4)

        UART_TXD_IN = 0;

        #(6510 * 16 / 4)

        UART_TXD_IN = 1;

        #(6510 * 16 / 4)

        UART_TXD_IN = 0;

        #(39060 * 16 / 4)

        UART_TXD_IN = 1; //bit stop
	end

	always 
	begin
		#5 clk = ~clk;
	end

endmodule
