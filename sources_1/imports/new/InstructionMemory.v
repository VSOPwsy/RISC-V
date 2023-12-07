`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: InstructionMemory
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionMemory(
    input [31:0] PC,
    output [31:0] Instr
    );
    
    reg [31:0] INSTR_MEM [0:127];
    integer i;
    
    initial begin
        INSTR_MEM[0] = 32'b11111111111111111111_00001_0110111;
        for(i = 1; i < 128; i=i+1) begin
            INSTR_MEM[i] = 32'b0;
        end
    end
    
    assign Instr = INSTR_MEM[{2'b00, PC[31:2]}];
    
endmodule
