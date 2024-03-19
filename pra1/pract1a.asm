;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
;-- rellenar con los datos solicitados
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
MOV AX, 4BB4H
;Cargar CFH en BH 
MOV BH, 0CFH
;Cargar 3412H en DX 
MOV DX, 3412H
;Cargar -23 en BL 
MOV BL, -23
;Cargar 11001011b en ES 
MOV DX, 0CBH
MOV ES, DX
;Cargar FABAH en DS 
MOV DX, 0FABAH
MOV DS, DX
;Cargar el contenido de DX en [BX]+15
MOV DS:[BX]+15, DX
;Cargar en DH el contenido de la posición de memoria 51222H y 
;en DL en contenido de la posición 51223H 
MOV AX, 5000H
MOV DS, AX
MOV DH, DS:[1222H]
MOV DL, DS:[1223H]
;Cargar en la posición de memoria 70007H el contenido de DH
MOV AX, 7000H
MOV DS, AX
MOV BYTE PTR DS:[0007H], DH
;Cargar en AX el contenido de la dirección de memoria apuntada por SI 
MOV AX, DS:[SI]
;Cargar en BX el contenido de la dirección de memoria que está
;10B por encima de la dirección apuntada por BP 
MOV BX, DS:[BP]+10
; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 