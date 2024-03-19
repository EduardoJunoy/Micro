;_______________________________________________________________
; DEFINICION DEL SEGMENTO DE CODIGO 
codigo SEGMENT 
	ASSUME cs: codigo
	
	ORG 256
	
inicio: jmp comienzo

	;variables globales
	vector55Ok db 13, 10, "vector 55h esta instalado", '$'
	vector55Err db 13, 10, "vector 55h esta desinstalado", '$'
	vector57Ok db 13, 10, "vector 57h esta instalado", '$'
	vector57Err db 13, 10, "vector 57h esta desinstalado", '$'
	informacion db 13, 10, "X", 13, 10, "Instrucciones:", 13, 10, "-Escribe /I para instalar el driver // Escribe /D para desinstalar", 13, 10, '$'
	modoVideo db 0
	;variable temporal que almacena las posiciones de X e Y
	temporal db 0, 0
	aux1 dw 0
	aux2 dw 0


	;calcular parametros de entrada
comienzo:	
	MOV SI, 80H
	MOV CX, 0
	
	;si es 0 no hay parametros de entrada
	MOV CL, [SI]
	CMP CX, 0
	JE NO_PARAMETROS
	
	;si el primer parametro es distinto de '/' salta a fin
	ADD SI, 2
	MOV CL, [SI]
	CMP CL, '/'	
	JNE FIN
	
	INC SI
	MOV CL, [SI]
	
	;si es 'I' salta a instalacion, si es 'D' salta a desinstalacion
	CMP CL, 'I'
	JE INSTALACION
	CMP CL, 'D'	
	JE DESINSTALACION
	JMP FIN
	
	;calcula el estado actual
NO_PARAMETROS:
	CALL ESTADO_INSTALACION
	JMP FIN
	
	;llama a rutina instaladora si usuario introduce /I 
INSTALACION:
	CALL INSTALAR
	JMP FIN

	;llama a rutina desinstaladora si usuario introduce /D
DESINSTALACION:
	CALL DESINSTALAR
	JMP FIN

	;final del programa
FIN:
	MOV AX, 4C00H
	INT 21H


;________________________________________________________________________________
;------------------------------rutina vector 55h---------------------------------
;imprime cuadrado azul 10*10 pixeles a partir de posicion AL (X) y AH(Y)
AZUL PROC 
	;guardamos coordenadas en temporal
	MOV temporal[0], AL
	MOV temporal[1], AH
	
	;interrupcion para entrar en modo video
	MOV AH, 0FH
	INT 10H
	MOV modoVideo, AL
	;configuramos entrada a modo video
	MOV AH, 00
	MOV AL, 0DH
	INT 10H
	;configuramos color de fondo blanco
	MOV AH, 0BH
	MOV BH, 00H
	;color blanco
	MOV BL, 0FH
	INT 10H
	
	
	MOV aux1, 0
BUCLE1_AZUL:
	MOV aux2, 0
BUCLE2_AZUL:
	;pintamos de color azul
	MOV AH, 0CH
	MOV AL, 01H
	;numero de pagina (a cero)
	MOV BH, 00H
	
	;posicion X donde pintar
	MOV CX, 0
	MOV CL, temporal[0]
	ADD CX, aux1
	
	;posicion Y donde pintar
	MOV DX, 0
	MOV DL, temporal[1]
	ADD DX, aux2
	INT 10H
	
	INC aux2
	MOV CX, aux2
	CMP CX, 10
	JNGE BUCLE2_AZUL
	
	INC aux1
	MOV CX, aux1
	CMP CX, 10
	JNGE BUCLE1_AZUL
	
	
	;espera activa en microsegundos
	MOV CX, 2DH
	MOV DX, 0C6C0H
	MOV AH, 86H
	INT 15H
	;restaurar configuracion de entrada
	MOV AH, 00H
	MOV AL, modoVideo
	INT 10H
		
	IRET
AZUL ENDP


;________________________________________________________________________________
;------------------------------rutina vector 57h---------------------------------
;imprime cuadrado rojo 10*10 pixeles a partir de posicion AL (X) y AH(Y)
ROJO PROC 
	;guardamos coordenadas en temporal
	MOV temporal[0], AL
	MOV temporal[1], AH
	
	;interrupcion para entrar en modo video
	MOV AH, 0FH
	INT 10H
	MOV modoVideo, AL
	;configuramos entrada a modo video
	MOV AH, 00
	MOV AL, 0DH
	INT 10H
	;configuramos color de fondo blanco
	MOV AH, 0BH
	MOV BH, 00H
	;color blanco
	MOV BL, 0FH
	INT 10H
	
	
	MOV aux1, 0
BUCLE1_ROJO:
	MOV aux2, 0
BUCLE2_ROJO:
	;pintamos de color rojo
	MOV AH, 0CH
	MOV AL, 04H
	;numero de pagina (a cero)
	MOV BH, 00H
	
	;posicion X donde pintar
	MOV CX, 0
	MOV CL, temporal[0]
	ADD CX, aux1
	
	;posicion Y donde pintar
	MOV DX, 0
	MOV DL, temporal[1]
	ADD DX, aux2
	INT 10H
	
	INC aux2
	MOV CX, aux2
	CMP CX, 10
	JNGE BUCLE2_ROJO
	
	INC aux1
	MOV CX, aux1
	CMP CX, 10
	JNGE BUCLE1_ROJO
	
	
	;espera activa en microsegundos
	MOV CX, 2DH
	MOV DX, 0C6C0H
	MOV AH, 86H
	INT 15H
	;restaurar configuracion de entrada
	MOV AH, 00H
	MOV AL, modoVideo
	INT 10H
		
	IRET
ROJO ENDP

;________________________________________________________________________________
;--------------------------desinstalar vector 55h/57h----------------------------
DESINSTALAR PROC 
	PUSH AX BX CX DS ES
	
	MOV CX, 0
	MOV DS, CX
	
	;desinstalacion de azul
	MOV ES, DS:[55H*4+2]
	MOV BX, ES:[2CH]
	
	MOV AH, 49H
	INT 21H
	MOV ES, BX
	INT 21H
	
	CLI
	MOV DS:[55H*4], CX
	MOV DS:[55H*4+2], CX
	STI
	
	;desinstalacion de rojo
	MOV ES, DS:[57H*4+2]
	MOV BX, ES:[2CH]
	
	MOV AH, 49H
	INT 21H
	MOV ES, BX
	INT 21H
	
	CLI
	MOV DS:[57H*4], CX
	MOV DS:[57H*4+2], CX
	STI
	
	POP ES DS CX BX AX
	RET
ENDP DESINSTALAR


;______________________________________________________________________________
;---------------------------instalar vector 55h/57h----------------------------
INSTALAR PROC
	MOV AX, 0
	MOV ES, AX
	MOV BX, CS
	
	;deja residentes las rutinas asociadas a las interrupciones correspondientes
	MOV AX, OFFSET AZUL
	
	CLI
	MOV ES:[55H*4], AX
	MOV ES:[55H*4+2], BX
	STI
	
	MOV AX, OFFSET ROJO
	
	CLI 
	MOV ES:[57H*4], AX
	MOV ES:[57H*4+2], BX
	STI
	
	MOV DX, OFFSET INSTALAR
	INT 27H
INSTALAR ENDP

;________________________________________________________________________________________
;comprueba el estado de instalacion en caso de haber ejecutado el programa sin parametros
ESTADO_INSTALACION PROC 
	
	;imprime el autor y las instrucciones de uso
	MOV AH, 9
	MOV DX, OFFSET informacion
	INT 21H
	
	MOV AX, 0
	MOV ES, AX
COMPROBAR_55:	
	;comprobar que el vector55 este instalado 
	MOV AX, ES:[55H*4]
	MOV BX, ES:[55H*4+2]
	CMP AX, 0
	JNE INSTALADO_55
	CMP BX, 0
	JNE INSTALADO_55
	
	;indica que esta desinstalado
	MOV AH, 9
	MOV DX, OFFSET vector55Err
	INT 21H
	JMP COMPROBAR_57

INSTALADO_55:
	MOV AH, 9
	MOV DX, OFFSET vector55Ok
	INT 21H


COMPROBAR_57:
	;comprobar que el vector57 este instalado
	MOV AX, ES:[57H*4]
	MOV BX, ES:[57H*4+2]
	CMP AX, 0
	JNE INSTALADO_57
	CMP BX, 0
	JNE INSTALADO_57
	
	;indica que esta desinstalado
	MOV AH, 9
	MOV DX, OFFSET vector57Err
	INT 21H
	JMP FIN_ESTADO
		
INSTALADO_57:
	MOV AH, 9
	MOV DX, OFFSET vector57Ok
	INT 21H
	JMP FIN_ESTADO


FIN_ESTADO:
	RET
ESTADO_INSTALACION ENDP


codigo ENDS
END inicio
	