.data
seq1:    .asciiz "GAGCCTACTAACGGGAT"   # sequência fixa
prompt:  .asciiz "Digite a sequencia de DNA: "
err_len: .asciiz "Erro: sequencias com tamanhos diferentes.\n"
err_char:.asciiz "Erro: caractere invalido na sequencia.\n"
outmsg:  .asciiz "Distancia de Hamming: "

buffer:  .space 20  # espaço para entrada do usuário (maior que a string fixa)

.text
.globl main

main:
    # imprimir prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # ler string do usuário (max 20 bytes)
    li $v0, 8
    la $a0, buffer
    li $a1, 20
    syscall

    # remover newline da entrada (trocar \n por \0)
    la $t0, buffer
remove_newline:
    lb $t1, 0($t0)
    beqz $t1, check_length   # fim string
    li $t2, 10
    beq $t1, $t2, set_zero
    addi $t0, $t0, 1
    j remove_newline

set_zero:
    sb $zero, 0($t0)
    j check_length

check_length:
    # pegar o tamanho das duas strings
    la $t0, seq1
    la $t1, buffer
    move $t2, $zero   # contador seq1
    move $t3, $zero   # contador buffer

count_len_seq1:
    lb $t4, 0($t0)
    beqz $t4, count_len_buffer
    addi $t2, $t2, 1
    addi $t0, $t0, 1
    j count_len_seq1

count_len_buffer:
    lb $t4, 0($t1)
    beqz $t4, compare_strings
    addi $t3, $t3, 1
    addi $t1, $t1, 1
    j count_len_buffer

compare_strings:
    # comparar tamanhos, se diferente -> erro e fim
    bne $t2, $t3, erro_tamanho

    # reset ponteiros para comparação
    la $t0, seq1
    la $t1, buffer
    move $t5, $zero   # contador de erros (distância de Hamming)

loop_compare:
    lb $t6, 0($t0)
    beqz $t6, print_result # fim seq1 (e buffer)
    
    lb $t7, 0($t1)

    # verificar caractere valido seq1
    jal check_char_valid
    beqz $v0, erro_caractere

    # verificar caractere valido buffer
    move $a0, $t7
    jal check_char_valid
    beqz $v0, erro_caractere

    # comparar caracteres
    bne $t6, $t7, inc_error

    j advance

inc_error:
    addi $t5, $t5, 1

advance:
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j loop_compare

print_result:
    # imprimir mensagem
    li $v0, 4
    la $a0, outmsg
    syscall

    # imprimir distância (int)
    li $v0, 1
    move $a0, $t5
    syscall

    # nova linha
    li $v0, 11
    li $a0, 10
    syscall

    # sair
    li $v0, 10
    syscall

# Função check_char_valid
# Entrada: $a0 = caractere ASCII
# Retorno: $v0 = 1 se válido {C,A,G,T}, 0 caso contrário
check_char_valid:
    li $v0, 0
    li $t8, 'C'
    li $t9, 'A'
    li $s1, 'G'
    li $s2, 'T'

    beq $a0, $t8, valid_char
    beq $a0, $t9, valid_char
    beq $a0, $s1, valid_char
    beq $a0, $s2, valid_char

    jr $ra

valid_char:
    li $v0, 1
    jr $ra

erro_tamanho:
    li $v0, 4
    la $a0, err_len
    syscall
    li $v0, 10
    syscall

erro_caractere:
    li $v0, 4
    la $a0, err_char
    syscall
    li $v0, 10
    syscall
