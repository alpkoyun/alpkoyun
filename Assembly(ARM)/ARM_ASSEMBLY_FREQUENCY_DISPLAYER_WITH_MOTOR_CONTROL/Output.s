nu	  	 		EQU	0x20000250
num 	 		EQU	0x20000260
numm			EQU	0x20000270
GPIO_PORTF_DATA	EQU 0x4002507c ; Access BIT2
TIMER1_CTL		EQU 0x4003000C
TIMER1_TAPR		EQU 0x40030038

				AREA isr,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT	Output
				EXTERN	CONVRT
				EXTERN	SCR_CHAR
				extern	SCR_XY

Output			PROC
				PUSH	{R1-R12}
				push	{lr}
				LDR		R1,=nu
				ldr		r2,[r1],#2
				LDR		R3,=num
				ldr		r4,[r3],#4;load Amplitude
				MOV		R8,#0
				mov		r7,r4
				

				
				MOV			R0,#0
				MOV			R1,#4
				BL			SCR_XY;set xy coordinate
				
				MOV			R5,#0x41
				BL			SCR_CHAR
				MOV			R5,#0x70
				BL			SCR_CHAR
				MOV			R5,#0x3A
				BL			SCR_CHAR
				
	
							
log				cmp			r7,#0
				addne		r8,#1
				lsr			r7,#1;20log10sqrt(x)=3*log2(x)
				bne			log;; take the db of the amplitude 
				mov			r4,r8; the amplitude is first put into log2
				mov			r5,#3; then it is multipled by 3 to make it base 10
				mul			r4,r5
				
				ldr			r1,=num
				str			R4,[R1]
				
				
				bl			CONVRT; use convert function to convert the number to ascii values
				ldr			r4,=0x20000000
writ			LDRB		R5,[R4],#1
				MOV			R6,R5
				CMP			R6,#0X0d;read until newline is reached
				BEQ			contt
				bl			SCR_CHAR;print to the screen using scr_CHAR
				B			writ
				
				
				
				
contt			MOV			R0,#0
				MOV			R1,#5
				BL			SCR_XY
		
				MOV			R5,#0X46		;f
				BL			SCR_CHAR
				MOV			R5,#0X72		;r
				BL			SCR_CHAR
				MOV			R5,#0X65		;e
				BL			SCR_CHAR								
				MOV			R5,#0X3A
				BL			SCR_CHAR;:
				LDR		R3,=num
				ldr		r4,[r3,#4]
				BL		CONVRT
			mov			r3,#3
			ldr			r4,=0x20000000	;;same as the amplitude part take the CONVRT AND PRINT
write		LDRB		R5,[R4],#1
			MOV			R6,R5
			CMP			R6,#0X0d
			subne		r3,#1
			BEQ			CONT
			bl			SCR_CHAR
			B			write
				
				
	
	
	

CONT			cmp		r3,#0
				movne	r5,#0x20
				beq		compare;;If more then 3 values are printed print space 
				sub		r3,#1;; this is done to prevent the mixupwith the old value if the new value has less digits
				bl		SCR_CHAR
				b		CONT
				
				
compare			ldr		r3,=num
				ldr		r4,[r3],#4;;read amplitude
				ldr		r1,=nu;;read amplitude threshhold
				ldrh	r2,[r1],#2
				
				cmp		r4,r2;; if amplitude is below threshhold, exit to turn off led and motor
				blt		EXI
				
				ldr		r5,[r3];;load frequency value in r5
				ldrh	r6,[r1],#2;;load lower frequency limit
				cmp		r5,r6;;load if it is lower than the frequency limit branch to low
				blt		low

				ldrh	r7,[r1]
				cmp		r5,r7
				bgt		High
				b		normal

low
				ldr		r1,=GPIO_PORTF_DATA
				ldr		r2,[r1]
				BIC		R2,#0XE
				ORR		R2,#0X2;;turn on red led
				str		R2,[r1]
				mov		r8,#15;; make the motor tapr value 15
				lsl		r5,#1
				cmp		r5,r6;; decrease the tapr value if the twice of the frequency is higher than low limit
				subgt	r8,#3
				B		MOTOR
High	
				ldr		r1,=GPIO_PORTF_DATA
				ldr		r2,[r1]
				BIC		R2,#0XE
				ORR		R2,#0X4;turn on red blue
				str		R2,[r1]
				mov		r8,#4;make the motor tapr value 15
				lsr		r5,#1;decrease the tapr value if half of the frequency is higher than high limit
				cmp		r5,r7
				subgt	r8,#1
				B		MOTOR
normal
				ldr		r1,=GPIO_PORTF_DATA
				ldr		r2,[r1]
				BIC		R2,#0XE
				ORR		R2,#0X8;turn on red green
				str		R2,[r1]
				mov		r8,#9;make the motor tapr value 9
				lsl		r5,#1
				cmp		r5,r7;decrease the tapr value if the twice of the frequency is higher than high limit
				subgt	r8,#2
				B		MOTOR
				
MOTOR			LDR R1, =TIMER1_CTL ; disable timer during setup 
				LDR R2, [R1]
				BIC R2, R2, #0x01
				STR R2, [R1];disable timer
				LDR R3, =TIMER1_TAPR;
				str	r8,[r3];load tapr with the speed value according to the frequency stored in R8
				mov	r8,#3;;enable timer
				str	r8,[r1]
				B	EXIT
				
EXI				ldr		r1,=GPIO_PORTF_DATA
				ldr		r2,[r1]
				BIC		R2,#0XE;this branch means the amplitude is low, turn off the leds an slow down the motor
				str		R2,[r1]
				
				
EXIT			
				pop		{lr}
				POP		{R1-R12}
				BX		LR
				ALIGN
				ENDP
				END
					
				

			

			
			





;CONT	




;log			lsr			r7,#1
;			cmp			r7,#0
;			addne		r8,#1
;			bne			log
;			mov			r7,#3
;			mul			r8,r7
;			MOV			R4,R8
;			BL			CONVRT
		