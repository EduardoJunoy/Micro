;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
VECTOR1 DB 1,2,2,5,4,6,7
VECTOR2 DB 1,2,9,4,5,6,7
VECTOR3 DB 5,7,6,3,2,4,1
TEXTO1 DB "->No valido", 13, 10, '$'
TEXTO2 DB "->Correcto", 13, 10, '$'
TEXTO3 DB "Repeticion numero=", 13, 10, '$'
TEXTO4 DB "Numero fuera de rango=", 13, 10, '$'
CADENA1 DB 10 DUP (0)
VECTOR_SIZE EQU 6
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
CALL VECTOR_TO_CADENA
CALL PRINT_CADENA
LEA BX, VECTOR1
CALL REP_CMP

CALL VECTOR_TO_CADENA
CALL PRINT_CADENA
LEA BX, VECTOR2
CALL RANGE

; FIN DEL PROGRAMA
FIN:
MOV AX, 4C00H
INT 21H
INICIO ENDP
REP_CMP PROC NEAR
MOV CX, VECTOR_SIZE
LOOP_INIT:
PUSH CX
MOV SI, 0
MOV DL, VECTOR1[BX][SI]
INC SI
LOOP_CMP:
MOV DH, VECTOR1[BX][SI]
CMP DL, DH
JE TEXTO1_PRINT
INC SI
LOOP LOOP_CMP
POP CX
INC BX
LOOP LOOP_INIT
RET
REP_CMP ENDP

RANGE PROC NEAR
MOV CX, 7
MOV SI, 0
LOOP_RANGE:
MOV DL, VECTOR2[BX][SI]
CMP DL, 8
JG TEXTO1_PRINT
CMP DL, 0
JL TEXTO1_PRINT
INC SI
LOOP LOOP_RANGE
RET
RANGE ENDP

VECTOR_TO_CADENA PROC NEAR
MOV CX, 7
LEA BX, VECTOR1
MOV SI, 0
MOV DI, 0
LOOP_CADENA:
LEA BX, VECTOR1
MOV BL, VECTOR1[BX][SI]
CALL INT_TO_ASCII
MOV CADENA1[DI], BL
INC SI
INC DI
LOOP LOOP_CADENA
RET
VECTOR_TO_CADENA ENDP

INT_TO_ASCII PROC NEAR
ADD BL, 30H
MOV DX, DS
MOV AX, SI
RET
INT_TO_ASCII ENDP

PRINT_CADENA PROC NEAR
MOV CADENA1[8], 13
MOV CADENA1[9], 10
MOV CADENA1[10], '$'
MOV DX, OFFSET CADENA1
MOV AH, 9
INT 21H
RET
PRINT_CADENA ENDP

TEXTO1_PRINT:
POP CX
CALL PRINT_TEXTO1

PRINT_TEXTO1 PROC NEAR
POP CX
MOV DX, OFFSET TEXTO1
MOV AH, 9
INT 21H
RET
PRINT_TEXTO1 ENDP

TEXTO2_PRINT:
CALL PRINT_TEXTO2

PRINT_TEXTO2 PROC NEAR
MOV DX, OFFSET TEXTO2
MOV AH, 9
INT 21H
RET
PRINT_TEXTO2 ENDP

TEXTO3_PRINT:
CALL PRINT_TEXTO3

PRINT_TEXTO3 PROC NEAR
MOV DX, OFFSET TEXTO3
MOV AH, 9
INT 21H
RET
PRINT_TEXTO3 ENDP

TEXTO4_PRINT:
CALL PRINT_TEXTO4

PRINT_TEXTO4 PROC NEAR
MOV DX, OFFSET TEXTO4
MOV AH, 9
INT 21H
RET
PRINT_TEXTO4 ENDP

; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO