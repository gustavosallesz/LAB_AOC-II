.data
variavel: .word 0x8000000f
separa: .asciiz " "  # Coloquei isso só pra ficar mais bacana ao ler o número

.text
main:
	la $t0, variavel
	lw $t1, 0($t0)
	li $t2, 32

loop: 
	sll $t1, $t1, 1
	andi $t3, $t1, 0x80000000
	beqz $t3, print_zero
	li $a0, 49 # 49 é o ascii de 1
	li $v0, 11
	syscall
	j print_espaco

print_zero:
	
	li $a0, 48 # 48 é o ascii de 0
	li $v0, 11
	syscall
	
print_espaco:

    li $a0, 32           
    li $v0, 11
    syscall

    subi $t2, $t2, 1     
    bgtz $t2, loop       

    li $v0, 10           
    syscall