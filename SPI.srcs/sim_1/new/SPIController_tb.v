`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 04:00:09 PM
// Design Name: 
// Module Name: SPIController_tb
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


module SPIController_tb();
    parameter DATA_WIDTH = 8;
    
    reg clk_i;
    reg reset_n;
    
    //Input control signal from Microcontroller
    reg SPI_en_n;
    reg PISO_empty;
    reg SIPO_empty;
    
    //Input control signal from LMMI device
    reg lmmi_ready;
    reg lmmi_rdata_valid;
    
    //Input control signal from FIFO
    reg FIFO_ready;
    
    //Output control signal for intra Controller
    wire SS_n;
    wire clk_gen_en;
    wire [1:0] PISO_mode;
    wire [1:0] SIPO_mode;
    
    //Output control signal for communication with LMMI
    wire lmmi_request;
    wire lmmi_wr_rdn;
    wire [7:0] offset;
    wire SPI_ready;
    
    //Output control signal for communication with FIFO output
    wire FIFO_wr_request;
    
    SPIController#(
        .DATA_WIDTH(DATA_WIDTH)
    )DUT(
        .clk_i(clk_i),
        .reset_n(reset_n),
        .SPI_en_n(SPI_en_n),
        .PISO_empty(PISO_empty),
        .SIPO_empty(SIPO_empty),
        .lmmi_ready(lmmi_ready),
        .lmmi_rdata_valid(lmmi_rdata_valid),
        .FIFO_ready(FIFO_ready),
        .SS_n(SS_n),
        .clk_gen_en(clk_gen_en),
        .PISO_mode(PISO_mode),
        .SIPO_mode(SIPO_mode),
        .lmmi_request(lmmi_request),
        .lmmi_wr_rdn(lmmi_wr_rdn),
        .offset(offset),
        .SPI_ready(SPI_ready),
        .FIFO_wr_request(FIFO_wr_request)
    );
    
    initial begin
        forever #5 clk_i = ~clk_i;
    end
    
    initial begin
        clk_i <= 1'b0;
        reset_n <= 1'b1;
        SPI_en_n <= 1'b1;
        PISO_empty <= 1'b0;
        SIPO_empty <= 1'b0;
        lmmi_ready <= 1'b0;
        lmmi_rdata_valid <= 1'b0;   
        FIFO_ready <= 1'b0;
        #18;
        reset_n <= 1'b0;
        #50;
        reset_n <= 1'b1;
        SPI_en_n <= 1'b0;
        #38;
        SPI_en_n <= 1'b1;
        lmmi_ready <= 1'b1;
        #35;
        lmmi_ready <= 1'b0;
        lmmi_rdata_valid <= 1'b1;
        #17;
        lmmi_rdata_valid <= 1'b0;
        #100;
        PISO_empty <= 1;
        #100;
        PISO_empty <= 0;
        SIPO_empty <= 1;
        #28;
        SIPO_empty <= 0;
        FIFO_ready <= 1;
        #17;
        FIFO_ready <= 0;
        #34;
        FIFO_ready <= 1;
        #10;
        FIFO_ready <= 0;
        #10;
        $stop;
    end
endmodule
