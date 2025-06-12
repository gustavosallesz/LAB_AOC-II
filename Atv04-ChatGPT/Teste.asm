.data
    prompt_x: .asciiz "Digite o valor real para x: "
    prompt_y: .asciiz "Digite o valor inteiro para y: "
    prompt_z: .asciiz "Digite o valor real para z: "
    prompt_t: .asciiz "Digite o valor real para t: "
    error_z_zero: .asciiz "\nERRO: O valor de z nao pode ser zero!\n"
    result_x: .asciiz "\nValores lidos:\nx = "
    result_y: .asciiz "y = "
    result_z: .asciiz "z = "
    result_t: .asciiz "t = "
    result_f: .asciiz "Resultado f = (x^y)/z - t = "
    newline: .asciiz "\n"

    const_float_one: .float 1.0  # Constante 1.0 para ponto flutuante
    const_float_zero: .float 0.0 # Constante 0.0 para ponto flutuante

.text
.globl main

main:
    # --- Bloco de Documentacao Inicial ---
    # Registradores de ponto flutuante para entradas:
    # $f12: armazena x
    # $f14: armazena z
    # $f16: armazena t
    # Registrador inteiro para entrada:
    # $s0: armazena y
    #
    # Registradores de ponto flutuante para calculos intermediarios e resultado:
    # $f10: armazena o resultado de x^y
    # $f18: armazena o resultado de (x^y)/z
    # $f20: armazena o resultado final f
    #
    # Registradores de ponto flutuante para constantes:
    # $f1: constante 1.0
    # $f3: constante 0.0
    # --- Fim do Bloco de Documentacao ---

    # Carregar constantes de ponto flutuante em registradores dedicados
    lwc1 $f1, const_float_one   # $f1 = 1.0
    lwc1 $f3, const_float_zero  # $f3 = 0.0

    # 1. Ler x (real)
    li $v0, 4                   # Codigo syscall para imprimir string
    la $a0, prompt_x
    syscall
    li $v0, 6                   # Codigo syscall para ler float
    syscall
    mov.s $f12, $f0             # Armazena x em $f12

    # 2. Ler y (inteiro)
    li $v0, 4
    la $a0, prompt_y
    syscall
    li $v0, 5                   # Codigo syscall para ler int
    syscall
    move $s0, $v0               # Armazena y em $s0

    # 3. Ler z (real)
    li $v0, 4
    la $a0, prompt_z
    syscall
    li $v0, 6
    syscall
    mov.s $f14, $f0             # Armazena z em $f14

    # 4. Ler t (real)
    li $v0, 4
    la $a0, prompt_t
    syscall
    li $v0, 6
    syscall
    mov.s $f16, $f0             # Armazena t em $f16

    # 5. Verificar se z eh zero
    c.eq.s $f14, $f3            # Compara z ($f14) com 0.0 ($f3)
    bc1t handle_error_z_zero    # Se z == 0.0, salta para o manipulador de erro

    # 6. Calcular x^y
    #    Entrada: x em $f12, y em $s0
    #    Saida: x^y em $f10
    #    Registradores temporarios: $t0 (contador para |y|), $t1 (flag para y negativo)
    #    Constantes usadas: $f1 (1.0), $f3 (0.0)

    # Inicializa o resultado de x^y ($f10) como 1.0
    mov.s $f10, $f1             # $f10 (resultado_pow_xy) = 1.0

    # Caso especial: x = 0.0
    c.eq.s $f12, $f3            # x ($f12) == 0.0 ($f3) ?
    bc1t power_x_is_zero        # Se x eh zero, trata separadamente

power_x_not_zero:
    # x != 0.0
    li $t1, 0                   # flag_y_negativo = 0 (falso)
    move $t0, $s0               # contador_abs_y = y

    beq $s0, $zero, power_done  # Se y == 0, x^0 = 1.0 (ja esta em $f10), pula o loop

    bltz $s0, power_y_is_negative # Se y < 0, ajusta o contador e a flag
    # y > 0, $t0 ja contem y
    j power_loop_begin

power_y_is_negative:
    li $t1, 1                   # flag_y_negativo = 1 (verdadeiro)
    sub $t0, $zero, $s0         # contador_abs_y = -y (valor absoluto)

power_loop_begin:
    # Loop para calcular x^|y|
    # $f10 eh o acumulador, $f12 eh a base x, $t0 eh o contador |y|
    beq $t0, $zero, power_post_loop # Se contador |y| == 0, fim do loop de multiplicacao
    mul.s $f10, $f10, $f12      # resultado_pow_xy = resultado_pow_xy * x
    addi $t0, $t0, -1           # contador_abs_y--
    j power_loop_begin

power_post_loop:
    beq $t1, $zero, power_done  # Se y NAO era negativo, $f10 contem x^y
    # y ERA negativo. $f10 contem x^|y|. Precisamos de 1.0 / (x^|y|)
    # Nao precisamos verificar se $f10 eh zero aqui, pois x != 0.0
    div.s $f10, $f1, $f10       # resultado_pow_xy = 1.0 / resultado_pow_xy
    j power_done

power_x_is_zero:
    # x == 0.0
    # Se y == 0, 0^0. resultado_pow_xy ($f10) ja eh 1.0.
    beq $s0, $zero, power_done
    # Se y > 0, 0^y = 0.0
    bgtz $s0, power_x_zero_y_positive
    # Se y < 0, 0^y = 1 / (0^|y|) = 1/0.0, que resulta em Infinito.
    # $f10 (resultado_pow_xy) esta em 1.0. $f3 (0.0).
    div.s $f10, $f1, $f3      # resultado_pow_xy = 1.0 / 0.0 (resulta em +INF no MIPS)
    j power_done

power_x_zero_y_positive:
    # x eh 0.0, y > 0. Resultado de 0^y eh 0.0.
    mov.s $f10, $f3             # resultado_pow_xy = 0.0
    # Salta para power_done

power_done:
    # $f10 agora contem o valor de x^y

    # 7. Calcular (x^y) / z
    #    $f10 contem x^y
    #    $f14 contem z
    #    Resultado em $f18
    div.s $f18, $f10, $f14      # $f18 = (x^y) / z

    # 8. Calcular f = (x^y)/z - t
    #    $f18 contem (x^y)/z
    #    $f16 contem t
    #    Resultado em $f20 (resultado_final_f)
    sub.s $f20, $f18, $f16      # $f20 = ((x^y)/z) - t

    # 9. Imprimir os valores lidos e o resultado
    # Imprimir "x = "
    li $v0, 4
    la $a0, result_x
    syscall
    # Imprimir valor de x ($f12)
    li $v0, 2                   # Codigo syscall para imprimir float
    # O valor a ser impresso por syscall 2 deve estar em $f12. Ja esta la.
    syscall

    # Imprimir "y = "
    li $v0, 4
    la $a0, result_y
    syscall
    # Imprimir valor de y ($s0)
    li $v0, 1                   # Codigo syscall para imprimir int
    move $a0, $s0               # Mover y para $a0 para impressao
    syscall

    # Imprimir "z = "
    li $v0, 4
    la $a0, result_z
    syscall
    # Imprimir valor de z ($f14)
    li $v0, 2
    mov.s $f12, $f14            # Mover z para $f12 para impressao
    syscall

    # Imprimir "t = "
    li $v0, 4
    la $a0, result_t
    syscall
    # Imprimir valor de t ($f16)
    li $v0, 2
    mov.s $f12, $f16            # Mover t para $f12 para impressao
    syscall

    # Imprimir "f = "
    li $v0, 4
    la $a0, result_f
    syscall
    # Imprimir valor de f ($f20)
    li $v0, 2
    mov.s $f12, $f20            # Mover f para $f12 para impressao
    syscall

    # Imprimir nova linha para finalizar
    li $v0, 4
    la $a0, newline
    syscall

    # 10. Terminar o programa
    j exit_program

handle_error_z_zero:
    # Imprimir mensagem de erro para z = 0
    li $v0, 4
    la $a0, error_z_zero
    syscall
    # Terminar o programa
    j exit_program

exit_program:
    li $v0, 10                  # Codigo syscall para terminar o programa
    syscall