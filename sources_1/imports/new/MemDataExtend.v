module MemDataExtend (
    input [31:0] DataIn,
    input [5:0] ALUControl,
    output reg [31:0] ExtData
);

    always @(*) begin
        if (ALUControl == `LB | ALUControl == `SB) begin
            ExtData = {{24{DataIn[7]}}, DataIn[7:0]};
        end
        else if (ALUControl == `LBU) begin
            ExtData = {24'b0, DataIn[7:0]};
        end
        else if (ALUControl == `LH | ALUControl == `SH) begin
            ExtData = {{16{DataIn[7]}}, DataIn[15:0]};
        end
        else if (ALUControl == `LHU) begin
            ExtData = {16'b0, DataIn[15:0]};
        end
        else begin
            ExtData = DataIn;
        end
    end
endmodule