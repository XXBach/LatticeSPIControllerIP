`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2025 10:20:47 PM
// Design Name: 
// Module Name: Sync_Counter_tb
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


module Sync_Counter_tb();
    parameter NUM_BITS = 4;
    
    logic sclk;
    logic reset_n;
    logic cnt_en;
    logic [NUM_BITS - 1 : 0] Counting;
    
    Counter#(
        .NUM_BITS(NUM_BITS)
    )DUT(
        .sclk(sclk),
        .reset_n(reset_n),
        .cnt_en(cnt_en),
        .Counting(Counting)
    );

    initial begin
        sclk = 0;
        forever #5 sclk = ~sclk;
    end
        
    initial begin
      reset_n <= 1;
      cnt_en <= 0;
      #10;
      reset_n <= 0;
      #10;
      reset_n <= 1;
      #100;
      cnt_en <= 1;
      #100;
      repeat(5) begin
        #10;
        reset_n <= $random($realtime * 1200);
      end
      #10;      
      $stop;
    end
endmodule
