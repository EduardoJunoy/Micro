;_______________________________________________________________
;DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
	informacion db 13, 10, "Pulsa una tecla:", 13, 10, '$'
	teclaErr db 13, 10, "Intentalo de nuevo, tecla no valida...", '$' 
	teclaQ db 13, 10, "Hasta luego!!", '$' 
	desinstalado db 13, 10, "Vectores desinstalados...", '$'
	;posicion inicial cuadrado azul
	posicionAzul db 50, 100 
	;posicion inicial cuadrado rojo
	posicionRojo db 200, 100
	;tecla almacenada en AL
	caracter db ?
DATOS ENDS

;_______________________________________________________________
;DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
	DB 40H DUP (0)
PILA ENDS

;_______________________________________________________________
;DEFINICION DEL SEGMENTO DE CODIGO 
CODE SEGMENT 
	ASSUME CS:CODE, DS:DATOS, SS:PILA

; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 
START PROC
	MOV AX, DATOS
	MOV DS, AX
	
	MOV AX, PILA
	MOV SS, AX
	
	MOV SP, 64
	
	;solicita al usuario que introduzca un tecla por pantalla
BUCLE:
	MOV AH, 9
	MOV DX, OFFSET informacion
	INT 21H
	
	MOV AH, 01
	INT 16H
	JNZ BUCLE
	
	;guardamos tecla introducida
	MOV AH, 00
	INT 16H
	
	MOV caracter, AL
	CALL VECTOR55
	;vector no esta instalado
	CMP AX, -1
	JE DRIVER_ERR
	;se ha ejecutado correctamente
	CMP AX, 1
	JE BUCLE
	
	MOV AL, caracter
	CALL VECTOR57
	;vector no esta instalado
	CMP AX, -1
	JE DRIVER_ERR
	;se ha ejecutado correctamente
	CMP AX, 1
	JE BUCLE
	
	;mientras que no se pulse 'q' el programa se sigue ejecutando
	MOV AL, caracter	
	CMP AL, 'q'
	JE TECLA_Q
	
	;puede que la tecla introducida no sea valida, vuelta a bucle
	MOV AH, 9
	MOV DX, OFFSET teclaErr
	INT 21H
	JMP BUCLE
	
TECLA_Q:	
	MOV AH, 9
	MOV DX, OFFSET teclaQ
	INT 21H
	JMP FIN
	
DRIVER_ERR:
	MOV AH, 9
	MOV DX, OFFSET desinstalado
	INT 21H
	
FIN:
	MOV AX, 4C00H
	INT 21H
START ENDP


;______________________________________________________________________________
;imprime cuadrado azul_________________________________________________________
VECTOR55 PROC
	;teclas relacionadas con jugador 1
	CMP AL, 'a'
	JE IZQUIERDA_55
	CMP AL, 'd'
	JE DERECHA_55
	CMP AL, 'w'
	JE ARRIBA_55
	CMP AL, 's'
	JE ABAJO_55
	;no ha encontrado las teclas asociadas a la interrupcion 55h
	JMP VECTOR55_FIN
	
	
IZQUIERDA_55:	
	SUB BYTE PTR posicionAzul[0], 10
	JMP VECTOR_55
DERECHA_55:	  
	ADD BYTE PTR posicionAzul[0], 10
	JMP VECTOR_55
ARRIBA_55:		
	SUB BYTE PTR posicionAzul[1], 10
	JMP VECTOR_55
ABAJO_55:		
	ADD BYTE PTR posicionAzul[1], 10
	JMP VECTOR_55

	
VECTOR_55:
	MOV AX, 0
	MOV ES, AX
	;controlamos que este instalado antes de llamar a la interrupcion
	MOV AX, ES:[55H*4]
	MOV BX, ES:[55H*4+2]
	AND AX, BX
	CMP AX, 0
	JE VECTOR55_ERR

	;llamada a interrupcion 55H (AL=X, AH=Y)
	MOV AL, posicionAzul[0]	;X
	MOV AH, posicionAzul[1]	;Y
	INT 55H

	;se ha ejecutado la interrupcion correctamente
	MOV AX, 1
	RET

VECTOR55_ERR:
	MOV AX, -1
VECTOR55_FIN:
	RET
VECTOR55 ENDP

;_____________________________________________________________________________
;imprime cuadrado rojo________________________________________________________
VECTOR57 PROC
	;teclas relacionadas con jugador 2
	CMP AL, 'j'
	JE IZQUIERDA_57
	CMP AL, 'l'
	JE DERECHA_57
	CMP AL, 'i'
	JE ARRIBA_57
	CMP AL, 'k'
	JE ABAJO_57
	;no ha encontrado las teclas asociadas a la interrupcion 57h
	JMP VECTOR57_FIN
	
IZQUIERDA_57:	
	SUB BYTE PTR posicionRojo[0], 10
	JMP VECTOR_57
DERECHA_57:		
	ADD BYTE PTR posicionRojo[0], 10
	JMP VECTOR_57
ARRIBA_57:		
	SUB BYTE PTR posicionRojo[1], 10
	JMP VECTOR_57
ABAJO_57:		
	ADD BYTE PTR posicionRojo[1], 10
	JMP VECTOR_57

	
VECTOR_57:
	MOV AX, 0
	MOV ES, AX
	;controlamos que este instalado antes de llamar a la interrupcion
	MOV AX, ES:[57H*4]
	MOV BX, ES:[57H*4+2]
	AND AX, BX
	CMP AX, 0
	JE VECTOR57_ERR

	;llamada a interrupcion 57H (AL=X, AH=Y)
	MOV AL, posicionRojo[0]	
	MOV AH, posicionRojo[1]	
	INT 57H

	;se ha ejecutado la interrupcion correctamente
	MOV AX, 1
	RET

VECTOR57_ERR:
	MOV AX, -1
VECTOR57_FIN:
	RET
VECTOR57 ENDP

;_____________________________________________________________________________
;_____________________________________________________________________________

CODE ENDS
END START