`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2025 10:21:55 PM
// Design Name: 
// Module Name: SPI_top_tb
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


module SPI_top_tb();
    parameter DATA_WIDTH = 8; //Bit length 
    parameter SCLK_PW = 1; // sclk_o pulse width, meaning that sclk pulse width is equal to SLCK_PW * T of clk_i

    reg clk_i;
    reg reset_n;
    reg SPI_en_n;
    reg [DATA_WIDTH - 1 : 0] D_in;
    reg lmmi_ready;
    reg lmmi_rdata_valid;
    reg FIFO_ready;
    wire lmmi_request;
    wire lmmi_wr_rdn;
    wire [7:0] offset;
    wire SPI_ready;
    wire FIFO_wr_request;
    wire [DATA_WIDTH - 1 : 0] D_out;
    
    SPI_Controller_Top#(
        .DATA_WIDTH(DATA_WIDTH), //Bit length 
        .SCLK_PW(SCLK_PW) // sclk_o pulse width, meaning that sclk pulse width is equal to SLCK_PW * T of clk_i
    )DUT( 
        .clk_i(clk_i),
        .reset_n(reset_n),
        .SPI_en_n(SPI_en_n),
        .D_in(D_in),
        .lmmi_ready(lmmi_ready),
        .lmmi_rdata_valid(lmmi_rdata_valid),
        .FIFO_ready(FIFO_ready),
        .lmmi_request(lmmi_request),
        .lmmi_wr_rdn(lmmi_wr_rdn),
        .offset(offset),
        .SPI_ready(SPI_ready),
        .FIFO_wr_request(FIFO_wr_request),
        .D_out(D_out)
    );
    task self_check();
        if(
        
    endtask
    
    initial begin
        clk_i = 0;
        forever #5 begin
            clk_i <= ~clk_i;
            D_in <= $random($time * 102343);
        end
    end
    
    initial begin
        reset_n <= 1'b1;
        SPI_en_n <= 1'b1;
        D_in <= 0;
        lmmi_ready <= 1'b0;
        lmmi_rdata_valid <= 1'b0;
        FIFO_ready <= 1'b0;
        #10;
        reset_n <= 1'b0;
        #100;
        reset_n <= 1'b1;
        SPI_en_n <= 1'b0;
        #40;
        SPI_en_n <= 1'b1;
        lmmi_ready <= 1'b1;
        #40;
        lmmi_ready <= 1'b0;
        lmmi_rdata_valid <= 1'b1;
        #10;
        lmmi_rdata_valid <= 1'b0;
        #500;
        FIFO_ready <= 1;
        #20;
        FIFO_ready <= 0;
        #30;
        FIFO_ready <= 1;
        #10;
        FIFO_ready <= 0;
        #10;
        $stop;
    end
endmodule
