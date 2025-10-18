`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 08:46:48 PM
// Design Name: 
// Module Name: Synchronous_Counter
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

module Counter#(
        parameter NUM_BITS = 4
)(
        input wire sclk,
        input wire reset_n,
        input wire cnt_en,
        output wire [NUM_BITS - 1 : 0] Counting
        );
        reg [NUM_BITS - 1 : 0] temp_Counting;
        initial begin
            temp_Counting = 0;
        end
        always@(posedge sclk or negedge reset_n) begin
            if(!reset_n) temp_Counting <= 0;
            else begin
                if(cnt_en) temp_Counting <= temp_Counting + 1'b1;
                else temp_Counting <= temp_Counting;
            end
        end
        assign Counting = temp_Counting;
endmodule

////Gate Level
//module Synchronous_Counter_GateLevel#(
//        parameter NUM_BITS = 4
//)(
//        input wire clk,
//        input wire reset,
//        output wire [NUM_BITS - 1 : 0] Counting
//        );
//        wire [NUM_BITS-1:0] T_in;
//        genvar i;
//        generate
//            for(i = 1; i < NUM_BITS; i = i + 1) begin: gen_t_in
//                assign T_in[i] = T_in[i - 1] * Counting[i - 1];
//            end
//        endgenerate
//        generate
//            for(i = 0; i < NUM_BITS; i = i + 1) begin: gen_t
//                if(i == 0) begin
//                    TFFs_GateLevel TFFs(
//                        .clk(clk),
//                        .T(1),
//                        .Q(Counting[i])
//                    );
//                end
//                else begin
//                    TFFs_GateLevel TFFs(
//                        .clk(clk),
//                        .T(T_in[i]),
//                        .Q(Counting[i])
//                    );
//                end
//            end
//        endgenerate
//endmodule