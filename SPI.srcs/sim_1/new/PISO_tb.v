`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 03:38:09 PM
// Design Name: 
// Module Name: PISO_tb
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


module PISO_tb();
    parameter DATA_WIDTH = 8;
    
    reg sclk;
    reg reset_n;
    reg [1:0] PISO_mode;
    reg [DATA_WIDTH - 1 : 0] D_in;
    wire D_out;
    
    USR_PISO#(
       .DATA_WIDTH(DATA_WIDTH)
    )DUT(
        .sclk(sclk),
        .reset_n(reset_n),
        .PISO_mode(PISO_mode),
        .D_in(D_in),
        .D_out(D_out)  
    );
    
    initial begin
        sclk <= 0;
        forever #5 sclk = ~sclk;
    end
    
    initial begin    
        reset_n <= 1'b1;
        PISO_mode <= 2'b00;
        D_in <= 0;
        #20
        reset_n <= 1'b0;
        #50
        reset_n <= 1'b1;
        #15;
        repeat(5) begin
            #10;
            D_in <= $random($realtime*12013);
            PISO_mode <= 2'b00;
        end
        repeat(10) begin
            #10;
            D_in <= $random($realtime*14350);
            PISO_mode <= 2'b01;
        end
        #10;
        PISO_mode <= 2'b00;
        repeat(10) begin
            #10;
            D_in <= $random($realtime*13481);
            PISO_mode <= 2'b10;
        end
        repeat(5) begin
            #10;
            D_in <= $random($realtime*13410);
            PISO_mode <= 2'b11;
        end
        repeat(5) begin
            #10;
            PISO_mode <= $random($realtime*1200);
            D_in <= $random($realtime*1000);
        end     
        $stop;
    end
endmodule
