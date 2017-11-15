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
	input CLK100MHZ,
	input reset
    );

	wire [10:0] connect_addr_instrucciones;
	wire [15:0] connect_instrucciones;
	wire [10:0] connect_addr_datos;
	wire [15:0] connect_datos_out;
	wire [15:0] connect_datos_in;
	wire connect_Rd;
	wire connect_Wr;
    
//    io #()
//        u_io (
//                .clk(CLK100MHZ),
//        		.reset(reset),
//        		.in_opcode(connect_instrucciones[15:11]),
//        		.in_acc(connect_datos_out),    
//        		.tx_done(),
    
//        		.tx_start(),
//        		.data_out() 
//        );       
    
	cpu_top #()
		u_cpu_top(
			 .CLK100MHZ(CLK100MHZ),
		     .instruction_memory(connect_instrucciones),
		     .data_memory(connect_datos_in),

			 .addr_instruction(connect_addr_instrucciones),
			 .addr_data(connect_addr_datos),
			 .Rd(connect_Rd),
			 .Wr(connect_Wr),
		     .in_ram_data(connect_datos_out)
			);

	ram_instrucciones #(
			.RAM_WIDTH(16),
			.RAM_DEPTH(2048),
			.RAM_PERFORMANCE("LOW_LATENCY"),
			//.INIT_FILE("/home/facundo/Desktop/practico_arquitectura_de_computadoras/TP3_BIP/TP3_BIP.srcs/sources_1/new/program.hex")
            .INIT_FILE("E:/Drive/Facultad/quinto/Arquitectura_de_Computadoras/TP3_BIP/TP3_BIP.srcs/sources_1/new/program.hex")
			)
		u_ram_instrucciones(
			.addra(connect_addr_instrucciones),
			.clka(CLK100MHZ),
			.douta(connect_instrucciones)
			);

	ram_datos #(
		.RAM_WIDTH(16),
		.RAM_DEPTH(1024),
		.RAM_PERFORMANCE("LOW_LATENCY")		
		)
		u_ram_datos (
			.addra(connect_addr_datos),
			.dina(connect_datos_out),
			.clka(CLK100MHZ),
			.wea(connect_Wr),
			.regcea(connect_Rd),
			.douta(connect_datos_in)
			);

endmodule
