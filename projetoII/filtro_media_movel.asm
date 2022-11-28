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
	
	# labels para a entrada de dados
	entrada_dados_0: .asciiz "\n============================\nENTRADA DE DADOS\n============================"
	entrada_dados_1: .asciiz "\nInforme o valor de N:\n"
	entrada_dados_2: .asciiz "\nInforme 1 entrada por vez:\n"
	entrada_dados_3: .asciiz "Dados armazenados com sucesso!\n"
	
	# labels para a exibição dos dados
	exibicao_dados_0: .asciiz "\n============================\nSÉRIE DE DADOS\n\n"
	
	# labels para o calculo de MM-n
	calculo_mmn_0: .asciiz "\n============================\nMÉDIA MÓVEL\n============================"
	calculo_mmn_1: .asciiz "\nInforme o tamanho da média móvel:\n"
	calculo_mmn_2: .asciiz "\nCotação | MM-:"
	calculo_mmn_3: .asciiz " | "
	
	
	# buffer p/ armazenar os dados
	.align 2
	dados: .float
	
	# buffer result
	.align 3
	buffer_result: .float

	# buffer p/ calcular a média móvel de N
	.align 2
	float_1: .float 1.0
	
	.align 2
	float_2: .float
	
	

.text
	la $s2, dados 		# endereço dos dados	

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
	li $v0, 7
	syscall
	s.s $f0, ($s2)
	
	addi $s2, $s2, 8
	
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
	# $t3 = ponteiro pra Entradas
	move	$t3, $s2

	# auxiliar para calcular os endereços
	addi $t0, $zero, 0

	loop_impressao:
		# $f2 armazena valores de Entradas
		l.s	$f2, 0($t3)
	
		# imprimindo os valores na tela
		#li $v0, 3	
		#l.d $f12, ($s2)
		#syscall
		
		mov.s $f12, $f2
    	li $v0, 2
    	syscall

		# calculando o endereço absoluto p/ o próximo valor (se tiver)
		addi $s2, $s2, 8
		addi $t0, $t0, 1
		
		#subi $t1, $s0, 1
		beq $t0, $s0, final_exibir_serie_dados # p/ o último não imprimir a vírgula

		# imprimindo a vírgula
		li 	$v0, 4
		la	$a0, virgula
		syscall
		
		blt $t0, $s0, loop_impressao
	
final_exibir_serie_dados:
	j menu_principal

media_movel:
	# imprimindo os labels na tela
	li $v0, 4
	la $a0, calculo_mmn_0
	syscall
	
	li $v0, 4
	la $a0, calculo_mmn_1
	syscall
	
	li $v0, 7
	syscall
	s.d $f0, float_2 # $f2 é o n da MM-n

	l.s $f0, dados 	# endereço dos dados
	l.s $f1, float_1 # float que vale 1
	l.s $f2, float_2
	l.s $f3, buffer_result
	
	# auxiliar p/ qtd de loops 
	addi $t0, $zero, 0

	li $v0, 2
	la $a0, buffer_result
	syscall
	
