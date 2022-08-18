;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  ISR OF THE Q1					  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PB_OUT				EQU		0X400053C0
GPIO_PORTB_ICR		EQU		0X4000541C
GPIO_PORTB_RIS		EQU		0X40005414
ADC0_RIS 			EQU 0x40038004 	; Interrupt status
ADC0_PSSI 			EQU 0x40038028 	; Initiate sample
ADC0_SSFIFO3 		EQU 0x400380A8 	; Channel 3 results ADC0_PC EQU 0x40038FC4 ; Sample rate
ADC0_ISC			EQU	0X4003800C	;INTERRUPT STATUS AND CLEAR REGISTER	
NUM	  	 			EQU	0x20000400
NU	  	 			EQU	0x20000200
nu	  	 			EQU	0x20000260
store				equ	0x20000300	
NVIC_ST_CTRL	EQU		0XE000E010

	
;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA isr,	CODE,	READONLY,	ALIGN=2
				THUMB
MSG1     	DCB     	"frequency"
MSG2     	DCB     	"Amplitude"
				
				EXPORT	My_ST_ISR
				EXTERN	OutStr
				EXTERN	CONVRT
				EXTERN		arm_cfft_sR_q15_len256
				EXTERN		arm_cfft_q15
				EXTERN		InitSysTick	
				EXTERN		Output
				EXTERN		SCR_XY
				EXTERN		SCR_CHAR
My_ST_ISR		PROC
				
				LDR			R1,=NU
				LDR			R11,[R1],#4;THE ADDRESS OF THE CURRENT FFT ADRESS IS LOADED
				LDR			R12,[R1];THE COUNTER IS LOADED
				
				
				LDR 		R3, =ADC0_RIS 		; interrupt address
				LDR 		R4, =ADC0_SSFIFO3 	; result address
				LDR 		R2, =ADC0_PSSI 		; sample sequence initiate address
				
			
				LDR 		R0, [R2]
				ORR 		R0, R0, #0x08 		; set bit 3 for SS3
				STR 		R0, [R2];initiate sampling
				
				
Cont 			LDR 		R0, [R3]
				ANDS 		R0, R0, #8;w8 until the analog read is finish
				BEQ 		Cont
				
				
				;branch fails if the flag is set so data can be read and flag is cleared
				LDR 		R0,[R4];read data
				SUB			R0,#1551;substract offset
				mov			r3,#0
				mov			r4,#3
			;	mul			r0,r4
				strh		r0,[r11],#2;store the read value to the FFT ADDRESS
				strh		r3,[r11],#2;STORE 0 TO IMAGNINARY PART
				
				
				
				add			r12,#1;counter;INCREASE COUNTER
				cmp			r12,#256
				
				bne			EXIT;exit before 256
				
				
				;IF counter=256 then use FFT
				LDR			R1,=NVIC_ST_CTRL;stop THE SYSTICK CLOCK BEFORE USING FFT
				MOV			R0,#0X00
				STR			R0,[R1]
				
				ldr			r1,=NUM
				ldr			r0,=arm_cfft_sR_q15_len256
				mov			r2,#0					
				MOV			R3,#1
				push		{lr}
				BL			arm_cfft_q15;USE FFT
				
			ldr			r1,=NUM
			mov			r7,#0
			mov			r8,#0
			mov32		r10,#0xffffff
			
			
fg			ldrsh		r6,[r1],#2
			ldrsh		r5,[r1],#2
			
			mul			r6,r6,r6
			mul			r5,r5,r5
			add			r6,r5
			
			cmp			r6,r7;r7is amplitude
			movgt		r7,r6
			movgt		r9,r8;r9 is hz
			add			r8,#1
			cmp			r8,#128
			bne			fg
			

			mov			r5,#1000;
			mul			r9,r5;multiply the frequency with 10000
			udiv		r9,r8;divide by 128 to reach the real frequency value
			
			LDR			R1,=nu	
			str			r7,[r1],#4;store amplitude in the memort
			str			r9,[r1],#4;;store frequency in the memort
			mov			r4,r9
			BL			Output
;			

			bl			InitSysTick	;start the clock again 
			pop			{lr}
			mov			r12,#0;reset the counter and the address
			LDR			R11,=NUM
			
				
			

EXIT		LDR 		R6,= ADC0_ISC
			MOV 		R0, #8
			STR 		R0, [R6] 


			LDR			R1,=NU
			STR			R11,[R1],#4
			STR			R12,[R1]
				

				BX		LR
				ALIGN
				ENDP
				END
