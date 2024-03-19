;_______________________________________________________________
; DEFINICION DEL SEGMENTO DE DATOS
_DATA SEGMENT WORD PUBLIC 'DATA'
	
_DATA ENDS

_BSS SEGMENT WORD PUBLIC 'BSS'; Segmento de datos público

_BSS ENDS


; DEFINICION DEL SEGMENTO DE CODIGO
_TEXT SEGMENT BYTE PUBLIC 'CODE'
ASSUME CS:_TEXT, DS:_DATA, ES:_BSS

PUBLIC _AccHuida
PUBLIC _Decode

_AccHuida PROC FAR
	PUSH BP
	MOV BP, SP
	PUSH AX DX SI 
	;EMPUJE
	MOV DX, [BP + 42]
	;ACELERACION_X
	MOV AX, 7
	MUL DX
	MOV SI, [BP + 6]
	MOV SS:[SI], AX
	MOV SS:[SI+2], DX
	;ACELARCION_Y
	MOV DX, [BP + 42]
	MOV AX, 5
	MUL DX
	MOV SI, [BP + 10]
	MOV SS:[SI], AX
	MOV SS:[SI+2], DX
	;ACELARCION_Z
	MOV DX, [BP + 42]
	MOV AX, 3
	MUL DX
	MOV SI, [BP + 14]
	MOV SS:[SI], AX
	MOV SS:[SI+2], DX
	;GRA_PL * PATM
	MOV DX, [BP + 20]
	MOV AX, [BP + 28]
	MUL DX
	;GUARDAR EN VEL_X
	MOV SI, [BP + 30]
	MOV SS:[SI], AX
	;PSOL * idPlanet
	MOV DX, [BP + 18]
	MOV AX, [BP + 26]
	MUL DX
	;GUARDAR EN VEL_Y
	MOV SI, [BP + 34]
	MOV SS:[SI], AX
	;GRA_L * NLUN
	MOV DX, [BP + 22]
	MOV AX, [BP + 24]
	MUL DX
	;GUARDAR EN VEL_Z
	MOV SI, [BP + 38]
	MOV SS:[SI], AX
	POP AX DX SI BP
	RET 
_AccHuida ENDP

_Decode PROC FAR
	PUSH BP
	MOV BP, SP
	PUSH AX DX SI 
	
	;ROTM
	MOV AX, [BP + 14]
	
	
	;ENCRIPTADO
	MOV 
	POP AX DX SI BP	
_Decode ENDP 

_TEXT ENDS
END