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


module maquina_estados #(
    parameter len = 32,
    parameter cant_instruccciones = 64,
    parameter LEN_DATA = 8,
    parameter nb_pc = len/8, //Num bytes
    parameter nb_regs = (len*len)/8,
    parameter nb_MemDatos = (len*1)/8,
    parameter nb_Latches_1_2 = (len*1)/8,
    parameter nb_Latches_2_3 = (len*1)/8,
    parameter nb_Latches_3_4 = (len*1)/8,
    parameter nb_Latches_4_5 = (len*1)/8,
    parameter total_lenght = nb_pc + nb_regs + nb_MemDatos + nb_Latches_1_2 + nb_Latches_2_3 + nb_Latches_3_4 + nb_Latches_4_5,
	parameter NB_addr = $clog2(cant_instruccciones),
    parameter NB_total_lenght = $clog2(total_lenght)
	) (
    input clk,
    input reset,
    input [len-1:0] current_inst,  
    input [(nb_pc*8)-1:0] pc,
    input [(nb_regs*8)-1:0] regs, // pensar la longitud pq queda demasiados cables
    input [(nb_MemDatos*8)-1:0] MemDatos, // pensar la longitud pq queda demasiados cables
    input [(nb_Latches_1_2*8)-1:0] Latches_1_2, // pensar la longitud pq queda demasiados cables
    input [(nb_Latches_2_3*8)-1:0] Latches_2_3, // pensar la longitud pq queda demasiados cables
    input [(nb_Latches_3_4*8)-1:0] Latches_3_4, // pensar la longitud pq queda demasiados cables
    input [(nb_Latches_4_5*8)-1:0] Latches_4_5, // pensar la longitud pq queda demasiados cables
    output [NB_addr-1:0] addr_mem_inst,
    output [len-1:0] ins_to_mem,
    output reg reset_mips,
    output reg erase_mem_inst,
    output reg ctrl_clk_mips,

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
                     STEPPING       = 6'b 010001;

    localparam [5:0] SUB_INIT		= 6'b 100000,
    				 SUB_READ_1		= 6'b 100001,
    				 SUB_READ_2		= 6'b 100010,
    				 SUB_READ_3		= 6'b 100100,
    				 SUB_READ_4		= 6'b 101000,
    				 SUB_WRITE_MEM	= 6'b 110000,
                     SUB_SEND_1     = 6'b 110001,
                     SUB_SEND_2     = 6'b 110010,
                     SUB_SEND_3     = 6'b 110100,
                     SUB_SEND_4     = 6'b 111000,
                     SUB_SUB_SEND_PC        = 6'b 111001,
                     SUB_SUB_SEND_32_REGS   = 6'b 111010,
                     SUB_SEND_BYTE     = 6'b 111011;


    localparam [7:0] StartSignal		= 8'b 00000001,
					 ContinuosSignal  	= 8'b 00000010,
					 StepByStepSignal   = 8'b 00000011,
					 ResetMipsSignal   	= 8'b 00000100,
					 EraseMemorySignal 	= 8'b 00000101,
					 StepSignal			= 8'b 00000110;

    reg [5:0] state;
    reg [5:0] sub_state;
    reg [5:0] sub_sub_state;
    reg [5:0] n_bytes, i;
    reg [NB_total_lenght-1:0] index;
    reg [len-1:0] ciclos;
    reg [len-1:0] instruction;
    reg [NB_addr-1:0] num_instruc;
    reg wrtie_enable_ram_inst;

    wire [LEN_DATA-1:0] bytes_to_send [total_lenght-1:0];

    generate
        genvar ii;     
        for (ii = 0; ii < total_lenght; ii = ii + 1) begin: cargar_todo
            if (ii < nb_pc) begin
                assign bytes_to_send[ii] = pc[((nb_pc*8)-((nb_pc-ii)*8))-1+8:((nb_pc*8)-((nb_pc-ii)*8))];                            
            end
            else if (ii < nb_regs+nb_pc) begin
                assign bytes_to_send[ii] = regs[((nb_regs*8)-((nb_regs-(ii-nb_pc))*8))-1+8:((nb_regs*8)-((nb_regs-(ii-nb_pc))*8))];                                                            
            end
            else if (ii < nb_regs+nb_pc+nb_MemDatos) begin
                assign bytes_to_send[ii] = MemDatos[((nb_MemDatos*8)-((nb_MemDatos-ii+nb_pc+nb_regs)*8))-1+8:((nb_MemDatos*8)-((nb_MemDatos-ii+nb_pc+nb_regs)*8))];                                                            
            end
            else if (ii < nb_regs+nb_pc+nb_MemDatos+nb_Latches_1_2) begin
                assign bytes_to_send[ii] = Latches_1_2[((nb_Latches_1_2*8)-((nb_Latches_1_2-ii+nb_regs+nb_pc+nb_MemDatos)*8))-1+8:((nb_Latches_1_2*8)-((nb_Latches_1_2-ii+nb_regs+nb_pc+nb_MemDatos)*8))];                                                            
            end
            else if (ii < nb_regs+nb_pc+nb_MemDatos+nb_Latches_1_2+nb_Latches_2_3) begin
                assign bytes_to_send[ii] = Latches_2_3[((nb_Latches_2_3*8)-((nb_Latches_2_3-ii+nb_regs+nb_pc+nb_MemDatos+nb_Latches_1_2)*8))-1+8:((nb_Latches_2_3*8)-((nb_Latches_2_3-ii+nb_regs+nb_pc+nb_MemDatos+nb_Latches_1_2)*8))];                                                            
            end
            else if (ii < nb_regs+nb_pc+nb_MemDatos+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4) begin
                assign bytes_to_send[ii] = Latches_3_4[((nb_Latches_3_4*8)-((nb_Latches_3_4-ii+nb_regs+nb_pc+nb_MemDatos+nb_Latches_1_2+nb_Latches_2_3)*8))-1+8:((nb_Latches_3_4*8)-((nb_Latches_3_4-ii+nb_regs+nb_pc+nb_MemDatos+nb_Latches_1_2+nb_Latches_2_3)*8))];                                                            
            end
            else if (ii < nb_regs+nb_pc+nb_MemDatos+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4+nb_Latches_4_5) begin
                assign bytes_to_send[ii] = Latches_4_5[((nb_Latches_4_5*8)-((nb_Latches_4_5-ii+nb_regs+nb_pc+nb_MemDatos+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4)*8))-1+8:((nb_Latches_4_5*8)-((nb_Latches_4_5-ii+nb_regs+nb_pc+nb_MemDatos+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4)*8))];                                                            
            end
        end
    endgenerate

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
                        index = 0;
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
                        if (index < total_lenght) begin
                            uart_data_out = bytes_to_send[index];
                            index = index + 1;
                            tx_start = 1;
                            if (tx_done) begin
                                tx_start = 0;
                                state = SENDING_DATA;
                            end
                        end
                        else begin
                            index = 0;                            
                            if (&current_inst[31:26]) begin
                                state = WAITING;                            
                            end
                            else begin
                                state = STEP_BY_STEP;
                            end
                        end
                    end
            endcase                
        end
    end
endmodule