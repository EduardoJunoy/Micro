;Programa 2: P4B2.asm
;Realiza un programa .EXE que pruebe el funcionamiento del programa residente anterior.
;El programa debe solicitar e imprimir los strings a modificar y los strings modificados.
;Cuando se reciba la instrucción "quit" el programa deberá finalizar.
;Realice la impresión de caracteres en pantalla a un ritmo de 2 caracteres por segundo. Para ello haga uso de la rutina int 1Ch.

;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
CADENA DB "INTRODUCE UNA CADENA: ", '$'
SALTO DB 13, 10, '$'
CADENA2 DB "LA CADENA SIN VOCALES ES: ", '$'
CADENA3 DB "Saliendo...", '$'
NOMBRE DB 80 DUP (?)
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
ETIQ1:

MOV AH, 9
MOV DX, OFFSET CADENA
INT 21H

MOV AH, 0AH
MOV DX, OFFSET NOMBRE
MOV NOMBRE[0], 60
INT 21H

MOV AH, 9
MOV DX, OFFSET SALTO
INT 21H

MOV AH, 9
MOV DX, OFFSET CADENA2
INT 21H

MOV BX, OFFSET NOMBRE
MOV AH, 13H
INT 61H

MOV AH, 9
MOV DX, OFFSET SALTO
INT 21H

CMP AX, 4
JE FIN
JMP ETIQ1
; FIN DEL PROGRAMA
FIN:
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO