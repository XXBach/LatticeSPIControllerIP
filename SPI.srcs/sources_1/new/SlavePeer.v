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
    parameter DATA_WIDTH = 8,
    parameter NUM_BITS = 4
)(
    input wire sclk,
    input wire reset_n,
    input wire SLV_start,
    input wire [1:0] SISO_mode,
    input wire MOSI,
    output wire MISO,
    output wire SISO_empty,
    //Tesing output
    output wire [DATA_WIDTH - 1 : 0] SISO_Current_Data   
    );
    //Slave peer contain of 1 Up Counter and 1 Universal Shift Regs
    //The Counter is responsible for feedback SISO_empty to the Controller, inform the Controller that the Shift Regs has Shifted for 8 cycles - equal to 8 bits in Data width
    //2 Universal Shift Regs is designed in the form of SISO
    //SISO reg will receive data serial from MOSI and shift them onto MISO, start from the MSB bit 
       
    wire [NUM_BITS - 1 : 0] Counting;

    Counter#(
        .NUM_BITS(NUM_BITS)
    )SLV_Counter(
        .sclk(sclk),
        .reset_n(reset_n),
        .cnt_en(SLV_start),
        .Counting(Counting)
    );
    
    USR_SISO#(
       .DATA_WIDTH(DATA_WIDTH)
    )SLV_SISO(
        .sclk(sclk),
        .reset_n(reset_n),
        .SISO_mode(SISO_mode),
        .D_in(MOSI),
        .D_out(MISO),
        .temp_D_out(SISO_Current_Data)  
    );
    
    assign SISO_empty = Counting[2] & Counting[1] & Counting[0]; 
endmodule
