GPIO_PORTD_ICR		EQU		0X4000741C
GPIO_PORTD_DATA		EQU		0X4000703c
GPIO_PORTB_DATA		EQU		0X4000503c
nu					equ		0x20000250
				AREA init_gpio,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT		KEYPAD_Interrupt
				extern		DELAY100
				EXTERN		DELAY10
				extern		SCR_XY
				extern		SCR_CHAR
					
KEYPAD_Interrupt	proc
				push		{r1-r12}
				mov			r6,#0x0
				LDR			R11,=GPIO_PORTB_DATA
				LDR			R2,[R11]
				ORR			R2,R2,#0X07;;make portC1231 TO CHECK THE LAST DIGIT
				str			r2,[r11]
				
				push		{lr}
				bl			DELAY10;DEBOUNCING
				pop			{lr}
				
				LDR			R10,=GPIO_PORTD_DATA
				LDR			R2,[R10]
				BIC			R2,#0xf0
				cmp			r2,#0x07;;check if the button 16 is pressed IF SO FREQUENCY SELECT IS PRESESED
				moveq		r8,#0x2
				moveq		r9,#2
				MOVEQ		R0,#0X17
				moveq		r12,#1
				beq			waitsw
				
				
				LDR			R2,[R11]
				mov			r2,#0x0B;IF BUTTON 16 IS NOT PRESSED CHECK BUTTON 12
				str			r2,[r11]
				push		{lr}
				bl			DELAY10
				pop			{lr}
				LDR			R2,[R10];
				BIC			R2,#0xf0
				cmp			r2,#0x07;IF BUTTON 12 IS PRESSED AMPLITUDE CHECK
				moveq		r8,#0x0
				moveq		r9,#0
				MOVEQ		R0,#0X3C
				moveq		r12,#2
				BNE			exit_keypad
				
waitsw		LDR			R2,[R10];DEBOUNCING
			cmp			r2,#0x0f
			bne			waitsw
			push	{lr}
			bl		DELAY100
			pop		{lr}
				
					
			MOV		R1,r12;SET XY COORDINATE FOR SCREEN
			push	{lr}
			BL		SCR_XY
			pop		{lr}
			
floop		mov		r7,#3;;THE OUTER LOOP IS FOR TAKING MORE THAN 1 NUMBER FOR FRQUNECY SELECT
			mov		r6,#0
			mov		r3,#1
loop		cmp		r3,#5;LOOP FOR READING 1 KEY
			moveq	r3,#1
			mov		r5,#1
			mov		r1,#0x0f;CHANGE THE OUTPUTS TO SEARCH EVERY ROW
			SUB		r4,r3,#1
			lsl		r5,r4
			sub		r1,r1,r5
			mov		r5,#5
			str		r1,[r11]				;make the output "0" for first row
			nop
			nop
			nop							;wait for output to stablize
			ldrb	r1,[r10]
			bic		r1,#0xf0
			cmp		r1,#0x0e
			moveq	r5,#0x0
			cmp		r1,#0x0d
			moveq	r5,#0x1
			cmp		r1,#0x0b
			moveq	r5,#0x2
			cmp		r1,#0x07
			moveq	r5,#0x3			;check for each column
			cmp		r5,#5;;LOOP BACK IF NO BUTTON IS READ
			addeq	r3,#1;
			beq		loop
			
			bne		print		        

			
			
			
print		push	{lr};DEBOUNCING
			bl		DELAY100
			pop		{lr}
			;wait 100ms for debouncing (for pressing)
check		ldrb	r1,[r10]
			bic		r1,#0xf0
			cmp		r1,#0x0f
			bne		check
			
			push	{lr}
			bl		DELAY100;DEBOUNCING
			pop		{lr}
			sub		r3,#1
			lsl		r3,#2
			add		r5,r3;CALCULATE THE BUTTON NUBER
			
			add		r6,r5
			mov		r4,#10
			add		r5,#0x30;PRINT SCREEN
			push	{lr}
			bl		SCR_CHAR
			pop		{lr}
			
			subs	r7,#1;COUNTER FOR 3 DIGIT
			mulne	r6,r4;MULTIPLY THE SUM VALUE TO CONVERT THE BUTTONS TO DECIMAL 3 DIGIT
			mov		r3,#1;
			
			
			bne		loop;READ AGAIN
			ldr		r1,=nu
			add		r1,r9,lsl#1
			strh	r6,[r1];STORE THE VALUE, IF AMPLITUDE, R9 IS 0, IF FREQUENCY FOR HIGHFREQUENCY R9 IS 2, FOR LOW IT IS 1
			;SO THE MEMORY IS AMPLITUDE-LOWFREQ-HGHFREQ IN ORDER
			
			cmp		r8,#2;IF THE AMPLTUDE BUTTON IS PRESSED 3 DIGIT IS ENOUGH, EXIT
			bne 	exit_keypad
			
			subs	r9,#1
			
			
			beq		exit_keypad;IF FREQUNECY THRESHOLD BUTTON IS SELECTED LOOP AGAIN
			mov		r5,#0x2D; PRINT (-) CHAR BETWEEN FREQUENCIES
			push	{lr}
			bl		SCR_CHAR
			pop		{lr}
			b		floop
			




	
					

exit_keypad		LDR			R11,=GPIO_PORTB_DATA;RESET ALL THE OUTPUT PINS SO THAT NEW INTERRUPT CANT BE DETECTED
				LDR			R2,[R11]
				BIC			R2,R2,#0X0F
				STR			R2,[R11]
				
				LDR			R1,=GPIO_PORTD_ICR;CLEAT INTERRUPT
				LDR			R2,[R1]			
				ORR			R2,R2,#0X08
				STR			R2,[R1]
				pop			{r1-r12}
				bx			lr	
				endp
				end