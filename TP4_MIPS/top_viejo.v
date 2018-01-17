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


module top#(
	parameter LEN = 32,
	parameter NB = $clog2(LEN),
	parameter len_exec_bus = 11,
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2
	)(
	input CLK100MHZ,
	input SWITCH_RESET,
	input UART_TXD_IN,
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
				   connect_pc;

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
		 connect_reprogram;


    wire [7:0] connect_uart_data_in,
			   connect_uart_data_out;

	assign connect_write_data_5_2 = (connect_out_writeBack_bus[0]) ? connect_read_data : connect_out_addr_mem;

	assign clk_mips = (ctrl_clk_mips) ? (clk) : (1'b 0);

	instruction_fetch #(
		.len(LEN)
		)
		u_instruction_fetch(
			.clk(clk_mips),
			.reset(reset_mips | connect_reprogram),
			.in_pc_src({connect_flag_jump, connect_flag_jump_register, connect_branch_flag}),
			.in_pc_jump(connect_in_pc_jump),
			.in_pc_branch(connect_in_pc_branch_4_1),
			.in_pc_register(connect_in_pc_jump_register),
			.stall_flag(!connect_stall_flag),

			.out_pc_branch(connect_in_pc_branch_1_2),
			.out_instruction(connect_instruccion),
			.out_pc(connect_pc)
		);

	decode #(
		.len(LEN)
		)
		u_decode(
			.clk(clk_mips),
			.reset(reset_mips),
			.in_pc_branch(connect_in_pc_branch_1_2),
			.in_instruccion(connect_instruccion),
			.RegWrite(connect_out_writeBack_bus[1]),
			.write_data(connect_write_data_5_2),
			.write_register(connect_write_reg_4_2),
			.flush(connect_branch_flag),
			
			.out_pc_branch(connect_in_pc_branch_2_3),
			.out_pc_jump(connect_in_pc_jump),
			.out_pc_jump_register(connect_in_pc_jump_register),
			.out_reg1(connect_reg1),
			.out_reg2(connect_reg2),
			.out_sign_extend(connect_sign_extend),
			.out_rt(connect_rt),
			.out_rd(connect_rd),
			.out_rs(connect_rs),
			.out_shamt(connect_shamt),

			.execute_bus(connect_execute_bus),
			.flag_jump(connect_flag_jump),
			.flag_jump_register(connect_flag_jump_register),
			.memory_bus(connect_memory_bus_2_3),
			.writeBack_bus(connect_writeBack_bus_2_3),

			.stall_flag(connect_stall_flag)
		);

	execute #(
		.len(LEN)
		)
		u_execute(
			.clk(clk_mips),
			.reset(reset_mips),
		
			.in_pc_branch(connect_in_pc_branch_2_3),
			.in_reg1(connect_reg1),
			.in_reg2(connect_reg2),
			.in_sign_extend(connect_sign_extend),
			.in_rt(connect_rt),
			.in_rd(connect_rd),
			.in_shamt(connect_shamt),
		
			.execute_bus(connect_execute_bus),
			.memory_bus(connect_memory_bus_2_3),
			.writeBack_bus(connect_writeBack_bus_2_3), 

			.register_write_3_4(connect_writeBack_bus_3_4[1]),
			.register_write_4_5(connect_out_writeBack_bus[1]),
			.rd_3_4(connect_write_reg_3_4),
			.rd_4_5(connect_write_reg_4_2),
			.in_rs(connect_rs),

			.in_mem_forw(connect_alu_out),
			.in_wb_forw(connect_write_data_5_2),
			.flush(connect_branch_flag),
		
			.out_pc_branch(connect_in_pc_branch_3_4),
			.out_alu(connect_alu_out),
			.zero_flag(connect_zero_flag),
			.out_reg2(connect_write_data_3_4),
			.out_write_reg(connect_write_reg_3_4),
		
			// señales de control
			.memory_bus_out(connect_memory_bus_3_4),
			.writeBack_bus_out(connect_writeBack_bus_3_4)
			);

	memory #(
		.len(LEN)
		)
		u_memory(
			.clk(clk_mips),
			.reset(reset_mips),
			.in_addr_mem(connect_alu_out),
			.write_data(connect_write_data_3_4),
			
			.memory_bus(connect_memory_bus_3_4),
		    .in_writeBack_bus(connect_writeBack_bus_3_4),
			.in_write_reg(connect_write_reg_3_4),			
			.zero_flag(connect_zero_flag),
			.in_pc_branch(connect_in_pc_branch_3_4),

			//outputs		
			.read_data(connect_read_data),
			.pc_src(connect_branch_flag),
			.out_pc_branch(connect_in_pc_branch_4_1),
		    .out_writeBack_bus(connect_out_writeBack_bus),
			.out_addr_mem(connect_out_addr_mem),
			.out_write_reg(connect_write_reg_4_2)	
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
		.cant_instruccciones(64),
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
		    .halt(),
		    .pc(connect_pc),
		    .Latches_1_2(),
		    .Latches_2_3(),
		    .Latches_3_4(),
		    .Latches_4_5(),
		    .recolector(connect_data_recolector),

		    // outputs
		    .addr_mem_inst(),
		    .ins_to_mem(),
		    .reset_mips(reset_mips),
		    .reprogram(connect_reprogram),
		    .ctrl_clk_mips(ctrl_clk_mips),
			.restart_recolector(connect_restart_recolector),
			.send_regs_recolector(connect_send_regs),
			.enable_next_recolector(connect_enable_next),
		
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
