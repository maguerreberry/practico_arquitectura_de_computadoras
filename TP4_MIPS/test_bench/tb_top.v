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
    reg [7:0] uart_debug;

    localparam [7:0] StartSignal		= 8'b 00000001,
					 ContinuosSignal  	= 8'b 00000010,
					 StepByStepSignal   = 8'b 00000011,
					 ReProgramSignal 	= 8'b 00000101,
					 StepSignal			= 8'b 00000110;

    top_modular#(
    	.LEN(32)
 		)
        u_top_modular(
        	.CLK100MHZ(clk),
        	.SWITCH_RESET(reset),
            .uart_in_debug(uart_debug),
        );

	initial
	begin
		clk = 0;
		reset = 1;
		#12
        uart_debug = StepByStepSignal;
		reset = 0;

		#20
		uart_debug = 0;

        #20

        uart_debug = StepSignal;
        #20
        uart_debug = 0;

        #2000000

        uart_debug = StepSignal;

        #20
        // clk_mips = 0;
        uart_debug = 0;

        #2000000

        uart_debug = StepSignal;

        #20
        // clk_mips = 0;
        uart_debug = 0;

        #2000000

        uart_debug = StepSignal;

        #20
        // clk_mips = 0;
        uart_debug = 0;

        #2000000

        uart_debug = StepSignal;

        #20
        // clk_mips = 0;
        uart_debug = 0;

        #2000000

        uart_debug = StepSignal;

        #20
        // clk_mips = 0;
        uart_debug = 0;

        #2000000

        uart_debug = StepSignal;

        #20
        // clk_mips = 0;
        uart_debug = 0;

        #2000000

        uart_debug = StepSignal;

        #20
        // clk_mips = 0;
        uart_debug = 0;

        #2000000

        uart_debug = StepSignal;

        #20
        // clk_mips = 0;
        uart_debug = 0;

	end

	always 
	begin
		#5 clk = ~clk;
	end

endmodule
