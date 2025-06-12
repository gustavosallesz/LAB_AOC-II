.data
    S1: .asciiz "EU AMO ASSEMBLY"
    encontrou: .asciiz "\nEncontrou o caracter "
    nao_encontrou: .asciiz "\nNao encontrou"
    vezes: .asciiz " vez(es)"
    digite: .asciiz "Digite um caracter: "

.text
main:
    la $a0, digite 
    li $v0, 4 	 
    syscall
    
    li $v0, 12
    syscall
    
    move $a0, $v0
    la $a1, S1  
    
    jal encontra_caracter
    
    beq $v1, $zero, nao  
    
    la $a0, encontrou 
    li $v0, 4 	 
    syscall
    
    move $a0, $v1
    li $v0, 1 	 
    syscall
    
    la $a0, vezes 
    li $v0, 4 	 
    syscall 
   
    j feito
nao: 
    la $a0, nao_encontrou 
    li $v0, 4 	 
    syscall
feito:    
    li $v0, 10
    syscall 

encontra_caracter: 
    li $v1, 0  
    loop:
        lbu $t0, 0($a1)  
        beq $t0, $zero, fim  
        beq $t0, $a0, conta 
        j continuar
    conta:
        addi $v1, $v1, 1 
    continuar:
        addi $a1, $a1, 1  
        j loop
    fim:
        jr $ra
