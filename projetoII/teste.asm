# esse loop acontece p/ cada elemento
	loop_elements:
		# auxiliar p/ imitar um buffer
		addi $t1, $zero, 0

		# auxiliar p/ a qtd de loops
		sub.s $f3, $f3, $f3

		# $f0 irá conter a soma dos valores
		sub.s $f0, $f0, $f0

		loop_media:
			# calculando endereço absoluto
			add $t3, $t1, $a1
			
			l.d $f4, ($t3)
			
			# somando os valores
			add.d $f0, $f0, $f4 
			
			# p/ pegar as posições anteriores			
			subi $t1, $t1, 8

			# caso $t1 seja negativo os outros valores devem ser 0
			ble $t1, 0, final_media
			
			add.d $f3, $f3, $f1
			
			# se for igual seta True
			c.eq.d $f3, $f2
			# se for True vai p/ final
			bc1t final_media
			
			j loop_media
			
		final_media:
			div.d $f0, $f0, $f2
			
			s.d $f0, result
			
			# imprimindo os valores na tela
			li $v0, 3 	
			l.d $f12, result	
			syscall
			
		# calculando o endereço p/ o próximo valor (se tiver)
		addi $a1, $a1, 8
		addi $t0, $t0, 1

		blt $t0, $s0, loop_elements