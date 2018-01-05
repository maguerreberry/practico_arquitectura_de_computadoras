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






// #########################################
// // CAMBIAR EL BAUD RATE GENARATE CUANDO PASEMOS A LA FPGA
// #########################################




module top_modular#(
	parameter LEN = 32,
	parameter NB = $clog2(LEN),
	parameter len_exec_bus = 11,
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2,
	parameter estamos_en_test_bench = 0,
    parameter nb_Latches_1_2 = (LEN*2)/8,
    parameter nb_Latches_2_3 = (LEN*4)/8,
    parameter nb_Latches_3_4 = (LEN*4)/8,
    parameter nb_Latches_4_5 = (LEN*3)/8
	)(
	input CLK100MHZ,
	input SWITCH_RESET,
	input UART_TXD_IN,
	output [2:0] led,
	output UART_RXD_OUT,
	output [5:0] led_state

	// puertos para el test bench
	// input [7:0] uart_in_debug,
	// input select_uart_puente,
	// input tx_start_debug,
	// output tx_done_debug
    );
        
    wire clk, 
         reset, 
         clk_mips, 
         ctrl_clk_mips, 
         reset_mips;
             
    assign reset = SWITCH_RESET; 

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
				   connect_addr_mem_inst,
				   connect_ins_to_mem;

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
		 connect_halt,
		 connect_tx_debug,
		 connect_rx_debug;

	wire [(nb_Latches_1_2*8)-1:0] connect_Latches_1_2;
	wire [(nb_Latches_2_3*8)-1:0] connect_Latches_2_3;
	wire [(nb_Latches_3_4*8)-1:0] connect_Latches_3_4;
	wire [(nb_Latches_4_5*8)-1:0] connect_Latches_4_5;


    wire [7:0] connect_uart_data_in,
			   connect_uart_data_out;

	assign connect_write_data_5_2 = (connect_out_writeBack_bus[0]) ? connect_read_data : connect_out_addr_mem;

	assign clk_mips = (ctrl_clk_mips) ? (!clk) : (1'b 0);

	assign connect_rx_debug = (1 & estamos_en_test_bench) ? connect_tx_debug : UART_TXD_IN;
	assign UART_RXD_OUT = connect_tx_debug;
	assign tx_done_debug = connect_uart_tx_done;


	assign led[0] = connect_uart_tx_start;	
	assign led[1] = connect_halt;
	assign led[2] = reset;

	wire [5:0] connect_state_out;

	assign led_state = connect_state_out;

  clk_wiz_0 
  u_clk_wiz_0
   (
    	// Clock out ports
    	.clk_out1(clk),     // output clk_out1
    	// Status and control signals
    	.reset(reset), // input reset
    	.locked(),       // output locked
        // Clock in ports
    	.clk_in1(CLK100MHZ)      // input clk_in1
    );


	top_mips #(
	.LEN(32),
	.NB($clog2(LEN)),
	.len_exec_bus(11),
	.len_mem_bus(9),
	.len_wb_bus(2),
	.nb_Latches_1_2(nb_Latches_1_2),
	.nb_Latches_2_3(nb_Latches_2_3),
	.nb_Latches_3_4(nb_Latches_3_4),
	.nb_Latches_4_5(nb_Latches_4_5)
	)
	u_top_mips(
		.clk(clk_mips),
		.reset(reset | reset_mips),

		//para debug
		.debug_flag(connect_debug_mode),
		.in_addr_debug(connect_addr_recolector_mips),
		.in_addr_mem_inst(connect_addr_mem_inst),
		.in_ins_to_mem(connect_ins_to_mem),
		.wea_ram_inst(connect_wea_ram_inst),

		.out_reg1_recolector(connect_regs_recolector_mips),
		.out_mem_wire(connect_mem_datos_recolector_mips),
		.out_pc(connect_pc_debug),
		.halt_flag(connect_halt),
		.Latches_1_2(connect_Latches_1_2),
		.Latches_2_3(connect_Latches_2_3),
		.Latches_3_4(connect_Latches_3_4),
		.Latches_4_5(connect_Latches_4_5)
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
		.nb_Latches_1_2(nb_Latches_1_2),
		.nb_Latches_2_3(nb_Latches_2_3),
		.nb_Latches_3_4(nb_Latches_3_4),
		.nb_Latches_4_5(nb_Latches_4_5),
		.cant_regs(32),
		.cant_mem_datos(16),
		.LEN_DATA(8)
		)
		u_maquina_estados(
		    .clk(clk),
		    .reset(reset),
		    .halt(connect_halt),
		    .pc(connect_pc_debug),
		    .Latches_1_2(connect_Latches_1_2),
		    .Latches_2_3(connect_Latches_2_3),
		    .Latches_3_4(connect_Latches_3_4),
		    .Latches_4_5(connect_Latches_4_5),
		    .recolector(connect_data_recolector),

		    // outputs
		    .state_out             (connect_state_out),
		    .addr_mem_inst(connect_addr_mem_inst),
		    .ins_to_mem(connect_ins_to_mem),
		    .reset_mips(reset_mips),
		    .reprogram(connect_reprogram),
		    .ctrl_clk_mips(ctrl_clk_mips),
			.restart_recolector(connect_restart_recolector),
			.send_regs_recolector(connect_send_regs),
			.enable_next_recolector(connect_enable_next),
			.debug(connect_debug_mode),
			.write_enable_ram_inst(connect_wea_ram_inst),
		
		    //UART
		    .tx_done(connect_uart_tx_done),
		    .rx_done(connect_uart_rx_done),	    
		    .uart_data_in(connect_uart_data_out), 
		    .tx_start(connect_uart_tx_start),
		    .uart_data_out(connect_uart_data_in) 
			);

	uart #(
		.NBITS(8),
		.NUM_TICKS(16),
		.BAUD_RATE(38400),
		.CLK_RATE(40000000)
		)
		u_uart(
			.CLK_100MHZ(clk),
			.reset(reset),
			.tx_start((select_uart_puente & estamos_en_test_bench) ? tx_start_debug : connect_uart_tx_start),
			.rx(connect_rx_debug),
			.data_in((1 & estamos_en_test_bench) ? uart_in_debug : connect_uart_data_in),

			.data_out(connect_uart_data_out),
			.rx_done_tick(connect_uart_rx_done),
			.tx(connect_tx_debug),
			.tx_done_tick(connect_uart_tx_done)
			);

endmodule
