.data
	texto: .asciiz "Classe: "
	a: .asciiz "A\n"
	b: .asciiz "B\n"
	c: .asciiz "C\n"
	msg: .asciiz "Digite o primeiro octeto: "
	n: .asciiz "Nao encontrou\n"
    
.text

main:
    
    li $v0, 4
    la $a0, msg
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    blt $t0, 1, nao_encontrou
    ble $t0, 126, classe_a
    ble $t0, 191, classe_b
    ble $t0, 223, classe_c
 
 nao_encotrou:
 
    li $v0, 4
    la $a0, n
    syscall
    j fim
    
    
    classe_a:
    li $v0, 4
    la $a0, texto
    syscall
    la $a0, a
    syscall
    j fim
    
     classe_b:
    li $v0, 4
    la $a0, texto
    syscall
    la $a0, b
    syscall
    j fim
    
     classe_c:
    li $v0, 4
    la $a0, texto
    syscall
    la $a0, c
    syscall
    j fim
    
    
nao_encontrou:
	la $a0, n
    	li $v0, 4 	 
    	syscall

fim: 

    li $v0, 10
    syscall 

    
    
    
