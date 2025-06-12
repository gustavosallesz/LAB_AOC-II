.data
    digite_x: .asciiz "Digite x: "
    digite_z: .asciiz "Digite z: "
    digite_y: .asciiz "Digite y: "
    digite_t: .asciiz "Digite t: "
    erro_zero: .asciiz "\n  Erro, z não pode ser ZERO \n"
    resultado: .asciiz "\n Resultado:  "
    var_1: .float 1.0
    var_0: .float 0.0 
    
.text
main:
    # Carrega constantes para ponto flutuante
    lwc1 $f1, var_1       # $f1 = 1.0
    lwc1 $f3, var_0       # $f3 = 0.0 (CORREÇÃO: Zero carregado para comparação)

    # Leitura de x
    la $a0, digite_x     
    li $v0, 4      
    syscall
    li $v0, 6            # lê float para $f0
    syscall
    mov.s $f12, $f0      # $f12 contém x

    # Leitura de z (CORREÇÃO: Verificação de zero)
    la $a0, digite_z
    li $v0, 4
    syscall
    li $v0, 6            # lê float para $f0
    syscall
    mov.s $f14, $f0      # $f14 contém z
    
    # Verificação se z é zero (CORREÇÃO PRINCIPAL)
    c.eq.s $f14, $f3     # Compara z ($f14) com 0.0 ($f3)
    bc1t tratar_erro_zero # Se for igual, trata erro
    
    # Leitura de t
    la $a0, digite_t
    li $v0, 4
    syscall
    li $v0, 6            # lê float para $f0
    syscall
    mov.s $f16, $f0      # $f16 contém t
    
    # Leitura de y (inteiro)
    la $a0, digite_y
    li $v0, 4
    syscall
    li $v0, 5            # lê inteiro para $v0
    syscall
    move $s0, $v0        # $s0 contém y

    # Cálculo de x^y
    mov.s $f10, $f1      # Inicializa resultado (1.0)
    c.eq.s $f12, $f3     # Verifica se x == 0
    bc1t potencia_x_zero

potencia_x_n_zero: 
    li $t1, 0            # Flag para sinal negativo
    move $t0, $s0        # Contador de expoente
    
    beq $s0, $zero, potencia_concluida  # y == 0
    bltz $s0, potencia_y_negativo       # y < 0
    j inicio_loop_potencia

potencia_y_negativo: 
    li $t1, 1            # Marca expoente negativo
    sub $t0, $zero, $s0  # Valor absoluto do expoente
    
inicio_loop_potencia:
    beq $t0, $zero, dps_loop_potencia
    mul.s $f10, $f10, $f12 
    addi $t0, $t0, -1
    j inicio_loop_potencia
    
dps_loop_potencia:
    beq $t1, $zero, potencia_concluida
    div.s $f10, $f1, $f10  # Inverte se expoente negativo
    j potencia_concluida
    
potencia_x_zero:
    beq $s0, $zero, potencia_concluida  # 0^0 = 1
    bgtz $s0, potencia_x_zero_y_positivo # 0^y (y>0) = 0
    div.s $f10, $f1, $f3   # 0^y (y<0) = infinito (erro)
    j potencia_concluida
    
potencia_x_zero_y_positivo:
    mov.s $f10, $f3        # Resultado = 0
    
potencia_concluida:
    # Cálculo final: (x^y)/z - t
    div.s $f18, $f10, $f14
    sub.s $f20, $f18, $f16
    
    # Exibe resultado
    li $v0, 4
    la $a0, resultado
    syscall
    li $v0, 2
    mov.s $f12, $f20
    syscall
    j encerrar_programa

tratar_erro_zero:
    li $v0, 4
    la $a0, erro_zero
    syscall

encerrar_programa:
    li $v0, 10
    syscall
.end main