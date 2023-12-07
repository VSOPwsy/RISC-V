`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: ALU
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [1:0] ALUControl,
    output reg [31:0] ALUResult,
    output [3:0] ALUFlags
    );
    
    wire N, Z, C, V;
    assign ALUFlags = {N, Z, C, V};
    wire [31:0] a;
    wire [31:0] b;
    wire cout;
    
    wire [31:0] ResultADDER, ResultAND, ResultORR;
    
    adder adder(
        .c0(ALUControl[0]),
        .a(a),
        .b(b),
        .s(ResultADDER),
        .cout(cout)
    );
    
    assign a = SrcA;
    assign b = ALUControl[0] ? ~SrcB : SrcB;
    
    assign ResultAND = SrcA & SrcB;
    assign ResultORR = SrcA | SrcB;
    
    always @(*) begin
        casex (ALUControl)
            2'b0X: ALUResult = ResultADDER;
            2'b10: ALUResult = ResultAND;
            2'b11: ALUResult = ResultORR;
        endcase
    end
    
    wire ALUControl_1_n;
    assign ALUControl_1_n = ~ALUControl[1];
    
    assign N = ALUResult[31];
    assign Z = ~|ALUResult;
    assign C = ALUControl_1_n & cout;
    assign V = ALUControl_1_n & (SrcA[31] ^ ResultADDER[31]) & ~(ALUControl[0] ^ SrcA[31] ^ SrcB[31]);
endmodule
