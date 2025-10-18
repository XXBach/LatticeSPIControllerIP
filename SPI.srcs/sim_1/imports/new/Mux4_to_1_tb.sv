`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2025 09:21:15 PM
// Design Name: 
// Module Name: Mux4_to_1_tb
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


module Mux4_to_1_tb();
    parameter DATA_WIDTH = 4;
    
    logic [DATA_WIDTH - 1 : 0] A;
    logic [DATA_WIDTH - 1 : 0] B;
    logic [DATA_WIDTH - 1 : 0] C;
    logic [DATA_WIDTH - 1 : 0] D;
    logic [1:0] Sel;
    logic [DATA_WIDTH - 1 : 0] E;
    
//    Mux4_to_1_Dataflow#(
//        .DATA_WIDTH(DATA_WIDTH)
//    )Mux4_to_1_DTF(
//        .A(A),
//        .B(B),
//        .C(C),
//        .D(D),
//        .Sel(Sel),
//        .E(E)
//    );

//    Mux4_to_1_Behavioral#(
//        .DATA_WIDTH(DATA_WIDTH)
//    )Mux4_to_1_BHVR(
//        .A(A),
//        .B(B),
//        .C(C),
//        .D(D),
//        .Sel(Sel),
//        .E(E)
//    );
    
    Mux4_to_1_Gatelevel#(
        .DATA_WIDTH(DATA_WIDTH)
    )Mux4_to_1_GLV(
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Sel(Sel),
        .E(E)
    );
    task automatic self_checking (input [DATA_WIDTH - 1 : 0] A, input [DATA_WIDTH - 1 : 0] B, input [DATA_WIDTH - 1 : 0] C, input [DATA_WIDTH - 1 : 0] D, input [1:0] Sel, input [DATA_WIDTH - 1 : 0] E);
        logic [DATA_WIDTH - 1 : 0] expected_result;
        begin
            expected_result = (Sel == 2'b11) ? D : (Sel == 2'b10) ? C : (Sel == 2'b01) ? B : A;
            #5;
            if(E == expected_result) begin
                $display("[%0t] Mux 4-1 worked correctly on inputs A: %b | B: %b | C: %b | D: %b", $time, A, B, C, D);
                $display("Expected result: %b | Actual result: %b", expected_result, E); 
            end
            else begin
                $display("[%0t] Mux 4-1 worked incorrectly on inputs A: %b | B: %b | C: %b | D: %b", $time, A, B, C, D);
                $display("Expected result: %b | Actual result: %b", expected_result, E);  
            end
        end
    endtask:self_checking
    
    initial begin
        fork
            begin
                repeat (20) begin
                    A = $random($realtime*1000);
                    B = $random($realtime*1100);
                    C = $random($realtime*900);
                    D = $random($realtime*800);                    
                    Sel = $random($realtime*1200);
                    #10; 
                end
            end
            begin
                repeat(20) begin
                    self_checking(A, B, C, D, Sel, E);
                end
            end
        join
        $stop;
    end
endmodule
