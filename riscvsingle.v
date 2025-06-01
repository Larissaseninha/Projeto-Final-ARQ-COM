//------------------------------------------------------------------------------
// riscvsingle module (processor core)
//------------------------------------------------------------------------------
`include "controller.v"
`include "datapath.v"

module riscvsingle(
  input        clk, reset,
  output [31:0] PC,
  input  [31:0] Instr,
  output       MemWrite,
  output [31:0] ALUResult, WriteData, // ALUResult é DataAdr para lw/sw
  input  [31:0] ReadData
);
  wire         ALUSrc, RegWrite, Jump, Zero;
  wire [1:0]   ResultSrc, ImmSrc;
  wire [2:0]   ALUControl;
  wire         PCSrc;

  controller c_inst(Instr[6:0], Instr[14:12], Instr[30], Zero, // Instr[30] é funct7b5
                    ResultSrc, MemWrite, PCSrc,
                    ALUSrc, RegWrite, Jump,
                    ImmSrc, ALUControl);
  datapath dp_inst(clk, reset, ResultSrc, PCSrc,
                   ALUSrc, RegWrite,
                   ImmSrc, ALUControl,
                   Zero, PC, Instr,
                   ALUResult, WriteData, ReadData);
endmodule