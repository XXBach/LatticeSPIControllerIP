`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2025 03:17:01 PM
// Design Name: 
// Module Name: Mux4_to_1
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
//module Mux4_to_1_Dataflow#(
//    parameter DATA_WIDTH = 8
//)(
//    input wire [DATA_WIDTH - 1 : 0] A,
//    input wire [DATA_WIDTH - 1 : 0] B,
//    input wire [DATA_WIDTH - 1 : 0] C,
//    input wire [DATA_WIDTH - 1 : 0] D,
//    input wire [1:0] Sel,
//    output wire [DATA_WIDTH - 1 : 0] E
//    );
//    assign E = (Sel == 2'b11) ? D : 
//               (Sel == 2'b10) ? C :
//               (Sel == 2'b01) ? B : A;
//endmodule

//Behavioral

module Mux4_to_1_Behavioral#(
    parameter DATA_WIDTH = 8
)(
    input wire [DATA_WIDTH - 1 : 0] A,
    input wire [DATA_WIDTH - 1 : 0] B,
    input wire [DATA_WIDTH - 1 : 0] C,
    input wire [DATA_WIDTH - 1 : 0] D,
    input wire [1:0] Sel,
    output reg [DATA_WIDTH - 1 : 0] E
    );
    always@(*) begin
        if(Sel == 2'b00) E = A;
        else if(Sel == 2'b01) E = B;
        else if(Sel == 2'b10) E = C;
        else E = D;
    end
endmodule

//Gate level
module Mux4_to_1_Gatelevel#(
    parameter DATA_WIDTH = 1
)(
    input wire [DATA_WIDTH - 1 : 0] A,
    input wire [DATA_WIDTH - 1 : 0] B,
    input wire [DATA_WIDTH - 1 : 0] C,
    input wire [DATA_WIDTH - 1 : 0] D,
    input wire [1:0] Sel,
    output wire [DATA_WIDTH - 1 : 0] E
    );
    wire [DATA_WIDTH - 1 : 0] mux0_temp, mux1_temp;
    
    Mux2_to_1_Gatelevel#(
        .DATA_WIDTH(DATA_WIDTH)
    )mux0(
        .A(A),
        .B(B),
        .Sel(Sel[0]),
        .C(mux0_temp)
    );
    Mux2_to_1_Gatelevel#(
        .DATA_WIDTH(DATA_WIDTH)
    )mux1(
        .A(C),
        .B(D),
        .Sel(Sel[0]),
        .C(mux1_temp)
    );
    Mux2_to_1_Gatelevel#(
        .DATA_WIDTH(DATA_WIDTH)
    )mux2(
        .A(mux0_temp),
        .B(mux1_temp),
        .Sel(Sel[1]),
        .C(E)
    );
endmodule
