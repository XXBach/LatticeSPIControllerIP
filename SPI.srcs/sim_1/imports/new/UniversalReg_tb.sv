`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2025 08:17:15 PM
// Design Name: 
// Module Name: UniversalReg_tb
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


module UniversalReg_tb();
    parameter DATA_WIDTH = 4;
    
    logic clk;
    logic reset;
    logic [1:0] shift_mode;
    logic [DATA_WIDTH - 1:0] D_in;
    logic [DATA_WIDTH - 1:0] D_out;
    
    Universal_Shift_Reg_Behavioral#(
        .DATA_WIDTH(DATA_WIDTH)
    )USRB(
        .clk(clk),
        .reset(reset),
        .shift_mode(shift_mode),
        .D_in(D_in),
        .D_out(D_out)  
    );

//    Universal_Shift_Reg_GateLevel#(
//        .DATA_WIDTH(DATA_WIDTH)
//    )USRGLV(
//        .clk(clk),
//        .reset(reset),
//        .shift_mode(shift_mode),
//        .D_in(D_in),
//        .D_out(D_out)  
//    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
        
    initial begin
        reset <= 0;
        shift_mode <= 2'b11;
        D_in <= 4'b1001;
        #17
        reset <= 1;
        #20;
        reset <= 0;
        #10;
        repeat(5) begin
            #13;
            D_in <= $random($realtime*1000);
            shift_mode <= 2'b00;
        end
        repeat(5) begin
            #17;
            D_in <= $random($realtime*1000);
            shift_mode <= 2'b01;
        end
        #11;
        shift_mode <= 2'b00;
        repeat(5) begin
            #23;
            D_in <= $random($realtime*1000);
            shift_mode <= 2'b10;
        end
        repeat(5) begin
            #19;
            D_in <= $random($realtime*1000);
            shift_mode <= 2'b11;
        end
        repeat(5) begin
            #9;
            shift_mode <= $random($realtime*1200);
            D_in <= $random($realtime*1000);
        end     
        $stop;
    end
endmodule
