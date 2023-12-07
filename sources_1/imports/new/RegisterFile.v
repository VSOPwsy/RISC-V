`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: RegisterFile
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////


module RegisterFile(
    input CLK,
    input WE3,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2
    );
    
    reg [31:0] RegBankCore[0:31];
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            RegBankCore[i] = 32'b0;
    end
    
    always @(posedge CLK) begin
        if (WE3 & (A3 != 5'd0)) begin
            RegBankCore[A3] <= WD3;
        end
    end
    
    assign RD1 = RegBankCore[A1];
    assign RD2 = RegBankCore[A2];
endmodule
