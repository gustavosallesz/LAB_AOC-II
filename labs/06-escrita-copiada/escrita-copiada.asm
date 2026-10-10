.data  

origem: .asciiz "arquivo.txt"
destino: .asciiz "arquivo2.txt"
buffer: .space 1024  

.text
main:
    # Abrir arquivo de origem para leitura
    li   $v0, 13
    la   $a0, origem  
    li   $a1, 0        
    li   $a2, 0        
    syscall
    move $s0, $v0      

    # Abrir arquivo de destino para escrita
    li   $v0, 13
    la   $a0, destino  
    li   $a1, 1        
    li   $a2, 0        
    syscall
    move $s1, $v0      

leitura:
    # Ler do arquivo de origem
    li   $v0, 14
    move $a0, $s0
    la   $a1, buffer
    li   $a2, 1024
    syscall

    move $t0, $v0      
    beq  $t0, $zero, exibir_destino  

    # Escrever no arquivo de destino
    li   $v0, 15
    move $a0, $s1
    la   $a1, buffer
    move $a2, $t0      
    syscall

    j leitura  

exibir_destino:
    # Fechar arquivo de escrita antes de ler
    li   $v0, 16
    move $a0, $s1
    syscall

    # Abrir arquivo de destino para leitura
    li   $v0, 13
    la   $a0, destino  
    li   $a1, 0        
    li   $a2, 0        
    syscall
    move $s1, $v0      

    # Ler do arquivo de destino
    li   $v0, 14
    move $a0, $s1
    la   $a1, buffer
    li   $a2, 1024
    syscall

    move $t0, $v0      
    beq  $t0, $zero, fechar_arquivos  

    # Imprimir conteúdo do buffer na tela
    li   $v0, 4
    la   $a0, buffer
    syscall

fechar_arquivos:
    # Fechar arquivo de origem
    li   $v0, 16
    move $a0, $s0
    syscall

    # Fechar arquivo de destino
    li   $v0, 16
    move $a0, $s1
    syscall

    # Finaliza o programa
    li $v0, 10
    syscall
