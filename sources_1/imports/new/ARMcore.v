`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech
// Engineer: Suyu Wang
// Module Name: ARMcore
// Project Name: Processor
// Tool Versions: Vivado 2021.2
// Description: 
//
//////////////////////////////////////////////////////////////////////////////////


module ARMcore(
    input               CLK,
    input               Reset,
    input   [31:0]      Instr,
    input   [31:0]      ReadData,
    
    output              MemWrite,
    output  [31:0]      PC,
    output  [31:0]      ALUResult,
    output  [31:0]      WriteData
    );
    
    // Test
    assign  InstructionMemory_Instr =   Instr;
    assign  DataMemory_RD           =   ReadData;
    
    assign  PC                      =   ProgramCounter_PC;
    assign  MemWrite                =   ControlUnit_MemWrite;
    assign  WriteData               =   RegisterFile_RD2;
    assign  ALUResult               =   ALU_ALUResult;
    
    
    // ControlUnit
    // Input
    wire    [31:0]      ControlUnit_Instr;
    wire    [3:0]       ControlUnit_ALUFlags;
    // Output
    wire    [1:0]       ControlUnit_ALUControl;
    wire                ControlUnit_ALUSrc;
    wire    [1:0]       ControlUnit_ImmSrc;
    wire                ControlUnit_MemWrite;
    wire                ControlUnit_MemtoReg;
    wire                ControlUnit_PCSrc;
    wire    [1:0]       ControlUnit_RegSrc;
    wire                ControlUnit_RegWrite;
    // Assignment
    assign  ControlUnit_Instr       =   InstructionMemory_Instr;
    assign  ControlUnit_ALUFlags    =   ALU_ALUFlags;
    
    
    
    // ProgramCounter
    // Input
    wire                ProgramCounter_PCSrc;
    wire    [31:0]      ProgramCounter_Result;
    // Output
    wire    [31:0]      ProgramCounter_PC;
    wire    [31:0]      ProgramCounter_PC_Plus_4;
    wire    [31:0]      ProgramCounter_PC_Plus_8;
    // Assignment
    assign  ProgramCounter_PCSrc    =   ControlUnit_PCSrc;
    assign  ProgramCounter_Result   =   ControlUnit_MemtoReg ? DataMemory_RD : ALU_ALUResult;
    
    
    
    // InstructionMemory
    // Input
    wire    [31:0]      InstructionMemory_PC;
    // Output
    wire    [31:0]      InstructionMemory_Instr;
    // Assignment
    assign  InstructionMemory_PC    =   ProgramCounter_PC;
    
    
    
    // RegisterFile
    // Input
    wire                RegisterFile_WE3;
    wire    [4:0]       RegisterFile_A1;
    wire    [4:0]       RegisterFile_A2;
    wire    [4:0]       RegisterFile_A3;
    wire    [31:0]      RegisterFile_WD3;
    // Output
    wire    [31:0]      RegisterFile_RD1;
    wire    [31:0]      RegisterFile_RD2;
    // Assignment
    assign  RegisterFile_WE3    =   ControlUnit_RegWrite;
    assign  RegisterFile_A1     =   ControlUnit_RegSrc[0] ? 4'd15 : InstructionMemory_Instr[19:16];
    assign  RegisterFile_A2     =   ControlUnit_RegSrc[1] ? InstructionMemory_Instr[15:12] : InstructionMemory_Instr[3:0];
    assign  RegisterFile_A3     =   InstructionMemory_Instr[15:12];
    assign  RegisterFile_WD3    =   ControlUnit_MemtoReg ? DataMemory_RD : ALU_ALUResult;
    assign  RegisterFile_R15    =   ProgramCounter_PC_Plus_8;
    
    
    
    // Extend
    // Input
    wire    [1:0]       Extend_ImmSrc;
    wire    [23:0]      Extend_InstrImm;
    // Output
    wire    [31:0]      Extend_ExtImm;
    // Assignment
    assign  Extend_ImmSrc       =   ControlUnit_ImmSrc;
    assign  Extend_InstrImm     =   InstructionMemory_Instr[23:0];
    
    
    
    // Shifter
    // Input
    wire    [1:0]       Shifter_Sh;
    wire    [4:0]       Shifter_Shamt5;
    wire    [31:0]      Shifter_ShIn;
    // Output
    wire    [31:0]      Shifter_ShOut;
    // Assignment
    assign  Shifter_Sh      =   InstructionMemory_Instr[6:5];
    assign  Shifter_Shamt5  =   InstructionMemory_Instr[11:7];
    assign  Shifter_ShIn    =   RegisterFile_RD2;
    
    
    
    // ALU
    // Input
    wire    [31:0]      ALU_SrcA;
    wire    [31:0]      ALU_SrcB;
    wire    [1:0]       ALU_ALUControl;
    // Output
    wire    [31:0]      ALU_ALUResult;
    wire    [3:0]       ALU_ALUFlags;
    // Assignment
    assign  ALU_SrcA        =   RegisterFile_RD1;
    assign  ALU_SrcB        =   ControlUnit_ALUSrc ? Extend_ExtImm : Shifter_ShOut;
    assign  ALU_ALUControl  =   ControlUnit_ALUControl;
    
    
    
    // DataMemory
    // Input
    wire                DataMemory_WE;
    wire    [31:0]      DataMemory_A;
    wire    [31:0]      DataMemory_WD;
    // Output
    wire    [31:0]      DataMemory_RD;
    // Assignment
    assign  DataMemory_WE   =   ControlUnit_MemWrite;
    assign  DataMemory_A    =   ALU_ALUResult;
    assign  DataMemory_WD   =   RegisterFile_RD2;
    
    
    
    ControlUnit ControlUnit(
        .CLK        (CLK                    ),
        .Instr      (ControlUnit_Instr      ),
        .ALUFlags   (ControlUnit_ALUFlags   ),
        .ALUControl (ControlUnit_ALUControl ),
        .ALUSrc     (ControlUnit_ALUSrc     ),
        .ImmSrc     (ControlUnit_ImmSrc     ),
        .MemWrite   (ControlUnit_MemWrite   ),
        .MemtoReg   (ControlUnit_MemtoReg   ),
        .PCSrc      (ControlUnit_PCSrc      ),
        .RegSrc     (ControlUnit_RegSrc     ),
        .RegWrite   (ControlUnit_RegWrite   ));
    
    ProgramCounter ProgramCounter(
        .CLK        (CLK                        ),
        .Reset      (Reset                      ),
        .PCSrc      (ProgramCounter_PCSrc       ),
        .Result     (ProgramCounter_Result      ),
        .PC         (ProgramCounter_PC          ),
        .PC_Plus_4  (ProgramCounter_PC_Plus_4   ),
        .PC_Plus_8  (ProgramCounter_PC_Plus_8   ));
    
    
//    InstructionMemory InstructionMemory(
//        .PC     (InstructionMemory_PC       ),
//        .Instr  (InstructionMemory_Instr    ));
    
    
    RegisterFile RegisterFile(
        .CLK    (CLK                ),
        .WE3    (RegisterFile_WE3   ),
        .A1     (RegisterFile_A1    ),
        .A2     (RegisterFile_A2    ),
        .A3     (RegisterFile_A3    ),
        .WD3    (RegisterFile_WD3   ),
        .R15    (RegisterFile_R15   ),
        .RD1    (RegisterFile_RD1   ),
        .RD2    (RegisterFile_RD2   ));
        
        
    Extend Extend(
        .ImmSrc     (Extend_ImmSrc      ),
        .InstrImm   (Extend_InstrImm    ),
        .ExtImm     (Extend_ExtImm      ));
        
        
    Shifter Shifter(
        .Sh     (Shifter_Sh     ),
        .Shamt5 (Shifter_Shamt5 ),
        .ShIn   (Shifter_ShIn   ),
        .ShOut  (Shifter_ShOut  ));
    
    
    ALU ALU(
        .SrcA       (ALU_SrcA       ),
        .SrcB       (ALU_SrcB       ),
        .ALUControl (ALU_ALUControl ),
        .ALUResult  (ALU_ALUResult  ),
        .ALUFlags   (ALU_ALUFlags   ));
        
        
//    DataMemory DataMemory(
//        .CLK    (CLK            ),
//        .WE     (DataMemory_WE  ),
//        .A      (DataMemory_A   ),
//        .WD     (DataMemory_WD  ),
//        .RD     (DataMemory_RD  ));
        
endmodule
