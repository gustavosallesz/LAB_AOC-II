.data
    seq1:      .asciiz "GAGCCTACTAACGGGAT"   # sequência do DNA
    usuario:   .asciiz "Digite a sequencia de DNA: "
    erro_tam:  .asciiz "Erro: sequencias com tamanhos diferentes.\n"
    erro_char: .asciiz "Erro: caractere invalido na sequencia.\n"
    saida:     .asciiz "Distancia de Hamming: " 
    buffer:    .space 50                     # espaço para a sequência do usuário

.text
.globl main

main:
    # Imprimir prompt para o usuário
    li $v0, 4
    la $a0, usuario
    syscall

    # Ler string do usuário
    li $v0, 8
    la $a0, buffer
    li $a1, 50
    syscall
    
    # Remover o \n do final da string
    la $t0, buffer
    
tira_barraN:
    lb $t1, 0($t0)
    beqz $t1, check_tam        # Se encontrou o final da string
    li $t2, 10                 # Código ASCII para \n
    beq $t1, $t2, set_zero     # Se encontrou \n
    addi $t0, $t0, 1
    j tira_barraN

set_zero:
    sb $zero, 0($t0)           # Substitui \n por \0
    j check_tam

check_tam:
    # Contar tamanho das sequências
    la $t0, seq1
    la $t1, buffer
    move $t2, $zero            # Contador para seq1
    move $t3, $zero            # Contador para buffer
    
count_tam_seq1:
    lb $t4, 0($t0)
    beqz $t4, count_tam_buffer # Se chegou ao final da seq1
    addi $t2, $t2, 1
    addi $t0, $t0, 1
    j count_tam_seq1

count_tam_buffer:
    lb $t4, 0($t1)
    beqz $t4, compare_strings  # Se chegou ao final do buffer
    addi $t3, $t3, 1
    addi $t1, $t1, 1
    j count_tam_buffer

compare_strings:
    # Verificar se os tamanhos são iguais
    bne $t2, $t3, erro_tamanho
    
    # Inicializar para comparação
    la $t0, seq1
    la $t1, buffer
    move $t5, $zero            # Contador de diferenças (Distância de Hamming)

loop_compare:
    lb $t6, 0($t0)             # Carrega caractere de seq1
    beqz $t6, print_resultado  # Se chegou ao final da sequência
    
    lb $t7, 0($t1)             # Carrega caractere do buffer

    # Verificar se caractere de seq1 é válido (CORREÇÃO APLICADA AQUI)
    move $a0, $t6              # Passa o caractere como argumento
    jal check_char_incluso
    beqz $v0, erro_caractere

    # Verificar se caractere do buffer é válido
    move $a0, $t7
    jal check_char_incluso
    beqz $v0, erro_caractere

    # Comparar caracteres
    bne $t6, $t7, incrementa_erro
    j prox

incrementa_erro:
    addi $t5, $t5, 1           # Incrementa contador de diferenças
    
prox:
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j loop_compare
    
print_resultado: 
    # Imprimir mensagem de resultado
    li $v0, 4
    la $a0, saida
    syscall
      
    # Imprimir distância de Hamming
    li $v0, 1
    move $a0, $t5
    syscall
    
    # Pular linha
    li $v0, 11
    li $a0, 10
    syscall
    
    # Encerrar programa
    li $v0, 10
    syscall
    
# Função para verificar se caractere é válido (C, A, G ou T)
check_char_incluso:
    li $v0, 0                  # Assume que é inválido inicialmente
    li $t8, 'C'
    li $t9, 'A'
    li $s1, 'G'
    li $s2, 'T'

    beq $a0, $t8, char_valido
    beq $a0, $t9, char_valido
    beq $a0, $s1, char_valido
    beq $a0, $s2, char_valido

    jr $ra
    
char_valido:
    li $v0, 1                  # Marca como válido
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