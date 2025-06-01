//------------------------------------------------------------------------------
// datapath module
//------------------------------------------------------------------------------
`include "flopr.v"
`include "adder.v"
`include "regfile.v"
`include "extend.v"
`include "mux2.v"
`include "alu.v"
`include "mux3.v"

module datapath(
  input        clk, reset,
  input  [1:0] ResultSrc,
  input        PCSrc, ALUSrc,
  input        RegWrite,
  input  [1:0] ImmSrc,
  input  [2:0] ALUControl,
  output       Zero,     
  output [31:0] PC,      
  input  [31:0] Instr,
  output [31:0] ALUResult, WriteData, // Saídas de ALU e Regfile (rd2)
  input  [31:0] ReadData
);
  wire [31:0] PCNext, PCPlus4, PCTarget;
  wire [31:0] ImmExt;
  wire [31:0] SrcA, SrcB;
  wire [31:0] Result; 

  // next PC logic
  flopr #(.WIDTH(32)) pcreg_inst(clk, reset, PCNext, PC); // PC é a saída 'q' do flopr
  adder #(.WIDTH(32)) pcadd4_inst(PC, 32'd4, PCPlus4);
  adder #(.WIDTH(32)) pcaddbranch_inst(PC, ImmExt, PCTarget);
  mux2  #(.WIDTH(32)) pcmux_inst(PCPlus4, PCTarget, PCSrc, PCNext);

  // register file logic
  regfile rf_inst(clk, RegWrite, Instr[19:15], Instr[24:20],
                  Instr[11:7], Result, SrcA, WriteData);
  extend  ext_inst(Instr[31:7], ImmSrc, ImmExt);
  // ALU logic
  mux2  #(.WIDTH(32)) srcbmux_inst(WriteData, ImmExt, ALUSrc, SrcB);
  alu   alu_inst_main(SrcA, SrcB, ALUControl, ALUResult, Zero);
  mux3  #(.WIDTH(32)) resultmux_inst(ALUResult, ReadData, PCPlus4, ResultSrc, Result);
endmodule