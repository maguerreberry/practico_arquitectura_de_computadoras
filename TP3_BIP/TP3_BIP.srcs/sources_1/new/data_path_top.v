`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 08:16:22 PM
// Design Name: 
// Module Name: data_path_top
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


module data_path_top(
	input CLK100MHZ,
    input [1:0] SelA,
    input SelB,
    input WrAcc,
    input Op,
    input WrRam,
    input RdRam,
    input [10:0] operand
    );
	
	wire [15:0] connect_out_sign_extend;
	wire [15:0] connect_out_mem;
	wire [15:0] connect_out_alu;
	wire [15:0] connect_muxA_acc;
	wire [15:0] connect_muxB_alu;
	wire [15:0] connect_out_acc;

	signal_extend #()
		u_signal_extend(
			.In(operand),
			.Out(connect_out_sign_extend)
			);

	mux_A #()
		u_mux_A(
			.out_memory(connect_out_mem),
			.out_alu(connect_out_alu),
			.out_sign_extend(connect_out_sign_extend),
			.SelA(SelA),
			.Out(connect_muxA_acc)
			);

	mux_B #()
		u_mux_B(
			.out_ram(connect_out_mem),
			.out_sign_extend(connect_out_sign_extend),
			.SelB(SelB),
			.Out(connect_muxB_alu)
			);	

	accumulator #()
		u_accumulator(
			.In(connect_muxA_acc),
			.clk(CLK100MHZ),
			.WrAcc(WrAcc),
			.Out(connect_out_acc)
			);

	arithmetic_unit #()
		u_arithmetic_unit(
			.Op(Op),
			.A(connect_out_acc),
			.B(connect_muxB_alu),
			.Out(connect_out_alu)
			);

	ram_datos #()
		u_ram_datos (
			.addra(operand),
			.dina(connect_out_acc),
			.clka(CLK100MHZ),
			.wea(WrRam),
			.regcea(RdRam),
			.douta(connect_out_mem)
			);

endmodule
