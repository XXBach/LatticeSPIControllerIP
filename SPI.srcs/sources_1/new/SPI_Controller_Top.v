`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 10:09:00 PM
// Design Name: 
// Module Name: SPI_Controller_Top
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


module SPI_Controller_Top#(
    parameter DATA_WIDTH = 8, //Bit length
//    parameter NUM_BITS = 4, 
    parameter SCLK_PW = 1 // sclk_o pulse width, meaning that sclk pulse width is equal to SLCK_PW * T of clk_i
)( 
    input wire clk_i,
    input wire reset_n,
    
    //Input control signal from Microcontroller
    input wire SPI_en_n,
    input wire [DATA_WIDTH - 1 : 0] D_in,
    
    //Input control signal from LMMI device
    input wire lmmi_ready,
    input wire lmmi_rdata_valid,
    
    //Input control signal from FIFO
    input wire FIFO_ready,
     
    //Output control signal for communication with LMMI
    output wire lmmi_request,
    output wire lmmi_wr_rdn,
    output wire [7:0] offset,
    output wire SPI_ready,
    
    //Output control signal for communication with FIFO output
    output wire FIFO_wr_request,
    output wire [DATA_WIDTH - 1 : 0] D_out,
    
    //Testing Output
    output wire [DATA_WIDTH - 1 : 0] PISO_Current_Data,
    output wire [DATA_WIDTH - 1 : 0] SISO_Current_Data,
    
    output wire [2:0] Controller_states
    );
    
    //Control signal for intra Controller
    wire SS_n;
    wire clk_gen_en;
    wire [1:0] SISO_mode;
    wire [1:0] PISO_mode;
    wire [1:0] SIPO_mode;
    wire MST_start;
    wire SLV_start;
    
    //Response signal from Master Peer and Slave Peer
    wire PISO_empty;
    wire SISO_empty;
    
    //additional signal for master peer and slave peer
    wire sclk_o;
    wire MOSI;
    wire MISO;
    
    // SPI Controller initial
    SPIController#(
        .DATA_WIDTH(DATA_WIDTH)
    )Controller(
        .clk_i(clk_i),
        .reset_n(reset_n),
        .SPI_en_n(SPI_en_n),
        .PISO_empty(PISO_empty),
        .SISO_empty(SISO_empty),
        .lmmi_ready(lmmi_ready),
        .lmmi_rdata_valid(lmmi_rdata_valid),
        .FIFO_ready(FIFO_ready),
        .SS_n(SS_n),
        .clk_gen_en(clk_gen_en),
        .SISO_mode(SISO_mode),
        .PISO_mode(PISO_mode),
        .SIPO_mode(SIPO_mode),
        .MST_start(MST_start),
        .SLV_start(SLV_start),
        .lmmi_request(lmmi_request),
        .lmmi_wr_rdn(lmmi_wr_rdn),
        .offset(offset),
        .SPI_ready(SPI_ready),  
        .FIFO_wr_request(FIFO_wr_request),
        .current_state(Controller_state)
    );
    
    // Clock Generator initial
    Clock_Generator#(
        .NUM_BITS($clog2(DATA_WIDTH)),
        .SCLK_PW(SCLK_PW)
    )CLK_GEN(
        .clk_i(clk_i),
        .reset_n(reset_n),
        .clk_gen_en(clk_gen_en),
        .sclk_o(sclk_o)
    );
    
    //Master Peer initial
    MasterPeer#(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_BITS($clog2(DATA_WIDTH))
    )MST_Peer(
        .sclk(!sclk_o),
        .reset_n(reset_n),
        .MST_start(MST_start),
        .SIPO_mode(SIPO_mode),
        .PISO_mode(PISO_mode),
        .D_in(D_in),
        .MISO(MISO),
        .MOSI(MOSI),
        .D_out(D_out),
        .PISO_empty(PISO_empty)  
    );
    
    // Slave peer initial
    SlavePeer#(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_BITS($clog2(DATA_WIDTH))
    )SLV_Peer(
        .sclk(sclk_o),
        .reset_n(reset_n),
        .SLV_start(SLV_start & !SS_n),
        .SISO_mode(SISO_mode),
        .MOSI(MOSI),
        .MISO(MISO),
        .SISO_empty(SISO_empty) 
    ); 
endmodule
