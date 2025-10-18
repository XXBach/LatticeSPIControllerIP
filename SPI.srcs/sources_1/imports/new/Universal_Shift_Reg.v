`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 03:06:30 PM
// Design Name: 
// Module Name: Universal_Shift_Reg
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

//Behavioral
module Universal_Shift_Reg_Behavioral#(
    parameter DATA_WIDTH = 4
)(
    input wire clk,
    input wire sclk,
    input wire reset,
    input wire [1:0] shift_mode,
    input wire [DATA_WIDTH - 1 : 0] D_in,
    output reg [DATA_WIDTH - 1 : 0] D_out  
    );
    reg [DATA_WIDTH - 1 : 0] Shifted_Din;
    reg x;
    initial begin
        Shifted_Din = D_in;
        x = 0;
    end
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            Shifted_Din <= 0;
            x <= 0;
        end
        else begin
            case(shift_mode)
                2'b00: begin
                    Shifted_Din <= Shifted_Din;
                    x <= 0;
                end
                2'b01: begin
                    if(!x) begin
                        Shifted_Din <= D_in;
                        x <= 1;
                    end
                    else begin
                        Shifted_Din <= Shifted_Din >> 1;
                        x <= 1;
                    end
                end
                2'b10: begin
                    if(!x) begin
                        Shifted_Din <= D_in;
                        x <= 1;
                    end
                    else begin
                        Shifted_Din <= Shifted_Din << 1;
                        x <= 1;
                    end
                end
                2'b11: begin
                    Shifted_Din = D_in;
                    x <= 0;
                end
                default: Shifted_Din = D_in;
            endcase 
        end
    end
    always@(negedge sclk or posedge reset) begin 
        if(reset) D_out <= 0;
        else D_out <= Shifted_Din;
    end
endmodule

//Gate Level
module Universal_Shift_Reg_GateLevel#(
    parameter DATA_WIDTH = 4
)(
    input wire clk,
    input wire reset,
    input wire [1:0] shift_mode,
    input wire [DATA_WIDTH - 1 : 0] D_in,
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
                    .A(D_out[i]),
                    .B(0),
                    .C(D_out[i+1]),
                    .D(D_in[i]),
                    .Sel(shift_mode),
                    .E(DFF_input[i])
                );
            end
            else if(i == 3) begin
                Mux4_to_1_Gatelevel#(
                    .DATA_WIDTH(1)
                )input_Sel(
                    .A(D_out[i]),
                    .B(D_out[i-1]),
                    .C(0),
                    .D(D_in[i]),
                    .Sel(shift_mode),
                    .E(DFF_input[i])
                );
            end
            else begin
                Mux4_to_1_Gatelevel#(
                    .DATA_WIDTH(1)
                )input_Sel(
                    .A(D_out[i]),
                    .B(D_out[i-1]),
                    .C(D_out[i+1]),
                    .D(D_in[i]),
                    .Sel(shift_mode),
                    .E(DFF_input[i])
                );
            end
            DFFs_GateLevel#(
                .MODE(0)
            )DFF_Reg(
                .clk(clk),
                .reset(reset),
                .P(DFF_input[i]),
                .Q(D_out[i])
            );               
        end
    endgenerate
endmodule