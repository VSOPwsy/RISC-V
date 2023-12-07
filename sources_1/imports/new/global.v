`ifndef _GLOBAL__V
`define _GLOBAL__V

`define     R   3'b000
`define     RS  3'b001
`define     I   3'b010
`define     S   3'b011
`define     B   3'b100
`define     U   3'b101
`define     J   3'b110



`define     LUI     6'b000000
`define     AUIPC   6'b000001
`define     JAL     6'b000010
`define     JALR    6'b000011
`define     BEQ     6'b000100
`define     BNE     6'b000101
`define     BLT     6'b000110
`define     BGE     6'b000111
`define     BLTU    6'b001000
`define     BGEU    6'b001001
`define     LB      6'b001010
`define     LH      6'b001011
`define     LW      6'b001100
`define     LBU     6'b001101
`define     LHU     6'b001110
`define     SB      6'b001111
`define     SH      6'b010000
`define     SW      6'b010001
`define     ADDI    6'b010010
`define     SLTI    6'b010011
`define     SLTIU   6'b010100
`define     XORI    6'b010101
`define     ORI     6'b010110
`define     ANDI    6'b010111
`define     SLLI    6'b011000
`define     SRLI    6'b011001
`define     SRAI    6'b011010
`define     ADD     6'b011011
`define     SUB     6'b011100
`define     SLL     6'b011101
`define     SLT     6'b011110
`define     SLTU    6'b011111
`define     XOR     6'b100000
`define     SRL     6'b100001
`define     SRA     6'b100010
`define     OR      6'b100011
`define     AND     6'b100100
`define     FENCE   6'b100101
`define     ECALL   6'b100110
`define     EBREAK  6'b100111



`define     LSL     2'b00
`define     LSR     2'b01
`define     ASR     2'b10
`define     ROR     2'b11


`endif
