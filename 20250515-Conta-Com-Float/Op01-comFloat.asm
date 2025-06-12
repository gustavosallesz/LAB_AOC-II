.data
variavel_float1: .float 0.0                      # Reserva espaço para o primeiro valor float
variavel_float2: .float 0.0                      # Reserva espaço para o segundo valor float
msg1: .asciiz "Digite o primeiro valor: "        # Mensagem de entrada
msg2: .asciiz "Digite o segundo valor: "
msg_soma: .asciiz "Soma: "
msg_sub: .asciiz "Subtracao: "
msg_mul: .asciiz "Multiplicacao: "
msg_div: .asciiz "Divisao: "
msg_mod: .asciiz "Modulo (resto da divisao): "
msg_inv: .asciiz "Inverso do sinal do primeiro valor: "

.text
main:
    li $v0, 4
    la $a0, msg1
    syscall                                      # Imprime "Digite o primeiro valor:"

    li $v0, 6
    syscall                                      # Lê float do teclado em $f0
    s.s $f0, variavel_float1                     # Salva em variavel_float1

    li $v0, 4
    la $a0, msg2
    syscall                                      # Imprime "Digite o segundo valor:"

    li $v0, 6
    syscall                                      # Lê float do teclado em $f0
    s.s $f0, variavel_float2                     # Salva em variavel_float2

    l.s $f2, variavel_float1                     # Carrega primeiro valor em $f2
    l.s $f4, variavel_float2                     # Carrega segundo valor em $f4

    add.s $f6, $f2, $f4                          # Soma $f2 + $f4 -> $f6
    li $v0, 4
    la $a0, msg_soma
    syscall                                      # Imprime "Soma:"
    li $v0, 2
    mov.s $f12, $f6
    syscall                                      # Imprime resultado da soma

    sub.s $f6, $f2, $f4                          # Subtração $f2 - $f4
    li $v0, 4
    la $a0, msg_sub
    syscall
    li $v0, 2
    mov.s $f12, $f6
    syscall                                      # Imprime resultado da subtração

    mul.s $f6, $f2, $f4                          # Multiplicação
    li $v0, 4
    la $a0, msg_mul
    syscall
    li $v0, 2
    mov.s $f12, $f6
    syscall                                      # Imprime resultado da multiplicação

    div.s $f6, $f2, $f4                          # Divisão
    li $v0, 4
    la $a0, msg_div
    syscall
    li $v0, 2
    mov.s $f12, $f6
    syscall                                      # Imprime resultado da divisão

    # Módulo real: x - int(x/y) * y
    div.s $f6, $f2, $f4                          # $f6 = x / y
    trunc.w.s $f6, $f6                           # Trunca para inteiro
    mfc1 $t0, $f6                                # Move float truncado para inteiro $t0
    mtc1 $t0, $f8                                # Move inteiro de volta para float
    cvt.s.w $f8, $f8                             # Converte int para float em $f8
    mul.s $f6, $f8, $f4                          # $f6 = parte inteira * y
    sub.s $f6, $f2, $f6                          # $f6 = x - (int(x/y) * y)
    li $v0, 4
    la $a0, msg_mod
    syscall
    li $v0, 2
    mov.s $f12, $f6
    syscall                                      # Imprime resultado do módulo

    neg.s $f6, $f2                               # Inversão de sinal do primeiro valor
    li $v0, 4
    la $a0, msg_inv
    syscall
    li $v0, 2
    mov.s $f12, $f6
    syscall                                      # Imprime valor invertido

    li $v0, 10
    syscall                                      # Encerra o programa
