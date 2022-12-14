;回文判断
;利用栈和数组的对比
DATA SEGMENT
	IS DB 20
	    DB ?
	    DB 20 DUP(?)					;输入的回文
	INPUT DB 'PLEASE INPUT AN INTERGER$'		;输入提示
	OUTPUT_Y DB 'THE INTERGER IS A  PALINDROME$'	;输出结果
	OUTPUT_N DB 'THE INTERGER IS NOT A PALINDROME$'	;输出结果
	CRLF DB 0DH, 0AH, '$'				;回车

DATA ENDS

STACK SEGMENT
	MYSTACK DB 20 DUP(?)	;个人维护的栈
STACK ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA;SS:STACK
START:
	MOV AX,DATA
	MOV DS,AX	;数据段基址
	
	MOV DX,OFFSET INPUT	;OFFSET即偏移量
	MOV AH,09H
	INT 21H		;输入提示

	MOV DX,OFFSET CRLF
	MOV AH,09H
	INT 21H		;回车

	MOV DX,OFFSET IS
	MOV AH,0AH
	INT 21H		;输入

	MOV DX,OFFSET CRLF
	MOV AH,09H
	INT 21H		;回车，不回车后续输出会覆盖数据数据
	
	;利用CX LOOP压栈输入数据

	MOV AX,0
	MOV AL,IS[1]
	MOV CX,AX	;循环次数
	MOV SI,OFFSET IS[2]	;输入首地址偏移量

LOOP1:	MOV DX,0
	MOV DL,[SI]		;压栈数据变成双字节
	PUSH DX
	INC SI			;压栈数据下一个
	LOOP LOOP1		;循环

	MOV SI,OFFSET IS[2]
	
	MOV DX,0
	MOV AX,0
	MOV AL,IS[1]	;被除数在DX AX
	MOV BX,0
	MOV BL,02H	;除数2
	DIV BX		;除法，商在AX,余在DX
	MOV CX,AX

	

JUDGE:	MOV AX,0
	MOV BX,0
	MOV BL,[SI]
	POP AX
	CMP AL,BL
	JNE ERR		;有错误
	INC SI
	DEC CX
	CMP CL,0
	JNE JUDGE	;没判断完

	LEA DX,OUTPUT_Y
	MOV AH,09H
	INT 21H
	JMP EXIT		;是回文数

ERR:	LEA DX,OUTPUT_N
	MOV AH,09H
	INT 21H		;不是回文数

EXIT:	MOV AH,4CH
	INT 21H		;程序结束
	
	
CODE ENDS
END START