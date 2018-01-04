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
    reg [31:0] instruccion;
    reg uart_puente_selector;

    reg tx_start_debug;
    wire tx_done_debug;

    localparam [7:0] StartSignal		= 8'b 00000001,
					 ContinuosSignal  	= 8'b 00000010,
					 StepByStepSignal   = 8'b 00000011,
					 ReProgramSignal 	= 8'b 00000101,
					 StepSignal			= 8'b 00000110;

    top_modular#(
    	.LEN(32),
        .estamos_en_test_bench(1)
 		)
        u_top_modular(
        	.CLK100MHZ(clk),
        	.SWITCH_RESET(reset),
            .uart_in_debug(uart_debug),
            .select_uart_puente(uart_puente_selector),

            .tx_start_debug(tx_start_debug),
            .tx_done_debug(tx_done_debug)
        );

    integer program_file;

    localparam [5:0] EXECUTE      = 6'b 000001;
    localparam [5:0] READING      = 6'b 000010;
    localparam [5:0] TX1          = 6'b 000100;
    localparam [5:0] TX2          = 6'b 001000;
    localparam [5:0] TX3          = 6'b 010000;
    localparam [5:0] TX4          = 6'b 100000;
    localparam [5:0] IDLE         = 6'b 100001;
    localparam [5:0] INICIAL      = 6'b 101010;

    reg [5:0] state = INICIAL;

	initial
	begin
		clk = 0;
		reset = 1;
        uart_puente_selector = 1;

       program_file = $fopen("/home/facundo/Desktop/practico_arquitectura_de_computadoras/TP4_MIPS/program.hex", "r");
         // program_file = $fopen("E:/Drive/Facultad/quinto/Arquitectura_de_Computadoras/TP4_MIPS/program.hex", "r");

        if(program_file == 0) $stop;

        #12

        // uart_debug = StartSignal;
        reset = 0;

        // #2000000

        // uart_debug = ContinuosSignal;
	end

	always 
	begin
		#5 clk = ~clk;
	end

    always @(posedge clk) begin

        case(state)
            INICIAL:
                begin
                    uart_puente_selector = 1;
                    uart_debug = StartSignal;
                    tx_start_debug = 1;
                    if (tx_done_debug) begin
                        state = READING;
                        tx_start_debug = 0;
                    end
                end
            READING:
                begin
                    $fscanf(program_file, "%x", instruccion);
                    state = TX1;
                end

            TX1:
                begin
                    uart_debug = instruccion[7:0];
                    tx_start_debug = 1;
                    if (tx_done_debug) begin
                        state = TX2;
                        tx_start_debug = 0;
                    end
                end
            TX2:
                begin
                    uart_debug = instruccion[15:8];
                    tx_start_debug = 1;
                    if (tx_done_debug) begin
                        state = TX3;
                        tx_start_debug = 0;
                    end
                end
            TX3:
                begin
                    uart_debug = instruccion[23:16];
                    tx_start_debug = 1;
                    if (tx_done_debug) begin
                        state = TX4;
                        tx_start_debug = 0;
                    end
                end                
            TX4:
                begin
                    uart_debug = instruccion[31:24];
                    tx_start_debug = 1;
                    if (tx_done_debug) begin

                        if(& instruccion[31:26])begin
                            state = EXECUTE;
                        end
                        else begin
                            state = READING;
                        end
                        tx_start_debug = 0;
                    end
                end
            // EXECUTE: // continuous
            //     begin
            //         uart_debug = ContinuosSignal;
            //         tx_start_debug = 1;
            //         if (tx_done_debug) begin
            //             uart_puente_selector = 0;
            //             state = IDLE;
            //         end
            //     end
            EXECUTE: // step by step
                begin
                    uart_debug = StepByStepSignal;
                    tx_start_debug = 1;
                    if (tx_done_debug) begin
                        state = IDLE;
                    end
                end
            // IDLE: // continuous
            //     begin
            //         uart_debug = 0;
            //         tx_start_debug = 0;                    
            //     end
            IDLE: // step by step
                begin
                    uart_debug = StepSignal;
                    tx_start_debug = 1;
                    if (tx_done_debug) begin
                        state = IDLE;
                    end
                end
        endcase
    end

endmodule


        // #20

        // uart_debug = 0;

        // #2000000

        // uart_debug = StepByStepSignal;
// 
        // #20
        // uart_debug = 0;

        // #20
// 
        // uart_debug = StepSignal;
        // #20
        // uart_debug = 0;

        // #2000000

        // uart_debug = StepSignal;

        // #20
        // // clk_mips = 0;
        // uart_debug = 0;

        // #2000000

        // uart_debug = StepSignal;

        // #20
        // // clk_mips = 0;
        // uart_debug = 0;

        // #2000000

        // uart_debug = StepSignal;

        // #20
        // // clk_mips = 0;
        // uart_debug = 0;

        // #2000000

        // uart_debug = StepSignal;

        // #20
        // // clk_mips = 0;
        // uart_debug = 0;

        // #2000000

        // uart_debug = StepSignal;

        // #20
        // // clk_mips = 0;
        // uart_debug = 0;

        // #2000000

        // uart_debug = StepSignal;

        // #20
        // // clk_mips = 0;
        // uart_debug = 0;

        // #2000000

        // uart_debug = StepSignal;

        // #20
        // // clk_mips = 0;
        // uart_debug = 0;

        // #2000000

        // uart_debug = StepSignal;

        // #20
        // // clk_mips = 0;
        // uart_debug = 0;