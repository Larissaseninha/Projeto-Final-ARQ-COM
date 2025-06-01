//------------------------------------------------------------------------------
// maindec module
//------------------------------------------------------------------------------
module maindec(
  input  [6:0] op,
  output [1:0] ResultSrc,
  output       MemWrite,
  output       Branch, ALUSrc,
  output       RegWrite, Jump,
  output [1:0] ImmSrc,
  output [1:0] ALUOp
);
  reg [10:0] controls; // {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump}


  assign {RegWrite, ImmSrc, ALUSrc, MemWrite,
          ResultSrc, Branch, ALUOp, Jump} = controls;
  always @(*) 
  begin
    case(op)
      // RegWrite_ImmSrc(2)_ALUSrc_MemWrite_ResultSrc(2)_Branch_ALUOp(2)_Jump
      7'b0000011: controls = 11'b1_00_1_0_01_0_00_0; // lw
      7'b0100011: controls = 11'b0_01_1_1_00_0_00_0; // sw
      7'b0110011: controls = 11'b1_xx_0_0_00_0_10_0; // R-type (ImmSrc é X, ALUSrc é 0)
      7'b1100011: controls = 11'b0_10_0_0_00_1_01_0; // beq
      7'b0010011: controls = 11'b1_00_1_0_00_0_10_0; // I-type ALU
      7'b1101111: controls = 11'b1_11_0_0_10_0_00_1; // jal
      default:    controls = 11'bx_xx_x_x_xx_x_xx_x; // Mantendo 'x' com underscores como no original SV
    endcase
  end
endmodule