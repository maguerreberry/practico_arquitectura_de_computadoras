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
    input [10:0] operand,
    input [15:0] out_ram_data,
    output [15:0] in_ram_data,
    output [10:0] Addr
    );
	
	wire [15:0] connect_out_sign_extend;
	wire [15:0] connect_out_alu;
	wire [15:0] connect_muxA_acc;
	wire [15:0] connect_muxB_alu;

	// assign operand = Addr;
	assign Addr = operand;

	signal_extend #()
		u_signal_extend(
			.In(operand),
			.Out(connect_out_sign_extend)
			);

	mux_A #(
		.len(16)
		)
		u_mux_A(
			.out_memory(out_ram_data),
			.out_alu(connect_out_alu),
			.out_sign_extend(connect_out_sign_extend),
			.SelA(SelA),
			.Out(connect_muxA_acc)
			);

	mux_B #(
		.len(16)
		)
		u_mux_B(
			.out_ram(out_ram_data),
			.out_sign_extend(connect_out_sign_extend),
			.SelB(SelB),
			.Out(connect_muxB_alu)
			);	

	accumulator #(
		.len(16)
		)
		u_accumulator(
			.In(connect_muxA_acc),
			.clk(CLK100MHZ),
			.WrAcc(WrAcc),
			.Out(in_ram_data)
			);

	arithmetic_unit #(
		.len(16)
		)
		u_arithmetic_unit(
			.Op(Op),
			.A(in_ram_data),
			.B(connect_muxB_alu),
			.Out(connect_out_alu)
			);

	// ram_datos #(
	// 	.RAM_WIDTH(16),
	// 	.RAM_DEPTH(1024),
	// 	.RAM_PERFORMANCE("LOW_LATENCY")		
	// 	)
	// 	u_ram_datos (
	// 		.addra(operand),
	// 		.dina(connect_out_acc),
	// 		.clka(CLK100MHZ),
	// 		.wea(WrRam),
	// 		.regcea(RdRam),
	// 		.douta(connect_out_mem)
	// 		);

endmodule
