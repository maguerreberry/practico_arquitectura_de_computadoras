`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2017 05:16:44 PM
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


module control_top(
	input CLK100MHZ,
	input [15:0] Data,
    output [1:0] SelA,
    output SelB,
    output WrAcc,
    output Op,
    output WrRam,
    output RdRam,
    output [10:0] operand,
    output [10:0] Addr
    );
    
	wire [15:0] output_program_mem;
	wire connect_WrPC;
	wire [10:0] connect_PC_adder;
	wire [10:0] connect_adder_PC;

	wire [10:0] connect_operand_Data;
	assign connect_operand_Data = Data [10:0];
	assign operand = connect_operand_Data;

	// assign operand = Data [10:0];
	assign Addr = connect_PC_adder; 	
	
	decoder #()
		u_decoder(
			.opcode(Data[15:11]),
			.WrPC(connect_WrPC),
			.SelA(SelA),
			.SelB(SelB),
			.WrAcc(WrAcc),
			.Op(Op),
			.WrRam(WrRam),
			.RdRam(RdRam)
			);

	PC #(
		.len(11))
		u_PC(
			.In(connect_adder_PC),
			.enable(connect_WrPC),
			.clk(CLK100MHZ),
			.Out(connect_PC_adder)
			);

	adder_PC #(
		.len(11),
		.sumando(1)
		)
		u_adder_PC(
			.In(connect_PC_adder),
			.Out(connect_adder_PC)
			);

endmodule
