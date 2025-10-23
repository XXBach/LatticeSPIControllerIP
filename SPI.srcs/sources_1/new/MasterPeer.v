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
    parameter DATA_WIDTH = 8,
    parameter NUM_BITS = 4
)(
    input wire sclk,
    input wire reset_n,
    input wire MST_start,
    input wire [1:0] SIPO_mode,
    input wire [1:0] PISO_mode,
    input wire [DATA_WIDTH - 1 : 0] D_in,
    input wire MISO,
    output wire MOSI,
    output wire [DATA_WIDTH - 1 : 0] D_out,
    output wire PISO_empty,
    //testing output
    output wire [DATA_WIDTH - 1 : 0] PISO_Current_Data  
    );
    
    //Master peer contain of 1 Up Counter and 2 Universal Shift Regs
    //The Counter is responsible for feedback PISO_empty to the Controller, inform the Controller that the Shift Regs has Shifted for 8 cycles - equal to 8 bits in Data width
    //2 Universal Shift Regs is designed in the form of PISO and SIPO
    //PISO reg will receive data parallel from LMMI or Cross-clock FIFO and shift them onto MOSI, start from the MSB bit
    //SIPO reg will receive data serial from MISO and sample those out parallel on to FIFO   
       
    wire [NUM_BITS - 1 : 0] Counting;
    Counter#(
        .NUM_BITS(NUM_BITS)
    )MST_Counter(
        .sclk(sclk),
        .reset_n(reset_n),
        .cnt_en(MST_start),
        .Counting(Counting)
    );
    
    USR_PISO#(
       .DATA_WIDTH(DATA_WIDTH)
    )MST_PISO(
        .sclk(sclk),
        .reset_n(reset_n),
        .PISO_mode(PISO_mode),
        .D_in(D_in),
        .D_out(MOSI),
        .temp_D_out(PISO_Current_Data)   
    );
    
    USR_SIPO#(
       .DATA_WIDTH(DATA_WIDTH)
    )MST_SIPO(
        .sclk(sclk),
        .reset_n(reset_n),
        .SIPO_mode(SIPO_mode),
        .D_in(MISO),
        .D_out(D_out)  
    );
//    Universal_Shift_Reg_GateLevel#(
//        .DATA_WIDTH(DATA_WIDTH)
//    )MST_SR(
//        .clk(sclk),
//        .reset(!reset_n),
//        .shift_mode(PISO_mode & {2{MST_start}}),
//        .D_in(D_in),
//        .D_out(D_out)  
//    );
    assign PISO_empty = Counting[2] & Counting[1] & Counting[0];  
endmodule
