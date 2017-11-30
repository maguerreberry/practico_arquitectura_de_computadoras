`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:15:44 PM
// Design Name: 
// Module Name: decoder
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


module control(
    input [5:0] opcode,
    input reset,

    // junto las salidas en buses para mas prolijidad
    output reg [3:0] execute_bus,
    	// RegDst, ALUOp [2], ALUSrc
    output reg [2:0] memory_bus,
    	// Branch, MemRead, MemWrite
    output reg [1:0] writeBack_bus
    	// RegWrite, MemtoReg
    );

	always @(*) 
	begin
		if(reset)
		begin
			execute_bus <= 4'b0000;
			memory_bus <= 3'b000;
			writeBack_bus <= 2'b00;
		end
		else begin
			case(opcode)
				6'b 000000: 
				begin //R-type
					execute_bus <= 4'b1100;
					memory_bus <= 3'b000;
					writeBack_bus <= 2'b10;
				end			
				6'b 100011: 
				begin //LOAD
					execute_bus <= 4'b0001;
					memory_bus <= 3'b010;
					writeBack_bus <= 2'b11;
				end
				6'b 101011: 
				begin //STORE
					execute_bus <= 4'b0001;
					memory_bus <= 3'b001;
					writeBack_bus <= 2'b00;
				end
				6'b 000100: 
				begin //BRANCH
					execute_bus <= 4'b0010;
					memory_bus <= 3'b100;
					writeBack_bus <= 2'b00;
				end
				default: 
				begin
					execute_bus <= 4'b0000;
					memory_bus <= 3'b000;
					writeBack_bus <= 2'b00;
				end		
			endcase
		end
	end

endmodule
