`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2017 03:38:48 PM
// Design Name: 
// Module Name: tb_top
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


module tb_doble_uart
    (

    );
    
    reg clk;
    reg reset;
    wire connect_tx;
    wire connect_rx;
    reg tx_start;
    reg [7:0] data;


    localparam [7:0] StartSignal        = 8'b 00000001,
                     ContinuosSignal    = 8'b 00000010,
                     StepByStepSignal   = 8'b 00000011,
                     ReProgramSignal    = 8'b 00000101,
                     StepSignal         = 8'b 00000110;

    top_modular#(
        .LEN(32),
        .estamos_en_test_bench(0)
        )
        u_top_modular(
            .CLK100MHZ(clk),
            .SWITCH_RESET(reset),
            .UART_TXD_IN (connect_tx),
            .UART_RXD_OUT(connect_rx)
        );  

    uart #(
    .NBITS(8),
    .NUM_TICKS(16),
    .BAUD_RATE(100000),
    .CLK_RATE(100000000)
    )
    u_uart(
        .CLK_100MHZ(clk),
        .reset(reset),
        .tx_start(tx_start),
        .rx(connect_rx),
        .data_in(data),

        .data_out(),
        .rx_done_tick(),
        .tx(connect_tx),
        .tx_done_tick()
        );

    initial
    begin
        clk = 0;
        reset = 1;
        #12
        reset = 0;
        data = ContinuosSignal;
        tx_start = 1;
        #3000
        data = 0;
        tx_start = 0;
        #(65 * 1000 * 1000)
        data = ContinuosSignal;
        tx_start = 1;
        #3000
        data = 0;
        tx_start = 0;
    end

    always 
    begin
        #5 clk = ~clk;
    end

endmodule