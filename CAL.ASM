ASSUME CS:CODE,DS:DATA,SS:STACK
;--------------------------------------------------------------------------
STACK SEGMENT
YEAR DW 10 DUP(?)
TEMP DW 5 DUP(?)
SCREEN DW 1 DUP(?)
STACK ENDS
;--------------------------------------------------------------------------
DATA SEGMENT
COPY_RIGHT DB 'Copyright (C) muyangren907 2017.  All rights reserved.',13,10,13,10,13,10,25 DUP(' '),'WELCOME TO CALENDAR V2.0!'
PAU DB 'PRESS ANY KEY TO CONTINUE...'
WEEK DB 'S    M    T    W    T    F    S'
YEARD DB 'YEAR:',6 DUP(' '),'MONTH:'
MONTH DB 'JAN  FEB  MAR  APR  MAY  JUNE JULY AUG  SEPT OCT  NOV  DEC  '
DATE_NUM DB '01020304050607080910111213141516171819202122232425262728293031'
TODAY DW 2 DUP(0)
DATE DW 2 DUP(0)
HELP DB 'UP: ADD YEAR',10 DUP(' '),'DOWN: SUB YEAR',10,13,10 DUP(' '),'RIGHT: ADD MONTH',6 DUP(' '),'LEFT: SUB MONTH',10,13,10 DUP(' '),'ESC: EXIT'
ENDD DB 0
DATA ENDS
;--------------------------------------------------------------------------
CODE SEGMENT
START:
MOV AX,DATA
MOV DS,AX

MOV AX,STACK
MOV SS,AX
MOV SP,OFFSET SCREEN+2

MOV AH,0FH 
INT 10H
PUSH AX

MOV SP,OFFSET YEAR+20

;..........HIDE_CURSOR.....................................................
MOV AH,1
MOV CX,2000H
INT 10H
;..........................................................................

;..............................CLEAN_SCREEN................................
MOV AH,6
MOV AL,0
MOV BH,01111000B
MOV CH,0
MOV CL,0
MOV DH,25
MOV DL,80
INT 10H
;..........................................................................


;...............DISPLAY_COPYRIGHT..........................................
MOV AH,13H
MOV BX,DS
MOV ES,BX
MOV BP,OFFSET COPY_RIGHT
MOV CX,OFFSET PAU
SUB CX,BP
MOV DH,0
MOV DL,12
MOV BH,0
MOV AL,1
MOV BL,01111001B
INT 10H
;..........................................................................

;......................PAUSE...............................................
MOV AH,13H
MOV BX,DS
MOV ES,BX
MOV BP,OFFSET PAU
MOV CX,OFFSET WEEK
SUB CX,BP
MOV DH,13
MOV DL,25
MOV BH,0
MOV AL,1
MOV BL,01111001B
INT 10H
MOV AH,1
INT 21H
;..........................................................................

;..............................CLEAN_SCREEN................................
MOV AH,6
MOV AL,0
;MOV BH,10101100B
MOV BH,01111000B
MOV CH,0
MOV CL,0
MOV DH,25
MOV DL,80
INT 10H
;..........................................................................



;...........................GET_DATE.......................................
MOV AH,2AH
INT 21H
MOV SI,OFFSET TODAY
MOV [SI],CX   ;YEAR -> DATA
MOV [SI+2],DX  ;MONTH,DATE -> DATA
MOV SI,OFFSET DATE
MOV [SI],CX   ;YEAR -> DATA
MOV [SI+2],DX  ;MONTH,DATE -> DATA
;..........................................................................

DISPLAY:
MOV AX,CX ;YEAR FROM CX TO AX
MOV SP,OFFSET YEAR+20
;..................YEAR_CONVERT_TO_DEC.....................................
CONVERT_TO_DEC:

MOV BX,10
DIV BL
XOR DX,DX ;DX <- 0
MOV DL,AH
MOV AH,0
PUSH DX
CMP AL,0
JE DISPLAY_YEAR
JMP CONVERT_TO_DEC
;..........................................................................

;..................DISPLAY_YEAR............................................
DISPLAY_YEAR:
MOV AH,13H
MOV BX,DS
MOV ES,BX
MOV BP,OFFSET YEARD
MOV CX,OFFSET MONTH
SUB CX,BP
MOV DH,1
MOV DL,29
MOV BH,0
MOV AL,1
MOV BL,01111100B
INT 10H

	MOV DL,35  ;YEAR_NUM POS
DISPLAY_YEAR_1:
	;..................DISPLAY_SETPOS......................................
	MOV AH,2
	MOV BH,0
	MOV DH,1
	INT 10H
	;......................................................................

XOR AX,AX  ;AX <- 0
POP AX
ADD AX,30H
MOV AH,9
MOV BH,0
MOV BL,01110011B
MOV CX,1
INT 10H
INC DL
CMP SP,OFFSET YEAR+20
JE OK;;;
JMP DISPLAY_YEAR_1
;..........................................................................
OK:
;....................HELP..................................................
MOV AH,13H
MOV BX,DS
MOV ES,BX
MOV BP,OFFSET HELP
MOV CX,OFFSET ENDD
SUB CX,BP
MOV DH,17
MOV DL,10
MOV BH,0
MOV AL,1
MOV BL,01111001B
INT 10H
;..........................................................................
;...............................DISPLAY_WEEK...............................
MOV AH,13H
MOV BX,DS
MOV ES,BX
MOV BP,OFFSET WEEK
MOV CX,OFFSET YEARD
SUB CX,BP
MOV DH,3
MOV DL,25
MOV BH,0
MOV AL,1
MOV BL,01110000B
INT 10H
;..........................................................................

MOV SI,OFFSET DATE
MOV CX,[SI]
MOV DX,[SI+2]

;...............................DISPLAY_MONTH..............................
DISPLAY_MONTH:
XOR AX,AX
MOV AL,DH
SUB AX,1
MOV BL,5
MUL BL
MOV DX,AX

MOV AH,13H
MOV BX,DS
MOV ES,BX
MOV BP,OFFSET MONTH
ADD BP,DX
MOV CX,4
MOV DH,1
MOV DL,47   ;MONTH_WORD POS
MOV BH,0
MOV AL,1
MOV BL,01110011B
INT 10H
;..........................................................................

;............FIRTST_DISPLAY................................................
CALC:
MOV SI,OFFSET DATE
MOV CX,[SI]
MOV DX,[SI+2]


MOV DL,1 ;SET
MOV AH,2BH
INT 21H

MOV AH,2AH ;GET THE FIRST DAY OF THE MONTH
INT 21H


MOV BL,5
MUL BL
ADD AX,25


	
	;..................DISPLAY_SETPOS......................................
	MOV DL,AL
	MOV AH,2
	MOV BH,0
	MOV DH,5
	INT 10H
	;......................................................................
;SET
MOV SI,OFFSET TODAY
MOV CX,[SI]
MOV DX,[SI+2]
MOV AH,2BH
INT 21H
	
;.......LEAP_YEAR JUDGE.........
MOV SI,OFFSET DATE
MOV AX,[SI]
MOV BL,100
DIV BL
CMP AH,0
JE ZB  ;

MOV AX,[SI]
MOV DX,0
MOV BX,4
DIV BX
CMP DX,0
JE RUN
JMP NOT_RUN

ZB:
MOV BL,4
DIV BL
CMP AH,0
JE RUN;
JMP NOT_RUN
;......................................................................

RUN:
MOV SI,OFFSET DATE
MOV DX,[SI+2]
CMP DH,1
JA M_2
MOV CX,31
JMP MAIN

M_2:
CMP DH,2
MOV CX,29
JA M_3
JMP MAIN

M_3:
CMP DH,2
MOV CX,31
JA M_4
JMP MAIN

M_4:
CMP DH,4
MOV CX,30
JA M_5
JMP MAIN

M_5:
CMP DH,5
MOV CX,31
JA M_6
JMP MAIN

M_6:
CMP DH,6
MOV CX,30
JA M_7
JMP MAIN

M_7:
CMP DH,7
MOV CX,31
JA M_8
JMP MAIN

M_8:
CMP DH,8
MOV CX,31
JA M_9
JMP MAIN

M_9:
CMP DH,9
MOV CX,30
JA M_10
JMP MAIN

M_10:
CMP DH,10
MOV CX,31
JA M_11
JMP MAIN

M_11:
CMP DH,11
MOV CX,30
JA M_12
JMP MAIN

M_12:
MOV CX,31
JMP MAIN


NOT_RUN:
MOV SI,OFFSET DATE
MOV DX,[SI+2]
CMP DH,1
JA M_21
MOV CX,31
JMP MAIN

M_21:
CMP DH,2
MOV CX,28
JA M_31
JMP MAIN

M_31:
CMP DH,2
MOV CX,31
JA M_41
JMP MAIN

M_41:
CMP DH,4
MOV CX,30
JA M_51
JMP MAIN

M_51:
CMP DH,5
MOV CX,31
JA M_61
JMP MAIN

M_61:
CMP DH,6
MOV CX,30
JA M_71
JMP MAIN

M_71:
CMP DH,7
MOV CX,31
JA M_81
JMP MAIN

M_81:
CMP DH,8
MOV CX,31
JA M_91
JMP MAIN

M_91:
CMP DH,9
MOV CX,30
JA M_101
JMP MAIN

M_101:
CMP DH,10
MOV CX,31
JA M_111
JMP MAIN

M_111:
CMP DH,11
MOV CX,30
JA M_121
JMP MAIN

M_121:
MOV CX,31
JMP MAIN

;..........................................................................

;.................................MAIN.....................................
MAIN:
MOV SI,OFFSET DATE_NUM

MOV SP,OFFSET TEMP+10
DIS_LOOP:
PUSH CX

MOV AH,9
MOV BH,0
MOV BL,01110010B
MOV CX,1
MOV AL,[SI] 
INT 10H
INC SI

MOV AH,3 ;READ POS
MOV BH,0
INT 10H
INC DL
MOV AH,2 ;SET POS
INT 10H

MOV AH,9
MOV BH,0
MOV BL,01110010B
MOV CX,1
MOV AL,[SI] 
INT 10H
INC SI

MOV AH,3 ;READ POS
MOV BH,0
INT 10H

ADD DL,4
CMP DL,60   ;60=25+7*5
JE SET_POS

MOV AH,2 ;SET POS
INT 10H

POP CX
LOOP DIS_LOOP

JMP NEXT

SET_POS:
MOV DL,25
ADD DH,2
MOV AH,2
INT 10H
POP CX
LOOP DIS_LOOP
;..........................................................................

NEXT:
;.........................WAIT_INPUT.......................................
MOV AH,0
INT 16H

CMP AX,4800H
JZ YEAR_ADD
CMP AX,5000H
JZ YEAR_SUB
CMP AX,4B00H
JZ MONTH_SUB
CMP AX,4D00H
JZ MONTH_ADD
CMP AX,011BH
JZ EXIT
JMP NEXT
YEAR_ADD:
CALL CLS
MOV SI,OFFSET DATE
MOV CX,[SI]
MOV DX,[SI+2]
INC CX
MOV [SI],CX
JMP DISPLAY

YEAR_SUB:
CALL CLS
MOV SI,OFFSET DATE
MOV CX,[SI]
MOV DX,[SI+2]
DEC CX
MOV [SI],CX
JMP DISPLAY

MONTH_ADD:
CALL CLS
MOV SI,OFFSET DATE
MOV CX,[SI]
MOV DX,[SI+2]
INC DH
CMP DH,12
JA MON_UP_OVER
MOV [SI+2],DX
JMP DISPLAY

MON_UP_OVER:
MOV DH,1
INC CX
MOV [SI+2],DX
MOV [SI],CX
JMP DISPLAY

MONTH_SUB:
CALL CLS
MOV SI,OFFSET DATE
MOV CX,[SI]
MOV DX,[SI+2]
SUB DH,1
CMP DH,1
JB MON_DOWN_OVER
MOV [SI+2],DX
JMP DISPLAY

MON_DOWN_OVER:
MOV DH,12
DEC CX
MOV [SI+2],DX
MOV [SI],CX
JMP DISPLAY

;..........................................................................
EXIT:
LEA SP,SCREEN
POP AX
MOV AH,00H
INT 10H

MOV AX,4C00H
INT 21H
CLS:
;..............................CLEAN_SCREEN................................
MOV AH,6
MOV AL,0
;MOV BH,10101100B
MOV BH,01111000B
MOV CH,4
MOV CL,0
MOV DH,25
MOV DL,80
INT 10H
RET
;..........................................................................


CODE ENDS
END START