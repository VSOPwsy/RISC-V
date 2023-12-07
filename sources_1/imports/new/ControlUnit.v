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


`include "global.v"

module ControlUnit (
    input CLK,
    input [31:0] Instr,
    input [2:0] ALUCompareResult,
    output reg [2:0] InstrType,
    output reg [5:0] ALUControl,
    output reg Jump,
    output reg Branch,
    output reg MemtoReg,
    output reg MemWrite,
    output reg RegWrite
    );

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire EQ, SL, UL;
    assign opcode = Instr[6:0];
    assign funct3 = Instr[14:12];
    assign funct7 = Instr[31:25];
    assign {EQ, SL, UL} = ALUCompareResult;


    always @(*) begin
        case (ALUControl)
            `BEQ: Branch = EQ;
            `BNE: Branch = ~EQ;
            `BLT: Branch = SL;
            `BGE: Branch = ~SL & ~EQ;
            `BLTU: Branch = UL;
            `BGEU: Branch = ~UL & ~EQ;
            default: Branch = 1'b0;
        endcase
    end

    always @(*) begin
        case (opcode)
            7'b0110111: begin: _LUI
                InstrType = `U;
                ALUControl = `LUI;
                Jump = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end

            7'b0010111: begin: _AUIPC
                InstrType = `U;
                ALUControl = `AUIPC;
                Jump = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end

            7'b1101111: begin: _JAL
                InstrType = `J;
                ALUControl = `JAL;
                Jump = 1;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end

            7'b1100111: begin
                case (funct3)
                    3'b000: begin: _JALR
                        InstrType = `I;
                        ALUControl = `JALR;
                        Jump = 1;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 1;
                    end
                endcase
            end

            7'b1100011: begin
                case (funct3)
                    3'b000: begin: _BEQ
                        InstrType = `B;
                        ALUControl = `BEQ;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 0;
                    end

                    3'b001: begin: _BNE
                        InstrType = `B;
                        ALUControl = `BNE;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 0;
                    end

                    3'b100: begin: _BLT
                        InstrType = `B;
                        ALUControl = `BLT;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 0;
                    end

                    3'b101: begin: _BGE
                        InstrType = `B;
                        ALUControl = `BGE;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 0;
                    end

                    3'b110: begin: _BLTU
                        InstrType = `B;
                        ALUControl = `BLTU;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 0;
                    end

                    3'b111: begin: _BGEU
                        InstrType = `B;
                        ALUControl = `BGEU;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 0;
                    end
                endcase
            end

            7'b0000011: begin
                case (funct3)
                    3'b000: begin: _LB
                        InstrType = `I;
                        ALUControl = `LB;
                        Jump = 0;
                        MemtoReg = 1;
                        MemWrite = 0;
                        RegWrite = 1;
                    end
                    
                    3'b001: begin: _LH
                        InstrType = `I;
                        ALUControl = `LH;
                        Jump = 0;
                        MemtoReg = 1;
                        MemWrite = 0;
                        RegWrite = 1;
                    end
                    
                    3'b010: begin: _LW
                        InstrType = `I;
                        ALUControl = `LW;
                        Jump = 0;
                        MemtoReg = 1;
                        MemWrite = 0;
                        RegWrite = 1;
                    end
                    
                    3'b100: begin: _LBU
                        InstrType = `I;
                        ALUControl = `LBU;
                        Jump = 0;
                        MemtoReg = 1;
                        MemWrite = 0;
                        RegWrite = 1;
                    end
                    
                    3'b101: begin: _LHU
                        InstrType = `I;
                        ALUControl = `LHU;
                        Jump = 0;
                        MemtoReg = 1;
                        MemWrite = 0;
                        RegWrite = 1;
                    end
                endcase
            end

            7'b0100011: begin
                case (funct3)
                    3'b000: begin: _SB
                        InstrType = `S;
                        ALUControl = `SB;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 1;
                        RegWrite = 0;
                    end

                    3'b001: begin: _SH
                        InstrType = `S;
                        ALUControl = `SH;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 1;
                        RegWrite = 0;
                    end

                    3'b010: begin: _SW
                        InstrType = `S;
                        ALUControl = `SW;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 1;
                        RegWrite = 0;
                    end
                endcase
            end

            7'b0010011: begin
                case (funct3)
                    3'b000: begin: _ADDI
                        InstrType = `I;
                        ALUControl = `ADDI;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 1;
                    end

                    3'b010: begin: _SLTI
                        InstrType = `I;
                        ALUControl = `SLTI;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 1;
                    end

                    3'b011: begin: _SLTIU
                        InstrType = `I;
                        ALUControl = `SLTIU;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 1;
                    end

                    3'b100: begin: _XORI
                        InstrType = `I;
                        ALUControl = `XORI;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 1;
                    end

                    3'b110: begin: _ORI
                        InstrType = `I;
                        ALUControl = `ORI;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 1;
                    end

                    3'b111: begin: _ANDI
                        InstrType = `I;
                        ALUControl = `ANDI;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 1;
                    end

                    3'b001: begin
                        case (funct7)
                            7'b0000000: begin: _SLLI
                                InstrType = `RS;
                                ALUControl = `SLLI;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                        endcase
                    end

                    3'b101: begin
                        case (funct7)
                            7'b0000000: begin: _SRLI
                                InstrType = `RS;
                                ALUControl = `SRLI;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                            
                            7'b0100000: begin: _SRAI
                                InstrType = `RS;
                                ALUControl = `SRAI;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                        endcase
                    end
                endcase
            end

            7'b0110011: begin
                case (funct3)
                    3'b000: begin
                        case (funct7)
                            7'b0000000: begin: _ADD
                                InstrType = `R;
                                ALUControl = `ADD;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                            
                            7'b0100000: begin: _SUB
                                InstrType = `R;
                                ALUControl = `SUB;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                        endcase
                    end

                    3'b001: begin
                        case (funct7)
                            7'b0000000: begin: _SLL
                                InstrType = `R;
                                ALUControl = `SLL;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                        endcase
                    end

                    3'b010: begin
                        case (funct7)
                            7'b0000000: begin: _SLT
                                InstrType = `R;
                                ALUControl = `SLT;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                        endcase
                    end

                    3'b011: begin
                        case (funct7)
                            7'b0000000: begin: _SLTU
                                InstrType = `R;
                                ALUControl = `SLTU;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                        endcase
                    end

                    3'b100: begin
                        case (funct7)
                            7'b0000000: begin: _XOR
                                InstrType = `R;
                                ALUControl = `XOR;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                        endcase
                    end

                    3'b101: begin
                        case (funct7)
                            7'b0000000: begin: _SRL
                                InstrType = `R;
                                ALUControl = `SRL;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                            
                            7'b0100000: begin: _SRA
                                InstrType = `R;
                                ALUControl = `SRA;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                        endcase
                    end

                    3'b110: begin
                        case (funct7)
                            7'b0000000: begin: _OR
                                InstrType = `R;
                                ALUControl = `OR;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                        endcase
                    end

                    3'b111: begin
                        case (funct7)
                            7'b0000000: begin: _AND
                                InstrType = `R;
                                ALUControl = `AND;
                                Jump = 0;
                                MemtoReg = 0;
                                MemWrite = 0;
                                RegWrite = 1;
                            end
                        endcase
                    end
                endcase
            end

            7'b0001111: begin
                case (funct3)
                    3'b000: begin: _FENCE
                        ALUControl = `AND;
                        Jump = 0;
                        MemtoReg = 0;
                        MemWrite = 0;
                        RegWrite = 1;
                    end
                endcase
            end

            7'b1110011: begin
                if (Instr[31:7] == 25'b0000000000000000000000000) begin: _ECALL
                    ALUControl = `ECALL;
                    Jump = 0;
                    MemtoReg = 0;
                    MemWrite = 0;
                    RegWrite = 0;
                end
                else if (Instr[31:7] == 25'b0000000000010000000000000) begin: _EBREAK
                    ALUControl = `EBREAK;
                    Jump = 0;
                    MemtoReg = 0;
                    MemWrite = 0;
                    RegWrite = 0;
                end
            end
        endcase
    end
endmodule
