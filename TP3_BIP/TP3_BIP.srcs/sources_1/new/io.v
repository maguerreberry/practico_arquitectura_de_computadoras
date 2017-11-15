`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2017 05:12:21 PM
// Design Name: 
// Module Name: adder_PC
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


module io #(
	parameter len_opcode = 5,
    parameter len_pc = 16,
    parameter len_acc = 16,
    parameter LEN_DATA = 8
	) (
    input clk,
    input reset,
    input [len_opcode-1:0] in_opcode,
    input [len_acc-1:0] in_acc,    
    input tx_done,

    output reg tx_start,
    output reg [LEN_DATA-1:0] data_out 

    );

    localparam [5:0] IDLE         = 6'b 000001;
    localparam [5:0] PROCCESING   = 6'b 000010;
    localparam [5:0] TX1          = 6'b 000100;
    localparam [5:0] TX2          = 6'b 001000;
    localparam [5:0] TX3          = 6'b 010000;
    localparam [5:0] TX4          = 6'b 100000;

    reg [5:0] state;
    reg [len_pc-1:0] ciclos;
    wire [len_acc-1:0] acc;

    assign acc = in_acc;
    
    always @(negedge clk) begin
        if (reset) begin
          ciclos = 0;
          state = PROCCESING;
        end
        else begin
            case(state)
                PROCCESING:
                    begin
                        if (in_opcode != 0) begin
                            ciclos = ciclos + 1;
                        end
                        else begin
                            state = TX1;
                            tx_start = 0;
                        end
                    end
                TX1:
                    begin
                        data_out = ciclos[LEN_DATA-1:0];
                        tx_start = 1;
                        if (tx_done) begin
                            state = TX2;
                            tx_start = 0;
                        end
                    end
                TX2:
                    begin
                        data_out = ciclos[len_pc-1:LEN_DATA];
                        tx_start = 1;
                        if (tx_done) begin
                            state = TX3;
                            tx_start = 0;
                        end
                    end
                TX3:
                    begin
                        data_out = acc[LEN_DATA-1:0];
                        tx_start = 1;
                        if (tx_done) begin
                            state = TX4;
                            tx_start = 0;
                        end
                    end                
                TX4:
                    begin
                        data_out = acc[len_acc-1:LEN_DATA];
                        tx_start = 1;
                        if (tx_done) begin
                            state = IDLE;
                            tx_start = 0;
                        end
                    end                
                IDLE:
                    begin                        
                    end
            endcase
        end
    end
endmodule
