`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2017 07:31:57 PM
// Design Name: 
// Module Name: recolector
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


module recolector#(
	parameter len = 32
	)(
	input clk,
	input [len-1:0] regs,
	input [len-1:0] mem_datos,
	input enable_next,
	input send_regs,
	input restart,

	output [len-1:0] addr,
	output reg [len-1:0] data
    );

	reg [len-1:0] addr_reg = 0;
	reg [len-1:0] addr_mem_datos = 0;

	assign addr = send_regs ? addr_reg : addr_mem_datos;

    always @(posedge clk) begin
    	if (restart) begin
    		addr_reg <= 0;
			addr_mem_datos <= 0;
    	end
    	else if (enable_next) begin
    		if (send_regs) begin
    			data <= regs;    		 	
    			addr_reg <= addr_reg + 1;
    		end 
    		else begin
    			data <= mem_datos;    		 	    			
    			addr_mem_datos <= addr_mem_datos + 1;
    		end
    	end
    end


endmodule
