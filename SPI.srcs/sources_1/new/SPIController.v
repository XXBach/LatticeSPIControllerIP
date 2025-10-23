`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 08:17:09 AM
// Design Name: 
// Module Name: SPIController
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


module SPIController#(
    parameter DATA_WIDTH = 8
)(
    input wire clk_i,
    input wire reset_n,
    
    //Input control signal from Microcontroller
    input wire SPI_en_n,
    input wire PISO_empty,
    input wire SISO_empty,
    
    //Input control signal from LMMI device
    input wire lmmi_ready,
    input wire lmmi_rdata_valid,
    
    //Input control signal from FIFO
    input wire FIFO_ready,
    
    //Output control signal for intra Controller
    output wire SS_n,
    output wire clk_gen_en,
    output wire [1:0] SISO_mode,
    output wire [1:0] PISO_mode,
    output wire [1:0] SIPO_mode,
    output wire MST_start,
    output wire SLV_start,
    
    //Output control signal for communication with LMMI
    output wire lmmi_request,
    output wire lmmi_wr_rdn,
    output wire [7:0] offset,
    output wire SPI_ready,
    
    //Output control signal for communication with FIFO output
    output wire FIFO_wr_request,
    
    //Tesing output
    output reg [2:0] current_state
    );
    //local parameter for states
    localparam IDLE = 3'b000;
    localparam LMMI_READ_REQUEST = 3'b001;
    localparam WAIT_RDATA = 3'b010;
    localparam LATCH_RDATA = 3'b011;
    localparam MOSI_DRIVE = 3'b100;
    localparam MISO_DRIVE = 3'b101;
    localparam FIFO_WRITE_REQUEST = 3'b110;
    localparam FIFO_WRITE = 3'b111;
    
    //local reg / wires declaration
    //Local regs for intra Controller
    reg temp_SS_n;
    reg temp_clk_gen_en;
    reg [1:0] temp_SISO_mode;
    reg [1:0] temp_PISO_mode;
    reg [1:0] temp_SIPO_mode;
    reg temp_MST_start;
    reg temp_SLV_start;
    
    //Local regs for communication with LMMI
    reg temp_lmmi_request;
    reg temp_lmmi_wr_rdn;
    reg [7:0] temp_offset;
    reg temp_SPI_ready;
    
    //Local regs for communication with FIFO
    reg temp_FIFO_wr_request;
    
    //Local regs for SPIController States
    reg [2:0] current_state;
    reg [2:0] next_state;
    
    // Additional 
    
    // Current state assignment
    always@(posedge clk_i or negedge reset_n) begin
        if(!reset_n) current_state <= IDLE;
        else current_state <= next_state;
    end
    
    // Next state transition, the transition will be executed in the following order with no backward: S0 -> S1 -> S2 -> S3 -> S4 -> S5 -> S6 -> S7 -> S0/S1
    always@(*) begin
        case(current_state) 
            //IDLE state
            IDLE: begin
                if(!SPI_en_n) next_state = LMMI_READ_REQUEST;
                else next_state = IDLE;
            end
            //LMMI Read request data input from LMMI state
            LMMI_READ_REQUEST: begin
                if(lmmi_ready) next_state = WAIT_RDATA;
                else next_state = LMMI_READ_REQUEST;
            end
            //LMMI Data wait
            WAIT_RDATA: begin
                if(lmmi_rdata_valid) next_state = LATCH_RDATA;
                else next_state = WAIT_RDATA; 
            end
            //LMMI Data latch
            LATCH_RDATA: begin
                next_state = MOSI_DRIVE;
            end
            //MOSI Drive
            MOSI_DRIVE: begin
                if(PISO_empty) next_state = MISO_DRIVE;
                else next_state = MOSI_DRIVE;
            end
            //MISO_Drive
            MISO_DRIVE: begin
                if(SISO_empty) next_state = FIFO_WRITE_REQUEST;
                else next_state = MISO_DRIVE;
            end
            //Drive output to FIFO ( Which act like a buffer before being read out by other peers )
            FIFO_WRITE_REQUEST: begin
                if(FIFO_ready) next_state = FIFO_WRITE;
                else next_state = FIFO_WRITE_REQUEST;
            end
            // Done write output to FIFO, comeback to S0 or S1
            FIFO_WRITE: begin
                if(FIFO_ready) begin
                    if(SPI_en_n) next_state = IDLE;
                    else next_state = LMMI_READ_REQUEST; 
                end
                else next_state = FIFO_WRITE;
            end
            default: next_state = IDLE;
        endcase
    end
    
    // Decode States to Output
    always@(*) begin
        case(current_state)
            IDLE: begin
                temp_SS_n = 1'b1;
                temp_clk_gen_en = 1'b0;
                temp_SISO_mode = 2'b00;
                temp_PISO_mode = 2'b00;
                temp_SIPO_mode = 2'b00;
                temp_MST_start = 1'b0;
                temp_SLV_start = 1'b0;
                temp_lmmi_request = 1'b0;
                temp_lmmi_wr_rdn = 1'b0;
                temp_offset = 8'h00;
                temp_SPI_ready = 1'b0;
                temp_FIFO_wr_request = 1'b0;
            end
            LMMI_READ_REQUEST: begin
                temp_SS_n = 1'b1;
                temp_clk_gen_en = 1'b0;
                temp_SISO_mode = 2'b00;
                temp_PISO_mode = 2'b00;
                temp_SIPO_mode = 2'b00;
                temp_MST_start = 1'b0;
                temp_SLV_start = 1'b0;
                temp_lmmi_request = 1'b1;
                temp_lmmi_wr_rdn = 1'b0;
                temp_offset = 8'hA0;
                temp_SPI_ready = 1'b1;
                temp_FIFO_wr_request = 1'b0;
            end
            WAIT_RDATA: begin
                temp_SS_n = 1'b1;
                temp_clk_gen_en = 1'b1;
                temp_SISO_mode = 2'b00;
                temp_PISO_mode = 2'b00;
                temp_SIPO_mode = 2'b00;
                temp_MST_start = 1'b0;
                temp_SLV_start = 1'b0;                
                temp_lmmi_request = 1'b0;
                temp_lmmi_wr_rdn = 1'b0;
                temp_offset = 8'hA0;
                temp_SPI_ready = 1'b0;
                temp_FIFO_wr_request = 1'b0;
            end
            LATCH_RDATA: begin
                temp_SS_n = 1'b0;
                temp_clk_gen_en = 1'b1;
                temp_SISO_mode = 2'b01;
                temp_PISO_mode = 2'b01;
                temp_SIPO_mode = 2'b00;
                temp_MST_start = 1'b0;
                temp_SLV_start = 1'b0;                
                temp_lmmi_request = 1'b0;
                temp_lmmi_wr_rdn = 1'b0;
                temp_offset = 8'h00;
                temp_SPI_ready = 1'b1;
                temp_FIFO_wr_request = 1'b0;
            end
            MOSI_DRIVE: begin
                temp_SS_n = 1'b0;
                temp_clk_gen_en = 1'b1;
                temp_SISO_mode = 2'b01;
                temp_PISO_mode = 2'b01;
                temp_SIPO_mode = 2'b00;
                temp_MST_start = 1'b1;
                temp_SLV_start = 1'b0;                
                temp_lmmi_request = 1'b0;
                temp_lmmi_wr_rdn = 1'b0;
                temp_offset = 8'h00;
                temp_SPI_ready = 1'b0;
                temp_FIFO_wr_request = 1'b0;
            end
            MISO_DRIVE: begin
                temp_SS_n = 1'b0;
                temp_clk_gen_en = 1'b1;
                temp_SISO_mode = 2'b10;
                temp_PISO_mode = 2'b00;
                temp_SIPO_mode = 2'b10;
                temp_MST_start = 1'b0;
                temp_SLV_start = 1'b1;                
                temp_lmmi_request = 1'b0;
                temp_lmmi_wr_rdn = 1'b0;
                temp_offset = 8'h00;
                temp_SPI_ready = 1'b0;
                temp_FIFO_wr_request = 1'b0;
            end
            FIFO_WRITE_REQUEST: begin
                temp_SS_n = 1'b1;
                temp_clk_gen_en = 1'b0;
                temp_SISO_mode = 2'b00;
                temp_PISO_mode = 2'b00;
                temp_SIPO_mode = 2'b00;
                temp_MST_start = 1'b0;
                temp_SLV_start = 1'b0;                
                temp_lmmi_request = 1'b0;
                temp_lmmi_wr_rdn = 1'b0;
                temp_offset = 8'h00;
                temp_SPI_ready = 1'b0;
                temp_FIFO_wr_request = 1'b1;
            end
            default: begin
                temp_SS_n = 1'b1;
                temp_clk_gen_en = 1'b0;
                temp_SISO_mode = 2'b00;
                temp_PISO_mode = 2'b00;
                temp_SIPO_mode = 2'b00;
                temp_MST_start = 1'b0;
                temp_SLV_start = 1'b0;                
                temp_lmmi_request = 1'b0;
                temp_lmmi_wr_rdn = 1'b0;
                temp_offset = 8'h00;
                temp_SPI_ready = 1'b0;
                temp_FIFO_wr_request = 1'b0;
            end            
        endcase
    end
    
    //Output signal assignment
    assign SS_n = temp_SS_n;
    assign clk_gen_en = temp_clk_gen_en;
    assign PISO_mode = temp_PISO_mode;
    assign SIPO_mode = temp_SIPO_mode;
    assign lmmi_request = temp_lmmi_request;
    assign lmmi_wr_rdn = temp_lmmi_wr_rdn;
    assign offset = temp_offset;
    assign SPI_ready = temp_SPI_ready;
    assign FIFO_wr_request = temp_FIFO_wr_request;
    assign MST_start = temp_MST_start;
    assign SLV_start = temp_SLV_start;
    assign SISO_mode = temp_SISO_mode;
endmodule
