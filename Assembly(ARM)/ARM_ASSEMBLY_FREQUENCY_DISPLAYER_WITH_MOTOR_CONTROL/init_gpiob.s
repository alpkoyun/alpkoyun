;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		   GPIO PORTB INITIALIZATION OF Q1		  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PB_INP				EQU		0X4000503C
PB_OUT				EQU		0X400063C0
GPIO_PORTB_DIR_R	EQU		0X40006400
GPIO_PORTB_AFSEL_R	EQU		0X40006420
GPIO_PORTB_DEN_R	EQU		0X4000651C
GPIO_PORTB_AMSEL_R	EQU		0X40006528
GPIO_PORTB_PDR		EQU		0X40006514 ;514
SYSCTL_RCGC2_R		EQU		0X400FE608
GPIO_PORTB_IS		EQU		0X40006404
GPIO_PORTB_IBE		EQU		0X40006408
GPIO_PORTB_IEV		EQU		0X4000640C
GPIO_PORTB_IM		EQU		0X40006410
GPIO_PORTB_ICR		EQU		0X4000641C
GPIO_PORTB_RIS		EQU		0X40006414


;LABEL			DIRECTIVE	VALUE				COMMENT	
				AREA init_gpio,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT		PORTC_Init

			
PORTC_Init	PROC
	;ACTIVATE CLOCK
			LDR		R1,=SYSCTL_RCGC2_R
			LDR		R0,[R1]
			ORR		R0,R0,#0X04	;only port b	
			STR		R0,[R1]
			NOP
			NOP
			NOP
	;SET DIRECTION REGISTER
			LDR		R1,=GPIO_PORTB_DIR_R
			LDR		R0,[R1]
			ORR		R0,R0,#0XF0
		
			STR		R0,[R1]
	;REGULAR PORT FUNCTION
			LDR		R1,=GPIO_PORTB_AFSEL_R
			LDR		R0,[R1]
			BIC		R0,R0,#0XF0
			STR		R0,[R1]

		
	;ENABLE DIGITAL PORT
			LDR		R1,=GPIO_PORTB_DEN_R
			LDR		R0,[R1]
			ORR		R0,R0,#0XF0
			STR		R0,[R1]
	;DISABLE ANALOG PORT
			LDR		R1,=GPIO_PORTB_AMSEL_R
			LDR		R0,[R1]
			BIC		R0,R0,#0XF0
			STR		R0,[R1]
	;CONFIGURE INTERRUPT FOR PORTB PINS 0-3=INPUT
			;LDR		R1,=GPIO_PORTB_IS
			;LDR		R2,=GPIO_PORTB_IBE
			;LDR		R3,=GPIO_PORTB_IEV
			;LDR		R4,=GPIO_PORTB_IM
			;LDR		R5,=GPIO_PORTB_ICR
			
			;MOV		R0,#0X00
			;STR		R0,[R1]
			;STR		R0,[R2]
			;MOV		R0,#0X0F
			;STR		R0,[R3]
			;STR		R0,[R4]
			;STR		R0,[R5]
			
	;CONFIGURE NVIC
			;LDR		R1,=NVIC_ISER0
			;LDR		R0,[R1]
			;ORR		R0,R0,#02
			;STR		R0,[R1]
			;CPSIE	I
							
				LDR		R1,=PB_OUT
				MOV		R0,#0X20
				STR		R0,[R1]	

			BX 		LR
			ENDP
			END