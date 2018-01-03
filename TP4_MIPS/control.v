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


module control#(
	parameter len_exec_bus = 11,
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2
	)(
	input clk,
    input [5:0] opcode,
    input reset,
    input [5:0] opcode_lsb,

    // junto las salidas en buses para mas prolijidad
    output reg [len_exec_bus-1:0] execute_bus,
    	// Jump&Link, JALOnly, RegDst, ALUSrc1, ALUSrc2, jump, jump register, ALUCode [4]
    output reg [len_mem_bus-1:0] memory_bus,
    	// SB, SH, LB, LH, Unsigned, Branch, MemRead, MemWrite
    output reg [len_wb_bus-1:0] writeBack_bus
    	// RegWrite, MemtoReg
    );

	reg [2:0] aluop;
	wire [3:0] alu_code;

	alu_control #()
	u_alu_control (.opcode_lsb(opcode_lsb), .aluop(aluop), 
				   .alu_code(alu_code));

	always @(*) 
	begin

		execute_bus[3:0] = alu_code;

		if(reset)
		begin
			execute_bus <= {len_exec_bus{1'b0}};
			memory_bus <= {len_mem_bus{1'b0}};
			writeBack_bus <= {len_wb_bus{1'b0}};
			aluop <= 0;
		end
		else begin
			case(opcode)
				6'b 000000 : 
				begin //R-type
					case(opcode_lsb)
						6'b000000, 6'b000010, 6'b000011 :
						begin //SHIFT CON SHAMT
							execute_bus[len_exec_bus-1:4] <= 7'b0011000;
							aluop <= 3'b000;
							memory_bus <= 9'b000000000;
							writeBack_bus <= 2'b10;
						end
						6'b001000 :
						begin //JR
							execute_bus[len_exec_bus-1:4] <= 7'b0000001;
							aluop <= 3'b000;
							memory_bus <= 9'b000000000;
							writeBack_bus <= 2'b10;
						end
						6'b001001 :
						begin //JALR
							execute_bus[len_exec_bus-1:4] <= 7'b1010001;
							aluop <= 3'b000;
							memory_bus <= 9'b000000000;
							writeBack_bus <= 2'b10;
						end
						default:
						begin
							execute_bus[len_exec_bus-1:4] <= 7'b0010000;
							aluop <= 3'b000;
							memory_bus <= 9'b000000000;
							writeBack_bus <= 2'b10;
						end
					endcase
				end
				// LOADS
				6'b100000:
				begin //LB
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b001;
					memory_bus <= 9'b000100010;
					writeBack_bus <= 2'b11;
				end
				6'b100001:
				begin //LH
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b001;
					memory_bus <= 9'b000010010;
					writeBack_bus <= 2'b11;
				end
				6'b100011, 6'b100111:
				begin //LW, LWU
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b001;
					memory_bus <= 9'b000000010;
					writeBack_bus <= 2'b11;
				end
				6'b100100:
				begin //LBU
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b001;
					memory_bus <= 9'b000101010;
					writeBack_bus <= 2'b11;
				end
				6'b100101:
				begin //LHU
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b001;
					memory_bus <= 9'b000011010;
					writeBack_bus <= 2'b11;
				end
				//STORES
				6'b101000:
				begin //SB
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b001;
					memory_bus <= 9'b010000001;
					writeBack_bus <= 2'b00;
				end
				6'b101001:
				begin //SH
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b001;
					memory_bus <= 9'b001000001;
					writeBack_bus <= 2'b00;
				end
				6'b101011 :
				begin //SW
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b001;
					memory_bus <= 9'b000000001;
					writeBack_bus <= 2'b00;
				end
				6'b001000 :
				begin //ADDI
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b001;
					memory_bus <= 9'b000000100;
					writeBack_bus <= 2'b10;
				end
				6'b001100 :
				begin //ANDI
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b010;
					memory_bus <= 9'b000000100;
					writeBack_bus <= 2'b10;
				end
				6'b001101 :
				begin //ORI
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b011;
					memory_bus <= 9'b000000100;
					writeBack_bus <= 2'b10;
				end
				6'b001110 :
				begin //XORI
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b100;
					memory_bus <= 9'b000000100;
					writeBack_bus <= 2'b10;
				end
				6'b001111 :
				begin //LUI
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b111;
					memory_bus <= 9'b000000100;
					writeBack_bus <= 2'b10;
				end
				6'b001010 :
				begin //SLTI
					execute_bus[len_exec_bus-1:4] <= 7'b0000100;
					aluop <= 3'b110;
					memory_bus <= 9'b000000000;
					writeBack_bus <= 2'b10;
				end
				6'b 000100:
				begin //BRANCH on equal
					execute_bus[len_exec_bus-1:4] <= 7'b0000000;
					aluop <= 3'b110;
					memory_bus <= 9'b000000100;
					writeBack_bus <= 2'b00;
				end
				6'b 000101:
				begin //BRANCH on not equal
					execute_bus[len_exec_bus-1:4] <= 7'b0000000;
					aluop <= 3'b110;
					memory_bus <= 9'b100000100;
					writeBack_bus <= 2'b00;
				end
				6'b000010 :
				begin //JUMP
					execute_bus[len_exec_bus-1:4] <= 7'b0000010;
					aluop <= 3'b000;
					memory_bus <= 9'b000000100;
					writeBack_bus <= 2'b00;
				end
				6'b000011 :
				begin //JAL
					execute_bus[len_exec_bus-1:4] <= 7'b1100010;
					aluop <= 3'b001;
					memory_bus <= 9'b000000000;
					writeBack_bus <= 2'b10;
				end
				default: 
				begin
					execute_bus[len_exec_bus-1:4] <= 7'b0000000;
					aluop <= 3'b000;
					memory_bus <= 9'b000000000;
					writeBack_bus <= 2'b00;
				end		
			endcase
		end
	end

endmodule
