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

module tb_hazard(
    );
	
	reg mem_read_2_3;
	reg [`NB-1:0] rt_2_3;
	reg [`NB-1:0] rs_1_2;
	reg [`NB-1:0] rt_1_2;
	reg CLK100MHZ;

	hazard_detection_unit #(.len(`len), .NB(`NB))
	u_hazard_detection_unit(
		.mem_read_2_3(mem_read_2_3),
		.rt_2_3(rt_2_3),
		.rs_1_2(rs_1_2),
		.rt_1_2(rt_1_2)
		);

	initial begin
		CLK100MHZ = 0;

		mem_read_2_3 = 0;
		rt_2_3 = 1;
		rs_1_2 = 0;
		rt_1_2 = 0;
		
		#10

		mem_read_2_3 = 0;
		rt_2_3 = 1;
		rs_1_2 = 1;
		rt_1_2 = 0;
		
		#10

		mem_read_2_3 = 0;
		rt_2_3 = 1;
		rs_1_2 = 0;
		rt_1_2 = 1;
		
		#10

		mem_read_2_3 = 0;
		rt_2_3 = 1;
		rs_1_2 = 1;
		rt_1_2 = 1;
		
		#10

		mem_read_2_3 = 1;
		rt_2_3 = 1;
		rs_1_2 = 0;
		rt_1_2 = 0;
		
		#10

		mem_read_2_3 = 1;
		rt_2_3 = 1;
		rs_1_2 = 0;
		rt_1_2 = 1;
		
		#10

		mem_read_2_3 = 1;
		rt_2_3 = 1;
		rs_1_2 = 1;
		rt_1_2 = 0;
		
		#10

		mem_read_2_3 = 1;
		rt_2_3 = 1;
		rs_1_2 = 1;
		rt_1_2 = 1;

	end

	always
		#5 CLK100MHZ = ~CLK100MHZ;
		
endmodule