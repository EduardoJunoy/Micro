; P4B2.asm

.DATA
PROMPT DB "INTRODUCE UNA CADENA: ", '$'
RESULT DB "LA CADENA SIN VOCALES ES: ", '$'
QUIT_MSG DB "quit", '$'
BUFFER DB 256 DUP (?)

.CODE
START:
    MOV AX, @data
    MOV DS, AX

; Solicitar cadena
PROMPT_USER:
    LEA DX, PROMPT
    MOV AH, 9
    INT 21H

    LEA DX, BUFFER
    MOV AH, 0Ah
    INT 21H

; Verificar si es "quit"
    LEA SI, BUFFER + 2
    LEA DI, QUIT_MSG
    MOV CX, 4
    REPE CMPSB
    JE END_PROGRAM

; Llamar a la función TSR para eliminar vocales
    LEA DX, BUFFER + 2
    MOV AH, 13H
    INT 61H

; Imprimir cadena modificada
    LEA DX, RESULT
    MOV AH, 9
    INT 21H

    LEA SI, BUFFER + 2
PRINT_LOOP:
    MOV AH, 2
    LODSB
    CMP AL, '$'
    JE PROMPT_USER

    INT 21H
    MOV CX, 65535 / 2 ; Demora aproximadamente 0.5 segundos
DELAY_LOOP:
    LOOP DELAY_LOOP

    JMP PRINT_LOOP

END_PROGRAM:
    MOV AX, 4C00H
    INT 21H

END START