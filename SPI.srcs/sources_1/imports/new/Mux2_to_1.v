`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2025 03:05:33 PM
// Design Name: 
// Module Name: Mux2_to_1
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

//Dataflow
module Mux2_to_1_Dataflow#(
    parameter DATA_WIDTH = 8
)(
    input wire [DATA_WIDTH - 1 : 0] A,
    input wire [DATA_WIDTH - 1 : 0] B,
    input wire Sel,
    output wire [DATA_WIDTH - 1 : 0] C
);
    assign C = Sel ? B : A; 
endmodule

//Behavioral
module Mux2_to_1_Behavioral#(
    parameter DATA_WIDTH = 8
)(
    input wire [DATA_WIDTH - 1 : 0] A,
    input wire [DATA_WIDTH - 1 : 0] B,
    input wire Sel,
    output reg [DATA_WIDTH - 1 : 0] C
);
    always@(*) begin
        if(!Sel) C = A;
        else C = B;
    end 
endmodule

//Gate level
module Mux2_to_1_Gatelevel#(
    parameter DATA_WIDTH = 8
)(
    input wire [DATA_WIDTH - 1 : 0] A,
    input wire [DATA_WIDTH - 1 : 0] B,
    input wire Sel,
    output wire [DATA_WIDTH - 1 : 0] C
    );
    
    wire notSel;
    
    not(notSel,Sel);
    genvar i;
    generate
        for(i = 0; i < DATA_WIDTH; i = i + 1) begin
            wire y0, y1;
            and(y0,notSel,A[i]);
            and(y1,Sel,B[i]);
            or(C[i],y0,y1);
        end
    endgenerate
endmodule