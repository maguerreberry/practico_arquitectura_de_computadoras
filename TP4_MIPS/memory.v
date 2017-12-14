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
	input [7:0] memory_bus,
    input [1:0] in_writeBack_bus,
	input [NB-1:0] in_write_reg,	

	input zero_flag,
	input [len-1:0] in_pc_branch,

	output reg [len-1:0] read_data,
	output pc_src,
	output [len-1:0] out_pc_branch,
    output reg [1:0] out_writeBack_bus,
	output reg [len-1:0] out_addr_mem,
	output reg [NB-1:0] out_write_reg	
    );

	wire 	MemWrite,
			MemRead,
			Branch,
			control_unsigned,
			control_LH,
			control_LB,
			control_SH,
			control_SB;

	reg [len-1:0] 	connect_mux_in_mem;	
	wire [len-1:0]	connect_out_mem;

	assign MemWrite			= memory_bus[0],
		   MemRead 			= memory_bus[1],
		   Branch 			= memory_bus[2],
		   control_unsigned = memory_bus[3],
		   control_LH 		= memory_bus[4],
		   control_LB 		= memory_bus[5],
		   control_SH 		= memory_bus[6],
		   control_SB 		= memory_bus[7];

	assign out_pc_branch = in_pc_branch;
	assign pc_src = Branch & zero_flag;	

	ram_datos #(
		.RAM_WIDTH(32),
		.RAM_DEPTH(2048),
		.RAM_PERFORMANCE("LOW_LATENCY")
		)
		u_ram_datos(
			.addra(in_addr_mem),
			.dina(connect_mux_in_mem),
			.clka(clk),
			.wea(MemWrite),
			.ena(MemRead),
			.douta(connect_out_mem)
			);

	always @(posedge clk) 
	begin
		out_writeBack_bus <= in_writeBack_bus;
		out_addr_mem <= in_addr_mem;
		out_write_reg <= in_write_reg;
	end

	always @(*)
	begin
		if (control_LH) 
		begin
			// connect_mux_in_mem <= write_data;
			if (control_unsigned) 
			begin
				connect_mux_in_mem <= {{16{1'b 0}},write_data[15:0]};
			end
			else 
			begin
				connect_mux_in_mem <= {{16{write_data[15]}},write_data[15:0]};				
			end
		end
		else if (control_LB) 
		begin
			// connect_mux_in_mem <= write_data;
			if (control_unsigned) 
			begin
				connect_mux_in_mem <= {{24{1'b 0}},write_data[7:0]};
			end
			else 
			begin
				connect_mux_in_mem <= {{24{write_data[7]}},write_data[7:0]};				
			end
		end
		else 
		begin
			connect_mux_in_mem <= write_data;				
		end

		if (control_SH) 
		begin
			read_data <= {{16{connect_out_mem[15]}},connect_out_mem[15:0]};				
		end
		else if (control_SB) 
		begin
			read_data <= {{24{connect_out_mem[7]}},connect_out_mem[7:0]};				
		end
		else 
		begin
			read_data <= connect_out_mem;				
		end


	end

endmodule
