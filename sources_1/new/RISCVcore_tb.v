`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 04:27:07
// Design Name: 
// Module Name: RISCVcore_tb
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


module RISCVcore_tb;
reg CLK;
reg Reset;

RISCVcore uut(
    .CLK(CLK),
    .Reset(Reset)
);

initial begin
    CLK = 0;
    forever #5 CLK = ~CLK;
end

initial begin
    Reset = 0;
    #20;
    Reset = 1;
    #10;
    Reset = 0;
    
    #50;
    $finish;
end
endmodule
