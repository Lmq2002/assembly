;MYASM2   转换字符串为数字，求和两个程序

PUBLIC SHIFT
PUBLIC ADDP
EXTERN	IS:BYTE
EXTERN INTERGER:WORD
EXTERN COUNT:WORD

DATA SEGMENT WORD PUBLIC 'DATA'
	LEN DB 0
DATA ENDS

CODE SEGMENT WORD PUBLIC 'CODE'
ASSUME CS:CODE,DS:DATA
SHIFT PROC NEAR
	;EXTERN	IS:BYTE
	;EXTERN INTERGER:WORD

	LEA SI,IS[1]
	MOV AL,[SI]
	MOV LEN,AL	;暂存字符串长度

	INC SI
	MOV CX,0
	MOV CL,LEN	;循环次数CX

LOOP1:	
	MOV BL,10
	MOV AX,INTERGER
	MUL BL		;乘10

	ADD AX,[SI]
	SUB AX,30H	;加？
	MOV AH,0

	MOV INTERGER,AX	;存变量
	INC SI
	LOOP LOOP1
	RET
SHIFT ENDP

ADDP PROC
	;EXTERN COUNT:WORD

	MOV BP,SP
	MOV CX,[BP+2]	;INTERGER
	MOV AX,COUNT
LOOP2:	
	ADD AX,CX
	LOOP LOOP2
	
	MOV COUNT,AX
	RET
ADDP ENDP
CODE ENDS
END