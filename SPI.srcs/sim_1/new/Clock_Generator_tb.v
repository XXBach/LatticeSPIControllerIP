`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 09:01:32 PM
// Design Name: 
// Module Name: Clock_Generator_tb
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


module Clock_Generator_tb();
    parameter NUM_BITS = 4;
    parameter SCLK_PW = 1;
    
    reg clk_i;
    reg reset_n;
    reg clk_gen_en;
    wire sclk_o;
    
    Clock_Generator#(
        .NUM_BITS(NUM_BITS),
        .SCLK_PW(SCLK_PW)
    )DUT(
        .clk_i(clk_i),
        .reset_n(reset_n),
        .clk_gen_en(clk_gen_en),
        .sclk_o(sclk_o)
    );
    
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end
    
    initial begin
        reset_n <= 1;
        clk_gen_en <= 0;
        #10;
        reset_n <= 0;
        #100;
        reset_n <= 1;
        #30;
        clk_gen_en <= 1;
        #100;
        clk_gen_en <= 0;
        #20;
        clk_gen_en <= 1;
        #50;
        $stop;
    end    
endmodule
