

// Single-cycle implementation of RISC-V (RV32I)


//------------------------------------------------------------------------------
// top module
//------------------------------------------------------------------------------
`include "riscvsingle.v"
`include "imem.v"
`include "dmem.v"

module top(
  input        clk, reset,
  output [31:0] WriteData, DataAdr,
  output       MemWrite
);
  wire [31:0] PC, Instr, ReadData;

  // instantiate processor and memories
  riscvsingle rvsingle_inst(clk, reset, PC, Instr, MemWrite, DataAdr,
                           WriteData, ReadData);
  imem imem_inst(PC, Instr);
  dmem dmem_inst(clk, MemWrite, DataAdr, WriteData, ReadData);
endmodule