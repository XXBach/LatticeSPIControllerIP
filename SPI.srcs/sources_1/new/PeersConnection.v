`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2025 09:16:00 PM
// Design Name: 
// Module Name: PeersConnection
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


module PeersConnection#(
    parameter DATA_WIDTH = 8, //Bit length 
    parameter SCLK_PW = 1 // sclk_o pulse width, meaning that sclk pulse width is equal to SLCK_PW * T of clk_i
)(
    input wire sclk,
    input wire reset_n,
    input wire SS_n,
    //Master Peer Signals
    input wire MST_start,
    input wire [1:0] PISO_mode,
    input wire [1:0] SIPO_mode,
    input wire [DATA_WIDTH - 1 : 0] D_in,
    output wire [DATA_WIDTH - 1 : 0] D_out,
    output wire PISO_empty,  
    // Slave Peer Signals
    input wire SLV_start,
    input wire [1:0] SISO_mode,

    output wire SISO_empty  
    );
    wire MISO;
    wire MOSI;
    MasterPeer#(
        .DATA_WIDTH(DATA_WIDTH)
    )MST_Peer(
        .sclk(sclk),
        .reset_n(reset_n),
        .MST_start(MST_start),
        .SIPO_mode(SIPO_mode),
        .PISO_mode(PISO_mode),
        .D_in(D_in),
        .MISO(MISO),
        .MOSI(MOSI),
        .D_out(D_out),
        .PISO_empty(PISO_empty)  
    );
    
    SlavePeer#(
        .DATA_WIDTH(DATA_WIDTH)
    )SLV_Peer(
        .sclk(sclk_o),
        .reset_n(reset_n),
        .SLV_start(SLV_start & !SS_n),
        .SISO_mode(SISO_mode),
        .MOSI(MOSI),
        .MISO(MISO),
        .SISO_empty(SISO_empty) 
    ); 
endmodule
