`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2017 08:21:19 PM
// Design Name: 
// Module Name: receiver
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


`define NBITS 8

module transmisor
(
	// input
	clk,
	reset,
	tx_start,
	tick,
	data_in,

	// output
	tx_done_tick,
	tx
);

parameter NBITS = `NBITS;
parameter LEN_DATA_COUNTER = $clog2(NBITS); 
parameter NUM_TICKS = 16;
parameter LEN_NUM_TICKS_COUNTER = $clog2(NUM_TICKS); 


input clk;
input reset;
input tx_start;
input tick;
input [NBITS-1:0] data_in;

output reg tx_done_tick;
output tx;

// Declaracion de estados
localparam [3:0] IDLE 	= 4'b 1000;
localparam [3:0] START 	= 4'b 0100;
localparam [3:0] DATA	= 4'b 0010;
localparam [3:0] STOP 	= 4'b 0001;

// declaracion de registros auxiliares
reg [3:0] state_reg, state_next;
reg [LEN_NUM_TICKS_COUNTER-1:0] acc_tick, acc_tick_next;
reg [LEN_DATA_COUNTER-1:0] num_bits, num_bits_next;
reg [NBITS-1:0] buffer, buffer_next;
reg tx_reg, tx_next;

assign tx = tx_reg;

// parte sincrona con el clock
always @(posedge clk, posedge reset)
begin
	if(reset)
		begin
			state_reg <= IDLE;
			acc_tick <= 0;
			num_bits <= 0;
			buffer <= 0;
			tx_reg <= 1'b1;	
		end
	else 
		begin
			state_reg <= state_next;
			acc_tick <= acc_tick_next;
			num_bits <= num_bits_next;
			buffer <= buffer_next;
			tx_reg <= tx_next;
		end
end

always @*
begin
	state_next = state_reg;
	tx_done_tick = 1'b0;
	acc_tick_next = acc_tick;
	num_bits_next = num_bits;
	buffer_next = buffer;
	tx_next = tx_reg;

	case (state_reg)
		IDLE:
			begin
				tx_next = 1'b1;
				if (tx_start) 
				begin
					state_next = START;
					acc_tick_next = 0;
					buffer_next = data_in;	
				end
			end
		START:
			begin
				tx_next = 1'b0;
				if(tick)
					if(acc_tick == NUM_TICKS-1)
					begin
						state_next = DATA;
						acc_tick_next = 0;
						num_bits_next = 0;
					end
					else 
					begin
						acc_tick_next = acc_tick + 1;	
					end
			end
		DATA:
			begin
				tx_next = buffer[0];
				if(tick)
				begin
					if(acc_tick == NUM_TICKS-1)
					begin
						acc_tick_next = 0;
						buffer_next = buffer >> 1;
						if(num_bits == (NBITS - 1))
						begin
							state_next = STOP;
						end
						else 
						begin
							num_bits_next = num_bits + 1;	
						end
					end
					else 
					begin
						acc_tick_next = acc_tick + 1;	
					end
				end
			end
		STOP:
			begin
				tx_next = 1'b1;
				if (tick)
				begin
					if(acc_tick == (NUM_TICKS - 1))
					begin
						state_next = IDLE;
						tx_done_tick = 1'b1;
					end
					else 
					begin
						acc_tick_next = acc_tick + 1;	
					end
				end
			end

        default:
            begin
				state_next = IDLE; 
				acc_tick_next = 0; 
				num_bits_next = 0; 
				buffer_next = 0;
				tx_next = 1'b1;
			end
	endcase
end
endmodule