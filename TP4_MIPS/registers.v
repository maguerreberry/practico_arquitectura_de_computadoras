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
	input hard_reset,
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

	always @(posedge clk, posedge hard_reset)
	begin
		if (hard_reset) begin
			read_data_1 = 0;
			read_data_2 = 0;
			registers_mips[0] = 0;
			registers_mips[1] = 1;
			registers_mips[2] = 2;
			registers_mips[3] = 3;
			registers_mips[4] = 4;
			registers_mips[5] = 5;
			registers_mips[6] = 6;
			registers_mips[7] = 7;
			registers_mips[8] = 8;
			registers_mips[9] = 9;
			registers_mips[10] = 10;
			registers_mips[11] = 11;
			registers_mips[12] = 12;
			registers_mips[13] = 13;
			registers_mips[14] = 14;
			registers_mips[15] = 15;
			registers_mips[16] = 16;
			registers_mips[17] = 17;
			registers_mips[18] = 18;
			registers_mips[19] = 19;
			registers_mips[20] = 20;
			registers_mips[21] = 21;
			registers_mips[22] = 22;
			registers_mips[23] = 23;
			registers_mips[24] = 24;
			registers_mips[25] = 25;
			registers_mips[26] = 26;
			registers_mips[27] = 27;
			registers_mips[28] = 28;
			registers_mips[29] = 29;
			registers_mips[30] = 30;
			registers_mips[31] = 31;
		end
		else begin
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
	end

	always @(negedge clk)
	begin
		if (RegWrite) 
		begin
			registers_mips[write_register] <= write_data;				
		end
	end

endmodule
