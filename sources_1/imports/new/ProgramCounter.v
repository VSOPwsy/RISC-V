`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: ProgramCounter
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////


module ProgramCounter(
    input CLK,
    input Reset,
    input PCSrc,
    input [31:0] Result,
    output reg [31:0] PC,
    output [31:0] PC_Plus_4,
    output [31:0] PC_Plus_8
    );
    
    reg [31:0] current_PC;
    reg [31:0] next_PC;
    
    initial begin
        current_PC = 32'b0;
        next_PC = 32'b0;
    end
    always @(*)
        next_PC = PCSrc ? Result : PC_Plus_4;
    
    always @(posedge CLK, posedge Reset) begin
        if (Reset) begin
            current_PC <= 32'b0;
        end
        else begin
            current_PC <= next_PC;
        end
    end
    
    always @(*)
        PC = current_PC;
    
    assign PC_Plus_4 = current_PC + 32'd4;
    assign PC_Plus_8 = PC_Plus_4 + 32'd4;
endmodule
