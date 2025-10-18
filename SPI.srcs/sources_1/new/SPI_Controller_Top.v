`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 10:09:00 PM
// Design Name: 
// Module Name: SPI_Controller_Top
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


module SPI_Controller_Top#(
    parameter DATA_WIDTH = 8,
    parameter SCLK_PW = 1
)( 
    input wire clk_i,
    input wire reset_n,
    
    //Input control signal from Microcontroller
    input wire SPI_en_n,
    input wire PISO_empty,
    input wire SIPO_empty,
    
    //Input control signal from LMMI device
    input wire lmmi_ready,
    input wire lmmi_rdata_valid,
    
    //Input control signal from FIFO
    input wire FIFO_ready,
    
    //Output control signal for intra Controller
    output wire SS_n,
    output wire clk_gen_en,
    output wire [1:0] PISO_mode,
    output wire [1:0] SIPO_mode,
    output wire MST_start,
    output wire SLV_start,
    
    //Output control signal for communication with LMMI
    output wire lmmi_request,
    output wire lmmi_wr_rdn,
    output wire [7:0] offset,
    output wire SPI_ready,
    
    //Output control signal for communication with FIFO output
    output wire FIFO_wr_request
    );
endmodule
