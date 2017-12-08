`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2017 10:31:53 AM
// Design Name: 
// Module Name: memory
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


module memory #(
	parameter len = 32,
	parameter NB = $clog2(len)
	)(
	input clk,
	input [len-1:0] in_addr_mem,
	input [len-1:0] write_data,
	input [2:0] memory_bus,
    input [1:0] in_writeBack_bus,
	input [NB-1:0] in_write_reg,	

	input zero_flag,
	input [len-1:0] in_pc_branch,

	output [len-1:0] read_data,
	output pc_src,
	output [len-1:0] out_pc_branch,
    output reg [1:0] out_writeBack_bus,
	output reg [len-1:0] out_addr_mem,
	output reg [NB-1:0] out_write_reg	
    );

	wire MemWrite;
	wire MemRead;
	wire Branch;

	assign MemWrite = memory_bus[0];
	assign MemRead = memory_bus[1];
	assign Branch = memory_bus[2];

	assign out_pc_branch = in_pc_branch;
	assign pc_src = Branch & zero_flag;

	ram_datos #(
		.RAM_WIDTH(32),
		.RAM_DEPTH(2048),
		.RAM_PERFORMANCE("LOW_LATENCY")
		)
		u_ram_datos(
			.addra(in_addr_mem),
			.dina(write_data),
			.clka(clk),
			.wea(MemWrite),
			.ena(MemRead),
			.douta(read_data)
			);

	always @(posedge clk) 
	begin
		out_writeBack_bus <= in_writeBack_bus;
		out_addr_mem <= in_addr_mem;
		out_write_reg <= in_write_reg;
	end

endmodule
