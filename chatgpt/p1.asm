; P4A2.asm

CODIGO SEGMENT
ASSUME CS:CODIGO

ORG 256
inicio: jmp COMIENZO

instalada db "instalado", '$'
desinstalada db "desinstalado", '$'

COMIENZO:
    MOV SI, 80H
    MOV CX, 0

    MOV CL, [SI]
    CMP CX, 0
    CALL COMP_INSTALACION

    MOV AX, 4C00H
    INT 21H

rsi PROC FAR
    PUSH DS DI DX BX CX AX

    CMP AH, 13H
    JNE FIN1

    MOV CX, DS:[DX]

    REMOVE_VOWELS:
        MOV AL, [DX]
        CMP AL, '$'
        JE FIN1

        CMP AL, 'A'
        JE NEXT_CHAR
        CMP AL, 'E'
        JE NEXT_CHAR
        CMP AL, 'I'
        JE NEXT_CHAR
        CMP AL, 'O'
        JE NEXT_CHAR
        CMP AL, 'U'
        JE NEXT_CHAR
        CMP AL, 'a'
        JE NEXT_CHAR
        CMP AL, 'e'
        JE NEXT_CHAR
        CMP AL, 'i'
        JE NEXT_CHAR
        CMP AL, 'o'
        JE NEXT_CHAR
        CMP AL, 'u'
        JE NEXT_CHAR

        MOV [CX], AL
        INC CX

    NEXT_CHAR:
        INC DX
        JMP REMOVE_VOWELS

    FIN1:
        POP AX CX BX DX DI DS

    IRET
rsi ENDP

INSTALAR PROC
    MOV ax, 0
    MOV es, ax
    MOV ax, OFFSET rsi
    MOV bx, cs
    CLI
    MOV es:[61h*4], ax
    MOV es:[61h*4+2], bx
    STI
    MOV dx, OFFSET INSTALAR
    INT 27h
    RET
INSTALAR ENDP

DESINSTALAR PROC
    PUSH ax bx cx ds es
    MOV cx, 0
    MOV ds, cx
    MOV es, ds:[61h*4+2]
    MOV bx, es:[2Ch]
    MOV ah, 49h
    INT 21h
    MOV es, bx
    INT 21h

    CLI
    MOV ds:[61h*4], cx
    MOV ds:[61h*4+2], cx
    STI

    POP es ds cx bx ax
    RET
DESINSTALAR ENDP

COMP_INSTALACION PROC
    MOV AX, 0
    MOV ES, AX

    MOV AX, ES:[61H*4]
    MOV BX, ES:[61H*4+2]
    CMP AX, 0
    JNE INSTALADO_61
    CMP BX, 0
    JNE INSTALADO_61

    MOV AH, 9
    MOV DX, OFFSET instalada
    INT 21H
    CALL INSTALAR
    JMP FIN_COMP

INSTALADO_61:
    MOV AH, 9
    MOV DX, OFFSET desinstalada
    INT 21H
    CALL DESINSTALAR

FIN_COMP:
    RET
COMP_INSTALACION ENDP

CODIGO ENDS
END inicio