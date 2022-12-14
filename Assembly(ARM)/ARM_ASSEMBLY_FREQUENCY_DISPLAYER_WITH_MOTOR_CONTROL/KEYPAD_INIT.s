PD_INP				EQU		0X4000703C
PB_INP				EQU		0X4000503C
GPIO_PORTD_DIR_R	EQU		0X40007400
GPIO_PORTD_AFSEL_R	EQU		0X40007420
GPIO_PORTD_DEN_R	EQU		0X4000751C
GPIO_PORTD_AMSEL_R	EQU		0X40007528
GPIO_PORTD_PUR		EQU		0X40007510 ;514
SYSCTL_RCGC2_R		EQU		0X400FE608
GPIO_PORTD_IS		EQU		0X40007404
GPIO_PORTD_IBE		EQU		0X40007408
GPIO_PORTD_IEV		EQU		0X4000740C
GPIO_PORTD_IM		EQU		0X40007410
GPIO_PORTD_ICR		EQU		0X4000741C
GPIO_PORTD_RIS		EQU		0X40007414
nvic				equ		0xE000E100
nvicpr				equ		0xE000E403
	
	
GPIO_PORTB_DIR_R	EQU		0X40005400
GPIO_PORTB_AFSEL_R	EQU		0X40005420
GPIO_PORTB_DEN_R	EQU		0X4000551C
GPIO_PORTB_AMSEL_R	EQU		0X40005528
GPIO_PORTB_PDR		EQU		0X40005514 ;514
GPIO_PORTB_IS		EQU		0X40005404
GPIO_PORTB_IBE		EQU		0X40005408
GPIO_PORTB_IEV		EQU		0X4000540C
GPIO_PORTB_IM		EQU		0X40005410
GPIO_PORTB_ICR		EQU		0X4000541C
GPIO_PORTB_RIS		EQU		0X40005414


;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA init_gpio,	CODE,	READONLY,	ALIGN=2
				THUMB
				
				EXPORT		KEYPAD_INIT
;D INPUT 0-1-2-3
;B OUTPUT 0-1-2-3
			
KEYPAD_INIT		PROC
		;ACTIVATE CLOCK
				LDR		R1,=SYSCTL_RCGC2_R
				LDR		R0,[R1]
				ORR		R0,R0,#0X0A	;PORT B AND D	
				STR		R0,[R1]
				NOP
				NOP
				NOP
		;SET DIRECTION REGISTER
				LDR		R1,=GPIO_PORTD_DIR_R
				LDR		R0,[R1]
				BIC		R0,R0,#0X0F			;0000 INPUT
				STR		R0,[R1]
				LDR		R1,=GPIO_PORTB_DIR_R
				LDR		R0,[R1]
				ORR		R0,R0,#0X0F			;1111 OUTPUT
				STR		R0,[R1]			
				
		;REGULAR PORT FUNCTION
				LDR		R1,=GPIO_PORTD_AFSEL_R
				LDR		R0,[R1]
				BIC		R0,R0,#0X0F
				STR		R0,[R1]
				LDR		R1,=GPIO_PORTB_AFSEL_R
				LDR		R0,[R1]
				BIC		R0,R0,#0X0F
				STR		R0,[R1]			
						
		;PULLUP RESISTORS ON INPUT PINS
				LDR		R1,=GPIO_PORTD_PUR
				MOV		R0,#0X0F
				STR		R0,[R1]

		;ENABLE DIGITAL PORT
				LDR		R1,=GPIO_PORTD_DEN_R
				LDR		R0,[R1]
				ORR		R0,R0,#0X0F
				STR		R0,[R1]
				LDR		R1,=GPIO_PORTB_DEN_R
				LDR		R0,[R1]
				ORR		R0,R0,#0X0F
				STR		R0,[R1]			
				
		;DISABLE ANALOG PORT
				LDR		R1,=GPIO_PORTD_AMSEL_R
				LDR		R0,[R1]
				BIC		R0,R0,#0X0F
				STR		R0,[R1]
				LDR		R1,=GPIO_PORTB_AMSEL_R
				LDR		R0,[R1]
				BIC		R0,R0,#0X0F
				STR		R0,[R1]			
				
				
		;CONFIGURE INTERRUPT FOR PORTB PINS 0-3=INPUT
				LDR		R1,=GPIO_PORTD_IS
				LDR		R2,=GPIO_PORTD_IBE
				LDR		R3,=GPIO_PORTD_IEV
				LDR		R4,=GPIO_PORTD_IM
				LDR		R5,=GPIO_PORTD_ICR
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
				ORR		R0,R0,#0X08
				STR		R0,[R4]	
				
				LDR		R0,[R5]
				BIC		R0,#0XFF;NOT SENT TO NVIC
				ORR		R0,#0X0F
				STR		R0,[R5]
				ldr		r1,=nvic
				ldr		r0,[r1]
				orr		r0,r0,#0x08
				str		r0,[r1]
				
				ldr		r1,=nvicpr
				ldr		r0,[r1]
				orr		r0,r0,#0x40
				str		r0,[r1]
;				
				
				
				BX 		LR
				ENDP
				END