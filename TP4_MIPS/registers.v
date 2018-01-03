`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2017 06:48:13 PM
// Design Name: 
// Module Name: registers
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


module registers#(
	parameter width = 32,
	parameter lenght = 32,
	parameter NB = $clog2(lenght)
	)(
	input clk,
	input reset,
	input RegWrite,
	input [NB-1:0] read_register_1,
	input [NB-1:0] read_register_2,
	input [NB-1:0] write_register,
	input [width-1:0] write_data,

	output [width-1:0] wire_read_data_1,
	output reg [width-1:0] read_data_1,
	output reg [width-1:0] read_data_2
    );

	reg [width-1:0]  registers_mips [lenght-1:0];

	assign wire_read_data_1 = registers_mips[read_register_1];

	generate
		integer ii;		
		initial
        for (ii = 0; ii < lenght; ii = ii + 1)
          registers_mips[ii] = {width{1'b0+(ii)}};
	endgenerate

	always @(posedge clk)
	begin
		if (reset)
		begin
			read_data_1 = 0;
			read_data_2 = 0;
		end

		else begin
			read_data_1 <= registers_mips[read_register_1];
			read_data_2 <= registers_mips[read_register_2];
		end
	end

	always @(negedge clk)
	begin
		if (RegWrite) 
		begin
			registers_mips[write_register] <= write_data;				
		end
	end

endmodule
