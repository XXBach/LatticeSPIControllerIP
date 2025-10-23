`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 11:02:14 AM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile#(
    parameter REGFILE_WIDTH = 8,
    parameter REGFILE_DEPTH = 16
)(
    input wire clk_i,
    input wire reset_n,
    input wire wr_rdn,
    input wire [$clog2(REGFILE_DEPTH) - 1 : 0] address,
    input wire [REGFILE_WIDTH - 1 : 0] WR_Data,
    output wire [REGFILE_WIDTH - 1 : 0] RD_Data,
    output wire ready
    );
   
    reg [REGFILE_WIDTH - 1 : 0] mem [0 : REGFILE_DEPTH - 1];
    
    reg [REGFILE_WIDTH - 1 : 0] temp_RD_Data;
    reg temp_ready;
    
    always@(posedge clk_i or negedge reset_n) begin
        if(!reset_n) begin
            temp_RD_Data <= 0;
            temp_ready <= 0;
        end
        else begin
            if(wr_rdn) begin
                mem[address] <= WR_Data;
                temp_ready <= 1;
            end
            else begin
                temp_RD_Data <= mem[address];
                temp_ready <= 1;    
            end
        end 
    end
    
    assign RD_Data = temp_RD_Data;
    assign ready = temp_ready;
endmodule
