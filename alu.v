//------------------------------------------------------------------------------
// alu module
//------------------------------------------------------------------------------
module alu(
  input  [31:0] a, b,
  input  [2:0]  alucontrol,
  output reg [31:0] result, // Saída é 'reg'
  output        zero        // Saída é wire
);
  wire [31:0] condinvb, sum;
  wire        v; // overflow
  wire        isAddSub; // true when is add or subtract operation

  // Lógica original da ALU
  assign condinvb = alucontrol[0] ? ~b : b;
  assign sum = a + condinvb + alucontrol[0];
  assign isAddSub = ~alucontrol[2] & ~alucontrol[1] | ~alucontrol[1] & alucontrol[0];

  always @(*) // Bloco combinacional
  begin
    case (alucontrol)
      3'b000: result = sum; // add
      3'b001: result = sum; // subtract
      3'b010: result = a & b; // and
      3'b011: result = a | b; // or
      3'b100: result = a ^ b; // xor
      3'b101: result = {31'd0, (sum[31] ^ v)}; // slt (resultado é 0 ou 1, estendido para 32 bits)
                                               // O original era `result = sum[31] ^ v;` que em Verilog
                                               // para um `result` de 32 bits também preencheria com zeros à esquerda.
                                               // A forma explícita `{31'd0, ...}` é mais clara.
      3'b110: result = a << b[4:0]; // sll
      3'b111: result = a >> b[4:0]; // srl (logical right shift)
                                    // Para sra (arithmetic right shift), seria a >>> b[4:0] em SV,
                                    // ou ($signed(a) >>> b[4:0]) em Verilog se 'a' não for signed.
                                    // O ISA RV32I base tem srl e sra. Este processador implementa apenas srl aqui.
      default: result = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    endcase
  end

  assign zero = (result == 32'd0);
  assign v = ~(alucontrol[0] ^ a[31] ^ b[31]) & (a[31] ^ sum[31]) & isAddSub;

endmodule