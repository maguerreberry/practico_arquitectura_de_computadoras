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


module cpu_top(
	input CLK100MHZ,
    input [15:0] instruction_memory,
    input [15:0] data_memory,
    input reset,
    
    output [10:0] addr_instruction,
    output [10:0] addr_data,
    output Rd,
    output Wr,
    output [15:0] in_ram_data
    );

	wire [1:0]connect_selA;
	wire connect_selB;
	wire connect_WrAcc;
	wire connect_Op;
	wire [10:0] connect_operand;

	// assign addr_instruction = instruction_memory[10:0];

	control_top #()
		u_control_top(
			.CLK100MHZ(CLK100MHZ),
			.reset(reset),
			.Data(instruction_memory),
			.SelA(connect_selA),
		    .SelB(connect_selB),
		    .WrAcc(connect_WrAcc),
		    .Op(connect_Op),
		    .WrRam(Wr),
		    .RdRam(Rd),
		    .operand(connect_operand),
		    .Addr(addr_instruction)
		    );

	data_path_top #()
		u_data_path_top(
			.CLK100MHZ(CLK100MHZ),
			.SelA(connect_selA),
			.SelB(connect_selB),
			.WrAcc(connect_WrAcc),
			.Op(connect_Op),
			.operand(connect_operand),
			.out_ram_data(data_memory),
			.in_ram_data(in_ram_data),
			.Addr(addr_data)
			);

endmodule
