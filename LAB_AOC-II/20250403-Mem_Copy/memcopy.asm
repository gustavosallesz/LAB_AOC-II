.data
    origem: .asciiz "Qualquer texto a ser copiado"

.text
main:
    # Imprime a string de origem
    la $a0, origem
    li $v0, 4
    syscall

    # Imprime '/'
    li $a0, 47
    li $v0, 11
    syscall

    # Chama o procedimento de copia de memoria
    la $a0, origem
    jal MEMCOPY

    # Imprime a string copiada
    move $a0, $v0
    li $v0, 4
    syscall

    # Encerra o programa
    li $v0, 10
    syscall

# Procedimento MEMCOPY: Copia conteudo de um bloco de memoria para outro alocado dinamicamente
# Entrada: $a0 = endereco da origem
# Retorno: $v0 = endereco do bloco de memoria alocado

MEMCOPY:
    # Calcula o tamanho da string de origem
    move $t0, $a0
    li $t1, 0

done_count:
    # Aloca memoria dinamicamente
    li $a0, 100
    li $v0, 9
    syscall

    # Copia a string para a nova area de memoria
    move $t3, $v0

copy_loop:
    lb   $t2, 0($t0)
    sb   $t2, 0($t3)
    beq  $t2, $zero, done_copy
    addi $t0, $t0, 1
    addi $t3, $t3, 1
    j copy_loop

done_copy:
    jr   $ra
