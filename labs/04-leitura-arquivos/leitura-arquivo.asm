# Este programa lê um arquivo até os 1024 primeiros bytes (caracteres)
# Coloque arquivo.txt no diretorio de trabalho do MARS.
# Altere o nome abaixo se quiser usar outro arquivo.
#
.data  
arquivo: .asciiz "arquivo.txt"      # arquivo no diretorio de trabalho do MARS
buffer: .space 1024

.text
# $s0: descritor do arquivo aberto
# $s1: endereço do bloco de dados do arquivo lido
#abre arquivo para leitura
	li   $v0, 13       # chamada de sistema para abrir arquivo
	la   $a0, arquivo      
	li   $a1, 0        # abrir para leitura
	li   $a2, 0
	syscall            # abre arquivo! (descritor do arquivo retornado em $v0)
	move $s0, $v0      # salva o descritor de arquivo 

#lê do arquivo
	li   $v0, 14       # chamada de sistema para ler arquivo
	move $a0, $s0      # descritor do arquivo 
	la   $a1, buffer   # endereço do buffer para receber a leitura
	move $s1, $a1      # salva ponteiro para buffer em $s1
	li   $a2, 1024     # número máximo de caracters a serem lidos
	syscall            # executa leitura do arquivo!

# Fecha o arquivo 
	li   $v0, 16       # chamada de sistema para fechar arquivo
	move $a0, $s0      # descritor do arquivo a ser fechado
	syscall            # fecha arquivo!

# imprime conteúdo do buffer    
        add  $t0, $zero, $zero   # i = 0
    	add  $t1, $s1, $t0       # inicia $t1 com ponteiro $s1
    	li   $t2, 5
    	
    L1: lb   $s3, 0($t1) 
   	beq  $s3, $zero, out     # Se encontrar '\0', sai do loop  
	jal  imprime_caracter_em_s3  
        addi $t0, $t0, 1         # i = i + 1 
        addi $t1, $t1, 1         # incrementa endereço  
        subi $t2, $t2, 1
        bne $t2, $zero, L1	#Se não for 5, continua o L1
        
    # Quando chega a 5 caracteres, imprime '-' e reseta contador  
    li   $a0, '-'  
    li   $v0, 11  
    syscall  
    li   $t2, 5              # Reseta contador  
    j    L1                  # Continua loop  

   out:  


feito:  
    li $v0, 10  
    syscall                   # Termina execução  

# Função para imprimir um caractere armazenado em $s3  
imprime_caracter_em_s3:  
    li $v0, 11  
    move $a0, $s3  
    syscall  
    jr $ra  
	


