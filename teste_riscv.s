# 1. Escreve 42 no endereço 96.
# 2. Escreve 25 no endereço 100.

#       RISC-V Assembly         Description                     Address   Machine Code
main:
        addi x5, x0, 42         # x5 = 42                       0
        addi x10, x0, 96        # x10 = 96 (endereço para primeira escrita) 4
        sw   x5, 0(x10)         # mem[96] = 42                  8  (Primeira escrita em Adr 96)

        addi x8, x0, 100        # x8 = 100 (endereço para segunda escrita) C
        addi x12, x0, 25        # x12 = 25                      10 (decimal) ; 0x19 (hex)
        sw   x12, 0(x8)         # mem[100] = 25                 14 (Segunda escrita - sucesso)
done:
        beq  x0, x0, done       # Loop infinito                 18