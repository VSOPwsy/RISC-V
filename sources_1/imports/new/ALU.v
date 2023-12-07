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


`include "global.v"

module ALU(
    input [31:0] Src1,
    input [31:0] Src2,
    input [31:0] PC,
    input [31:0] ExtImm,
    input [5:0] ALUControl,
    output reg [31:0] ALUResult,
    output [2:0] ALUCompareResult  // {EQ, SL, UL}
    );
    

    reg [31:0] adder_a, adder_b;
    wire [31:0] adder_s;
    wire cout;
    
    reg AdderControl;   // 0 for addition, 1 for subtraction

    adder adder(
        .c0(AdderControl),
        .a(adder_a),
        .b(adder_b),
        .s(adder_s),
        .cout(cout)
    );

    reg [31:0] cmp_a, cmp_b;
    wire EQ, SL, UL;
    assign {EQ, SL, UL} = ALUCompareResult;
    comparator comparator(
        .a(cmp_a),
        .b(cmp_b),
        .CMPResult(ALUCompareResult)
    );

    reg [1:0] Sh;
    reg [31:0] ShIn;
    reg [4:0] Shamt;
    wire [31:0] ShOut;
    shifter shifter(
        .Sh(Sh),
        .ShIn(ShIn),
        .Shamt(Shamt),
        .ShOut(ShOut)
    );

    always @(*) begin
        case (ALUControl)
            `LUI: begin
                ALUResult = ExtImm;
            end

            `AUIPC: begin
                adder_a = ExtImm;
                adder_b = PC;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `JAL: begin
                adder_a = ExtImm;
                adder_b = PC;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `JALR: begin
                adder_a = Src1;
                adder_b = PC;
                AdderControl = 0;
                ALUResult = {adder_s[31:1], 1'b0};
            end

            `BEQ: begin
                cmp_a = Src1;
                cmp_b = Src2;
                adder_a = ExtImm;
                adder_b = PC;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `BNE: begin
                cmp_a = Src1;
                cmp_b = Src2;
                adder_a = ExtImm;
                adder_b = PC;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `BLT: begin
                cmp_a = Src1;
                cmp_b = Src2;
                adder_a = ExtImm;
                adder_b = PC;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `BGE: begin
                cmp_a = Src1;
                cmp_b = Src2;
                adder_a = ExtImm;
                adder_b = PC;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `BLTU: begin
                cmp_a = Src1;
                cmp_b = Src2;
                adder_a = ExtImm;
                adder_b = PC;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `BGEU: begin
                cmp_a = Src1;
                cmp_b = Src2;
                adder_a = ExtImm;
                adder_b = PC;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `LB: begin
                adder_a = Src1;
                adder_b = ExtImm;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `LH: begin
                adder_a = Src1;
                adder_b = ExtImm;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `LW: begin
                adder_a = Src1;
                adder_b = ExtImm;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `LBU: begin
                adder_a = Src1;
                adder_b = ExtImm;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `LHU: begin
                adder_a = Src1;
                adder_b = ExtImm;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `SB: begin
                adder_a = Src1;
                adder_b = ExtImm;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `SH: begin
                adder_a = Src1;
                adder_b = ExtImm;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `SW: begin
                adder_a = Src1;
                adder_b = ExtImm;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `ADDI: begin
                adder_a = Src1;
                adder_b = ExtImm;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `SLTI: begin
                cmp_a = Src1;
                cmp_b = ExtImm;
                ALUResult = SL ? 32'd1 : 32'd0;
            end

            `SLTIU: begin
                cmp_a = Src1;
                cmp_b = ExtImm;
                ALUResult = UL ? 32'd1 : 32'd0;
            end

            `XORI: begin
                ALUResult = Src1 ^ ExtImm;
            end

            `ORI: begin
                ALUResult = Src1 | ExtImm;
            end

            `ANDI: begin
                ALUResult = Src1 & ExtImm;
            end

            `SLLI: begin
                Sh = `LSL;
                ShIn = Src1;
                Shamt = ExtImm[4:0];
                ALUResult = ShOut;
            end

            `SRLI: begin
                Sh = `LSR;
                ShIn = Src1;
                Shamt = ExtImm[4:0];
                ALUResult = ShOut;
            end

            `SRAI: begin
                Sh = `ASR;
                ShIn = Src1;
                Shamt = ExtImm[4:0];
                ALUResult = ShOut;
            end

            `ADD: begin
                adder_a = Src1;
                adder_b = Src2;
                AdderControl = 0;
                ALUResult = adder_s;
            end

            `SUB: begin
                adder_a = Src1;
                adder_b = ~Src2;
                AdderControl = 1;
                ALUResult = adder_s;
            end

            `SLL: begin
                Sh = `LSL;
                ShIn = Src1;
                Shamt = Src2[4:0];
                ALUResult = ShOut;
            end

            `SLT: begin
                cmp_a = Src1;
                cmp_b = Src2;
                ALUResult = SL ? 32'd1 : 32'd0;
            end

            `SLTU: begin
                cmp_a = Src1;
                cmp_b = Src2;
                ALUResult = UL ? 32'd1 : 32'd0;
            end

            `XOR: begin
                ALUResult = Src1 ^ Src2;
            end

            `SRL: begin
                Sh = `LSR;
                ShIn = Src1;
                Shamt = Src2[4:0];
                ALUResult = ShOut;
            end

            `SRA: begin
                Sh = `ASR;
                ShIn = Src1;
                Shamt = Src2[4:0];
                ALUResult = ShOut;
            end

            `OR: begin
                ALUResult = Src1 | Src2;
            end

            `AND: begin
                ALUResult = Src1 & Src2;
            end

            `FENCE: begin

            end

            `ECALL: begin

            end

            `EBREAK: begin
                
            end
        endcase
    end
endmodule
