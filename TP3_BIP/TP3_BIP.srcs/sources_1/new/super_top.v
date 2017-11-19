`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 08:41:17 PM
// Design Name: 
// Module Name: super_top
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

module super_top(
	input BOARD_CLK100MHZ,
//	input SWITCH_RESET,
	input UART_TXD_IN,

	output UART_RXD_OUT,
	output LED
    );

	wire [10:0] connect_addr_instrucciones;
	wire [15:0] connect_instrucciones;
	wire [10:0] connect_addr_datos;
	wire [15:0] connect_datos_out;
	wire [15:0] connect_datos_in;

	wire [`LEN_DATA-1 : 0]connect_data_tx;
	wire [`LEN_DATA-1 : 0]connect_data_rx;

	wire connect_tx_start;
	wire connect_tx_done_tick;

	wire connect_Rd;
	wire connect_Wr;
    reg reset;
    wire CLK100MHZ;
    
    assign LED = reset;
    
//    assign reset = SWITCH_RESET;
    
 clk_wiz_0 
    u_clk_wiz_0 (
                    // Clock out ports
                    .clk_out1(CLK100MHZ),     // output clk_out1
                    // Status and control signals
                    .reset(reset), // input reset
                    .locked(),       // output locked
                    // Clock in ports
                    .clk_in1(BOARD_CLK100MHZ)
                    );      // input clk_in1
    
	uart #(
		.NBITS(`LEN_DATA),
		.NUM_TICKS(16),
		.BAUD_RATE(9600)
		)
		u_uart(
			.CLK_100MHZ(CLK100MHZ),
			.reset(reset),
			.tx_start(connect_tx_start),
			.tx_done_tick(connect_tx_done_tick),
			.data_in(connect_data_tx),
			.tx(UART_RXD_OUT),
		
			.rx(UART_TXD_IN),
			.data_out(connect_data_rx),
			.rx_done_tick()
		);

    io #()
        u_io(
            .clk(CLK100MHZ),
    		.reset(reset),
    		.in_opcode(connect_instrucciones[15:11]),
    		.in_acc(connect_datos_out),    
    		.tx_done(connect_tx_done_tick),
 
    		.tx_start(connect_tx_start),
    		.data_out(connect_data_tx) 
        );       
     
	cpu_top #()
		u_cpu_top(
			 .CLK100MHZ(CLK100MHZ),
		     .instruction_memory(connect_instrucciones),
		     .data_memory(connect_datos_in),
		     .reset(reset),

			 .addr_instruction(connect_addr_instrucciones),
			 .addr_data(connect_addr_datos),
			 .Rd(connect_Rd),
			 .Wr(connect_Wr),
		     .in_ram_data(connect_datos_out)
			);

	ram_instrucciones #(
			.RAM_WIDTH(16),
			.RAM_DEPTH(2048),
			.RAM_PERFORMANCE("LOW_LATENCY"),
			// .INIT_FILE("/home/facundo/Desktop/practico_arquitectura_de_computadoras/TP3_BIP/TP3_BIP.srcs/sources_1/new/program.hex")
            .INIT_FILE("E:/Drive/Facultad/quinto/Arquitectura_de_Computadoras/TP3_BIP/TP3_BIP.srcs/sources_1/new/program.hex")
			)
		u_ram_instrucciones(
			.addra(connect_addr_instrucciones),
			.clka(CLK100MHZ),
			.douta(connect_instrucciones)
			);

	ram_datos #(
		.RAM_WIDTH(16),
		.RAM_DEPTH(2048),
		.RAM_PERFORMANCE("LOW_LATENCY")		
		)
		u_ram_datos (
			.addra(connect_addr_datos),
			.dina(connect_datos_out),
			.clka(CLK100MHZ),
			.wea(connect_Wr),
			.regcea(connect_Rd),
			.douta(connect_datos_in)
			);
			
	always @(connect_data_rx)
	begin
	   if (connect_data_rx == 8'b01010101)
	   begin
	       reset = 1'b1;
	   end
	   
	   else
	   begin 
	       reset = 1'b0;
	   end
	end
    
    
endmodule
