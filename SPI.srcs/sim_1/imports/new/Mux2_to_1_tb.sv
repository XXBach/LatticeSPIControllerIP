`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2025 08:52:22 PM
// Design Name: 
// Module Name: Mux2_to_1_tb
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


module Mux2_to_1_tb();
    parameter DATA_WIDTH = 4;
    
    logic [DATA_WIDTH - 1 : 0] A;
    logic [DATA_WIDTH - 1 : 0] B;
    logic Sel;
    logic [DATA_WIDTH - 1 : 0] C;
    
//    Mux2_to_1_Dataflow#(
//        .DATA_WIDTH(DATA_WIDTH)
//    )Mux2_to_1_DTF(
//        .A(A),
//        .B(B),
//        .Sel(Sel),
//        .C(C)
//    );

//    Mux2_to_1_Behavioral#(
//        .DATA_WIDTH(DATA_WIDTH)
//    )Mux2_to_1_BHVR(
//        .A(A),
//        .B(B),
//        .Sel(Sel),
//        .C(C)
//    );
    
    Mux2_to_1_Gatelevel#(
        .DATA_WIDTH(DATA_WIDTH)
    )Mux2_to_1_GLV(
        .A(A),
        .B(B),
        .Sel(Sel),
        .C(C)
    );
//    task automatic self_checking (input [DATA_WIDTH - 1 : 0] A, input [DATA_WIDTH - 1 : 0] B, input Sel, input [DATA_WIDTH - 1 : 0] C);
//        logic [DATA_WIDTH - 1 : 0] expected_result;
//        begin
//            expected_result = Sel ? B : A;
//            #5;
//            if(C == expected_result) begin
//                $display("[%0t] Mux 2-1 worked correctly on inputs A: %b | B: %b", $time, A, B);
//                $display("Expected result: %b | Actual result: %b", expected_result, C); 
//            end
//            else begin
//                $display("[%0t] Mux 2-1 worked incorrectly on inputs A: %b | B: %b", $time, A, B);
//                $display("Expected result: %b | Actual result: %b", expected_result, C);  
//            end
//        end
//    endtask:self_checking
    
    initial begin
        begin
            repeat (10) begin
                A = $random($realtime*1000);
                B = $random($realtime*500);
                Sel = 0;
                #10; 
            end
            repeat (10) begin
                A = $random($realtime*1000);
                B = $random($realtime*500);
                Sel = 1;
                #10; 
            end
        end
    $stop;
    end
endmodule
