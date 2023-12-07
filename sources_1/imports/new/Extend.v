`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: Extend
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////


module Extend(
    input [31:0] Instr,
    input [2:0] InstrType,
    output reg [31:0] ExtImm
    );
    
    always @(*) begin
        case (InstrType)
            `RS:ExtImm = {27'b0, Instr[24:20]};
            `I: ExtImm = {{21{Instr[31]}}, Instr[30:20]};
            `S: ExtImm = {{21{Instr[31]}}, Instr[30:25], Instr[11:7]};
            `B: ExtImm = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
            `U: ExtImm = {Instr[31:12], 12'b0};
            `J: ExtImm = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
        endcase
    end
endmodule
