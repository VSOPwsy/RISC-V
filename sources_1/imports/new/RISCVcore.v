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


module RISCVcore(
    input               CLK,
    input               Reset
    );
    
    wire                ProgramCounter_PCSrc;
    wire    [31:0]      ProgramCounter_Result;
    wire    [31:0]      ProgramCounter_PC;
    wire    [31:0]      ProgramCounter_PC_Plus_4;

    wire    [31:0]      InstructionMemory_PC;
    wire    [31:0]      InstructionMemory_Instr;
    
    wire    [31:0]      ControlUnit_Instr;
    wire    [2:0]       ControlUnit_ALUCompareResult;

    wire    [2:0]       ControlUnit_InstrType;
    wire    [5:0]       ControlUnit_ALUControl;
    wire                ControlUnit_Jump;
    wire                ControlUnit_Branch;
    wire                ControlUnit_MemtoReg;
    wire                ControlUnit_MemWrite;
    wire                ControlUnit_RegWrite;

    wire                RegisterFile_WE3;
    wire    [4:0]       RegisterFile_A1;
    wire    [4:0]       RegisterFile_A2;
    wire    [4:0]       RegisterFile_A3;
    wire    [31:0]      RegisterFile_WD3;
    wire    [31:0]      RegisterFile_RD1;
    wire    [31:0]      RegisterFile_RD2;

    wire    [31:0]      Extend_Instr;
    wire    [2:0]       Extend_InstrType;
    wire    [31:0]      Extend_ExtImm;

    wire    [31:0]      ALU_Src1;
    wire    [31:0]      ALU_Src2;
    wire    [31:0]      ALU_PC;
    wire    [31:0]      ALU_ExtImm;
    wire    [5:0]       ALU_ALUControl;
    wire    [31:0]      ALU_ALUResult;
    wire    [2:0]       ALU_ALUCompareResult;

    wire                DataMemory_WE;
    wire    [31:0]      DataMemory_A;
    wire    [31:0]      DataMemory_WD;
    wire    [31:0]      DataMemory_RD;

    wire    [31:0]      MemDataExtend_DataIn;
    wire    [5:0]       MemDataExtend_ALUControl;
    wire    [31:0]      MemDataExtend_ExtData;



    assign  ProgramCounter_PCSrc    =   ControlUnit_Jump | ControlUnit_Branch;
    assign  ProgramCounter_Result   =   ALU_ALUResult;

    assign  InstructionMemory_PC    =   ProgramCounter_PC;

    assign  ControlUnit_Instr   =   InstructionMemory_Instr;
    assign  ControlUnit_ALUCompareResult    =   ALU_ALUCompareResult;
    
    assign  RegisterFile_WE3    =   ControlUnit_RegWrite;
    assign  RegisterFile_A1     =   InstructionMemory_Instr[19:15];
    assign  RegisterFile_A2     =   InstructionMemory_Instr[24:20];
    assign  RegisterFile_A3     =   InstructionMemory_Instr[11:7];
    assign  RegisterFile_WD3    =   ControlUnit_MemtoReg ? MemDataExtend_ExtData : (ControlUnit_Jump ? ProgramCounter_PC_Plus_4 : ALU_ALUResult);

    assign  Extend_Instr        =   InstructionMemory_Instr;
    assign  Extend_InstrType    =   ControlUnit_InstrType;
    
    assign  ALU_Src1        =   RegisterFile_RD1;
    assign  ALU_Src2        =   RegisterFile_RD2;
    assign  ALU_PC          =   ProgramCounter_PC;
    assign  ALU_ExtImm      =   Extend_ExtImm;
    assign  ALU_ALUControl  =   ControlUnit_ALUControl;
    
    assign  DataMemory_WE   =   ControlUnit_MemWrite;
    assign  DataMemory_A    =   ALU_ALUResult;
    assign  DataMemory_WD   =   MemDataExtend_ExtData;
    
    assign  MemDataExtend_DataIn    =   ControlUnit_MemtoReg ? DataMemory_RD : RegisterFile_RD2;
    assign  MemDataExtend_ALUControl    =   ControlUnit_ALUControl;

    

    ProgramCounter ProgramCounter(
        .CLK        (CLK                        ),
        .Reset      (Reset                      ),
        .PCSrc      (ProgramCounter_PCSrc       ),
        .Result     (ProgramCounter_Result      ),
        .PC         (ProgramCounter_PC          ),
        .PC_Plus_4  (ProgramCounter_PC_Plus_4   ));
    
    
    InstructionMemory InstructionMemory(
        .PC     (InstructionMemory_PC       ),
        .Instr  (InstructionMemory_Instr    ));
    
    
    ControlUnit ControlUnit(
        .CLK        (CLK                    ),
        .Instr      (ControlUnit_Instr      ),
        .ALUCompareResult(ControlUnit_ALUCompareResult),
        .InstrType  (ControlUnit_InstrType  ),
        .ALUControl (ControlUnit_ALUControl ),
        .Jump       (ControlUnit_Jump       ),
        .Branch     (ControlUnit_Branch     ),
        .MemtoReg   (ControlUnit_MemtoReg   ),
        .MemWrite   (ControlUnit_MemWrite   ),
        .RegWrite   (ControlUnit_RegWrite   ));
    
    
    RegisterFile RegisterFile(
        .CLK    (CLK                ),
        .WE3    (RegisterFile_WE3   ),
        .A1     (RegisterFile_A1    ),
        .A2     (RegisterFile_A2    ),
        .A3     (RegisterFile_A3    ),
        .WD3    (RegisterFile_WD3   ),
        .RD1    (RegisterFile_RD1   ),
        .RD2    (RegisterFile_RD2   ));
        
        
    Extend Extend(
        .Instr      (Extend_Instr       ),
        .InstrType  (Extend_InstrType   ),
        .ExtImm     (Extend_ExtImm      ));
    
    
    ALU ALU(
        .Src1       (ALU_Src1       ),
        .Src2       (ALU_Src2       ),
        .PC         (ALU_PC         ),
        .ExtImm     (Extend_ExtImm  ),
        .ALUControl (ALU_ALUControl ),
        .ALUResult  (ALU_ALUResult  ),
        .ALUCompareResult(ALU_ALUCompareResult));
        
        
    DataMemory DataMemory(
        .CLK    (CLK            ),
        .WE     (DataMemory_WE  ),
        .A      (DataMemory_A   ),
        .WD     (DataMemory_WD  ),
        .RD     (DataMemory_RD  ));


    MemDataExtend MemDataExtend(
        .DataIn     (MemDataExtend_DataIn),
        .ALUControl (MemDataExtend_ALUControl),
        .ExtData    (MemDataExtend_ExtData));
        
endmodule
