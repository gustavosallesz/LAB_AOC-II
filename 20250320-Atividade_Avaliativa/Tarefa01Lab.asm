
#Codigo feito por Luiz Gustavo Salles e Vinicius Azevedo.

.data
    texto: .asciiz "\nQualquer texto a ser analisado"
    qualTrocar: .asciiz "Digite o caractere a ser substituído: "  
    novaMsg: .asciiz  "\n" 
    
.text
    
main:
    # Imprime a mensagem para o usuário
    li $v0, 4            
    la $a0, qualTrocar   # endereço da mensagem de qualTrocar
    syscall            

    # Lê o caractere digitado pelo usuário
    li $v0, 12           
    syscall             
    move $t0, $v0        # Joga caractere digitado em $t0

    # Imprime a mensagem original
    li $v0, 4            
    la $a0, texto        # endereço da mensagem original
    syscall             
    li $v0, 4            
    la $a0, novaMsg      # endereço da novaMsg
    syscall              

    # Modificar o texto
    la $t1, texto        # Endereço da string
    loop:
        lb $t2, 0($t1)   # Carrega o próximo caractere da string
        beqz $t2, feito    # Se for o fim da string (nulo), sai do loop

        # Compara se o caractere é igual ao digitado pelo usuário
        beq $t2, $t0, troca_letra
        
        # Continua para o próximo caractere da mensagem
        addi $t1, $t1, 1
        j loop

    troca_letra:
        # Se for igual, converte para maiúscula
        li $t3, 97         # a minúsculo na tabela ascii (65+32 =97)
        li $t4, 65         # Caractere A maiúsculo na tabela ascii 
        sub $t5, $t2, $t3  # Calcula a diferença entre o caractere e 'a'
        add $t2, $t5, $t4  # Converte para maiúscula

        # Armazena o caractere trocado de volta na mensagem
        sb $t2, 0($t1)

        # Continua para o próximo caractere
        addi $t1, $t1, 1
        j loop

    feito:
        # Imprime a string modificada
        li $v0, 4           
        la $a0, texto  # endereço da string modificada
        syscall             
        li $v0, 4            
        la $a0, novaMsg      
        syscall              

 	#Fechamos o código
    li $v0, 10           
    syscall             
