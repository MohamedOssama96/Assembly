.MODEL SMALL

.DATA
	MSG1 DB 0AH , 0DH , "Enter the card number: " , '$'
	MSG2 DB 0AH , 0DH , "Enter Password: " , '$'
	MSG3 DB 0AH , 0DH , "Entered card number and password are correct... Welcome!" , 0AH , 0DH , '$'
	MSG4 DB 0AH , 0DH , "Not a registered card number!" , 0AH , 0DH , '$'
	MSG5 DB 0AH , 0DH , "You entered a wrong password!" , 0AH , 0DH , '$'

	CardNumber1_5   DB "0101010101010101" , "0202020202020202" , "0303030303030303" , "0404040404040404" , "0505050505050505"
    CardNumber6_10  DB "0606060606060606" , "0707070707070707" , "0808080808080808" , "0909090909090909" , "1010101010101010"
    CardNumber11_15 DB "1111111111111111" , "1212121212121212" , "1313131313131313" , "1414141414141414" , "1515151515151515"
    CardNumber16_20 DB "1616161616161616" , "1717171717171717" , "1818181818181818" , "1919191919191919" , "2020202020202020"
    
	Password1_10  DB "0101" , "0202" , "0303" , "0404" , "0505" , "0606" , "0707" , "0808" , "0909" , "1010"
    Password11_20 DB "1111" , "1212" , "1313" , "1414" , "1515" , "1616" , "1717" , "1818" , "1919" , "2020"
    
	CardNumberTemp DB 20 DUP ('?')
	PasswordTemp DB 10 DUP ('?')

DATA ENDS

.CODE
    START:      MOV AX , DATA
                MOV DS , AX
                
    IN_USER:    MOV BX , 0
    			LEA DX , MSG1
                CALL PRINT
                LEA DX , CardNumberTemp
                CALL SCAN
                CMP CardNumberTemp[1] , 16
                JNE WRONG_U 
            
    USER:       LEA SI , CardNumber1_5 + BX
                LEA DI , CardNumberTemp + 2
    			CMP BX , 320
    			JE WRONG_U
    			ADD BX , 16
                MOV CX , 16
    		      
    CHECK_U:    MOV AL , [SI]
                CMP AL , [DI]
                JNE USER
                INC SI
                INC DI
                LOOP CHECK_U
                    
    IN_PASS:    LEA DX , MSG2
                CALL PRINT
                LEA DX , PasswordTemp
                CALL SCAN
                CMP PasswordTemp[1] , 4
                JNE WRONG_P
                
    ADJUST_BX:  MOV AX , BX
                MOV BL , 16
                DIV BL
                DEC AL
                MOV BL , 4
                MUL BL
                MOV BX , AX
    
    PASS:		LEA SI , Password1_10 + BX
                LEA DI , PasswordTemp + 2
                MOV CX , 4
            
    CHECK_P:    MOV AL , [SI]
                CMP AL , [DI]
                JNE WRONG_P
                INC SI
                INC DI
                LOOP CHECK_P
                LEA DX , MSG3
                CALL PRINT
                JMP IN_USER   
            
    WRONG_U:    LEA DX , MSG4
                CALL PRINT
                JMP IN_USER
            
    WRONG_P:    LEA DX , MSG5
                CALL PRINT
                JMP IN_USER  

CODE ENDS
    
	PRINT PROC
                MOV AH , 09H
                INT 21H
                RET
	PRINT ENDP
    
	SCAN PROC
                MOV AH , 0AH
                INT 21H
                RET
	SCAN ENDP
         
END