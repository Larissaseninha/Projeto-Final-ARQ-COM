//------------------------------------------------------------------------------
// extend module
//------------------------------------------------------------------------------
module extend(
  input  [31:7] instr, // Entrada é um slice [31:7] como no original SV
  input  [1:0]  immsrc,
  output reg [31:0] immext // Saída é 'reg' pois é atribuída em bloco always
);
  always @(*) // Bloco combinacional
  begin
    case(immsrc)
      // I-type
      2'b00: immext = {{20{instr[31]}}, instr[31:20]};
      // S-type (stores)
      2'b01: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      // B-type (branches) - deslocado por 1 bit implicitamente depois
      2'b10: immext = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
      // J-type (jal) - deslocado por 1 bit implicitamente depois
      2'b11: immext = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
      default: immext = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; // Usando 'x' explícito
    endcase
  end
endmodule