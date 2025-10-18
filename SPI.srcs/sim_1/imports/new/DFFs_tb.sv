`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 09:28:01 PM
// Design Name: 
// Module Name: DFFs_tb
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


module DFFs_tb();
    parameter MODE = 1;
    
    logic clk;
    logic reset;
    logic P;
    logic Q;
    logic notQ;
    
    DFFs_Behavioral #(
        .MODE(MODE)
    )DFFs_BHVR(
        .clk(clk),
        .reset(reset),
        .P(P),
        .Q(Q),
        .notQ(notQ)
    );
    
//    DFFs_GateLevel #(
//        .MODE(MODE)
//    )DFFs_GLV(
//        .clk(clk),
//        .reset(reset),
//        .P(P),
//        .Q(Q),
//        .notQ(notQ)
//    );    
    property DFF_assert;
        @(posedge clk)
        reset ? (Q == 0) : (Q == $past(P));   
    endproperty: DFF_assert
    
    assert property (DFF_assert)
    else $display("[%0t] DFF failed with input P: %b | Q: %b", $time, P, Q);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        reset <= 0;
        P <= 0;
        #17;
        reset <= 1;
        #25;
        reset <= 0;
        #100;
        repeat(20) begin
            #5; 
            P <= $random($realtime*1000);
            reset <= $random($realtime*1200);
        end
        #5;
        $stop;
    end
endmodule
