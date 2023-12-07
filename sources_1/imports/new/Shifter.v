`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: Shifter
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////


module shifter(
    input       [1:0]   Sh,
    input       [4:0]   Shamt,
    input       [31:0]  ShIn,
    output reg  [31:0]  ShOut
    );
    
    wire [31:0] ShOutLSL;
    wire [31:0] ShOutLSR;
    wire [31:0] ShOutASR;
    wire [31:0] ShOutROR;
    
    LSL LSL(
        .ShIn       (ShIn       ),
        .Shamt      (Shamt      ),
        .ShOutLSL   (ShOutLSL   ));
        
    LSR LSR(
        .ShIn       (ShIn       ),
        .Shamt      (Shamt      ),
        .ShOutLSR   (ShOutLSR   ));
                
    ASR ASR(
        .ShIn       (ShIn       ),
        .Shamt      (Shamt      ),
        .ShOutASR   (ShOutASR   ));
        
    always @(*) begin
        case (Sh)
            `LSL: ShOut = ShOutLSL;
            `LSR: ShOut = ShOutLSR;
            `ASR: ShOut = ShOutASR;
        endcase
    end
endmodule
