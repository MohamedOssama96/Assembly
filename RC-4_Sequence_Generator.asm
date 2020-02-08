INCLUDE 'emu8086.inc'

.MODEL SMALL

.DATA
	MSG1 DB             "Enter the key in ASCII: " , '$'
	MSG2 DB 0AH , 0DH , "Enter the key stream length: " , '$'
	MSG3 DB 0AH , 0DH , "The key stream: " , '$'
	NewLine DB 0AH , 0DH , '$'
    
	Key DB 18 DUP ('?')
	S DB 256 DUP (1)

DATA ENDS
    
.CODE
    START:      MOV AX , DATA
                MOV DS , AX
                MOV AL , 0
                MOV CX , 256
    
    ARRAY_S:    MOV S[BX] , AL
                INC AL
                INC BX
                LOOP ARRAY_S
                
    IN_KEY:     LEA DX , MSG1
                CALL PRINT_ME
                LEA DX , Key
                CALL SCAN_ME
                MOV CX , 256
                MOV BX , 0      ; For variable i
                MOV SI , 0      ; For varaible j
    
    KSA:        MOV AL , S[BX]
                MOV AH , 0
                ADD SI , AX 
                MOV AX , BX
                DIV Key[1]      ; Keylength
                MOV AL , AH
                MOV AH , 0
                MOV DI , AX
                MOV AL , Key[DI + 2]
                MOV AH , 0
                ADD SI , AX
                MOV AX , SI
                MOV DI , 256
                DIV DI
                MOV SI , DX
                MOV DL , S[BX]
                XCHG DL , S[SI]
                MOV S[BX] , DL
                INC BX
                LOOP KSA
                MOV BX , 0    
                MOV SI , 0
				LEA DX , MSG2
                CALL PRINT_ME
				CALL SCAN_NUM
				LEA DX , MSG3
				CALL PRINT_ME
                CALL PRINT_NEWLINE
                
    PRGA:       INC BX
                MOV AX , BX
                MOV DX , 0
                MOV DI , 256
                DIV DI
                MOV BX , DX
                MOV AL , S[BX]
                MOV AH , 0
                ADD SI , AX
                MOV AX , SI
                MOV DX , 0
                MOV DI , 256
                DIV DI
                MOV SI , DX
                MOV DL , S[BX]
                XCHG DL , S[SI]
                MOV S[BX] , DL
                MOV AX , 0
                MOV DL , S[BX]
                MOV DH , 0
                MOV AX , DX
                MOV DL , S[SI]
                ADD AX , DX
                MOV DX , 0
                MOV DI , 256
                DIV DI
                MOV DI , DX
                MOV AL , S[DI]
                MOV AH , 0
                CALL PRINT_NUM_UNS
                CALL PRINT_SPACE
                LOOP PRGA
                
                HLT      

CODE ENDS
    
	PRINT_ME PROC
                MOV AH , 09H
                INT 21H
                RET
	PRINT_ME ENDP
    
	SCAN_ME PROC
                MOV AH , 0AH
                INT 21H
                RET
	SCAN_ME ENDP
	
	PRINT_SPACE PROC
				MOV AH , 2
                MOV DL , ' '
                INT 21H
				RET
	PRINT_SPACE ENDP
	
	PRINT_NEWLINE PROC
				MOV AH , 09H
                LEA DX , NewLine
                INT 21H
				RET
	PRINT_NEWLINE ENDP

DEFINE_PRINT_NUM_UNS
DEFINE_SCAN_NUM
         
END