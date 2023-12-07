module comparator (
    input [31:0] a,
    input [31:0] b,
    output [2:0] CMPResult
    );

    wire [31:0] s;
    adder adder(
        .c0(1'b1),
        .a(a),
        .b(~b),
        .s(s),
        .cout(cout)
    );
    
    assign negative = s[31];
    assign zero = ~|s;
    assign carry = cout;
    assign overflow = (a[31] ^ s[31]) & (a[31] ^ b[31]);


    wire EQ, SL, UL;
    assign EQ = zero;
    assign SL = negative ^ overflow;
    assign UL = ~carry;
    
    assign CMPResult = {EQ, SL, UL};
endmodule