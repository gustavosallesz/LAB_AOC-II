.text
main:
    li $t0, 0           # $t0 = 0
    li $t1, 5           # $t1 = 5
    and $t2, $t0, $t1   # AND lógico entre $t0 e $t1 → $t2 = 0
    srl $t2, $t2, 1     # Shift lógico à direita → continua 0

    teqi $t2, 0         # Gera Exceção 13 (TRAP_EXCEPTION) porque $t2 == 0

    # Provocar Exceção 5 (ADDRESS_EXCEPTION_STORE)
    li $t3, 42
    li $t4, 3           # Endereço não alinhado (não múltiplo de 4)
    sw $t3, 1($t4)      # Gera Exceção 5

    li $v0, 10          # Encerrar programa normalmente
    syscall

# Handler para exceções
.ktext 0x80000180
    move $k0, $v0       # Salva $v0
    move $k1, $a0       # Salva $a0

    li $v0, 4           # Serviço de impressão
    la $a0, trap_msg
    syscall

    mfc0 $a0, $13       # Carrega registrador Cause em $a0
    li $v0, 1           # Serviço para imprimir inteiro
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    move $v0, $k0       # Restaura $v0
    move $a0, $k1       # Restaura $a0

    mfc0 $k0, $14       # Endereço da instrução que causou exceção
    addi $k0, $k0, 4    # Avança para próxima instrução
    mtc0 $k0, $14       # Salva de volta no registrador
    eret                # Retorna da exceção

.kdata
trap_msg:  .asciiz "Excecao capturada. Cause = "
newline:   .asciiz "\n"
