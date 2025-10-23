`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 09:49:55 AM
// Design Name: 
// Module Name: APB_Bridge
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


module APB_Bridge#(
    parameter DATA_WIDTH = 8
)(
    input wire PCLK,
    input wire PRESETn,
    input wire PREADY,
    inout wire PSEL,
    inout wire PWRITE,
    inout wire [DATA_WIDTH - 1 : 0] PRDATA,
    inout wire [DATA_WIDTH - 1 : 0] PWDATA,
    output wire PENABLE 
    );
    
    //local parameter for states
    localparam IDLE = 2'b00;
    localparam SETUP = 2'b01;
    localparam READ = 2'b10;
    localparam WRITE = 2'b11;
    
    //Local regs for PENABLE and PWDATA
    reg [DATA_WIDTH - 1 : 0] temp_PWDATA_o;
    reg temp_PENABLE;
    
    //additional
    reg [1:0] current_state;
    reg [1:0] next_state;
    
    // Current state assignment
    always@(posedge PCLK or negedge PRESETn) begin
        if(!PRESETn) current_state <= IDLE;
        else current_state <= next_state;
    end
    
    // Next state transition, the transition will be executed in the following order with no backward: S0 -> S1 -> S2 -> S3 -> S4 -> S5 -> S6 -> S7 -> S0/S1
    always@(*) begin
        case(current_state) 
            //IDLE state
            IDLE: begin
                if(PSEL) next_state = SETUP;
                else next_state = IDLE;
            end
            //LMMI Read request data input from LMMI state
            SETUP: begin
                if(PREADY && PWRITE) next_state = WRITE;
                else if (PREADY && !PWRITE) next_state = READ;
                else next_state = SETUP;
            end
            //LMMI Data wait
            READ: begin
                if(PREADY && PSEL) next_state = SETUP;
                else if (PREADY && !PSEL) next_state = IDLE;
                else next_state = READ; 
            end
            //LMMI Data latch
            WRITE: begin
                if(PREADY && PSEL) next_state = SETUP;
                else if (PREADY && !PSEL) next_state = IDLE;
                else next_state = WRITE; 
            end
            default: next_state = IDLE;
        endcase
    end
    
    // Decode States to Output
    always@(*) begin
        case(current_state)
            IDLE: begin
                temp_PWDATA_o = 8'h00;
                temp_PENABLE = 1'b0;
            end
            SETUP: begin
                temp_PWDATA_o = 8'h00;
                temp_PENABLE = 1'b0;
            end
            READ: begin
                temp_PWDATA_o = PRDATA;
                temp_PENABLE = 1'b1;
            end
            WRITE: begin
                temp_PWDATA_o = PWDATA_i;
                temp_PENABLE = 1'b1;
            end          
        endcase
    end
    
    //Output signal assignment
    assign PWDATA_o = temp_PWDATA_o;
    assign PENABLE = temp_PENABLE;
  
endmodule
