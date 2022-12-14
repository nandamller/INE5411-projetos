.data
	# labels coringas
	virgula: .asciiz ", "
	quebra: .asciiz "\n"
	quebra_dupla: .asciiz "\n\n"
	iguais: .asciiz "\n============================\n"
	escolha: .asciiz "Digite o número correspondente a operação desejada: "

	# labels para o menu principal
	menu_principal_0: .asciiz "\n============================\nMENU PRINCIPAL\n============================"
	menu_principal_1: .asciiz "\n1 - Adicionar novas entrada de dados."
	menu_principal_2: .asciiz "\n2 - Exibir a série de dados na tela."
	menu_principal_3: .asciiz "\n3 - Calcular a MM-n."
	menu_principal_4: .asciiz "\n4 - Mostrar a série de tendências baseada em duas médias móveis."
	menu_principal_5: .asciiz "\n5 - Encerrar programa.\n"
	menu_principal_6: .asciiz "\nEscolha inválida!\n"
	
	# labels para a entrada de dados
	entrada_dados_0: .asciiz "\n============================\nENTRADA DE DADOS\n============================"
	entrada_dados_1: .asciiz "\nInforme o valor de N:  (máximo 10)\n"
	entrada_dados_2: .asciiz "\nInforme 1 entrada por vez:\n"
	entrada_dados_3: .asciiz "Dados armazenados com sucesso!\n"
	
	# labels para a exibição dos dados
	exibicao_dados_0: .asciiz "\n============================\nSÉRIE DE DADOS\n"
	
	# labels para o calculo de MM-n
	calculo_mmn_0: .asciiz "\n============================\nMÉDIA MÓVEL\n============================"
	calculo_mmn_1: .asciiz "\nInforme o tamanho da média móvel: (máximo 10)\n"
	calculo_mmn_2: .asciiz "\nCotação | MM-"
	calculo_mmn_3: .asciiz " | "

	# labels para o calculo de MM-n
	tendencia_0: .asciiz "\n============================\nTENDÊNCIAS\n============================"
	tendencia_1: .asciiz "\nInforme o tamanho das médias móveis: (máximo 10)\n"
	tendencia_2: .asciiz "\nCotação | MM-"
	tendencia_3: .asciiz " | MM-"
	tendencia_4: .asciiz " | Tendência\n"
	tendencia_5: .asciiz " | "
	tendencia_alta: .asciiz "Alta"
	tendencia_baixa: .asciiz "Queda"
	tendencia_constante: .asciiz "Constante"
	
	# label p/ fim
	fim: .asciiz "\n============================\nPROGRAMA ENCERRADO\n============================"
	
	# valor de elementos
	N: .word 0
	
	# vai conter a média móvel
	.align 2
	media: .float 0

	# buffer p/ armazenar os dados
	.align 2
	dados: .float 0 0 0 0 0 0 0 0 0 0
	
	# buffer p/ auxiliar no cálculo da média móvel
	.align 2
	buffer_media: .float 0 0 0 0 0 0 0 0 0 0
	
	# buffer p/ armazenar as médias móveis p/ a tendência
	.align 2
	buffer_tendencia_1: .float 0 0 0 0 0 0 0 0 0 0
	.align 2
	buffer_tendencia_2: .float 0 0 0 0 0 0 0 0 0 0	

.text
	# $s0 é usado p/ o valor de N elementos
	la $s0, N
	# $s1 é usado p/ a escolha no menu
	la $s2, dados	
	# $s3 é usado p/ o valor de n na MMn
	la $s4, buffer_media
	la $s5, media
	la $s6, buffer_tendencia_1
	la $s7, buffer_tendencia_2

menu_principal:
	li $v0, 4 					# Comando para escrever no terminal.
	la $a0, menu_principal_0	# Carrega string (endereço).
	syscall
	
	li $v0, 4	 				# Comando para escrever no terminal.
	la $a0, menu_principal_1	# Carrega string (endereço).
	syscall
	
	li $v0, 4 					# Comando para escrever no terminal.
	la $a0, menu_principal_2	# Carrega string (endereço).
	syscall
	
	li $v0, 4 					# Comando para escrever no terminal.
	la $a0, menu_principal_3	# Carrega string (endereço).
	syscall
	
	li $v0, 4 				 # Comando para escrever no terminal.
	la $a0, menu_principal_4 # Carrega string (endereço).
	syscall
	
	li $v0, 4 				 # Comando para escrever no terminal.
	la $a0, menu_principal_5 # Carrega string (endereço).
	syscall
	
	li $v0, 4 				# Comando para escrever no terminal.
	la $a0, quebra_dupla 	# Carrega string (endereço).
	syscall

	li $v0, 4 				# Comando para escrever no terminal.
	la $a0, escolha 		# Carrega string (endereço).
	syscall

	li $v0, 4 				# Comando para escrever no terminal.
	la $a0, quebra		 	# Carrega string (endereço).
	syscall

	# lendo o inteiro referente a escolha do menu
	li $v0, 5				
	syscall
	move $s1, $v0
	
	beq $s1, 1, menu_entrada_dados
	beq $s1, 2, exibir_serie_dados
	beq $s1, 3, media_movel
	beq $s1, 4, tendencia
	beq $s1, 5, fim_programa
	
	li $v0, 4 				 # Comando para escrever no terminal.
	la $a0, menu_principal_6 # Carrega string (endereço).
	syscall
	
	j menu_principal

menu_entrada_dados:
	# escrevendo na tela as mensagens do menu
	li $v0, 4
	la $a0, entrada_dados_0
	syscall
	
	li $v0, 4
	la $a0, entrada_dados_1
	syscall
	
	# lendo o valor de N
	li $v0, 5
	syscall
	move $s0, $v0 # $s0 é N
	
	sw $s0, N
	
	# escrevendo na tela a mensagem
	li $v0, 4
	la $a0, entrada_dados_2
	syscall

	la $s2, dados 	# endereço dos dados

	# $t0 será um auxiliar p/ chamar a leitura N vezes
	addi $t0, $zero, 0

loop_leitura_dados:
	# chamando o loop para leitura dos dados
	j lendo_dados

lendo_dados:
	li $v0, 6
	syscall
	s.s $f0, ($s2)
	
	addi $s2, $s2, 4
	
	# incrementando auxiliar
	addi $t0, $t0, 1

	blt $t0, $s0, loop_leitura_dados

final_leitura:
	li $v0, 4
	la $a0, entrada_dados_3
	syscall
	
	j menu_principal
	
exibir_serie_dados:
	li $v0, 4
	la $a0, exibicao_dados_0
	syscall

	la $s2, dados

	# auxiliar para calcular os endereços
	addi $t0, $zero, 0

	loop_impressao:
		# $f2 armazena valores de Entradas
		l.s	$f2, 0($s2)
		
		# imprimindo os valores no console
		mov.s $f12, $f2
    	li $v0, 2
    	syscall

		# calculando o endereço absoluto p/ o próximo valor (se tiver)
		addi $s2, $s2, 4
		addi $t0, $t0, 1
		
		#subi $t1, $s0, 1
		beq $t0, $s0, final_exibir_serie_dados # p/ o último não imprimir a vírgula

		# imprimindo a vírgula
		li 	$v0, 4
		la	$a0, virgula
		syscall
		
		blt $t0, $s0, loop_impressao
	
final_exibir_serie_dados:
	li $v0, 4 		# Comando para escrever no terminal.
	la $a0, quebra	# Carrega string (endereço).
	syscall

	j menu_principal

media_movel:
	# chamando o procedimento para zerar o buffer
	jal zera_buffer
	
	# $s6 contem o endereço p/ as médias
	la $s6, buffer_tendencia_1
	
	# imprimindo os labels na tela
	li $v0, 4
	la $a0, calculo_mmn_0
	syscall
	
	li $v0, 4
	la $a0, calculo_mmn_1
	syscall
	
	# lendo o valor de n da MMn
	li $v0, 5				
	syscall
	move $s3, $v0

	# adicionando o n e o endereço do buffer das respostas p/ o procedimento usar	
	move $a0, $s3
	move $a1, $s6

	# chamando o procedimento que calcula as médias móveis
	jal calculadora_media_movel
	
	# endereços necessários p/ a impressão
	la $s2, dados
	la $s6, buffer_tendencia_1

	# $t1 = N (quantidade de elementos da entrada)
    la $s0, N
	lw $t1, 0($s0)
	
	# auxiliar p/ loop
	addi $t0, $zero, 0
	
	# loop p/ impressão do resultado
	loop_impressao_medias:
		# pegando o valor dos dados
		l.s	$f2, 0($s2)
		
		# imprimindo os valores no console
		mov.s $f12, $f2
    	li $v0, 2
    	syscall

		# imprimindo a quebra de linha
		li 	$v0, 4
		la	$a0, calculo_mmn_3
		syscall

		# pegando o valor dos resultados
		l.s	$f3, 0($s6)
		
		# imprimindo os valores no console
		mov.s $f12, $f3
    	li $v0, 2
    	syscall
		
		# imprimindo a quebra de linha
		li 	$v0, 4
		la	$a0, quebra
		syscall
		
		# calculando o endereço absoluto p/ o próximo elemento (se tiver)
		addi $s2, $s2, 4
		addi $s6, $s6, 4
		
		# incrementando auxiliar
		addi $t0, $t0, 1
		
		blt $t0, $t1, loop_impressao_medias
	
	j menu_principal

tendencia:
	# chamando o procedimento para zerar o buffer
	jal zera_buffer
	
	# $s6 e $s7 contem o endereço p/ as médias
	la $s6, buffer_tendencia_1
	la $s7, buffer_tendencia_2
	
	# escrevendo na tela as mensagens do menu
	li $v0, 4
	la $a0, tendencia_0
	syscall

	# escrevendo na tela as mensagens do menu
	li $v0, 4
	la $a0, tendencia_1
	syscall
		
	# lendo o valor de n da 1° MMn
	li $v0, 5				
	syscall
	move $t8, $v0

	# lendo o valor de n da 2° MMn
	li $v0, 5				
	syscall
	move $t9, $v0
	
	blt $t8, $t9, nao_troca_valores
	
	# troca os valores p/ $t8 ter sempre o menor valor
	move $t2, $t8
	move $t8, $t9
	move $t9, $t2
	
	nao_troca_valores:
		# adicionando o n e o endereço do buffer das respostas p/ o procedimento usar	
		move $a0, $t8
		move $a1, $s6

		# $s6 e $s7 contem o endereço p/ as médias
		la $s6, buffer_tendencia_1
		la $s7, buffer_tendencia_2
	
		# chamando o procedimento que calcula as médias móveis
		jal calculadora_media_movel

		# chamando o procedimento para zerar o buffer
		jal zera_buffer

		# adicionando o n e o endereço do buffer das respostas p/ o procedimento usar	
		move $a0, $t9
		move $a1, $s7

		# chamando o procedimento que calcula as médias móveis
		jal calculadora_media_movel
		
		# buffer dos dados
		la $s2, dados
	
		li $v0, 4 	
		la $a0, tendencia_2
		syscall

		li $v0, 1	
		move $a0, $t8
		syscall
	
		li $v0, 4 	
		la $a0, tendencia_3
		syscall
		
		li $v0, 1	
		move $a0, $t9
		syscall
	
		li $v0, 4 	
		la $a0, tendencia_4
		syscall
		
		# $t5 irá armazenar 1 quando a última transição entre as médias móveis 
		# foi de alta e 0 quando for de baixa
		addi $t5, $zero, 0
		
		# $t3 = N (quantidade de elementos da entrada)
   		la $s0, N
		lw $t3, 0($s0)
	
		# auxiliar p/ loop
		addi $t2, $zero, 0
		
		# percorrer os buffers printando as respostas
		loop_buffers_respostas:
			# carregando elemento dos buffers
			l.s $f0, 0($s2)
			l.s $f1, 0($s6)
			l.s $f2, 0($s7)
			
			# imprimindo os valores dos dados
			mov.s $f12, $f0
    		li $v0, 2
    		syscall
	
			li $v0, 4 	
			la $a0, tendencia_5
			syscall
			
			# imprimindo os valores do buffer-1
			mov.s $f12, $f1
    		li $v0, 2
    		syscall
			
			li $v0, 4 	
			la $a0, tendencia_5
			syscall

			# imprimindo os valores do buffer-2
			mov.s $f12, $f2
    		li $v0, 2
    		syscall
			
			li $v0, 4 	
			la $a0, tendencia_5
			syscall
		
			c.lt.s $f1, $f2
			bc1t primeiro_menor
			
			c.eq.s $f1, $f2
			bc1t constante
			
			c.lt.s $f2, $f1
			bc1t primeiro_maior
		
			primeiro_menor:				
				beq $t5, 0, constante
				j queda
					
			dois_iguais:
				bge $t5, 0, constante
				j constante
				
			primeiro_maior:
				beq $t5, 1, constante
				j alta
				
			queda:
				addi $t5, $zero, 0
				
				li $v0, 4 	
				la $a0, tendencia_baixa
				syscall
			
				j final_loop_buffers
				
			alta:				
				addi $t5, $zero, 1
				
				li $v0, 4 	
				la $a0, tendencia_alta
				syscall
				
				j final_loop_buffers
	
			constante:
				li $v0, 4 	
				la $a0, tendencia_constante
				syscall
			
				j final_loop_buffers
			
			final_loop_buffers:
				li $v0, 4 	
				la $a0, quebra
				syscall
			
				# calculando os endereços p/ o próximo elemento (se tiver)
				addi $s2, $s2, 4
				addi $s6, $s6, 4
				addi $s7, $s7, 4
		
				# incrementando auxiliar
				addi $t2, $t2, 1
		
				blt $t2, $t3, loop_buffers_respostas

	j menu_principal


# procedimento p/ zerar o buffer
zera_buffer:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $s4, buffer_media
	
	# auxiliar p/ o loop
	addi $t7, $zero, 0
	sub.s $f3, $f3, $f3
	
	# loop para zerar os valores do buffer novamente
	loop_zera_buffer:
		# atribuindo 0.0 ao buffer
		s.s $f3, ($s4)
		
		# próxima posição
		addi $s4, $s4, 4
		
		# incrementa auxiliar
		addi $t7, $t7, 1
		
		# 10 pq é o valor máximo do buffer
		blt $t7, 10, loop_zera_buffer
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# procedimento que calcula a média móvel para determinado N
calculadora_media_movel:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a0, 4($sp) # n
	sw $a1, 0($sp) # endereço do buffer p/ respostas
    
    # $t6 = N (quantidade de elementos da entrada)
    la $s0, N
	lw $t6, 0($s0)
	
	# $t7 = n (valor da média)
	move $t7, $a0
	
	# $s2 = dados
	la $s2, dados

	# convertendo o n da MMn p/ float p/ a divisão
	mtc1 $a0, $f5
	cvt.s.w $f5, $f5
	
	# auxiliar p/ loop
	addi $t0, $zero, 0
	
	# loop pelos elementos
	loop_elements:
		la $s4, buffer_media
		
		# auxiliar p/ loop		
		addi $t1, $zero, 1
		
		# auxiliar p/ as posições no buffer
		addi $t2, $t7, -2	# precisa fazer um tratamento p/ quando for menor que 3
		mul $t2, $t2, 4
		add $t2, $t2, $s4

		# loop p/ arrumar o buffer
		loop_buffer:
			# pegando o valor do buffer
			l.s	$f2, 0($t2)
			
			# colocando na próxima posição
			s.s $f2, 4($t2)
  
			# decremento a posição no buffer
			subi $t2, $t2, 4
			
			# incrementa auxiliar
			addi $t1, $t1, 1
		
			beq $t1, $t7, last_buffer_element
			blt $t1, $t7, loop_buffer
		
		# adicionando o próximo elemento no buffer que vai ser o próximo elemento dos dados
		last_buffer_element:
			# p/ sempre adicionar na 1° posição do buffer
			la $s4, buffer_media

			# pegando o valor dos dados
			l.s	$f2, 0($s2)

			# colocando na primeira posição
			s.s $f2, 0($s4)

		# auxiliar
		addi $t4, $zero, 0
		la $s4, buffer_media
	
		# auxiliar p/ armazenar a soma dos valores
		sub.s $f3, $f3, $f3

		calculando_media:
			l.s	$f2, 0($s4)
		
			add.s $f3, $f3, $f2
    		
			# calculando o endereço absoluto p/ o próximo valor (se tiver)
			addi $s4, $s4, 4
			
			# incrementando auxiliar
			addi $t4, $t4, 1
			
			blt $t4, $t7, calculando_media

		div.s $f3, $f3, $f5
		s.s $f3, ($a1)
				
		# calculando o endereço absoluto p/ o próximo elemento (se tiver)
		addi $s2, $s2, 4
		addi $a1, $a1, 4
    	   
		# incrementando auxiliar e vendo de chegou ao fim
		addi $t0, $t0, 1
		ble $t0, $t6, loop_elements

	lw $a1, 0($sp)
	lw $a0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra

fim_programa:
	la 	$a0, fim
	li	$v0, 4
	syscall
