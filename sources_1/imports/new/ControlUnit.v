`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: ControlUnit
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////


module ControlUnit (
    input               CLK,
    input   [31:0]      Instr,
    input   [3:0]       ALUFlags,
    
    output              PCSrc,
    output              RegWrite,
    output              MemWrite,
    output              MemtoReg,
    output              ALUSrc,
    output  [1:0]       ImmSrc,
    output  [1:0]       RegSrc,
    output  [1:0]       ALUControl
    );
    
    wire    [3:0]   Cond;
    wire    [1:0]   FlagW;
    wire            PCS;
    wire            RegW;
    wire            MemW;
    
    assign Cond = Instr[31:28];
    
    CondLogic CondLogic(
        .ALUFlags   (ALUFlags   ),
        .CLK        (CLK        ),
        .Cond       (Cond       ),
        .FlagW      (FlagW      ),
        .NoWrite    (NoWrite    ),
        .MemW       (MemW       ),
        .MemWrite   (MemWrite   ),
        .PCS        (PCS        ),
        .PCSrc      (PCSrc      ),
        .RegW       (RegW       ),
        .RegWrite   (RegWrite   ));
    
    Decoder Decoder(
        .Instr      (Instr      ),
        .FlagW      (FlagW      ),
        .NoWrite    (NoWrite    ),
        .PCS        (PCS        ),
        .RegW       (RegW       ),
        .MemW       (MemW       ),
        .MemtoReg   (MemtoReg   ),
        .ALUSrc     (ALUSrc     ),
        .ImmSrc     (ImmSrc     ),
        .RegSrc     (RegSrc     ),
        .ALUControl (ALUControl ));
endmodule
