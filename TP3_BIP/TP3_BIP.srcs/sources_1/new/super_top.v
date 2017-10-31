`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 08:41:17 PM
// Design Name: 
// Module Name: super_top
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


module super_top(
	input CLK100MHZ
    );

	wire [1:0] SelA;
	wire SelB;
	wire WrAcc;
	wire Op;
	wire WrRam;
	wire RdRam;
	wire [10:0] operand;

	data_path_top #()
		u_data_path_top (
			.CLK100MHZ(CLK100MHZ),
			.SelA(SelA),
			.SelB(SelB),
			.WrAcc(WrAcc),
			.Op(Op),
			.WrRam(WrRam),
			.RdRam(RdRam),
    		.operand(operand)
			);

	control_top #()
		u_control_top(
			.CLK100MHZ(CLK100MHZ),
			.SelA(SelA),
			.SelB(SelB),
			.WrAcc(WrAcc),
			.Op(Op),
			.WrRam(WrRam),
			.RdRam(RdRam),
    		.operand(operand)
			);
endmodule
