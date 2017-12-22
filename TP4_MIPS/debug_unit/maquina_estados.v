`timescale 1ns / 1ps
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


module maquina_estados(
	parameter len_opcode = 5,
    parameter len_pc = 16,
    parameter len = 32,
    parameter len_acc = 16,
    parameter LEN_DATA = 8
	) (
    input clk,
    input reset,
    input [len_opcode-1:0] in_opcode,
    input [len_acc-1:0] in_acc,    
    input tx_done,
    input rx_done,
    input [LEN_DATA-1:0] uart_data_in, 


    output [] addr_mem;
    output [] ins_to_mem;

    output reg tx_start,
    output reg [LEN_DATA-1:0] uart_data_out 
    );

    localparam [5:0] IDLE         	= 6'b 000000;
    localparam [5:0] PROGRAMMING  	= 6'b 000001;
    localparam [5:0] WAITING      	= 6'b 000010;
    localparam [5:0] STEP_BY_STEP   = 6'b 000100;
    localparam [5:0] SENDING_DATA 	= 6'b 001000;
    localparam [5:0] CONTINUOS		= 6'b 010000;

    localparam [5:0] SUB_INIT		= 6'b 100000;
    localparam [5:0] SUB_READ_1		= 6'b 100001;
    localparam [5:0] SUB_READ_2		= 6'b 100010;
    localparam [5:0] SUB_READ_3		= 6'b 100100;
    localparam [5:0] SUB_READ_4		= 6'b 101000;
    localparam [5:0] SUB_WRITE_MEM	= 6'b 110000;

    localparam [7:0] StartSignal		= 8'b 00000001;
    localparam [7:0] ContinuosSignal  	= 8'b 00000010;
    localparam [7:0] StepByStepSignal   = 8'b 00000011;
    localparam [7:0] ResetMipsSignal   	= 8'b 00000100;
    localparam [7:0] EraseMemorySignal 	= 8'b 00000101;
    localparam [7:0] StepSignal			= 8'b 00000110;


    reg [5:0] state;
    reg [5:0] sub_state;
    reg [len_pc-1:0] ciclos;
    reg [len-1:0] instruction;
    reg [5:0] num_instruc;
    reg wrtie_enable_ram_inst;
    wire [len_acc-1:0] acc;

    assign ins_to_mem = instruction;
    assign addr_mem = num_instruc;
    assign acc = in_acc;
    
    always @(negedge clk) begin
        if (reset) begin
          ciclos = 0;
          state = IDLE;
          sub_state = SUB_INIT;
        end
        else begin
            case(state)
                IDLE:
                    begin
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
                        data_out = ciclos[LEN_DATA-1:0];
                        tx_start = 1;
                        if (tx_done) begin
                            state = TX2;
                            tx_start = 0;
                        end
                    end
                STEP_BY_STEP:
                    begin
                        data_out = ciclos[len_pc-1:LEN_DATA];
                        tx_start = 1;
                        if (tx_done) begin
                            state = TX3;
                            tx_start = 0;
                        end
                    end
                CONTINUOS:
                    begin
                        data_out = acc[LEN_DATA-1:0];
                        tx_start = 1;
                        if (tx_done) begin
                            state = TX4;
                            tx_start = 0;
                        end
                    end                
                SENDING_DATA:
                    begin
                        data_out = acc[len_acc-1:LEN_DATA];
                        tx_start = 1;
                        if (tx_done) begin
                            state = IDLE;
                            tx_start = 0;
                        end
                    end                
            endcase
        end
    end
endmodule