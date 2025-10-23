`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 08:33:37 PM
// Design Name: 
// Module Name: Clock_Generator
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


module Clock_Generator#(
        parameter NUM_BITS = 4, //parameter that defines Counter number of bits
        parameter SCLK_PW = 1 
)(
        input wire clk_i,
        input wire reset_n,
        input wire clk_gen_en,
        output wire sclk_o
        );
        reg [NUM_BITS - 1 : 0] temp_Counting;
        reg temp_sclk_o;
        initial begin
            temp_Counting = 0;
            temp_sclk_o = 0;
        end
        
        // The base idea is that temp_Counting will start to count up from zero whenever clk_gen_en is HIGH,
        // if its value equal to SCLK_PW - 1 then the sclk_o will be toggled 
        always@(posedge clk_i or negedge reset_n) begin
            if(!reset_n) begin 
                temp_Counting <= 0;
                temp_sclk_o <= 0;
            end
            else begin
                if(clk_gen_en) begin
                    if(temp_Counting == SCLK_PW - 1) begin
                        temp_sclk_o <= ~temp_sclk_o;
                        temp_Counting <= 0;
                    end
                    else begin
                        temp_Counting <= temp_Counting + 1'b1;
                        temp_sclk_o <= temp_sclk_o;
                    end
                end
                else begin
                    temp_Counting <= 0;
                    temp_sclk_o <= 0;
                end
            end
        end
        assign sclk_o = temp_sclk_o; 
endmodule

