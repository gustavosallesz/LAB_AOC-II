.data
msg: .asciiz "Digite um valor float: "                # Mensagem para entrada de float
msg_intconv: .asciiz "Valor como inteiro (com conversao): "
msg_semconv: .asciiz "Valor como inteiro (sem conversao): "

.text
main:
    li $v0, 4
    la $a0, msg
    syscall                                           # Imprime "Digite um valor float:"

    li $v0, 6
    syscall                                           # Lê valor float do teclado para $f0
    mov.s $f2, $f0                                    # Copia float lido para $f2

    li $v0, 4
    la $a0, msg_semconv
    syscall                                           # Imprime "Valor como inteiro (sem conversao):"

    mfc1 $a0, $f2                                     # Move float binário bruto para registrador inteiro
    li $v0, 1
    syscall                                           # Imprime valor incorreto (interpretação binária errada)

    li $v0, 4
    la $a0, msg_intconv
    syscall                                           # Imprime "Valor como inteiro (com conversao):"

    trunc.w.s $f4, $f2                                # Converte float para inteiro (truncado)
    mfc1 $a0, $f4                                     # Move valor convertido para registrador de inteiros
    li $v0, 1
    syscall                                           # Imprime valor convertido corretamente

    li $v0, 10
    syscall                                           # Encerra o programa
