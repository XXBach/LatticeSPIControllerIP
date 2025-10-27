`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2025 09:37:33 PM
// Design Name: 
// Module Name: USR_SISO
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


module USR_SISO#(
    parameter DATA_WIDTH = 8
)(
    input wire sclk,
    input wire reset_n,
    input wire [1:0] SISO_mode,
    input wire D_in,
    output wire D_out,
    output wire [DATA_WIDTH - 1 : 0] temp_D_out 
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
                    .C(temp_D_out[i+1]),
                    .D(temp_D_out[i]),
                    .Sel(SISO_mode),
                    .E(DFF_input[i])
                );
            end 
            else if(i == DATA_WIDTH - 1) begin
                Mux4_to_1_Gatelevel#(
                    .DATA_WIDTH(1)
                )input_Sel(
                    .A(1'b0),
                    .B(temp_D_out[i-1]),
                    .C(D_in),
                    .D(temp_D_out[i]),
                    .Sel(SISO_mode),
                    .E(DFF_input[i])
                );
            end
            else begin
                Mux4_to_1_Gatelevel#(
                    .DATA_WIDTH(1)
                )input_Sel(
                    .A(1'b0),
                    .B(temp_D_out[i-1]),
                    .C(temp_D_out[i+1]),
                    .D(temp_D_out[i]),
                    .Sel(SISO_mode),
                    .E(DFF_input[i])
                );
            end
            DFFs_Behavioral#(
                .MODE(0)
            )DFF_Reg(
                .clk(sclk),
                .reset(!reset_n),
                .P(DFF_input[i]),
                .Q(temp_D_out[i])
            );               
        end
    endgenerate
    assign D_out = (SISO_mode == 2'b00) ? 1'b0 : (SISO_mode == 2'b01) ? temp_D_out[DATA_WIDTH - 1] : (SISO_mode == 2'b10) ? temp_D_out[0] : D_out;
endmodule
