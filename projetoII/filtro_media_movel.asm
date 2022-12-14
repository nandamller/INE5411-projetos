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
	menu_principal_5: .asciiz "\nEscolha inválida!\n"
	
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
	tendencia_4: .asciiz " | MM-"
	tendencia_5: .asciiz " | Tendência\n"
	tendencia_6: .asciiz " | "
	
	# valor de elementos
	N: .word 0

	# buffer p/ armazenar os dados
	.align 2
	dados: .float 0 0 0 0 0 0 0 0 0 0
	
	# buffer p/ auxiliar no cálculo da média móvel
	.align 2
	buffer_media: .float 0 0 0 0 0 0 0 0 0 0

	# vai conter a média móvel
	.align 2
	media: .float 0

	# buffer p/ calcular a média móvel de N
	.align 2
	float_1: .float 1.0
	
	# auxiliar p/ calcular a média móvel de N
	.align 2
	float_2: .float 0.0

.text
	# $s0 é usado p/ o valor de N elementos
	# $s1 é usado p/ a escolha no menu
	la $s2, dados 		# endereço dos dados	
	# $s3 é usado p/ o valor de n na MMn
	la $s4, buffer_media
	la $s5, media

main:

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
	
	li $v0, 4 				 # Comando para escrever no terminal.
	la $a0, menu_principal_5 # Carrega string (endereço).
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
	la $s0, N
	lw $t6, 0($s0)
    	
	la $s2, dados
	la $s4, buffer_media
	
	# $f2 armazena valores de Entradas
	l.s	$f2, 0($s2)
	
	# auxiliar p/ o loop
	addi $t2, $zero, 0
	sub.s $f3, $f3, $f3
	
	# loop para zerar os valores do buffer novamente
	loop_zera_buffer:
		s.s $f3, ($s4)
		
		addi $s4, $s4, 4
		
		# incrementa auxiliar
		addi $t2, $t2, 1
		
		blt $t2, $t0, loop_zera_buffer
	
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
	
	# convertendo o N p/ float p/ a divisão
	mtc1 $s3, $f5
	cvt.s.w $f5, $f5
	
	# auxiliar p/ loop
	addi $t0, $zero, 0
	
	# loop pelos elementos
	loop_elements:
		la $s4, buffer_media
		
		# auxiliar p/ loop		
		addi $t1, $zero, 1
		
		# auxiliar p/ as posições no buffer
		addi $t2, $s3, -2	# precisa fazer um tratamento p/ quando for menor que 3
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
		
			beq $t1, $s3, last_buffer_element
			blt $t1, $s3, loop_buffer
		
		# adicionando o próximo elemento no buffer que vai ser o próximo elemento dos dados
		last_buffer_element:
			# p/ sempre adicionar na 1° posição do buffer
			la $s4, buffer_media

			# pegando o valor dos dados
			l.s	$f2, 0($s2)

			# colocnado na próxima posição
			s.s $f2, 0($s4)

		# auxiliar
		addi $t4, $zero, 0
		la $s4, buffer_media
	
		# buffer p/ armazenar a soma dos valores
		sub.s $f3, $f3, $f3

		calculando_media:
			l.s	$f2, 0($s4)
		
			add.s $f3, $f3, $f2
			
			# calculando o endereço absoluto p/ o próximo valor (se tiver)
			addi $s4, $s4, 4
			
			addi $t4, $t4, 1
			
			# ñ está genérico, só p/ teste
			blt $t4, $s3, calculando_media
	
			
		# imprimindo escrita
		li 	$v0, 4
		la	$a0, calculo_mmn_2
		syscall
		
		# imprimindo o n 
		li 	$v0, 1
		move $a0, $s3
		syscall
		
		# imprimindo a quebra de linha
		li 	$v0, 4
		la	$a0, quebra
		syscall
		
		div.s $f3, $f3, $f5
		
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
	
		# incrementando auxiliar e vendo de chegou ao fim
		addi $t0, $t0, 1
		blt $t0, $t6, loop_elements
		beq $t0, $t6, end_loop_elements
		
	end_loop_elements:
		j menu_principal

# procedimento que calcula a média móvel para determinado N
calculadora_media_movel:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a0, 4($sp) 	# n
	sw $a1, 0($sp)	# elemento
    
	la $s4, buffer_media
	la $s5, media
	move $t8, $a0
		
	la $s4, buffer_media
	
	# auxiliar p/ loop		
	addi $t3, $zero, 1
		
	# auxiliar p/ as posições no buffer
	addi $t2, $t8, -2	# precisa fazer um tratamento p/ quando for menor que 3
	mul $t2, $t2, 4
	add $t2, $t2, $s4

	# loop p/ arrumar o buffer
	loop_buffer_proc:
		# pegando o valor do buffer
		l.s	$f2, 0($t2)
    		
		# colocando na próxima posição
		s.s $f2, 4($t2)
  
		# decremento a posição no buffer
		subi $t2, $t2, 4
			
		# incrementa auxiliar
		addi $t3, $t3, 1
		
		beq $t3, $t8, last_buffer_element_proc
		blt $t3, $t8, loop_buffer_proc
		
	# adicionando o próximo elemento no buffer que vai ser o próximo elemento dos dados
	last_buffer_element_proc:
		# p/ sempre adicionar na 1° posição do buffer
		la $s4, buffer_media

		# pegando o valor dos dados
		l.s	$f2, 0($a1)

		# colocnado na próxima posição
		s.s $f2, 0($s4)

	# auxiliar
	addi $t4, $zero, 0
	la $s4, buffer_media
	
	# buffer p/ armazenar a soma dos valores
	sub.s $f3, $f3, $f3

	calculando_media_proc:
		l.s	$f2, 0($s4)
    
		add.s $f3, $f3, $f2
   		
		# calculando o endereço absoluto p/ o próximo valor (se tiver)
		addi $s4, $s4, 4
			
		addi $t4, $t4, 1

		blt $t4, $t8, calculando_media_proc
	
	# convertendo o N p/ float p/ a divisão
	mtc1 $t8, $f5
	cvt.s.w $f5, $f5

	div.s $f3, $f3, $f5
	s.s $f3, ($s5) # salvando o valor da media em $s5

	lw $a1, 0($sp)
	lw $a0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra

tendencia:
	la $s4, buffer_media
	
	# auxiliar p/ o loop
	addi $t2, $zero, 0
	sub.s $f2, $f2, $f2
	
	# loop para zerar os valores do buffer novamente
	loop_zera_buffer_tendencia:
		s.s $f2, ($s4)
		
		addi $s4, $s4, 4
		
		# incrementa auxiliar
		addi $t2, $t2, 1
		
		blt $t2, $t0, loop_zera_buffer_tendencia

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
	move $t0, $v0

	# lendo o valor de n da 2° MMn
	li $v0, 5				
	syscall
	move $t1, $v0

	blt $t0, $t1, antes_loop_elements_tendencia
	
	# troca os valores p/ $t0 ter sempre o menor valor
	move $t2, $t0
	move $t0, $t1
	move $t1, $t2
	
	# setando os auxiliares que vou precisa
	antes_loop_elements_tendencia:
		la $s0, N
		lw $t6, 0($s0)
		
		la $s2, dados
		la $s5, media
		
		# auxiliar p/ o loop
		addi $t5, $zero, 0
	
		# auxiliar
		addi $t3, $zero, 1
	
	loop_elements_tendencia:
		move $a0, $t0
		la $a1, ($s2)
		jal calculadora_media_movel		
		
		# contem a media p/ o menor n
		l.s $f1, ($s5)

		#move $a0, $t1
		#la $a1, ($s2)
		#jal calculadora_media_movel		
		
		# convertendo o N p/ float p/ a divisão
		mtc1 $t0, $f5
		cvt.s.w $f5, $f5

		# contem a media p/ o maior n
		mul.s $f2, $f1, $f5
		
		# convertendo o N p/ float p/ a divisão
		mtc1 $t1, $f5
		cvt.s.w $f5, $f5
	
		# dividindo a média
		div.s $f2, $f2, $f5
	
		# impressão do resultado
		# imprimindo a quebra de linha
		li 	$v0, 4
		la	$a0, quebra
		syscall
	
		# imprimindo os valores no console
		mov.s $f12, $f1
   	 	li $v0, 2
    	syscall
    	
    	# imprimindo a vírgula
		li 	$v0, 4
		la	$a0, virgula
		syscall

    	# imprimindo os valores no console
		mov.s $f12, $f2
   	 	li $v0, 2
    	syscall
    	
    	# imprimindo a quebra de linha
		li 	$v0, 4
		la	$a0, quebra
		syscall
    	
    	# se $f1 menor ou igual a $f2
    	#c.le.s $f1, $f2
    	#bc1t compara_menor
    	
    	#compara_menor:
    	#	beq $t3, 1, constante
    		
    		# baixa
    		# seta t3 p/ 0
    	
    	#constante:
    	#baixa:
    	#alta:
     
		# incrementando auxiliar
		addi $t5, $t5, 1
		blt $t5, $t6, loop_elements_tendencia

end_tendencia:
	j menu_principal
