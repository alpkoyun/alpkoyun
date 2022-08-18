GPIO_PORTB_AFSEL	EQU 0x40005420 ; Alt Function enable
GPIO_PORTB_DEN 		EQU 0x4000551C ; Digital Enable
GPIO_PORTB_PCTL 	EQU 0x4000552C ; Alternate Functions
GPIO_PORTB_DATA		EQU 0x40005010 ; Access BIT2
GPIO_PORTB_DIR 		EQU 0x40005400 ; Port Direction
GPIO_PORTB_AMSEL 	EQU 0x40005528 ; Analog enable	
GPIO_PORTF_DATA		EQU 0x4002507c ; Access BIT2
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_AMSEL 	EQU 0x40025528 ; Analog enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions
GPIO_PORTF_LOCK		EQU 0x40025520 ; Alternate Functions	
NUM	  	 	EQU 0x20000400
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
GPIO_PORTF_pup		EQU 0x40025510
GPIO_PORTF_IS		EQU 0X40025404
GPIO_PORTF_IBE		EQU 0X40025408
GPIO_PORTF_IEV		EQU 0X4002540C
GPIO_PORTF_IM		EQU 0X40025410
GPIO_PORTF_ICR		EQU 0X4002541C
GPIO_PORTF_RIS		EQU 0X40025414
nvic			equ	0xE000E103
nvicpr				equ	0xE000E41E
	

;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA isr,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT	init_gpiof

init_gpiof		PROC


			LDR		R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR 	R0, [R1]
			ORR		R0, R0, #0x20 ; 
			STR 	R0, [R1]
			NOP 							; allow clock to settle
			NOP
			NOP
			
			ldr		r1,=GPIO_PORTF_AFSEL
			ldr		r0,[r1]
			orr		r0,#0x00
			str		r0,[r1]				
			
			LDR		R1, =GPIO_PORTF_LOCK ; start GPIO clock
			LDR 	R0,=0x4C4F434B
			STR 	R0,[R1],#4
			nop
			nop
			
			ldr		R0,[R1]
			orr		R0,#0XFF
			str		R0,[R1],#-4
			LDR		R0,[R1]
			
			ldr		r1,=GPIO_PORTF_DIR
			ldr		r0,[r1]
			mov		r0,#0x0e
			str		r0,[r1]				;make PB2 output
			
			ldr		r1,=GPIO_PORTF_DEN
			ldr		r0,[r1]
			orr		r0,#0x1f
			str		r0,[r1]				;digital enable PB2
			
			
			ldr		r1,=GPIO_PORTF_AMSEL
			mov		r0,#0
			str		r0,[r1]					;Disable analog mode
			
			ldr		r1,=GPIO_PORTF_pup
			ldr		r0,[r1]
			orr		r0,#0x11
			str		r0,[r1]
			
			ldr		r1,=GPIO_PORTF_DATA
			ldr		r0,[r1]
			orr		r0,#0xFF
			str		r0,[r1]
			
				LDR		R1,=GPIO_PORTF_IS
				LDR		R2,=GPIO_PORTF_IBE
				LDR		R3,=GPIO_PORTF_IEV
				LDR		R4,=GPIO_PORTF_IM
				LDR		R5,=GPIO_PORTF_ICR
				LDR		R0,[R1]
				BIC		R0,#0XFF
				STR		R0,[R1]
				
				LDR		R0,[R2]
				BIC		R0,#0XFF;EDGE SENSITIVE
				STR		R0,[R2]
				
				LDR		R0,[R3]
				BIC		R0,#0XFF;IEV CONTROL
				STR		R0,[R3]
				
				LDR		R0,[R4]
				BIC		R0,#0XFF;FALLING EDGE
				ORR		R0,R0,#0X11
				STR		R0,[R4]	
				
				LDR		R0,[R5]
				BIC		R0,#0XFF;
				ORR		R0,#0X0F
				STR		R0,[R5]
				ldr		r1,=nvic
				ldr		r0,[r1]
				orr		r0,r0,#0x40;enable interrupt
				str		r0,[r1]
				
				ldr		r1,=nvicpr
				ldr		r0,[r1]
				orr		r0,r0,#0x60;set priority 3
				str		r0,[r1]

			

				BX		LR
				ALIGN
				ENDP
				END
