;**************************************************************************
;SISTEMAS BASADOS EN MICROPROCESADORES 2291
;PRÁCTICA 2
;EDUARDO JUNOY ORTEGA
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
VECTOR1 DB 1,2,2,4
VECTOR2 DB 4,2,5,1
VECTOR3 DB 3,2,4,1
TEXTO1 DB "No válido.Repetición", 13, 10, "$"
TEXTO2 DB "No válido. Números diferentes 1-4", 13, 10, "$"
TEXTO3 DB "Correcto", 13, 10, "$"
COUNT1 DB 1
COUNT2 DB 1
BUFFER DB,  6, 0, 6 DUP ("$"), "$"
TEXTO DB "Ingrese un texto por pantalla", "$"
SALTODELINEA DB 0Ah, 0Dh, "$"
DATOS ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0
PILA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO EXTRA
EXTRA SEGMENT
RESULT DW 0,0 ;ejemplo de inicialización. 2 PALABRAS (4 BYTES)
EXTRA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
INICIO PROC
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV AX, DATOS
MOV DS, AX
MOV AX, PILA
MOV SS, AX
MOV AX, EXTRA
MOV ES, AX
MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO
; FIN DE LAS INICIALIZACIONES
; COMIENZO DEL PROGRAMA
;Datos proporcionados:

;REGISTROS
;AX: operaciones
;BX: guardar resultados offset o commparador
;CX: contador
;DX: general
;SI y DI: apuntadores, guarda valores (para arrays)
;SP: pila
;SS: segmento de pila
;DS: segmento de datos
;ES: segmento extra
;CS: segmento de código

MOV CX, 4

CALL BUCLE1
JMP FIN

INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
;PROCEDIMIENTOS
BUCLE1:
	DEC CX
	CMP CX, 0
	JE FIN
	BUCLE2:
		CMP COUNT1, 3						;comapara i con 3
		JE BUCLE1
		CMP VECTOR1[CX], VECTOR1[CX-COUNT1]	;compara C[3] y C[3-i]
		JE MOSTRARTEXTO1					;MENSAJE DE ERROR
		INC COUNT1							;i++
		JMP BUCLE2

MOSTRARTEXTO1:

; Si DS es el segmento donde está el texto a imprimir:
	MOV DX, offset TEXTO1	; DX : offset al inicio del texto a imprimir
	MOV AH, 9 				; Número de función = 9 (imprimir string)
	INT 21H 				; Ejecuta el servicio del sistema operativo

MOSTRARTEXTO2:

; Si DS es el segmento donde está el texto a imprimir:
	MOV DX, offset TEXTO2	; DX : offset al inicio del texto a imprimir
	MOV AH, 9 				; Número de función = 9 (imprimir string)
	INT 21H 				; Ejecuta el servicio del sistema operativo

MOSTRARTEXTO3:

; Si DS es el segmento donde está el texto a imprimir:
	MOV DX, offset TEXTO3	; DX : offset al inicio del texto a imprimir
	MOV AH, 9 				; Número de función = 9 (imprimir string)
	INT 21H 				; Ejecuta el servicio del sistema operativo

;Muestra el caracter "a" por pantalla
MOSTRAR_A:
	MOV AH, 02h
	MOV DL, 'a'
	INT 21h
	
;Muestra el 0 en ASCII = 30h = "0"
MOSTRAR_0:
	MOV AH, 02h
	MOV DL, 30h
	INT 21h
	
;Muestra el string leido por pantalla
MOSTRAR_TEXTO:
	MOV AH, 09h
	MOV DX, offset TEXTO
	INT 21h
	
;Muestra el string salto de linea por pantalla
MOSTRAR_SALTODELINEA:
	MOV AH, 09h
	MOV DX, offset SALTODELINEA
	INT 21h
	
;Lee un string por pantalla
LEER_STRING:
	MOV AH, 0Ah 
	MOV DX, offset BUFFER
	INT 21h
	
;Limpia la pantalla
LIMPIAR_PANTALLA:
	MOV AX, 03h
	INT 10h
	
;Muestra el string leido por pantalla
MOSTRAR_STRING:
	MOV AH, 09h
	MOV DX, offset BUFFER
	ADD DX, 2
	
;FIN DEL PROGRAMA
FIN:
	MOV AX, 4C00H
	INT 21H

CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 