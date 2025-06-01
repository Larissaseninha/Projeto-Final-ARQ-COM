//------------------------------------------------------------------------------
// controller module
//------------------------------------------------------------------------------
`include "maindec.v"
`include "aludec.v"

module controller(
  input  [6:0] op,
  input  [2:0] funct3,
  input        funct7b5, // bit 5 of funct7 (Instr[30])
  input        Zero,
  output [1:0] ResultSrc,
  output       MemWrite,
  output       PCSrc, ALUSrc,
  output       RegWrite, Jump,
  output [1:0] ImmSrc,
  output [2:0] ALUControl
);
  // Portas de saída são wires por padrão se não declaradas como reg
  // e são direcionadas por 'assign' ou saídas de submódulos.
  wire [1:0] ALUOp;
  wire       Branch;
  maindec md_inst(op, ResultSrc, MemWrite, Branch,
                  ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);
  aludec  ad_inst(op[5], funct3, funct7b5, ALUOp, ALUControl); // op[5] é passado para aludec

  // Lógica original do PCSrc.
  // Usar '&&' e '||' para clareza lógica.
  assign PCSrc = (Branch && Zero) || Jump;
endmodule