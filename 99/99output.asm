;九九乘法表的输出
;2022/10/18

DATA SEGMENT

OUTPUT	DB	'THE 9MUL9 TABLE:',0DH,0AH,'$'
OO	DB	29H, '*', 29H, '=', 29H, '    $'
CRLF	DB	0DH,0AH,'$'

XX	DB	9
YY	DB	1
FF	DB	9	;乘法结果
NN	DB	0	;栈大小

DATA ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA	;数据段地址存放
	MOV DS,AX

	LEA DX,OUTPUT	;输出提示
	MOV AH,09H
	INT 21H
LOOP1:	
	LEA SI,OO	;打印的地址
	MOV AL,XX
	CMP AL,0
	JE EXIT		;乘法表是否打印完毕，完毕跳转
	
	MOV AL,XX
	MOV AH,YY
	CMP AL,1
	JE FH
	CMP AH,AL
	JE HANG		;本行是否打印完毕，打印跳转

FH:	
	ADD SI,5
	MOV [SI],' '
	SUB SI,5
	MOV [SI],AL	;;继续打印本行
	ADD [SI],30H
	ADD SI,2
	MOV [SI],AH
	ADD [SI],30H
	ADD SI,2
	MUL AH
	MOV FF,AL	;进一步化字符串为数字
	CALL TOINT

	LEA DX,OO
	MOV AH,09H
	INT 21H		;开始打印
	
	MOV AL,YY
	ADD AL,1	
	MOV YY,AL	;变量变化

	MOV AL,XX
	CMP AL,1
	JE EXIT

	JMP LOOP1

TOINT:
LOOP2:
	MOV AX,0
	MOV AL,FF	;被除数
	MOV BX,0AH
	DIV BL		;AL商，AH余，余压栈

	CMP AL,0
	JE YAZ		;商为0，跳转出栈

	MOV BX,0
	MOV BL,AL
	MOV FF,BL	;FF存商
	MOV AL,AH
	MOV AH,0
	ADD AX,30H
	PUSH AX		;余数压栈
	MOV AL,NN
	ADD AL,1
	MOV NN,AL	;压栈数量加1
	JMP LOOP2
YAZ:
	MOV [SI],AH
	ADD [SI],30H
	INC SI
LOOP3:	
	MOV AL,NN
	CMP AL,0
	JE QUIT		;栈空退出LOOP3
	SUB AL,1
	MOV NN,AL
	POP AX
	MOV [SI],AL
	INC SI
	JMP LOOP3	
QUIT:
	RET
	

HANG:	LEA DX,CRLF
	MOV AH,09H
	INT 21H		;回车
	MOV AL,XX
	SUB AL,1
	MOV XX,AL
	MOV AL,1
	MOV YY,AL
	JMP LOOP1
EXIT:
	MOV AH,4CH
	INT 21H
	
CODE ENDS
END START