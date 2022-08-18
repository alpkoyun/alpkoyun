;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA screen,	CODE,	READONLY,	ALIGN=2
				THUMB				
				
				IMPORT		SCREEN_INIT
				IMPORT		SCR_XY
				IMPORT		SCR_CHAR
					
					
;				EXPORT		CLEAR4
;				EXPORT		SCREEN_POT	
;				EXPORT		SCREEN_KEY	
;				EXPORT		DISPLAY
				EXPORT		SCREEN_ALWYS

THRESHOLD			EQU		0X20000400
					
;NOKIA1 RST		PA7
;NOKIA2 CE		PA3
;NOKIA3 DC		PA6
;NOKIA4 DIN		PA5
;NOKIA5 CLK		PA2
;NOKIA6 VCC		3.3V
;NOKIA7 BL		3.3V
;NOKIA8 GND		GND
;NOTE: MOST OF THIS SCREEN CODE IS TAKEN FROM THE ADDRESS https://github.com/efeyitim/EE447-Introduction-to-Microprocessors/tree/main/Project/PROJECT

SCREEN_ALWYS	PROC
				PUSH	{LR}
				MOV		R0,#0X0D
				MOV		R1,#0X0
				BL		SCR_XY	
				MOV		R5,#0X54		;T
				BL		SCR_CHAR				
				MOV		R5,#0X68		;h
				BL		SCR_CHAR				
				MOV		R5,#0X72		;r
				BL		SCR_CHAR				
				MOV		R5,#0X65		;e
				BL		SCR_CHAR
				MOV		R5,#0X73;		s
				BL		SCR_CHAR
				MOV		R5,#0X68		;h
				BL		SCR_CHAR
				MOV		R5,#0X6f		;o
				BL		SCR_CHAR
				MOV		R5,#0X6c		;l
				BL		SCR_CHAR
				MOV		R5,#0X64		;d
				BL		SCR_CHAR
				MOV		R5,#0X73		;d
				BL		SCR_CHAR
				;THESE CHARACTERS WILL BE DISPLAYED ALWAYS
				MOV		R0,#0X0
				MOV		R1,#0X1
				BL		SCR_XY			;SET CURSOR TO THE BEGINNING
				
				MOV		R5,#0X46		;f
				BL		SCR_CHAR
				MOV		R5,#0X72		;r
				BL		SCR_CHAR
				MOV		R5,#0X65		;e
				BL		SCR_CHAR								
				MOV		R5,#0X3A		;:
				BL		SCR_CHAR

				
				MOV		R5,#0X37		;7
				BL		SCR_CHAR
				MOV		R5,#0X30		;0
				BL		SCR_CHAR
				MOV		R5,#0X30		;0
				BL		SCR_CHAR
				MOV		R5,#0X2d		;-
				BL		SCR_CHAR
				MOV		R5,#0X33		;3
				BL		SCR_CHAR
				MOV		R5,#0X30		;0
				BL		SCR_CHAR
				MOV		R5,#0X30		;0
				BL		SCR_CHAR
				
				MOV		R0,#0X49
				MOV		R1,#0X1
				BL		SCR_XY			;SET CURSOR TO THE LEFT OF THE ROW

				MOV		R5,#0X48		;H
				BL		SCR_CHAR
				MOV		R5,#0X7A		;Z
				BL		SCR_CHAR
				MOV		R0,#0X49
				MOV		R1,#0X5
				BL		SCR_XY			;SET CURSOR TO THE LEFT OF THE ROW

				MOV		R5,#0X48		;H
				BL		SCR_CHAR
				MOV		R5,#0X7A		;Z
				BL		SCR_CHAR

				MOV		R0,#0X0
				MOV		R1,#0X2
				BL		SCR_XY			;SET CURSOR TO THE START OF ROW1
	

				MOV		R5,#0X41		;A
				BL		SCR_CHAR				
				MOV		R5,#0X6d		;m
				BL		SCR_CHAR				
				MOV		R5,#0X70		;p
				BL		SCR_CHAR				
				MOV		R5,#0X6c		;l
				BL		SCR_CHAR				
				MOV		R5,#0X69		;:i
				BL		SCR_CHAR
				MOV		R5,#0X74		;t
				BL		SCR_CHAR
				MOV		R5,#0X75		;u
				BL		SCR_CHAR
				MOV		R5,#0X64		;d
				BL		SCR_CHAR
				MOV		R5,#0X65		;e
				BL		SCR_CHAR
				MOV		R5,#0X3a		;SPACE
				BL		SCR_CHAR
				MOV		R5,#0X33		;SPACE
				BL		SCR_CHAR
				MOV		R5,#0X30		;SPACE
				BL		SCR_CHAR
				
				
				MOV		R0,#0X49		
				MOV		R1,#0X4
				BL		SCR_XY			;SET CURSOR TO THE LEFT OF THE ROW
				MOV		R5,#0X44		;D
				BL		SCR_CHAR
				MOV		R5,#0X62		;b
				BL		SCR_CHAR				
				MOV		R0,#0X0C		
				MOV		R1,#0X3
				BL		SCR_XY
				
				MOV		R5,#0X4d		;M
				BL		SCR_CHAR
				MOV		R5,#0X69		;i
				BL		SCR_CHAR
				MOV		R5,#0X63		;c
				BL		SCR_CHAR
				MOV		R5,#0X20		; 
				BL		SCR_CHAR
				MOV		R5,#0X56		;V
				BL		SCR_CHAR
				MOV		R5,#0X61		;A
				BL		SCR_CHAR
				MOV		R5,#0X6C		;L
				BL		SCR_CHAR
				MOV		R5,#0X75		;U
				BL		SCR_CHAR
				MOV		R5,#0X65		;E
				BL		SCR_CHAR
				MOV		R5,#0X73		;S
				BL		SCR_CHAR
;				MOV		R0,#0X0
;				MOV		R1,#0X3
;				BL		SCR_XY			;SET CURSOR TO THE START OF ROW3
;				
;				MOV		R5,#0X2D		;-
;				BL		SCR_CHAR				
;				MOV		R5,#0X3E		;>
;				BL		SCR_CHAR
;				MOV		R5,#0X20		;SPACE
;				BL		SCR_CHAR
				
				POP		{LR}
				BX		LR
				ENDP
				
;///////////////////////////////////////////////////////////////;				
				
;DISPLAY			PROC
;				PUSH	{R0-R11,LR}
;				
;				CMP		R11,#2
;				BLEQ	DISP_BRK			;IF THE MODE IS BREAK MODE, THEN DISPLAY ACCORDINGLY
;				CMP		R11,#1
;				BLEQ	DISP_THR			;IF THE MODE IS THRESHOLD SETTING MODE, THEN DISPLAY ACCORDINGLY
;				CMP		R11,#0
;				BLEQ	DISP_NORMAL			;IF THE MODE IS NORMAL MODE, THEN DISPLAY ACCORDINGLY

;				POP		{R0-R11, LR}
;				BX		LR
;				ENDP

;;///////////////////////////////////////////////////////////////;	

;DISP_NORMAL		PROC
;				PUSH	{LR,R8}

;				;CHECK IF MEASUREMENT IS GREATER THAN 999
;				LDR		R0, =999
;				CMP		R8, R0				;R8 HAS THE DISTANCE
;				BHI		GT9991			
;					
;				;DISPLAY MEASUREMENT
;				MOV		R0,#0X20			;IF THERE IS A > CHAR, DELETE IT
;				MOV		R1,#0X0
;				BL		SCR_XY
;				
;				MOV		R5,#0X20
;				BL		SCR_CHAR				
;				
;				MOV		R0,#0X25			;GET TO THE MEAS. PART
;				MOV		R1,#0X0
;				BL		SCR_XY				
;				MOV		R0, #0X64			;DIVIDE BY 100 THEN MULTIPLY BY 100 TO GET THE FIRST DIGIT
;				UDIV	R5, R8, R0
;				MUL		R1, R5, R0
;				SUB		R8, R1
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				MOV		R0, #0X0A			;DIVIDE BY 10 THEN MULTIPLY BY 10 TO GET THE SECOND DIGIT
;				UDIV	R5, R8, R0
;				MUL		R1, R5, R0
;				SUB		R8, R1
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				CPY		R5,R8				;THIRD DIGIT
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				B		CNTN1
;				
;GT9991			MOV		R0,#0X20			;IF THE DISTANCE IS GREATER THAN 999
;				MOV		R1,#0X0
;				BL		SCR_XY
;				MOV		R5, #0X3E			;>
;				BL		SCR_CHAR
;				MOV		R5, #0X39			;9
;				BL		SCR_CHAR
;				MOV		R5, #0X39			;9
;				BL		SCR_CHAR
;				MOV		R5, #0X39			;9
;				BL		SCR_CHAR

;				;DISPLAY THRESHOLD
;CNTN1			MOV		R0,#0X25			;COUNTINUE FROM THE THR. PART
;				MOV		R1,#0X1
;				BL		SCR_XY
;				
;				LDR		R0, =THRESHOLD
;				LDR		R8, [R0]
;				MOV		R0, #0X64			;DIVIDE BY 100 THEN MULTIPLY BY 100 TO GET THE FIRST DIGIT
;				UDIV	R5, R8, R0
;				MUL		R1, R5, R0
;				SUB		R8, R1
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				MOV		R0, #0X0A			;DIVIDE BY 10 THEN MULTIPLY BY 10 TO GET THE SECOND DIGIT
;				UDIV	R5, R8, R0
;				MUL		R1, R5, R0
;				SUB		R8, R1
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				CPY		R5,R8				;LAST DIGIT
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR

;				;DISPLAY MODE INFORMATION
;				MOV		R0,#0X10
;				MOV		R1,#0X3
;				BL		SCR_XY	

;				MOV		R5,#0X4E			;N
;				BL		SCR_CHAR
;				MOV		R5,#0X6F			;o
;				BL		SCR_CHAR				
;				MOV		R5,#0X72			;r
;				BL		SCR_CHAR				
;				MOV		R5,#0X6D			;m
;				BL		SCR_CHAR				
;				MOV		R5,#0X61			;a
;				BL		SCR_CHAR				
;				MOV		R5,#0X6C			;l
;				BL		SCR_CHAR	

;				MOV		R5,#0X20			;SPACE
;				BL		SCR_CHAR				
;				
;				MOV		R5,#0X4F			;O
;				BL		SCR_CHAR				
;				MOV		R5,#0X70			;p
;				BL		SCR_CHAR
;				MOV		R5,#0X2E			;.
;				BL		SCR_CHAR
;				
;				;DISPLAY BAR
;				BL 		DISP_BAR	
;				
;				POP		{LR}
;				BX		LR
;				ENDP
;				LTORG
;				
;;///////////////////////////////////////////////////////////////;				
;					
;DISP_THR		PROC
;				PUSH	{LR,R8}
;				
;				;DISPLAY MEASUREMENT AS ***
;				MOV		R0,#0X20			;IF THERE IS A > CHAR, DELETE IT
;				MOV		R1,#0X0
;				BL		SCR_XY
;				
;				MOV		R5,#0X20
;				BL		SCR_CHAR				
;				
;				
;				MOV		R0,#0X25			;GET TO THE MEAS PART
;				MOV		R1,#0X0
;				BL		SCR_XY
;				
;				MOV		R5,#0X2A			;DISPLAY *** ON THE MEAS PART
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				
;				;DISPLAY THRESHOLD
;				MOV		R0,#0X25			;GET TO THE THRESHOLD PART
;				MOV		R1,#0X1
;				BL		SCR_XY
;				
;				LDR		R0, =THRESHOLD
;				LDR		R8, [R0]
;				MOV		R0, #0X64			;DIVIDE BY 100 THEN MULTIPLY BY 100 TO GET THE FIRST DIGIT
;				UDIV	R5, R8, R0
;				MUL		R1, R5, R0
;				SUB		R8, R1
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				MOV		R0, #0X0A			;DIVIDE BY 10 THEN MULTIPLY BY 10 TO GET THE SECOND DIGIT
;				UDIV	R5, R8, R0
;				MUL		R1, R5, R0
;				SUB		R8, R1
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				CPY		R5,R8				;THIRD DIGIT
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR

;				;DISPLAY MODE INFORMATION
;				MOV		R0,#0X10
;				MOV		R1,#0X3
;				BL		SCR_XY	

;				MOV		R5,#0X54			;T
;				BL		SCR_CHAR
;				MOV		R5,#0X68			;h
;				BL		SCR_CHAR				
;				MOV		R5,#0X72			;r
;				BL		SCR_CHAR				
;				MOV		R5,#0X2E			;.
;				BL		SCR_CHAR					

;				MOV		R5,#0X20			;SPACE
;				BL		SCR_CHAR				
;				
;				MOV		R5,#0X41			;A
;				BL		SCR_CHAR				
;				MOV		R5,#0X64			;d
;				BL		SCR_CHAR
;				MOV		R5,#0X6A			;j
;				BL		SCR_CHAR
;				MOV		R5,#0X2E			;.
;				BL		SCR_CHAR
;				MOV		R5,#0X20			;CLEAR THE DOT OF NORMAL MODE
;				BL		SCR_CHAR					
;				
;				;DISPLAY BAR
;				MOV		R0,#0X00
;				MOV		R1,#0X5
;				BL		SCR_XY
;				
;				;DISPLAY ALL *S
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR				
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR
;				MOV		R5,#0X2A
;				BL		SCR_CHAR				

;				POP		{LR,R8}
;				BX		LR	
;				ENDP
;					
;;///////////////////////////////////////////////////////////////;				
;					
;DISP_BRK		PROC
;				PUSH	{LR,R8}

;				;CHECK IF MEASUREMENT IS GREATER THAN 999
;				LDR		R0, =999
;				CMP		R8, R0				;MEAS. IS ON R8
;				BHI		GT9992			
;				
;				;DISPLAY MEASUREMENT
;				MOV		R0,#0X20			;IF THERE IS A > CHAR, DELETE IT
;				MOV		R1,#0X0
;				BL		SCR_XY
;				
;				MOV		R5,#0X20
;				BL		SCR_CHAR
;				
;				MOV		R0,#0X25
;				MOV		R1,#0X0
;				BL		SCR_XY	
;				MOV		R0, #0X64			;DIVIDE BY 100 THEN MULTIPLY BY 100 TO GET THE FIRST DIGIT
;				UDIV	R5, R8, R0
;				MUL		R1, R5, R0
;				SUB		R8, R1
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				MOV		R0, #0X0A			;DIVIDE BY 10 THEN MULTIPLY BY 10 TO GET THE SECOND DIGIT
;				UDIV	R5, R8, R0
;				MUL		R1, R5, R0
;				SUB		R8, R1
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				CPY		R5,R8				;THIRD DIGIT
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				B		CNTN2
;				
;GT9992			MOV		R0,#0X20
;				MOV		R1,#0X0
;				BL		SCR_XY
;				MOV		R5, #0X3E			;>
;				BL		SCR_CHAR
;				MOV		R5, #0X39			;9
;				BL		SCR_CHAR
;				MOV		R5, #0X39			;9
;				BL		SCR_CHAR
;				MOV		R5, #0X39			;9
;				BL		SCR_CHAR				
;				
;				;DISPLAY THRESHOLD
;CNTN2			MOV		R0,#0X25
;				MOV		R1,#0X1
;				BL		SCR_XY
;				
;				LDR		R0, =THRESHOLD
;				LDR		R8, [R0]
;				MOV		R0, #0X64			;DIVIDE BY 100 THEN MULTIPLY BY 100 TO GET THE FIRST DIGIT	
;				UDIV	R5, R8, R0
;				MUL		R1, R5, R0
;				SUB		R8, R1
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				MOV		R0, #0X0A			;DIVIDE BY 10 THEN MULTIPLY BY 10 TO GET THE SECOND DIGIT
;				UDIV	R5, R8, R0
;				MUL		R1, R5, R0
;				SUB		R8, R1				;THIRD DIGIT
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR
;				CPY		R5,R8
;				ADD		R5, #0X30			;CONVERT TO ASCII
;				BL		SCR_CHAR

;				;DISPLAY MODE INFORMATION
;				MOV		R0,#0X10
;				MOV		R1,#0X3
;				BL		SCR_XY	

;				MOV		R5,#0X42			;B
;				BL		SCR_CHAR
;				MOV		R5,#0X52			;R
;				BL		SCR_CHAR				
;				MOV		R5,#0X41			;E
;				BL		SCR_CHAR				
;				MOV		R5,#0X4B			;A
;				BL		SCR_CHAR				
;				MOV		R5,#0X45			;K
;				BL		SCR_CHAR					

;				MOV		R5,#0X20			;SPACE
;				BL		SCR_CHAR				
;				
;				MOV		R5,#0X4F			;O
;				BL		SCR_CHAR				
;				MOV		R5,#0X4E			;N
;				BL		SCR_CHAR
;				MOV		R5,#0X20			;CLEAR DOTS OF THRESHOLD AND NORMAL MODE
;				BL		SCR_CHAR				
;				MOV		R5,#0X20
;				BL		SCR_CHAR				

;				;DISPLAY BAR
;				BL		DISP_BAR
;				
;				POP		{LR}
;				BX		LR	
;				ENDP
;					
;;///////////////////////////////////////////////////////////////;

;				;DISPLAY BAR
;DISP_BAR		PROC
;				POP		{R8}
;				PUSH	{R8,LR}
;				MOV		R0,#0X00			;GET TO THRE 5TH ROW
;				MOV		R1,#0X5
;				BL		SCR_XY
;				
;				MOV		R5,#0X43			;C
;				BL		SCR_CHAR					
;				MOV		R5,#0X41			;A
;				BL		SCR_CHAR				
;				MOV		R5,#0X52			;R
;				BL		SCR_CHAR
;				
;				LDR		R0, =THRESHOLD		;GET THE CURRENT THRESHOLD
;				LDR		R0, [R0]
;				MOV		R1, #100
;				UDIV	R0, R1				;GET THE HUNDREDS DIGIT OF THRESHOLD
;				UDIV	R8, R1				;GET THE HUNDREDS DIGIT OF DISTANCE
;				
;				MOV		R1, #0X00
;LOOPBAR			CMP		R1, #0X0A			;DISPLAY TEN CHARACTERS AFTER CAR
;				BEQ		FINBAR
;				
;				CMP		R1, R8				;IF WE ACHIEVE THE HUNDREDS DIGIT OF DISTANCE, THAN EVERY OTHER CHAR SHOULD BE PIPE
;				BEQ		ALLPIPE
;				
;				CMP		R1, R0				;IF WE ACHIEVE THE HUNDREDS DIGIT OF THRESHOLD, THAN PRINT X AS THRESHOLD
;				MOVEQ	R5, #0X58
;				BLEQ	SCR_CHAR
;				ADDEQ	R1, #1
;				BEQ		LOOPBAR
;				

;				
;				MOV		R5, #0X2D			;ANY OTHER CHAR SHOULD BE -
;				BL		SCR_CHAR
;				ADD		R1, #1
;				CMP		R1, #0X0A			;IF TEN CHAR.S ARE PRINTED, THAN EXIT
;				B		LOOPBAR
;				
;				;PRINT REMAINING CHARS ALL PIPE
;ALLPIPE			CMP		R1, #0X0A
;				BEQ		FINBAR
;				MOV		R5, #0X7C			;|
;				BL		SCR_CHAR
;				ADD		R1, #1
;				B		ALLPIPE
;				
;FINBAR			MOV		R5, #0X20
;				BL		SCR_CHAR
;				POP		{R8,LR}
;				BX		LR
;				ENDP
;					
;;///////////////////////////////////////////////////////////////;														
;				;IF WE ARE USING KEYPAD ON THRESHOLD MODE, THEN DISPLAY KEYPAD	
;SCREEN_KEY		PROC
;				PUSH	{R8,LR}
;				MOV		R0,#0X18
;				MOV		R1,#0X4
;				BL		SCR_XY


;				MOV		R5,#0X4B		;K
;				BL		SCR_CHAR
;				MOV		R5,#0X45		;E
;				BL		SCR_CHAR				
;				MOV		R5,#0X59		;Y
;				BL		SCR_CHAR
;				MOV		R5,#0X50		;P
;				BL		SCR_CHAR
;				MOV		R5,#0X41		;A
;				BL		SCR_CHAR				
;				MOV		R5,#0X44		;D
;				BL		SCR_CHAR				
;				
;				
;				POP		{R8,LR}
;				BX		LR
;				ENDP
;					
;;///////////////////////////////////////////////////////////////;				
;				;IF WE ARE USING KEYPAD ON POT. MODE, THEN DISPLAY KEYPAD	
;SCREEN_POT		PROC
;				PUSH	{R8,LR}
;				MOV		R0,#0X18
;				MOV		R1,#0X4
;				BL		SCR_XY
;				
;				MOV		R5,#0X20		;CLEAR
;				BL		SCR_CHAR
;				MOV		R5,#0X50		;P
;				BL		SCR_CHAR
;				MOV		R5,#0X4F		;O
;				BL		SCR_CHAR				
;				MOV		R5,#0X54		;T
;				BL		SCR_CHAR
;				MOV		R5,#0X2E		;.
;				BL		SCR_CHAR
;				MOV		R5,#0X20		;CLEAR
;				BL		SCR_CHAR				
;				
;				
;				
;				POP		{R8,LR}
;				BX		LR
;				ENDP

;;///////////////////////////////////////////////////////////////;				

;				;CLEAR ROW4, AFTER THRESHOLD MODE
;CLEAR4			PROC
;				PUSH	{R8,LR}
;				MOV		R0,#0X18
;				MOV		R1,#0X4
;				BL		SCR_XY


;				MOV		R5,#0X20		;ALL SPACES
;				BL		SCR_CHAR
;				MOV		R5,#0X20
;				BL		SCR_CHAR				
;				MOV		R5,#0X20
;				BL		SCR_CHAR
;				MOV		R5,#0X20
;				BL		SCR_CHAR
;				MOV		R5,#0X20
;				BL		SCR_CHAR				
;				MOV		R5,#0X20
;				BL		SCR_CHAR				
;				
;				
;				POP		{R8,LR}
;				BX		LR
;				ENDP					

;;///////////////////////////////////////////////////////////////;				

;				ALIGN
;				END