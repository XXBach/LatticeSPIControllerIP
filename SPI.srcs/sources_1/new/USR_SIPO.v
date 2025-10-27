`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 04:33:40 PM
// Design Name: 
// Module Name: USR_SIPO
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


module USR_SIPO#(
    parameter DATA_WIDTH = 8
)(
    input wire sclk,
    input wire reset_n,
    input wire [1:0] SIPO_mode,
    input wire D_in,
    output wire [DATA_WIDTH - 1 : 0] D_out  
    );
    genvar i;
    generate
        wire [DATA_WIDTH - 1 : 0] DFF_input;
        for(i = 0; i < DATA_WIDTH; i = i + 1) begin
            if(i == 0) begin
                Mux4_to_1_Gatelevel#(
                    .DATA_WIDTH(1)
                )input_Sel(
                    .A(1'b0),
                    .B(D_in),
                    .C(D_out[i+1]),
                    .D(D_out[i]),
                    .Sel(SIPO_mode),
                    .E(DFF_input[i])
                );
            end
            else if(i == DATA_WIDTH - 1) begin
                Mux4_to_1_Gatelevel#(
                    .DATA_WIDTH(1)
                )input_Sel(
                    .A(1'b0),
                    .B(D_out[i-1]),
                    .C(D_in),
                    .D(D_out[i]),
                    .Sel(SIPO_mode),
                    .E(DFF_input[i])
                );
            end
            else begin
                Mux4_to_1_Gatelevel#(
                    .DATA_WIDTH(1)
                )input_Sel(
                    .A(1'b0),
                    .B(D_out[i-1]),
                    .C(D_out[i+1]),
                    .D(D_out[i]),
                    .Sel(SIPO_mode),
                    .E(DFF_input[i])
                );
            end
            DFFs_Behavioral#(
                .MODE(0)
            )DFF_Reg(
                .clk(sclk),
                .reset(!reset_n),
                .P(DFF_input[i]),
                .Q(D_out[i])
            );               
        end
    endgenerate
endmodule
