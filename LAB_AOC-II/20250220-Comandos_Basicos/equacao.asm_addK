.data
str1: .asciiz "Exemplo " 
str2: .asciiz "de soma "
str3: .asciiz "e subtracao. Resultado: " # string terminada em 0
str4: .asciiz "Erro de divisao por zero!"

varg: .word 10
varh: .word 20
vari: .word 10
varj: .word 20
varf: .word 0
vark:  .word 5   # Definindo o valor de k (pode ser alterado conforme necessário)

.text
.globl main

main:

# f = (g*h)/(i-j) + k;
# g , h , i e j: regs. $s1, $s2 , $s3  e $s4 respect.; f: registrador $s0
# k: variavel para soma após divisão

# leitura das variaveis e carga nos registradores
        li $v0, 5
        syscall
        sw $v0, varg
    
        li $v0, 5
        syscall
        sw $v0, varh
    
        li $v0, 5
        syscall
        sw $v0, vari

        li $v0, 5
        syscall
        sw $v0, varj

        li $v0, 5
        syscall
        sw $v0, vark  # Lê o valor de k

        lw $s1, varg     # Carrega o valor de g em $s1
        lw $s2, varh     # Carrega o valor de h em $s2
        lw $s3, vari     # Carrega o valor de i em $s3
        lw $s4, varj     # Carrega o valor de j em $s4
        lw $s5, vark        # Carrega o valor de k em $t2

# soma e subtração
        mul $t0, $s1, $s2   # $t0 = g * h
        sub $t1, $s3, $s4   # $t1 = i - j

        beq $t1, $zero, erro
        div $t2, $t0, $t1   # $s0 = (g * h) / (i - j)
        add $s0, $t2, $s5  # $s0 = resultado + k

        sw $s0, varf        # armazena o resultado final em f
        la $a0, str1        # endereço da string não terminada com NULL
        li $v0, 4           # imprime string
        syscall
        li $v0, 1           # imprime inteiro
        lw $a0, varf        # carrega o valor de f para impressão
        syscall
        j feito

erro:  
        la $a0, str4        # endereço da string de erro
        li $v0, 4           # imprime string
        syscall

feito:
        li $v0, 10          
