//------------------------------------------------------------------------------
// aludec module
//------------------------------------------------------------------------------
module aludec(
  input        opb5,     // Este é op[5]usado para R-type sub.
  input  [2:0] funct3,
  input        funct7b5, // Instr[30]
  input  [1:0] ALUOp,    // De maindec
  output reg [2:0] ALUControl // ALUControl'
);
  wire RtypeSub;
  // Lógica para RtypeSub
  assign RtypeSub = funct7b5 && opb5; // TRUE for R-type subtract instruction (opb5 is Instr[5])

  always @(*) // Bloco combinacional
  begin
    case(ALUOp)
      2'b00: ALUControl = 3'b000; // addition (para lw/sw)
      2'b01: ALUControl = 3'b001; // subtraction (para beq)
      default: // R-type or I-type ALU (ALUOp == 2'b10)
        case(funct3)
          3'b000: if (RtypeSub)
                    ALUControl = 3'b001; // sub
                  else
                    ALUControl = 3'b000; // add, addi
          3'b010: ALUControl = 3'b101; // slt, slti
          3'b110: ALUControl = 3'b011; // or, ori
          3'b111: ALUControl = 3'b010; // and, andi
          default: ALUControl = 3'bxxx; // 
        endcase
    endcase
  end
endmodule