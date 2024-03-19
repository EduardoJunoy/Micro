;**************************************************************************
; SBM 2023. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
;Reservar memoria para una variable, VIVA_SBM2023, de un byte de tamaño.
VIVA_SBM2023 DB ?
;Reservar memoria para una variable, BEBA, de dos bytes de tamaño,
;e inicializarla con el valor CAFEH
BEBA DW 0CAFEH
;Reservar 300 bytes para una tabla llamada TABLA300
TABLA300 DB 300 DUP ?
;Guardar en memoria la cadena de texto “Este programa se cuelga siempre.”, de nombre
;ERRORTOTAL2, para agilizar la salida de mensajes en un programa de corrección
;automática de prácticas.
ERRORTOTAL2 DB "Este programa se cuelga siempre."
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
;Copiar el segundo carácter de la cadena ERRORFATAL2 en la posición 63H de TABLA300
MOV AH, ERRORTOTAL2[2]
MOV TABLA300[63H], AH
;Copiar el contenido de la variable BEBA a partir de la posición 4 de TABLA300
;Se introduce EFAC
MOV AX, BEBA
MOV TABLA300[4], AH
MOV TABLA300[5], AL
;Copiar el byte más significativo de BEBA a la variable VIVA_SBM2023 
MOV VIVA_SBM2023, AH
; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO