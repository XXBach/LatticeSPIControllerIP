`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2025 09:46:55 PM
// Design Name: 
// Module Name: DFFs
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
//module DFFs_Dataflow#(
//    parameter DATA_WIDTH = 8
//)(
//    input wire clk,
//    input wire reset,
//    input wire [DATA_WIDTH - 1 : 0] P,
//    output reg [DATA_WIDTH - 1 : 0] Q
//    );
    
//    assign Q = 
//endmodule

//Behavioral
module DFFs_Behavioral#(
    parameter MODE = 0
)(
    input wire clk,
    input wire reset,
    input wire P,
    output reg Q
//    output reg notQ
    );
    generate
        if(MODE == 0) begin
            always@(posedge clk or posedge reset) begin
                if(reset) begin
                    Q <= 0;
//                   notQ <= 1;
                end
                else begin
                    Q <= P;
//                    notQ <= ~P;
                end
            end
        end
        else if (MODE == 1) begin
            always@(posedge clk) begin
                if(reset) begin
                    Q <= 0;
//                   notQ <= 1;
                end
                else begin
                    Q <= P;
//                    notQ <= ~P;
                end
            end
        end
    endgenerate
endmodule

//GateLevel
module DFFs_GateLevel#(
    parameter MODE = 0
)(
    input wire clk,
    input wire reset,
    input wire P,
    output wire Q,
    output wire notQ
    );
    wire master_Q;
    wire unused;
    generate
        if(MODE == 0) begin
            D_latch
            master(
                .P(P),
                .Enable(~clk),
                .Q(master_Q),
                .notQ(unused)
            );
            D_latch
            slave(
                .P(master_Q & ~reset),
                .Enable(clk),
                .Q(Q),
                .notQ(notQ)
            );           
        end
        else if (MODE == 1) begin
            D_latch
            master(
                .P(P),
                .Enable(~clk & ~reset),
                .Q(master_Q),
                .notQ(unused)
            );
            D_latch
            slave(
                .P(master_Q),
                .Enable(clk & reset),
                .Q(Q),
                .notQ(notQ)
            );
        end
    endgenerate
endmodule

module D_latch(
    input wire P,
    input wire Enable,
    output wire Q,
    output wire notQ
);
    wire notP, y0, y1;
    
    not(notP,P);
    and(y0,notP,Enable);
    and(y1,P,Enable);
    nor(Q,notQ,y0);
    nor(notQ,Q,y1);

endmodule
