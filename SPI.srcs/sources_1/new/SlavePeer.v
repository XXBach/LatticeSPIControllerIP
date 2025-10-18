`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 06:57:08 PM
// Design Name: 
// Module Name: SlavePeer
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


module SlavePeer#(
    parameter DATA_WIDTH = 8
)(
    input wire sclk,
    input wire reset_n,
    input wire SLV_start,
    input wire [1:0] SIPO_mode,
    input wire MOSI,
    output wire MISO,
    output wire SIPO_empty  
    );   
    wire [$clog2(DATA_WIDTH) - 1 : 0] Counting;
    
    Counter#(
        .NUM_BITS($clog2(DATA_WIDTH))
    )SLV_Counter(
        .sclk(sclk),
        .reset_n(reset_n),
        .cnt_en(SLV_start),
        .Counting(Counting)
    );
    
    USR_PISO#(
       .DATA_WIDTH(DATA_WIDTH)
    )SLV_SR(
        .sclk(sclk),
        .reset_n(reset_n),
        .SIPO_mode(SIPO_mode & {2{SLV_start}}),
        .D_in(MOSI),
        .D_out(MISO)  
    );
    
    assign SIPO_empty = Counting[2] & Counting[1] & Counting[0]; 
endmodule
