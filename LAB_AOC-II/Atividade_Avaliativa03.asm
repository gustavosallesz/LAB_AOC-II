.data

seq1:    .asciiz "GAGCCTACTAACGGGAT"   # sequência do DNA
usuario:  .asciiz "Digite a sequencia de DNA: "
erro_tam: .asciiz "Erro: sequencias com tamanhos diferentes.\n"
erro_char:.asciiz "Erro: caractere invalido na sequencia.\n"
saida:  .asciiz "Distancia de Hamming: " 

buffer:  .space 50  # tamanho para digitacao do user

.text
.global main

main:
    # imprimir prompt
    li $v0, 4
    la $a0, usuario
    syscall

    # ler string do usuário (max 50 bytes)
    li $v0, 8
    la $a0, buffer
    li $a1, 50
    syscall
    
    la $t0, buffer
    
    
tira_barraN:
    lb $t1, 0($t0)
    beqz $t1, check_tam   # fim da string
    li $t2, 10
    beq $t1, $t2, set_zero
    addi $t0, $t0, 1
    j tira_barraN

set_zero:
    sb $zero, 0($t0)
    j check_tam


check_tam:
    
    la $t0, seq1
    la $t1, buffer
    move $t2, $zero   # conta seq1
    move $t3, $zero   # conta buffer 50
    
   count_tam_seq1:
    lb $t4, 0($t0)
    beqz $t4, count_tam_buffer
    addi $t2, $t2, 1
    addi $t0, $t0, 1
    j count_tam_seq1

count_tam_buffer:
    lb $t4, 0($t1)
    beqz $t4, compare_strings
    addi $t3, $t3, 1
    addi $t1, $t1, 1
    j count_tam_buffer

compare_strings:
    # comparar tamanhos, se diferente -> erro e fim
    bne $t2, $t3, erro_tamanho

    
    la $t0, seq1
    la $t1, buffer
    move $t5, $zero   # contador de erros para distância de Hamming

loop_compare:
    lb $t6, 0($t0)
    beqz $t6, print_resultado
    
    lb $t7, 0($t1)

    # verificar caractere valido seq1
    jal check_char_incluso
    beqz $v0, erro_caractere

    # verificar caractere valido buffer
    move $a0, $t7
    jal check_char_incluso
    beqz $v0, erro_caractere

    # comparar caracteres
    bne $t6, $t7, erro

    j prox

erro:
    addi $t5, $t5, 1
    
prox:
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j loop_compare
    
print_resultado: 
  
         # imprimir mensagem
    li $v0, 4
    la $a0, saida
    syscall
      
          # imprimir distância de Hamming
    li $v0, 1
    move $a0, $t5
    syscall
    

    
          
    # pulando linha
    li $v0, 11
    li $a0, 10
    syscall
    
    li $v0, 10
    syscall
    
    
check_char_incluso:
    li $v0, 0
    li $t8, 'C'
    li $t9, 'A'
    li $s1, 'G'
    li $s2, 'T'

    beq $a0, $t8, verif_char
    beq $a0, $t9, verif_char
    beq $a0, $s1, verif_char
    beq $a0, $s2, verif_char

    jr $ra
    
verif_char:
    li $v0, 1
    jr $ra

erro_tamanho:
    li $v0, 4
    la $a0, erro_tam
    syscall
    li $v0, 10
    syscall

erro_caractere:
    li $v0, 4
    la $a0, erro_char
    syscall
    li $v0, 10
    syscall
    
   


