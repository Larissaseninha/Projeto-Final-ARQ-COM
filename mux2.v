//------------------------------------------------------------------------------
// mux2 module
//------------------------------------------------------------------------------
module mux2 #(parameter WIDTH = 8) (
  input  [WIDTH-1:0] d0, d1,
  input                s,
  output [WIDTH-1:0] y    // Saída é wire
);
  assign y = s ? d1 : d0;
endmodule