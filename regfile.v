//------------------------------------------------------------------------------
// regfile module
//------------------------------------------------------------------------------
module regfile(
  input        clk,
  input        we3,      // Write enable
  input  [4:0] a1, a2, a3, // Read addresses, Write address
  input  [31:0] wd3,     // Write data
  output [31:0] rd1, rd2  // Read data (são wires, direcionados por 'assign')
);
  reg [31:0] rf[31:0]; // Memória do banco de registradores

  // Inicialização para garantir que x0 seja 0 e outros estados definidos (opcional em síntese, bom para simulação)
  // O código original não tinha um bloco initial explícito para zerar todos,
  // mas a lógica de leitura de x0 já garante isso para x0.
  // Para consistência com simulações onde 'x' pode ser problemático, pode-se adicionar:
  /* integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      rf[i] = 32'd0;
    end
  end */


  // Escrita na borda de subida do clock
  always @(posedge clk)
  begin
    if (we3) begin // Escrita habilitada
        if (a3 != 5'd0) begin // Não permitir escrita direta em x0, embora a leitura já o force a 0
            rf[a3] <= wd3;
        end
    end
  end

  // Leitura combinacional
  // x0 é sempre 0
  assign rd1 = (a1 == 5'd0) ? 32'd0 : rf[a1];
  assign rd2 = (a2 == 5'd0) ? 32'd0 : rf[a2];
endmodule