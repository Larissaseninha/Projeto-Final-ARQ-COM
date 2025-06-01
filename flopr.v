//------------------------------------------------------------------------------
// flopr module (flip-flop com reset assíncrono)
//------------------------------------------------------------------------------
module flopr #(parameter WIDTH = 8) (
  input               clk, reset,
  input  [WIDTH-1:0]  d,
  output reg [WIDTH-1:0] q // Saída 'q' é 'reg'
);
  // Em Verilog, reset assíncrono na lista de sensibilidade
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      q <= {WIDTH{1'b0}}; // Zerar na largura correta
    else
      q <= d;
  end
endmodule