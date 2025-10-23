`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 11:22:09 AM
// Design Name: 
// Module Name: LMMI2APB
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


module LMMI2APB#(
    parameter DATA_WIDTH = 8,
    parameter REGFILE_DEPTH = 16
)(
    input wire clk_i,
    input wire reset_n,
    //Signals for APB
    input wire PSEL,
    input wire PWRITE,
    input wire [DATA_WIDTH - 1 : 0] PRDATA,
    input wire [DATA_WIDTH - 1 : 0] PWDATA,
    output wire PENABLE
    //Signals for  
    );
endmodule
