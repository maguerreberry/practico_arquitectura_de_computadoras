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
    parameter cant_regs = 32,
    parameter cant_mem_datos = 16,
    parameter LEN_DATA = 8,
    parameter nb_pc = len/8, //Num bytes
    parameter nb_recolector = len/8,
    parameter nb_Latches_1_2 = (len*1)/8,
    parameter nb_Latches_2_3 = (len*1)/8,
    parameter nb_Latches_3_4 = (len*1)/8,
    parameter nb_Latches_4_5 = (len*1)/8,
    parameter nb_ciclos = (len*1)/8,
    parameter total_lenght = nb_pc + nb_Latches_1_2 + nb_Latches_2_3 + nb_Latches_3_4 + nb_Latches_4_5 + nb_recolector + nb_ciclos,
	parameter NB_addr = $clog2(cant_instruccciones),
    parameter NB_total_lenght = $clog2(total_lenght)
	) (
    input clk,
    input reset,
    input halt,  
    input [(nb_pc*8)-1:0] pc,
    input [(nb_Latches_1_2*8)-1:0] Latches_1_2, // pensar la longitud pq queda demasiados cables
    input [(nb_Latches_2_3*8)-1:0] Latches_2_3, // pensar la longitud pq queda demasiados cables
    input [(nb_Latches_3_4*8)-1:0] Latches_3_4, // pensar la longitud pq queda demasiados cables
    input [(nb_Latches_4_5*8)-1:0] Latches_4_5, // pensar la longitud pq queda demasiados cables
    input [(nb_recolector*8)-1:0] recolector, // pensar la longitud pq queda demasiados cables
    output [NB_addr-1:0] addr_mem_inst,
    output [len-1:0] ins_to_mem,
    output reg reset_mips,
    output reg reprogram,
    output reg ctrl_clk_mips,
    output reg restart_recolector,
    output reg send_regs_recolector,
    output reg enable_next_recolector,

    //UART
    input tx_done,
    input rx_done,
    input [LEN_DATA-1:0] uart_data_in, 
    output reg tx_start,
    output reg [LEN_DATA-1:0] uart_data_out 
    );

    localparam [6:0] IDLE         	= 7'b 0000001,
    				 PROGRAMMING  	= 7'b 0000010,
    				 WAITING      	= 7'b 0000100,
    				 STEP_BY_STEP   = 7'b 0001000,
                     SENDING_DATA   = 7'b 0010000,
                     CONTINUOS      = 7'b 0100000,
                     STEPPING       = 7'b 1000000;

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
					 ReProgramSignal 	= 8'b 00000101,
					 StepSignal			= 8'b 00000110;

    reg [6:0] state;
    reg [5:0] sub_state;
    reg [NB_total_lenght-1:0] index;
    reg [(nb_ciclos*8)-1:0] ciclos;
    reg [len-1:0] instruction;
    reg [NB_addr-1:0] num_instruc;
    reg write_enable_ram_inst;
    reg [7:0] regs_counter;

    wire [LEN_DATA-1:0] bytes_to_send [total_lenght-1:0];

    generate
        genvar ii;     
        for (ii = 0; ii < total_lenght; ii = ii + 1) begin: cargar_todo
            if (ii < nb_pc) begin
                assign bytes_to_send[ii] = pc[((nb_pc*8)-((nb_pc-ii)*8))-1+8:((nb_pc*8)-((nb_pc-ii)*8))];                            
            end
            else if (ii < nb_pc+nb_Latches_1_2) begin
                assign bytes_to_send[ii] = Latches_1_2[((nb_Latches_1_2*8)-((nb_Latches_1_2-ii+nb_pc)*8))-1+8:((nb_Latches_1_2*8)-((nb_Latches_1_2-ii+nb_pc)*8))];                                                            
            end
            else if (ii < nb_pc+nb_Latches_1_2+nb_Latches_2_3) begin
                assign bytes_to_send[ii] = Latches_2_3[((nb_Latches_2_3*8)-((nb_Latches_2_3-ii+nb_pc+nb_Latches_1_2)*8))-1+8:((nb_Latches_2_3*8)-((nb_Latches_2_3-ii+nb_pc+nb_Latches_1_2)*8))];                                                            
            end
            else if (ii < nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4) begin
                assign bytes_to_send[ii] = Latches_3_4[((nb_Latches_3_4*8)-((nb_Latches_3_4-ii+nb_pc+nb_Latches_1_2+nb_Latches_2_3)*8))-1+8:((nb_Latches_3_4*8)-((nb_Latches_3_4-ii+nb_pc+nb_Latches_1_2+nb_Latches_2_3)*8))];                                                            
            end
            else if (ii < nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4+nb_Latches_4_5) begin
                assign bytes_to_send[ii] = Latches_4_5[((nb_Latches_4_5*8)-((nb_Latches_4_5-ii+nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4)*8))-1+8:((nb_Latches_4_5*8)-((nb_Latches_4_5-ii+nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4)*8))];                                                            
            end
            else if (ii < nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4+nb_Latches_4_5+nb_ciclos) begin
                assign bytes_to_send[ii] = ciclos[((nb_ciclos*8)-((nb_ciclos-ii+nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4+nb_Latches_4_5)*8))-1+8:((nb_ciclos*8)-((nb_ciclos-ii+nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4+nb_Latches_4_5)*8))];
            end
            else if (ii < nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4+nb_Latches_4_5+nb_recolector+nb_ciclos) begin
                assign bytes_to_send[ii] = recolector[((nb_recolector*8)-((nb_recolector-ii+nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4+nb_Latches_4_5+nb_ciclos)*8))-1+8:((nb_recolector*8)-((nb_recolector-ii+nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4+nb_Latches_4_5+nb_ciclos)*8))];
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
                        reprogram = 0;
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
                                    num_instruc = 0;
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
	                				write_enable_ram_inst = 1'b 1;
	                				num_instruc = num_instruc + 1'b 1;
	                				if (&instruction[31:26]) 
	                				begin
	                					state = WAITING;
	                					sub_state = SUB_INIT;
                                        write_enable_ram_inst = 0;
	                				end
	                				else 
	                				begin
	                					sub_state = SUB_READ_1;
                                        write_enable_ram_inst = 0;             					
	                				end
                				end
                    	endcase	
                    end
                WAITING:
                    begin
                        ciclos = 0;
                        reset_mips = 1;
                        case (uart_data_in)
                            ReProgramSignal: begin
                                reprogram = 1;
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
                            ctrl_clk_mips = 1;
                            ciclos = ciclos + 1;
                            state = SENDING_DATA;
                        end
                    end
                CONTINUOS:
                    begin
                        ctrl_clk_mips = 1;
                        ciclos = ciclos + 1;
                        if (halt) begin
                            state = SENDING_DATA;
                        end
                    end
                SENDING_DATA:
                    begin
                        enable_next_recolector = 0;
                        ctrl_clk_mips = 0;
                        restart_recolector = 0;
                        if (index < nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4+nb_Latches_4_5+nb_ciclos) begin
                            uart_data_out = bytes_to_send[index];
                            tx_start = 1;
                        end
                        else if (index < total_lenght) begin
                            uart_data_out = bytes_to_send[index];
                            tx_start = 1;
                            if (&index[1:0]) begin
                                index = nb_pc+nb_Latches_1_2+nb_Latches_2_3+nb_Latches_3_4+nb_Latches_4_5+nb_ciclos;
                                enable_next_recolector = 1;
                                if (regs_counter < cant_regs) begin
                                    send_regs_recolector = 1;
                                    regs_counter = regs_counter + 1;
                                end
                                else if(regs_counter < cant_mem_datos+cant_regs) begin
                                    send_regs_recolector = 0;                                    
                                    regs_counter = regs_counter + 1;
                                end
                                else begin
                                    index = total_lenght;
                                end
                            end
                        end
                        else begin
                            index = 0;
                            restart_recolector = 1;                         
                            if (halt) begin
                                state = WAITING;                            
                            end
                            else begin
                                state = STEP_BY_STEP;
                            end
                        end
                        if (tx_done) begin
                            index = index + 1;
                            tx_start = 0;
                            // state = SENDING_DATA;
                        end
                    end
            endcase                
        end
    end
endmodule