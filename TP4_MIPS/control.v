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
	input clk,
    input [5:0] opcode,
    input reset,
    input [5:0] opcode_lsb,

    // junto las salidas en buses para mas prolijidad
    output reg [8:0] execute_bus,
    	// RegDst, ALUSrc1, ALUSrc2, jump, jump register, ALUCode [4]
    output reg [2:0] memory_bus,
    	// Branch, MemRead, MemWrite
    output reg [1:0] writeBack_bus
    	// RegWrite, MemtoReg
    );

	reg [2:0] aluop;
	wire [3:0] alu_code;

	alu_control #()
	u_alu_control (.opcode_lsb(opcode_lsb), .aluop(aluop), 
				   .alu_code(alu_code), .clk(clk));

	always @(posedge clk) 
	begin

		execute_bus[3:0] = alu_code;

		if(reset)
		begin
			execute_bus <= 9'b000000000;
			memory_bus <= 3'b000;
			writeBack_bus <= 2'b00;
		end
		else begin
			case(opcode)
				6'b 000000 : 
				begin //R-type
					case(opcode_lsb)
						6'b000000, 6'b000010, 6'b000011 :
						begin //SHIFT CON SHAMT
							execute_bus[8:4] <= 5'b11000;
							aluop <= 3'b000;
							// memory_bus <= 3'b000;
							// writeBack_bus <= 2'b10;
						end
						6'b001000, 6'b001001 :
						begin //JR, OJO VER JALR
							execute_bus[8:4] <= 5'bxxxx01;
							aluop <= 3'bxxx;
						end
						default:
						begin
							execute_bus[8:4] <= 5'b10000;
							aluop <= 3'b000;
							// memory_bus <= 3'b000;
							// writeBack_bus <= 2'b10;
						end
					endcase
				end
				
				6'b100000, 6'b100001, 6'b100011, 6'b100100, 6'b100101 :
				begin //LOAD
					execute_bus[8:4] <= 5'b00100;
					aluop <= 3'b001;
					// memory_bus <= 3'b010;
					// writeBack_bus <= 2'b11;
				end
				6'b101000, 6'b101001, 6'b101011 :
				begin //STORE
					execute_bus[8:4] <= 5'b00100;
					aluop <= 3'b001;
					// memory_bus <= 3'b001;
					// writeBack_bus <= 2'b00;
				end
				6'b001000 :
				begin //ADDI
					execute_bus[8:4] <= 5'b00100;
					aluop <= 3'b001;
				end
				6'b001100 :
				begin //ANDI
					execute_bus[8:4] <= 5'b00100;
					aluop <= 3'b010;
				end
				6'b001101 :
				begin //ORI
					execute_bus[8:4] <= 5'b00100;
					aluop <= 3'b011;
				end
				6'b001110 :
				begin //XORI
					execute_bus[8:4] <= 5'b00100;
					aluop <= 3'b100;
				end
				6'b001111 :
				begin //LUI
					execute_bus[8:4] <= 5'b0x100;
					aluop <= 3'b111;
				end
				6'b001010 :
				begin //SLTI
					execute_bus[8:4] <= 5'b00100;
					aluop <= 3'b110;
				end
				6'b 000100, 6'b 000101 :
				begin //BRANCH
					execute_bus[8:4] <= 5'bx0000;
					aluop <= 3'b110;
					// memory_bus <= 3'b100;
					// writeBack_bus <= 2'b00;
				end
				6'b000010 :
				begin //JUMP
					execute_bus[8:4] <= 5'bxxx10;
					aluop <= 3'bxxx;
				end
				default: 
				begin
					execute_bus[8:4] <= 5'bxxxxx;
					aluop <= 3'bxxx;
					// memory_bus <= 3'b000;
					// writeBack_bus <= 2'b00;
				end		
			endcase
		end
	end

endmodule
