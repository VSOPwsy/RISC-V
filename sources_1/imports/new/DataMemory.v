`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: DataMemory
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////


module DataMemory(
    input CLK,
    input WE,
    input [31:0] A,
    input [31:0] WD,
    output [31:0] RD
    );
    
    reg [31:0] DATA_MEM [0:127];
    integer i;
    
    initial begin
        for (i = 0; i < 128; i=i+1) begin
            DATA_MEM[i] = 32'b0;
        end
    end
    
    wire [31:0] RDW;
    assign RDW = DATA_MEM[{2'b00, A[31:2]}];
    assign RD = RDW[4*A[1:0]+3-:4];
    
    always @(posedge CLK) begin
        if (WE) begin
            DATA_MEM[{2'b00, A[31:2]}] <= WD;
        end
    end
endmodule
