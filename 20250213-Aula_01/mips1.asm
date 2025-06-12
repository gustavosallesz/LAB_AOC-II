.data 


mensagem1: .asciiz "Digite um numero: "
mensagem2: .asciiz "Digite outro numero: "
resultado: .asciiz "O resultado da soma é: "

.text
.globl main

main:
    
    li $v0, 4
    la $a0, mensagem1
    syscall 

   
    li $v0, 5
    syscall
    move $t0, $v0

   
    li $v0, 4
    la $a0, mensagem2
    syscall

  
    li $v0, 5
    syscall
    move $t1, $v0

 
    add $t2, $t0, $t1

   
    li $v0, 4
    la $a0, resultado
    syscall

    
    li $v0, 1
    move $a0, $t2
    syscall

   
    li $v0, 10
    syscall
