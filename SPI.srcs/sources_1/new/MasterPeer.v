`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 05:37:46 PM
// Design Name: 
// Module Name: MasterPeer
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


module MasterPeer#(
    parameter DATA_WIDTH = 8
)(
    input wire sclk,
    input wire reset_n,
    input wire MST_start,
    input wire [1:0] PISO_mode,
    input wire [DATA_WIDTH - 1 : 0] D_in,
    output wire MOSI,
    output wire PISO_empty  
    );   
    wire [$clog2(DATA_WIDTH) - 1 : 0] Counting;
    
    Counter#(
        .NUM_BITS($clog2(DATA_WIDTH))
    )MST_Counter(
        .sclk(sclk),
        .reset_n(reset_n),
        .cnt_en(MST_start),
        .Counting(Counting)
    );
    
    USR_PISO#(
       .DATA_WIDTH(DATA_WIDTH)
    )MST_SR(
        .sclk(sclk),
        .reset_n(reset_n),
        .PISO_mode(PISO_mode & {2{MST_start}}),
        .D_in(D_in),
        .D_out(MOSI)  
    );
    
    assign PISO_empty = Counting[2] & Counting[1] & Counting[0]; 
endmodule
