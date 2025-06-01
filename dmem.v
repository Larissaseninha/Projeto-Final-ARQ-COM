//------------------------------------------------------------------------------
// dmem module (Data memory)
//------------------------------------------------------------------------------
module dmem(
  input        clk, we,    // Clock, Write enable
  input  [31:0] a, wd,    // Address, Write data
  output [31:0] rd        // Read data (é wire)
);
  reg [31:0] RAM[63:0]; // Memória como array de regs

  // Leitura combinacional
  assign rd = RAM[a[31:2]]; // Acesso alinhado à palavra

  // Escrita síncrona
  always @(posedge clk)
  begin
    if (we)
      RAM[a[31:2]] <= wd;
  end
endmodule