`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2017 03:11:48 PM
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


module top_modular#(
	parameter LEN = 32,
	parameter NB = $clog2(LEN),
	parameter len_exec_bus = 11,
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2
	)(
	input CLK100MHZ,
	input SWITCH_RESET,
	input UART_TXD_IN,
	input [7:0] uart_in_debug,

	output UART_RXD_OUT
    );    
    wire clk, reset, clk_mips, ctrl_clk_mips, reset_mips;    
    assign clk = CLK100MHZ,
           reset = SWITCH_RESET; 

    wire [LEN-1:0] connect_in_pc_branch_1_2,
				   connect_in_pc_branch_2_3,
				   connect_in_pc_branch_3_1,
				   connect_in_pc_jump,
				   connect_in_pc_jump_register,
				   connect_instruccion,
				   connect_reg1,
				   connect_reg2,
				   connect_sign_extend,
				   connect_alu_out,
				   connect_write_data_5_2,
				   connect_read_data,
				   connect_out_addr_mem,
				   connect_write_data_3_4,
				   connect_in_pc_branch_3_4,
				   connect_in_pc_branch_4_1,
				   connect_regs_recolector_mips,
				   connect_mem_datos_recolector_mips,
				   connect_addr_recolector_mips,
				   connect_data_recolector,
				   connect_pc_debug,
				   connect_addr_mem_inst;

	wire [NB-1:0] connect_rt,
				  connect_rd,
				  connect_rs,
				  connect_shamt,
				  connect_write_reg_3_4,
				  connect_write_reg_4_2;

    wire [len_exec_bus-1:0] connect_execute_bus;
	
	wire [len_mem_bus-1:0] connect_memory_bus_2_3,
			   connect_memory_bus_3_4;
	
	wire [len_wb_bus-1:0] connect_writeBack_bus_2_3,
			   connect_out_writeBack_bus,
			   connect_writeBack_bus_3_4;
    
    wire connect_flag_jump,
         connect_flag_jump_register,
	     connect_zero_flag,
	     connect_branch_flag,
	     connect_stall_flag,
	     connect_uart_rx_done,
	     connect_uart_tx_start,
	     connect_uart_tx_done,
		 connect_restart_recolector,
		 connect_send_regs,
		 connect_enable_next,
		 connect_reprogram,
		 connect_debug_mode,
		 connect_halt;


    wire [7:0] connect_uart_data_in,
			   connect_uart_data_out;

	assign connect_write_data_5_2 = (connect_out_writeBack_bus[0]) ? connect_read_data : connect_out_addr_mem;

	assign clk_mips = (ctrl_clk_mips) ? (clk) : (1'b 0);


	top_mips #(
	.LEN(32),
	.NB($clog2(LEN)),
	.len_exec_bus(11),
	.len_mem_bus(9),
	.len_wb_bus(2)
	)
	u_top_mips(
		.clk(clk_mips),
		.reset(reset),

		//para debug
		.debug_flag(connect_debug_mode),
		.in_addr_debug(connect_addr_recolector_mips),
		.in_addr_mem_inst(connect_addr_mem_inst),

		.out_reg1_recolector(connect_regs_recolector_mips),
		.out_mem_wire(connect_mem_datos_recolector_mips),
		.out_pc(connect_pc_debug),
		.halt_flag(connect_halt)
		);
	
	recolector #(
		.len(LEN)
		)
		u_recolector(
			.clk(clk),
			.regs(connect_regs_recolector_mips),
			.mem_datos(connect_mem_datos_recolector_mips),
			.enable_next(connect_enable_next),
			.send_regs(connect_send_regs),
			.restart(connect_restart_recolector),		
			.addr(connect_addr_recolector_mips),
			.data(connect_data_recolector)
	    ); 	

	maquina_estados #(
		.len(LEN),
		.cant_instrucciones(64),
		.nb_Latches_1_2((LEN*5)/8),
		.nb_Latches_2_3((LEN*5)/8),
		.nb_Latches_3_4((LEN*5)/8),
		.nb_Latches_4_5((LEN*5)/8),
		.cant_regs(32),
		.cant_mem_datos(16),
		.LEN_DATA(8)
		)
		u_maquina_estados(
		    .clk(clk),
		    .reset(reset),
		    .halt(connect_halt),
		    .pc(connect_pc_debug),
		    .Latches_1_2(),
		    .Latches_2_3(),
		    .Latches_3_4(),
		    .Latches_4_5(),
		    .recolector(connect_data_recolector),

		    // outputs
		    .addr_mem_inst(connect_addr_mem_inst),
		    .ins_to_mem(),
		    .reset_mips(reset_mips),
		    .reprogram(connect_reprogram),
		    .ctrl_clk_mips(ctrl_clk_mips),
			.restart_recolector(connect_restart_recolector),
			.send_regs_recolector(connect_send_regs),
			.enable_next_recolector(connect_enable_next),
			.debug(connect_debug_mode),
		
		    //UART
		    .tx_done(connect_uart_tx_done),
		    .rx_done(connect_uart_rx_done),
		    // .uart_data_in(connect_uart_data_out), 

		    .uart_data_in(uart_in_debug),

		    .tx_start(connect_uart_tx_start),
		    .uart_data_out(connect_uart_data_in) 
			);

	uart #(
		.NBITS(8),
		.NUM_TICKS(16),
		.BAUD_RATE(9600)
		)
		u_uart(
			.CLK_100MHZ(clk),
			.reset(reset),
			.tx_start(connect_uart_tx_start),
			.rx(UART_TXD_IN),
			.data_in(connect_uart_data_in),

			.data_out(connect_uart_data_out),
			.rx_done_tick(connect_uart_rx_done),
			.tx(UART_RXD_OUT),
			.tx_done_tick(connect_uart_tx_done)
			);

endmodule