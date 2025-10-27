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
    //Testing Output
    wire [DATA_WIDTH - 1 : 0] PISO_Current_Data;
    wire [DATA_WIDTH - 1 : 0] SISO_Current_Data;
    wire [2:0] Controller_states;
    wire SS_n;
    wire sclk_o;
    wire MOSI;
    wire MISO;

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
        .D_out(D_out),
        .PISO_Current_Data(PISO_Current_Data),
        .SISO_Current_Data(SISO_Current_Data),
        .Controller_states(Controller_states),
        .SS_n(SS_n),
        .sclk_o(sclk_o),
        .MISO(MISO),
        .MOSI(MOSI)
    );

    task logdata();
        begin
            if (Controller_states == 3'b011) begin
                @(posedge sclk_o);
                $display("[%0t] Master latch the data that will be shifted to Slave later on | data in Master: %b | data in Slave: %b", $time, PISO_Current_Data, SISO_Current_Data);
                $display("[%0t] SS_n is set and sclk_o start working in this state| current SS_n: %b | current sclk_o: %b", $time, SS_n, sclk_o);
                $display("[%0t] MISO and MOSI not yet been drive | current MISO: %b | current MOSI: %b", $time, MISO, MOSI);
            end
            else if (Controller_states == 3'b100) begin
                @(negedge sclk_o);
                $display("[%0t] MOSI drive, the data in master is now shifting data into slave |SS_n: %b | sclk_o: %b | MOSI: %b | MISO: %b | Current data in Master: %b |current data in Slave: %b", 
                    $time, SS_n, sclk_o, MOSI, MISO, PISO_Current_Data, SISO_Current_Data);
                @(posedge sclk_o);
                $display("[%0t] Slave Sample data in MOSI, the data which was sent is sampling by Slave |SS_n: %b | sclk_o: %b | MOSI: %b | MISO: %b | Current data in Master: %b |current data in Slave: %b", 
                    $time, SS_n, sclk_o, MOSI, MISO, PISO_Current_Data, SISO_Current_Data);
            end
            else if (Controller_states == 3'b101) begin
                @(posedge sclk_o);
                $display("[%0t] MISO drive, the data in slave is now shifting back into master |SS_n: %b | sclk_o: %b | MOSI: %b | MISO: %b | Current data in Master: %b |current data in Slave: %b", 
                    $time, SS_n, sclk_o, MOSI, MISO, D_out, SISO_Current_Data);
                @(negedge sclk_o);
                $display("[%0t] Master Sample data in MISO, the data which was sent is sampling by Master |SS_n: %b | sclk_o: %b | MOSI: %b | MISO: %b | Current data in Master: %b |current data in Slave: %b", 
                    $time, SS_n, sclk_o, MOSI, MISO, PISO_Current_Data, SISO_Current_Data);
            end
            else begin
                @(posedge clk_i);
                $display("[%0t] Setups states or sampling to FIFO, do not have meaningful data yet", $time); 
            end
        end
    endtask
    
   
    initial begin
        clk_i = 0;
        forever #5 begin
            clk_i <= ~clk_i;
            D_in <= $random($time * 102343);
        end
    end
    
    initial begin
    fork
        begin
            $dumpfile("SPI_top_tb.vcd");
            $dumpvars(0, SPI_top_tb.DUT);
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
        begin 
            forever begin
                logdata();
            end
        end
    join
    end
endmodule
