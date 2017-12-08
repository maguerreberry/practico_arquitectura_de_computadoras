`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2017 07:24:24 PM
// Design Name: 
// Module Name: tb_alu
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

`define len 32
`define NB $clog2(`len)

module tb_forwarding_unit(
    );
	
	reg register_write_3_4;
	reg register_write_4_5;
	reg [`NB-1:0] rd_3_4;
	reg [`NB-1:0] rd_4_5;
	reg [`NB-1:0] rs_2_3;
	reg [`NB-1:0] rt_2_3;
	reg CLK100MHZ;

	forwarding_unit #(.lenghtIN(`len), .NB(`NB))
	u_forwarding_unit(
		.register_write_3_4(register_write_3_4),
		.register_write_4_5(register_write_4_5),
		.rd_3_4(rd_3_4),
		.rd_4_5(rd_4_5),
		.rs_2_3(rs_2_3),
		.rt_2_3(rt_2_3)
		);

	initial begin
		CLK100MHZ = 0;

		register_write_3_4 = 0;
		register_write_4_5 = 0;
		rd_3_4 = 1;
		rd_4_5 = 1;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 0;
		register_write_4_5 = 0;
		rd_3_4 = 1;
		rd_4_5 = 0;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 0;
		register_write_4_5 = 0;
		rd_3_4 = 0;
		rd_4_5 = 1;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 0;
		register_write_4_5 = 0;
		rd_3_4 = 0;
		rd_4_5 = 0;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 0;
		register_write_4_5 = 1;
		rd_3_4 = 1;
		rd_4_5 = 1;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 0;
		register_write_4_5 = 1;
		rd_3_4 = 1;
		rd_4_5 = 0;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 0;
		register_write_4_5 = 1;
		rd_3_4 = 0;
		rd_4_5 = 1;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 0;
		register_write_4_5 = 1;
		rd_3_4 = 0;
		rd_4_5 = 0;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 1;
		register_write_4_5 = 0;
		rd_3_4 = 1;
		rd_4_5 = 1;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 1;
		register_write_4_5 = 0;
		rd_3_4 = 1;
		rd_4_5 = 0;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 1;
		register_write_4_5 = 0;
		rd_3_4 = 0;
		rd_4_5 = 1;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 1;
		register_write_4_5 = 0;
		rd_3_4 = 0;
		rd_4_5 = 0;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 1;
		register_write_4_5 = 1;
		rd_3_4 = 1;
		rd_4_5 = 1;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 1;
		register_write_4_5 = 1;
		rd_3_4 = 1;
		rd_4_5 = 0;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 1;
		register_write_4_5 = 1;
		rd_3_4 = 0;
		rd_4_5 = 1;
		
		rs_2_3 = 0;

		#10

		register_write_3_4 = 1;
		register_write_4_5 = 1;
		rd_3_4 = 0;
		rd_4_5 = 0;
		
		rs_2_3 = 0;

	end

	always
		#5 CLK100MHZ = ~CLK100MHZ;
		
endmodule