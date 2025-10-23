`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 09:15:27 AM
// Design Name: 
// Module Name: PeersConnection_tb
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


module PeersConnection_tb();
    parameter DATA_WIDTH = 8; //Bit length 
    parameter SCLK_PW = 1; // sclk_o pulse width, meaning that sclk pulse width is equal to SLCK_PW * T of clk_i
    
    reg sclk;
    reg reset_n;
    reg SS_n;
    reg MST_start;
    reg [1:0] PISO_mode;
    reg [1:0] SIPO_mode;
    reg [DATA_WIDTH - 1 : 0] D_in;
    wire [DATA_WIDTH - 1 : 0] D_out;
    wire PISO_empty;  
    // Slave Peer Signals
    reg SLV_start;
    reg [1:0] SISO_mode;
    wire SISO_empty;
    
    PeersConnection#(
        .DATA_WIDTH(DATA_WIDTH), //Bit length 
        .SCLK_PW(SCLK_PW) // sclk_o pulse width, meaning that sclk pulse width is equal to SLCK_PW * T of clk_i
    )DUT(
        .sclk(sclk),
        .reset_n(reset_n),
        .SS_n(SS_n),
        .MST_start(MST_start),
        .PISO_mode(PISO_mode),
        .SIPO_mode(SIPO_mode),
        .D_in(D_in),
        .D_out(D_out),
        .PISO_empty(PISO_empty),
        .SLV_start(SLV_start),
        .SISO_mode(SISO_mode),
        .SISO_empty(SISO_empty)  
    );
    
    initial begin
        sclk = 0;
        forever begin 
            #5 
            sclk = ~sclk;
            D_in = $random($time * 102349);
        end
    end
    
    initial begin
        reset_n <= 1;
        SS_n <= 1;
        MST_start <= 0;
        SLV_start <= 0;
        SISO_mode <= 2'b00;
        PISO_mode <= 2'b00;
        SIPO_mode <= 2'b01;
        D_in <= 0;
        #20;
        reset_n <= 0;
        #50;
        reset_n <= 1;
        #10;
        SS_n <= 0;
        MST_start <= 1;  
    end
endmodule
