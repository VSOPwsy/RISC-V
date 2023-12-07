`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: CondLogic
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////


module CondLogic(
    input CLK,
    input [1:0] FlagW,
    input NoWrite,
    input PCS,
    input RegW,
    input MemW,
    input [3:0] Cond,
    input [3:0] ALUFlags,
    output PCSrc,
    output RegWrite,
    output MemWrite
    );
    
    wire CondEx;
    reg N = 0, Z = 0, C = 0, V = 0;
    wire [1:0] FlagWrite;
    
    ConditionCheck CondCheck(
        .Cond(Cond),
        .Flags({N, Z, C, V}),
        .CondEx(CondEx)
        );
        
        
    assign PCSrc = PCS & CondEx;
    assign RegWrite = RegW & CondEx & ~NoWrite;
    assign MemWrite = MemW & CondEx;
    assign FlagWrite = FlagW & {2{CondEx}};

    always @(posedge CLK) begin
        if (FlagWrite[1]) begin
            {N, Z} <= ALUFlags[3:2];
        end
        if (FlagWrite[0]) begin
            {C, V} <= ALUFlags[1:0];
        end
    end
    
endmodule
