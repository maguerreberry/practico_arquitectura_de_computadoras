s`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2017 07:24:46 PM
// Design Name: 
// Module Name: maquina_estados
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


module maquina_estados #(
    parameter len = 32,
    parameter cant_instruccciones = 64,
	parameter NB_addr = $clog2(cant_instruccciones),
    parameter LEN_DATA = 8
	) (
    input clk,
    input reset,
    input [len-1:0] pc,
    input [len-1:0] current_inst,  
    input [(len*len)-1:0] regs, // pensar la longitud pq queda demasiados cables
    input [(len*len)-1:0] MemDatos, // pensar la longitud pq queda demasiados cables
    input [(len*len)-1:0] Latches_1_2, // pensar la longitud pq queda demasiados cables
    input [(len*len)-1:0] Latches_2_3, // pensar la longitud pq queda demasiados cables
    input [(len*len)-1:0] Latches_3_4, // pensar la longitud pq queda demasiados cables
    input [(len*len)-1:0] Latches_4_5, // pensar la longitud pq queda demasiados cables
    output [NB_addr-1:0] addr_mem_inst,
    output [len-1:0] ins_to_mem,
    output reg reset_mips,
    output reg erase_mem_inst,
    output ctrl_clk_mips,

    //UART
    input tx_done,
    input rx_done,
    input [LEN_DATA-1:0] uart_data_in, 
    output reg tx_start,
    output reg [LEN_DATA-1:0] uart_data_out 
    );

    localparam [5:0] IDLE         	= 6'b 000000,
    				 PROGRAMMING  	= 6'b 000001,
    				 WAITING      	= 6'b 000010,
    				 STEP_BY_STEP   = 6'b 000100,
                     SENDING_DATA   = 6'b 001000,
                     CONTINUOS      = 6'b 010000,
                     STEPPING       = 6'b 010001,

    localparam [5:0] SUB_INIT		= 6'b 100000,
    				 SUB_READ_1		= 6'b 100001,
    				 SUB_READ_2		= 6'b 100010,
    				 SUB_READ_3		= 6'b 100100,
    				 SUB_READ_4		= 6'b 101000,
    				 SUB_WRITE_MEM	= 6'b 110000,
                     SUB_SEND_1     = 6'b 110001,
                     SUB_SEND_2     = 6'b 110010,
                     SUB_SEND_3     = 6'b 110100,
                     SUB_SEND_4     = 6'b 111000;


    localparam [7:0] StartSignal		= 8'b 00000001,
					 ContinuosSignal  	= 8'b 00000010,
					 StepByStepSignal   = 8'b 00000011,
					 ResetMipsSignal   	= 8'b 00000100,
					 EraseMemorySignal 	= 8'b 00000101,
					 StepSignal			= 8'b 00000110;

    reg [5:0] state;
    reg [5:0] sub_state;
    reg [len-1:0] ciclos;
    reg [len-1:0] instruction;
    reg [NB_addr-1:0] num_instruc;
    reg wrtie_enable_ram_inst;

    assign ins_to_mem = instruction;
    assign addr_mem_inst = num_instruc;
    
    always @(negedge clk) begin
        if (reset) begin
          ciclos = 0;
          reset_mips = 0;
          state = IDLE;
          sub_state = SUB_INIT;
        end
        else begin
            case(state)
                IDLE:
                    begin
                      	reset_mips = 0;
                        erase_mem_inst = 0;
                    	if (uart_data_in == StartSignal) 
                    	begin
							state <= PROGRAMMING;	                	                   	
	                   	end                   
                    end
                PROGRAMMING:
                    begin
                    	case (sub_state)
                    		SUB_INIT:
                    			begin
                    				sub_state = SUB_READ_1;
                    			end
                    		SUB_READ_1:
                    			begin
	                    			instruction[7:0] = uart_data_in;
	                    			if (rx_done) 
	                    			begin
	                    				sub_state = SUB_READ_2; 
	                    			end
                    			end
                    		SUB_READ_2:
                    			begin
	                    			instruction[15:8] = uart_data_in;
	                    			if (rx_done) 
	                    			begin
	                    				sub_state = SUB_READ_3; 
	                    			end
                    			end
                    		SUB_READ_3:
	                			begin
	                    			instruction[23:16] = uart_data_in;
	                    			if (rx_done) 
	                    			begin
	                    				sub_state = SUB_READ_4; 
	                    			end
                    			end
                    		SUB_READ_4:
                    			begin
	                    			instruction[31:24] = uart_data_in;
	                    			if (rx_done) 
	                    			begin
	                    				sub_state = SUB_WRITE_MEM;
	                    			end
                    			end
                			SUB_WRITE_MEM:
                				begin
	                				wrtie_enable_ram_inst = 1'b 1;
	                				num_instruc = num_instruc + 1'b 1;
	                				if (&instruction[31:26]) 
	                				begin
	                					state = WAITING;
	                					sub_state = SUB_INIT;
	                				end
	                				else 
	                				begin
	                					sub_state = SUB_READ_1;                					
	                				end
                				end
                    	endcase	
                    end
                WAITING:
                    begin
                        ciclos = 0;
                        case (uart_data_in)
                            ResetMipsSignal: begin
                                reset_mips = 1;
                            end
                            EraseMemorySignal: begin
                                erase_mem_inst = 1;
                                state = IDLE;                                                        
                            end
                            ContinuosSignal: begin 
                                state = CONTINUOS;
                                reset_mips = 0;
                            end 
                            StepByStepSignal: begin 
                                state = STEP_BY_STEP;
                                reset_mips = 0;
                            end
                        endcase                    
                    end
                STEP_BY_STEP:
                    begin
                        ctrl_clk_mips = 0;
                        if (uart_data_in == StepSignal) begin
                            ciclos = ciclos + 1;
                            state = SENDING_DATA;
                        end
                    end
                CONTINUOS:
                    begin
                        ctrl_clk_mips = 1;
                        ciclos = ciclos + 1;
                        if (&current_inst[31:26]) begin
                            state = SENDING_DATA;
                        end
                    end
                SENDING_DATA:
                    begin
                        ctrl_clk_mips = 1;
                        if (&current_inst[31:26]) begin
                            state = WAITING;                            
                        end
                        else begin
                            state = STEP_BY_STEP;
                        end
                        case (sub_state):
                            SUB_INIT: begin
                                sub_state = SUB_SEND_BYTE; 
                                sub_sub_state = SUB_SUB_SEND_PC; 
                            end
                            SUB_SEND_BYTE: begin
                                case(sub_sub_state) 
                                    SUB_SUB_SEND_PC: begin
                                        
                                    end
                                endcase
                                tx_start = 1;
                                if (tx_done) begin
                                    tx_start = 0;
                                end
                            end
                        endcase
                    end                
            endcase
        end
    end
endmodule