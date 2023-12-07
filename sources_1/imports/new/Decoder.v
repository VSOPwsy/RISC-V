`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: Decoder
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////


module Decoder(
    input [31:0] Instr,
    output reg [1:0] FlagW,
    output reg NoWrite,
    output PCS,
    output reg RegW,
    output reg MemW, 
    output reg MemtoReg,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg [1:0] RegSrc,
    output reg [1:0] ALUControl
    );
    
    reg Branch;
    reg [1:0] ALUOp;
    
    wire [1:0] Op;
    wire [5:0] Funct;
    wire [3:0] Rd;
    assign Op = Instr[27:26];
    assign Funct = Instr[25:20];
    assign Rd = Instr[15:12];
    
    wire I_bar, P, U, B, W, L;
    assign {I_bar, P, U, B, W, L} = Funct;
    
    
    
    always @(*) begin
        casex (Op)
            2'b00: begin: _DP
                casex (Funct)
                    6'b0XXXXX: begin: _DP_reg
                        Branch = 1'b0;
                        MemtoReg = 1'b0;
                        MemW = 1'b0;
                        ALUSrc = 1'b0;
                        ImmSrc = 2'b00;
                        RegW = 1'b1;
                        RegSrc = 2'b00;
                        ALUOp = 2'b11;
                    end
                    
                    6'b1XXXXX: begin: _DP_imm
                        Branch = 1'b0;
                        MemtoReg = 1'b0;
                        MemW = 1'b0;
                        ALUSrc = 1'b1;
                        ImmSrc = 2'b00;
                        RegW = 1'b1;
                        RegSrc = 2'b00;
                        ALUOp = 2'b11;
                    end
                endcase
            end
            
            2'b01: begin: _Mem
                ImmSrc = 2'b01;
                Branch = 1'b0;
                ALUOp = 2'b01;
                        
                casex (Funct)
                    6'bXXXXX0: begin: _STR
                        ALUSrc = ~I_bar;
                        MemtoReg = 1'b0;
                        MemW = 1'b1;
                        RegW = 1'b0;
                        RegSrc = 2'b10;
                    end
                    
                    6'bXXXXX1: begin: _LDR
                        ALUSrc = ~I_bar;
                        MemtoReg = 1'b1;
                        MemW = 1'b0;
                        RegW = 1'b1;
                        RegSrc = 2'b00;
                    end
                endcase
            end
            
            2'b10: begin: _Branch
                casex (Funct)
                    6'bXXXXXX: begin: _B
                        Branch = 1'b1;
                        MemtoReg = 1'b0;
                        MemW = 1'b0;
                        ALUSrc = 1'b1;
                        ImmSrc = 2'b10;
                        RegW = 1'b0;
                        RegSrc = 2'b01;
                        ALUOp = 2'b00;
                    end
                endcase
            end
        endcase
    end
    
    
    
    always @(*) begin
        case (ALUOp)
            2'b11: begin
                casex (Funct[4:1])
                    4'b0100: begin
                        ALUControl = 2'b00;
                        FlagW = Funct[0] ? 2'b11 : 2'b00;
                        NoWrite = 1'b0;
                    end
                    
                    4'b0010: begin
                        ALUControl = 2'b01;
                        FlagW = Funct[0] ? 2'b11 : 2'b00;
                        NoWrite = 1'b0;
                    end
                    
                    4'b0000: begin
                        ALUControl = 2'b10;
                        FlagW = Funct[0] ? 2'b10 : 2'b00;
                        NoWrite = 1'b0;
                    end
                    
                    4'b1100: begin
                        ALUControl = 2'b11;
                        FlagW = Funct[0] ? 2'b10 : 2'b00;
                        NoWrite = 1'b0;
                    end
                    
                    4'b1010: begin
                        ALUControl = 2'b01;
                        FlagW = 2'b11;
                        NoWrite = 1'b1;
                    end
                    
                    4'b1011: begin
                        ALUControl = 2'b00;
                        FlagW = 2'b11;
                        NoWrite = 1'b1;
                    end
                endcase
            end
            
            2'b01: begin: _Mem_offset
                casex (Funct[4:1])
                    4'bX1XX: begin
                        ALUControl = 2'b00;
                        FlagW = 2'b00;
                        NoWrite = 1'b0;
                    end
                    
                    4'bX0XX: begin
                        ALUControl = 2'b01;
                        FlagW = 2'b00;
                        NoWrite = 1'b0;
                    end
                endcase
            end
            
            2'b00: begin: _Branch_
                ALUControl = 2'b00;
                FlagW = 2'b00;
                NoWrite = 1'b0;
            end
        endcase
    end
    
    assign PCS = ((Rd == 4'd15) & RegW) | Branch;
endmodule
