.MODEL LARGE  
.STACK 2000H
.DATA
    M1 DB '	                    Menu                  ', 0DH, 0AH, '	+===+=====================================+', 10,'$'
    M2 DB '        Enter your choice > $ '

    M3 DB '	| 1 | - Fried Chicken            RM  5.00 |',10,'$'
    M4 DB '	| 2 | - Mashed Potato            RM  2.00 |',10,'$'
    M5 DB '	| 3 | - Crispy Chicken Burger    RM  8.00 |',10,'$'
    M6 DB '	| 4 | - Chicken Chop with Fries  RM 26.00 |',10,'$'
    M7 DB '	| 5 | - Coleslaw                 RM  5.00 |',10,'$'
    M8 DB '	+===+=====================================+', 0DH, 0AH, '	| 6 | Exit |', 0DH, 0AH, '	+===+======+', 0DH, 0AH, 10,'$'

    ;INVALID
	M9 DB  '	     INVALID ENTRY    ', 0DH, 0AH, '	    Please try again    ', 10, '$'
    M11 DB '	Here is your receipt. ',10,'$'

    ;COMMAND
    ;M13 DB 'Total Quantity             : $'
	M16 DB '        Quantity [Under 20]       : $'
	M18 DB '        Continue order item?(Y/N) > $'
    M20 DB '        Go to next order?(Y/N) > $'
	
	M26 DB '	        Total sales earned       : RM $'
	M29 DB '	        Total number of customer : $'
	M28 DB '               QUANTITY SET $'
	
    ;RECIPT
    M27 DB '	            CUSTOMER Order NO: $'
    M21 DB '	| - Fried Chicken            RM  5.00   | $'
    M22 DB '	| - Mashed Potato            RM  2.00   | $'
    M23 DB '	| - Crispy Chicken Burger    RM  8.00   | $'
    M24 DB '	| - Chicken Chop with Fries  RM 26.00   | $'
    M25 DB '	| - Coleslaw                 RM  5.00   | $'
	M14 DB '	| SST Tax (10%)           :  RM  $      | '
	M17 DB '	| Total Price             :  RM  $      | '
	M30 DB '	+===========================+===========+===========+===========+', 0DH, 0AH, '$'
	M31 DB '	|  Product                   Price       Quantity     Subtotal  |', 0DH, 0AH, '$'

    M32 DB '    K   K    FFFFF    CCCCC  ', 0DH, 0AH, '$'
    M33 DB '    K K      F       C      ', 0DH, 0AH, '$'
    M34 DB '    K        FFFF    C      ', 0DH, 0AH, '$'
    M35 DB '    K K      F       C      ', 0DH, 0AH, '$'
    M36 DB '    K   K    F        CCCCC ', 0DH, 0AH, '$'
 
    M37 DB 'WELCOME TO KLANG FRIED CHICKEN', 0DH, 0AH, '$'
    M38 DB '(CrunchCraft: Klang Fried Chicken)', 0DH, 0AH, '$'

    ; Drink Menu Items
    M39 DB '        Pay by 1.Cash or 2.Credit(1/2):$'
    M40 DB '        Pay at counter', 0DH, 0AH, '$'
    M41 DB '        Insert your credit card number:$'
    M42 DB '        Payment successfully!', 0DH, 0AH,'$'
    

    ;PASSWORD
    ENTERUSERNAME   DB 'Enter username: $'
    ENTERPASSWORD   DB 0DH, 0AH, 'Enter password: $'
    SCCLOGIN        DB 0DH, 0AH, 'Login successful! Press any key to continue...', 0DH, 0AH, '$'
    INLOGIN         DB 0DH, 0AH, 'Invalid login, try again. Press any key to continue...', 0DH, 0AH, '$'
    ADMINUSER       DB 'abcd', 0       ; Correct username
    ADMINPASSWORD   DB '1234', 0       ; Correct password
    INUSER          DB 21 DUP('$')    ; Buffer for username input, 20 characters + null terminator
    INPSW           DB 21 DUP('$')    ; Buffer for password input, 20 characters + null terminator
    PWCOUNT         DW ?              ; Counter for password length

	R3 DB "	        ----------- The system is closed... -----------", 10, '$'
    NL DB 0DH,0AH,"$"   
    ;DATA STORE
    QUANTITY DW 0,0,0,0,0
	QUANTITY2 DW 0,0,0,0,0
    BOOLEAN DW ?
    DAILYEARN DW 0
    DAILYEARN2 DW 0
    DAILYEARNDIGIT DW 0
	TOTAL DW 0
    SSTPRICE DW 0
    SSTPRICEDIGIT DW 0
    Price DW 5,2,8,26,5
    DOT DB '.$'
	RECIPTMIDDLE DB '        | RM $       |'
    CUSTOMERNO DW 1
    TOTAL1 DW 0
	TEN DB 10
     
    ;NEXT LINE
    NEXTLINE DB 13, 10, "$"
    EMPTYSPACES DB "      $"

    CC_NUMBER_PROMPT DB "        Insert your credit card number (16 digits): $"
    CC_NUMBER_BUFFER DB 17 DUP(0) ; 16 digits + terminating null character
    INVALID_CC_NUMBER_MSG DB 0DH, 0AH, "        Invalid credit card number. Please enter exactly 16 digits.: $"


.CODE
PRINT PROC
    MOV CX,0
    MOV DX,0
    LABELPRINT:
        CMP AX,0
        JE PRINTAX

        MOV BX,10
        DIV BX
        PUSH DX
        INC CX
        XOR DX,DX
        JMP LABELPRINT
    PRINTAX:
        CMP CX,0
        JE EXITPRINT

        POP DX
        ADD DX,48
        MOV AH,02h
        INT 21H

        LOOP PRINTAX
	EXITPRINT:
	RET
PRINT ENDP
QUANTITYPRINT PROC
	MOV AH, 0
	DIV TEN
	MOV BX, AX
	
	CMP BL, 0
	
	MOV AH, 02H
	MOV DL, BL
	
	CMP DL, 0
	JE IS0
		ADD DL, 30H
		JMP QNUM1
	IS0:
		MOV DL, ' '
		
	QNUM1:
		INT 21H
	MOV AH, 02H
	MOV DL, BH
	ADD DL, 30H
	INT 21H
	
	MOV AH, 09H
	LEA DX, RECIPTMIDDLE
	INT 21H
	RET
QUANTITYPRINT ENDP
;description
QUANTITYOUTPUT PROC
    LEA DX,M28
    MOV AH,09H
    INT 21H
QUANTITYOUTPUT ENDP
TOTALDAILYEARN PROC
    MOV AX,TOTAL
    ADD DAILYEARN,AX

    XOR AX,AX
    XOR BX,BX
    XOR DX,DX

    MOV AX,SSTPRICEDIGIT
    ADD DAILYEARNDIGIT,AX

    MOV AX,DAILYEARNDIGIT
    MOV BX,1000
    DIV BX

    ADD DAILYEARN,AX
    MOV DAILYEARNDIGIT,DX
    RET
TOTALDAILYEARN ENDP
NEWLINE PROC
    LEA DX,NEXTLINE ;NEWLINE
    MOV AH,09H
    INT 21H
    RET
NEWLINE ENDP
OUTPRINTQUANTITY PROC
    LEA DX,M16 ;'Quantity: $'
    MOV AH,09H
    INT 21H
    RET
OUTPRINTQUANTITY ENDP
CHOICE PROC
    LEA DX,M18
    MOV AH,9
    INT 21H

    MOV AH,1 ;INPUT VALUE
    INT 21H
    MOV BH,AL

    CALL NEWLINE

    RET
CHOICE ENDP
MENU PROC
    MOV AX,3
    INT 10H
    CALL NEWLINE
	CALL NEWLINE
    LEA DX,M27
    MOV AH,9
    INT 21H

    MOV AX,CUSTOMERNO
    CALL PRINT

    CALL NEWLINE

    LEA DX,M1 
    MOV AH,9
    INT 21H

    LEA DX,M3 ;SHOW '**   1.Fried Chicken            **' ,10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M4 ;SHOW '**   2.Mashed Potato            **',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M5 ;SHOW '**   3.Crispy Chicken Burger    **',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M6 ;SHOW '**   4.Chicken Chop with Fries         **',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M7 ;SHOW '**   5.Coleslaw              **',10,'$'
    MOV AH,9
    INT 21H

    LEA DX,M8 ;SHOW '**   6.Exit               **',10,'$'
    MOV AH,9
    INT 21H

    RET
MENU ENDP
;description
PAYMENT PROC
    LEA DX,M39 ;'Pay by 1.Cash or 2.Credit(1/2) > $'
    MOV AH,09H
    INT 21H

    MOV AH,1 ;INPUT VALUE
    INT 21H
    MOV BH,AL

    CALL NEWLINE

    CMP BH, '1' ; Check if input is '1'
    JE PAYCASH ; Jump to PAYCASH if input is '1'

    CMP BH, '2' ; Check if input is '2'
    JE PAYCREDIT ; Jump to PAYCREDIT if input is '2'

    ; If input is neither '1' nor '2', display invalid message and prompt user to input again
    CALL NEWLINE ; Call NEWLINE to display a new line


    ; Prompt user to input again
    JMP PAYMENT ; Jump back to the beginning of PAYMENT to get user input again

PAYCASH:
    LEA DX,M40 ;'Pay at counter'
    MOV AH,9
    INT 21H

    CALL NEWLINE

    LEA DX,M42 ;'Thank you. Have a nice day!'
    MOV AH,9
    INT 21H
    CALL NEWLINE

    RET

; Procedure to read and validate credit card number
; Procedure to read and validate credit card number
READ_CC_NUMBER PROC
    MOV AH, 09H
    LEA DX, CC_NUMBER_PROMPT  ; Prompt for credit card number
    INT 21H                   ; Display prompt

READ_AGAIN:
    XOR CX, CX                ; Clear CX to count the number of digits entered
    LEA DI, CC_NUMBER_BUFFER  ; Point DI to the buffer for storing the credit card number

READ_CHAR:
    MOV AH, 01H
    INT 21H                   ; Read a character from keyboard
    CMP AL, 0DH               ; Check if Enter key
    JE CHECK_LENGTH           ; If Enter, jump to length check
    CMP AL, '0'               ; Check if character is below '0'
    JB INVALID_CC             ; If below '0', jump to invalid input
    CMP AL, '9'               ; Check if character is above '9'
    JA INVALID_CC             ; If above '9', jump to invalid input
    MOV [DI], AL              ; Store valid character in buffer
    INC DI                    ; Increment buffer pointer
    INC CX                    ; Increment digit count
    CMP CX, 16                ; Check if 16 characters have been read
    JLE READ_CHAR             ; Continue reading if less than 16 characters

CHECK_LENGTH:
    CMP CX, 16                ; Check if exactly 16 digits were entered
    JNE INVALID_CC            ; If not 16 digits, jump to invalid input
    MOV BYTE PTR [DI], '$'    ; Terminate string with '$'
    RET                       ; Return if valid

INVALID_CC:
    MOV AH, 09H
    LEA DX, INVALID_CC_NUMBER_MSG
    INT 21H                   ; Display error message
    JMP READ_AGAIN            ; Prompt to enter number again

READ_CC_NUMBER ENDP



PAYCREDIT:
    CALL READ_CC_NUMBER

    ; After validation
    LEA DX, M42                  
    MOV AH, 09H
    INT 21H
    CALL NEWLINE
    RET

PAYMENT ENDP


PrintTotal:
    LEA DX, M17 ; '	| Total Price             :  RM  $      | '
    MOV AH, 09H
    INT 21H
    MOV AX, TOTAL
    CALL NEWLINE
    RET

INVALID PROC
    CALL NEWLINE
    CALL NEWLINE

    mov ah, 9
    mov al, ' '     ; Character to print (space to set the background color)
    mov bh, 0       ; Page number (usually 0)
    mov bl, 00CH       ; Attribute byte (background color is 0 (black), foreground color is 4 (red))
    MOV CX,0050H
    MOV DX,0C4FH
    int 10h

    LEA DX,M9 ;'&&	INVALID ENTRY	&&',10,'$'
    MOV AH,9
    INT 21H

    CALL NEWLINE
    XOR AX,AX
    XOR CX,CX
    XOR BX,BX
    XOR DX,DX
    MOV AH,08H
    INT 21H
    RET
INVALID ENDP
SCANTWODIGITNUMBER PROC
    XOR AX,AX
    XOR BX,BX
    XOR CX,CX
    XOR DX,DX

JUDGESIGN:
    MOV AH,1
    INT 21H
    CMP AL,'-'
    JNE NEXT
    MOV DX,0FFFFH
    JMP DIGITIN

NEXT:
    CMP AL,30H
    JB UNEXPECTED
    CMP AL,39H
    JA UNEXPECTED
    SUB AL,30H
    SHL BX,1
    MOV CX,BX
    SHL BX,1
    SHL BX,1
    ADD BX,CX
    ADD BL,AL
    ADC BH,0

DIGITIN:
    MOV AH,1
    INT 21H
    JMP NEXT

SAVE:
    CMP DX,0FFFFH
    JNE RESULTSAVE
    NEG BX

RESULTSAVE:
    MOV AX,BX
    RET

UNEXPECTED:
    CMP AL,0DH
    JE SAVE
    CALL INVALID
    JMP MENU
SCANTWODIGITNUMBER ENDP
DISPLAYDATE PROC
    MOV DL,BH
    ADD DL,30H
    MOV AH,02H
    INT 21H
    MOV DL,BL
    ADD DL,30H
    MOV AH,02H
    INT 21H
    RET
DISPLAYDATE ENDP
;description
SHOWDATE PROC
    ;description
    MOV AH,2AH
    INT 21H
    MOV AL,DL
    AAM
    MOV BX,AX
    CALL DISPLAYDATE

    MOV DL,'/'
    MOV AH,02H
    INT 21H

    MOV AH,2AH
    INT 21H
    MOV AL,DH
    AAM
    MOV BX,AX
    CALL DISPLAYDATE

    MOV DL,'/'
    MOV AH,02H
    INT 21H

    MOV AH,2AH
    INT 21H
    ADD CX,0F830H
    MOV AX,CX
    AAM
    MOV BX,AX
    CALL DISPLAYDATE

    RET
SHOWDATE ENDP
EXIT PROC
	MOV AX, CUSTOMERNO
	DEC AX
	CMP AX, 0
	
	JE SYSEND
		LEA DX, M29 ;"The total number of customer: "
		MOV AH, 9
		INT 21H
		
		MOV AX, CUSTOMERNO
		DEC AX
		CALL PRINT
		CALL NEWLINE
	SYSEND:
    LEA DX,R3 ;' -- The system is closed. --'
    MOV AH,9
    INT 21H

    MOV AH,4CH
    INT 21H
EXIT ENDP
RECIPT PROC
    MOV AX,3
    INT 10H
    CALL NEWLINE
	CALL NEWLINE
	CALL NEWLINE
	
	; PRINT CUSTOMER ORDER NUMBER
	MOV AH, 9
	LEA DX, M27
	INT 21H

	MOV AX, CUSTOMERNO
	CALL PRINT

    LEA DX,EMPTYSPACES
    MOV AH,9
    INT 21H
    CALL SHOWDATE

	CALL NEWLINE
	INC CUSTOMERNO
	
	; ORDER LINE BREAK
	MOV AH, 09H
	LEA DX, M30
	INT 21H
	
	MOV AH, 09H
	LEA DX, M31
	INT 21H
	
	MOV AH, 09H
	LEA DX, M30
	INT 21H
	
;GENERATE NAME AND QUANTITY
    LEA SI,QUANTITY
    MOV AX,[SI+0]
    CMP AX,0000H
    JG RECEIPTFRIEDCHICKEN

    JMP RECIPT1

RECEIPTFRIEDCHICKEN:
    LEA DX,M21 ; 'fried chicken:  $'
    MOV AH,9
    INT 21H

    LEA SI,QUANTITY2
    MOV AX,[SI]
    CALL QUANTITYPRINT
	
	LEA SI,QUANTITY
    MOV AX,[SI]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT1


RECIPT1:
    LEA SI,QUANTITY
    MOV AX,[SI+2]
    CMP AX,0000H
    JG RECEIPTMASHEDPOTATO

    JMP RECIPT2
RECEIPTMASHEDPOTATO:
    LEA DX,M22 ; 'Mashed Potato: $'
    MOV AH,9
    INT 21H

	LEA SI,QUANTITY2
    MOV AX,[SI+2]
    CALL QUANTITYPRINT
	
    LEA SI,QUANTITY
    MOV AX,[SI+2]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT2

RECIPT2:
    LEA SI,QUANTITY
    MOV AX,[SI+4]
    CMP AX,0000H
    JG RECEIPTCRISPYCHICKENBURGER

    JMP RECIPT3

RECEIPTCRISPYCHICKENBURGER:
    LEA DX,M23 ; 'Crispy Chicken Burger: $'
    MOV AH,9
    INT 21H

	LEA SI,QUANTITY2
    MOV AX,[SI+4]
    CALL QUANTITYPRINT
	
    LEA SI,QUANTITY
    MOV AX,[SI+4]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT3

RECIPT3:
    LEA SI,QUANTITY
    MOV AX,[SI+6]
    CMP AX,0000H
    JG RECEIPTCHICKENCHOPWITHFRIES

    JMP RECIPT4

RECEIPTCHICKENCHOPWITHFRIES:
    LEA DX,M24 ; 'Chicken Chop with Fries: $'
    MOV AH,9
    INT 21H

	LEA SI,QUANTITY2
    MOV AX,[SI+6]
    CALL QUANTITYPRINT
	
    LEA SI,QUANTITY
    MOV AX,[SI+6]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT4
    
RECIPT4:
    LEA SI,QUANTITY
    MOV AX,[SI+8]
    CMP AX,0000H
    JG RECEIPTCOLESLAW

    JMP RECIPT5

RECEIPTCOLESLAW:
    LEA DX,M25 ; 'Coleslaw: $'
    MOV AH,9
    INT 21H

	LEA SI,QUANTITY2
    MOV AX,[SI+8]
    CALL QUANTITYPRINT
	
    LEA SI,QUANTITY
    MOV AX,[SI+8]
    CALL PRINT

    CALL NEWLINE

    JMP RECIPT5

RECIPT5:
		;COMPLETE GENERATE 
	MOV AH, 09H
	LEA DX, M30 ;ORDER LINE BREAK
	INT 21H
	
    LEA DX,M14 ;'SST TAX PRICE'
    MOV AH,9
    INT 21H

    MOV AX,SSTPRICE
    CMP AX,0
    JNZ PRINTSSTPRICE
    MOV DX,48
    MOV AH,02H
    INT 21H

    JMP PRINTSSTPRICEDIGIT
    
PRINTSSTPRICE:
    CALL PRINT

PRINTSSTPRICEDIGIT:
    MOV AX,SSTPRICEDIGIT
    CMP AX,0
    JZ NODOT

    MOV DX,OFFSET DOT
    MOV AH,9
    INT 21H

    MOV AX,SSTPRICEDIGIT
    CALL PRINT

NODOT:
    CALL NEWLINE
    
    LEA DX,M17 ; PRINT 'Total Price: $' 
    MOV AH,9
    INT 21H

    MOV AX,TOTAL
    CALL PRINT
    
    MOV AX,SSTPRICEDIGIT
    CMP AX,0
    JZ NODOT2

    MOV DX,OFFSET DOT
    MOV AH,9
    INT 21H

    MOV AX,SSTPRICEDIGIT
    CALL PRINT

NODOT2:
    CALL NEWLINE

	MOV AH, 09H
	LEA DX, M30
	INT 21H
	
	CALL NEWLINE
	MOV AH, 09H
	LEA DX, M11
	INT 21H
	
	CALL NEWLINE
	
    RET
	

RECIPT ENDP


SST PROC
    MOV CX,5
    LEA SI,QUANTITY2
    LEA DI,QUANTITY
    XOR AX,AX

	LOOP0:
		MOV AX,[DI]
		MOV [SI],AX
		ADD SI,2
		ADD DI,2
	LOOP LOOP0
	

    MOV CX,5
    LEA SI,Price
    LEA DI,QUANTITY
    XOR AX,AX

LOOP1:
    MOV AX,[SI]
    MOV BX,[DI]
    MUL BX
    
    MOV [DI],AX
    ADD SI,2
    ADD DI,2
    LOOP LOOP1 

    LEA DI,QUANTITY
    MOV AX,0000H
    MOV CX,5







LOOPTOTAL:
    MOV AX,[DI]
    MOV BX,TOTAL
    ADD DX,AX

    ADD DI,2
    LOOP LOOPTOTAL

    MOV TOTAL1,DX
    MOV AX,DX
    MOV BX,10
    MUL BX

    MOV BX,100
    DIV BX
  
    MOV SSTPRICE,AX

    MOV AX,DX

    MOV SSTPRICEDIGIT,AX
    MOV AX,SSTPRICE
    MOV BX,TOTAL1
    ADD AX,BX
    MOV TOTAL,AX

    MOV AX,SSTPRICEDIGIT
    MOV BX,10
    MUL BX
    MOV SSTPRICEDIGIT,AX

    LEA SI,QUANTITY
    MOV AX,[SI+0]
    CMP AX,0000H
    RET
SST ENDP

PASSWORDS PROC
    ; Prompt for username
    MOV AH, 09H
    LEA DX, ENTERUSERNAME
    INT 21H
    MOV AH, 0AH
    LEA DX, INUSER
    INT 21H

    ; Prompt for password
    MOV AH, 09H
    LEA DX, ENTERPASSWORD
    INT 21H
    XOR BX, BX             ; BX as index for storing password characters
    MOV PWCOUNT, 0         ; Reset password counter

PASSWORD_INPUT:
    MOV AH, 07H            ; Read character without echoing
    INT 21H
    CMP AL, 13             ; Check if Enter key
    JE  CHECKLOGIN         ; Jump to check login if Enter
    MOV INPSW[BX], AL      ; Store the input character in password buffer
    INC BX
    INC PWCOUNT            ; Increment password length counter
    MOV AH, 02H
    MOV DL, '*'            ; Echo '' for each password character
    INT 21H
    CMP BX, 20             ; Check if maximum password length is reached
    JB PASSWORD_INPUT

CHECKLOGIN:
    MOV BYTE PTR [INPSW+BX], 0     ; Null-terminate the password input
    XOR BX, BX             ; Reset BX for username validation

    ; Validate username
    MOV SI, OFFSET ADMINUSER      ; SI points to the correct username
    LEA DI, INUSER+2       ; DI points to the input username (skip length byte)
    MOV CX, 4              ; Length of the username "abcd"
USERNAME_CHECK:
    MOV AL, [SI]
    MOV AH, [DI]
    INC SI
    INC DI
    CMP AL, AH
    JNE INVALIDLOGIN
    DEC CX
    JNZ USERNAME_CHECK

    ; Validate password
    MOV SI, OFFSET ADMINPASSWORD  ; SI points to the correct password
    LEA DI, INPSW         ; DI points to the input password
    MOV CX, 4             ; Length of the password "1234"
PASSWORD_CHECK:
    MOV AL, [SI]
    MOV AH, [DI]
    INC SI
    INC DI
    CMP AL, AH
    JNE INVALIDLOGIN
    DEC CX
    JNZ PASSWORD_CHECK

LOGINSUCCESS:
    MOV AH, 09H
    LEA DX, SCCLOGIN       ; Display login success message
    INT 21H
    MOV AH, 01H            ; Wait for any key
    INT 21H
    JMP MENU               ; Proceed to menu page

INVALIDLOGIN:
    MOV AH, 09H
    LEA DX, INLOGIN        ; Display invalid login message
    INT 21H
    MOV AH, 01H            ; Wait for any key
    INT 21H
    JMP PASSWORDS          ; Restart login procedure

PASSWORDS ENDP
;description
DEFINEERROR PROC
    CMP BOOLEAN,1
    JE ERROR
    RET
ERROR:
    CALL INVALID
    MOV BOOLEAN,0
    RET
DEFINEERROR ENDP
;DX = NAME STROING PLACES
;CX = LOOPING PLACES
;BX = CALCULATING PLACE
MAIN PROC 
    MOV AX,@DATA
    MOV DS,AX
;LOGIN START
    MOV AL,03H;SET VIDEO MODE
    MOV AH,0
    INT 10H

    mov ah, 9
    mov al, ' '     ; Character to print (space to set the background color)
    mov bh, 0       ; Page number (usually 0)
    mov bl, 4       ; Attribute byte (background color is 0 (black), foreground color is 4 (red))
    MOV CX,01F0H
    MOV DX,0C4FH
    int 10h

    LEA DX,M32 
    MOV AH,9
    INT 21H

    LEA DX,M33
    MOV AH,9
    INT 21H

    LEA DX,M34 
    MOV AH,9
    INT 21H

    LEA DX,M35 
    MOV AH,9
    INT 21H

    LEA DX,M36 
    MOV AH,9
    INT 21H

    CALL NEWLINE
    CALL NEWLINE

    mov ah, 9
    mov al, ' '     ; Character to print (space to set the background color)
    mov bh, 0       ; Page number (usually 0)
    mov bl, 9       ; Attribute byte (background color is 0 (black), foreground color is 4 (red))
    MOV CX,0050H
    MOV DX,0C4FH
    int 10h

    LEA DX,M37
    MOV AH,9
    INT 21H

    mov ah, 9
    mov al, ' '     ; Character to print (space to set the background color)
    mov bh, 0       ; Page number (usually 0)
    mov bl, 00AH       ; Attribute byte (background color is 0 (black), foreground color is 4 (red))
    MOV CX,0050H
    MOV DX,0C4FH
    int 10h

    LEA DX,M38 
    MOV AH,9
    INT 21H

    CALL NEWLINE
    CALL NEWLINE
    CALL PASSWORDS
;MENU START
SHOWMENU:
 CALL DEFINEERROR
    CALL MENU
    LEA DX,M2 ;SHOW 'Enter your Choise ',10,'$'
    MOV AH,9
    INT 21H

    MOV AH,1 ;INPUT VALUE
    INT 21H
    MOV BH,AL
    SUB BH,48

    CALL NEWLINE
	
	;------------------- Selection Checking
    CMP BH,1 ;JUMP FRIEDCHICKEN
    JE FRIEDCHICKEN

    JMP MASHEDPOTATO1
FRIEDCHICKEN:
    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    
    CMP AX,19
    MOV BOOLEAN,1
    JA SHOWMENU
	MOV [SI+0], AX    ; Store the final number in the variable "number"
	MOV BOOLEAN,0
	CALL QUANTITYOUTPUT
	MOV AX,[SI]
    CALL PRINT
    CALL NEWLINE

    CALL CHOICE
    CMP BH, 'Y';
    JE SHOWMENU
	CMP BH, 'y';
    JE SHOWMENU

    CMP BH, 'N';
    JMP COUNTSST1
    CMP BH, 'n';
    JMP COUNTSST1

    CALL INVALID
    JMP FRIEDCHICKEN


MASHEDPOTATO1:
    CMP BH,2 ;JUMP MASHEDPOTATO
    JE MASHEDPOTATO

    JMP CRISPYCHICKENBURGER1
MASHEDPOTATO:
    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    
    CMP AX,19
    MOV BOOLEAN,1
    JA SHOWMENU1
	MOV [SI+2], AX   ; Store the final number in the variable "number"
	MOV BOOLEAN,0
	CALL QUANTITYOUTPUT
	MOV AX,[SI+2]
    CALL PRINT
    CALL NEWLINE

    CALL CHOICE
    CMP BH, 'Y';
    JE SHOWMENU1
	CMP BH, 'y';
    JE SHOWMENU1

    CMP BH, 'N';
    JMP COUNTSST1
    
	CMP BH, 'n';
    JMP COUNTSST1
    

    CALL INVALID
    JMP MASHEDPOTATO

CRISPYCHICKENBURGER1:
    CMP BH,3 ;JUMP CRISPYCHICKENBURGER
    JE CRISPYCHICKENBURGER
	
    JMP CHICKENCHOPWITHFRIES1
SHOWMENU1:
    JMP SHOWMENU
COUNTSST1:
    JMP DEFINEEXIT
CRISPYCHICKENBURGER:
    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    

    CMP AX,19
    MOV BOOLEAN,1
    JA SHOWMENU1
	MOV [SI+4], AX    ; Store the final number in the variable "number"
	MOV BOOLEAN,0
	CALL QUANTITYOUTPUT
	MOV AX,[SI+4]
    CALL PRINT
    CALL NEWLINE

    CALL CHOICE
    CMP BH, 'Y';
    JE SHOWMENU1
	CMP BH, 'y';
    JE SHOWMENU1

    CMP BH, 'N';
    JMP COUNTSST1
	CMP BH, 'n';
    JMP COUNTSST1

    CALL INVALID
    JMP CRISPYCHICKENBURGER

CHICKENCHOPWITHFRIES1:
    CMP BH,4 ;JUMP CHICKENCHOPWITHFRIES
    JE CHICKENCHOPWITHFRIES

    JMP COLESLAW1
CHICKENCHOPWITHFRIES:
    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY

    CMP AX,19
    MOV BOOLEAN,1
    JA SHOWMENU2
    MOV [SI+6], AX   ; Store the final number in the variable "number"
	MOV BOOLEAN,0
	CALL QUANTITYOUTPUT
	MOV AX,[SI+6]
    CALL PRINT
    CALL NEWLINE

    CALL CHOICE
    CMP BH, 'Y';
    JE SHOWMENU2
	CMP BH, 'y';
    JE SHOWMENU2

    CMP BH, 'N';
    JMP COUNTSST1
	CMP BH, 'n';
    JMP COUNTSST1

    CALL INVALID
    JMP CHICKENCHOPWITHFRIES

COLESLAW1:
    CMP BH,5 ;JUMP COLESLAW
    JE COLESLAW

    JMP DEFINEEXIT1
SHOWMENU2:
    JMP SHOWMENU1
COUNTSST2:
	JMP DEFINEEXIT
COLESLAW:
    CALL OUTPRINTQUANTITY
    CALL SCANTWODIGITNUMBER
    MOV SI,OFFSET QUANTITY
    
    CMP AX,19
    MOV BOOLEAN,1
    JA SHOWMENU2
    MOV [SI+8], AX    ; Store the final number in the variable "number"
	MOV BOOLEAN,0
	CALL QUANTITYOUTPUT
	MOV AX,[SI+8]
    CALL PRINT
    CALL NEWLINE

    CALL CHOICE
    CMP BH, 'Y';
    JE SHOWMENU2
	CMP BH, 'y';
    JE SHOWMENU2

    CMP BH, 'N';
    JE DEFINEEXIT
	CMP BH, 'n';
    JE DEFINEEXIT

    CALL INVALID
    JMP COLESLAW

DEFINEEXIT1:
    CMP BH,6 ;JUMP EXIT
    JMP EXIT

    CALL INVALID
    JMP SHOWMENU

DEFINEEXIT:
    MOV CX,5
    LEA SI,QUANTITY
	
    LOOPEXIT:
        MOV AX,[SI]
        CMP AX,0
        JNE COUNTSST
		
        ADD SI,2
        LOOP LOOPEXIT

    JMP NEXTCUSTOMER

COUNTSST:
    CALL SST

SHOWRECIPT:
    CALL RECIPT
    CALL PAYMENT
	CALL TOTALDAILYEARN

NEXTCUSTOMER:
    LEA DX,M20 ;'NEXT CUSTOMER'
    MOV AH,9
    INT 21H

    MOV AH,1 ;INPUT VALUE
    INT 21H
    MOV BH,AL

    CALL NEWLINE

    CMP BH,'y'
    JE SHOWMENU3

    CMP BH,'Y'
    JE SHOWMENU3

    CMP BH,'n'
    JE EXITSYSTEM

    CMP BH,'N'
    JE EXITSYSTEM

    JMP NEXTCUSTOMER

SHOWMENU3:
    LEA SI,QUANTITY
    MOV CX,5
    MOV AX,0000H
    LOOPCLEANQUANTITY:
        MOV [SI],AX
        ADD SI,2
        LOOP LOOPCLEANQUANTITY
    MOV AX,@DATA
    MOV DS,AX

    XOR AX,AX
    MOV TOTAL,AX
    MOV SSTPRICE,AX
    MOV SSTPRICEDIGIT,AX

    JMP SHOWMENU2

EXITSYSTEM:
	CALL NEWLINE
	CALL NEWLINE
    MOV AX,DAILYEARN
    CMP AX,0
    JE DOT1

    LEA DX,M26;'DAILY EARN'
    MOV AH,9
    INT 21H

    MOV AX,DAILYEARN
    CALL PRINT

DOT1:
    MOV AX,DAILYEARNDIGIT
    CMP AX,0
    JE NEWLINEEXIT

    MOV DX,OFFSET DOT
    MOV AH,9
    INT 21H
    
    MOV AX,DAILYEARNDIGIT
    CALL PRINT

NEWLINEEXIT:
    CALL NEWLINE

    CALL EXIT

MAIN ENDP
END MAIN
