nu					equ		0x20000240
GPIO_PORTF_DATA		EQU 	0x4002507c
GPIO_PORTD_ICR		EQU		0X4002541C

				AREA init_gpio,	CODE,	READONLY,	ALIGN=2
				THUMB
					
				EXPORT		F_INT
				EXTERN		DELAY10

					
F_INT			proc
				PUSH		{r1-r12}
				ldr			r1,=GPIO_PORTF_DATA
				ldr			r2,[r1];Read PORTF to determine the pushhed switch
				BIC			R2,#0X0E
				CMP			R2,#0X01;;;If the PB4 pin is 0 then the sw2 is pressed
				MOVEQ		R3,#1
				CMP			R2,#0X10;If the first pin is 0 then the sw1 is pressed
				MOVEQ		R3,#0
				LDR			R2,=nu
				str			r3,[r2];store motor direction in motor memort
				ldr			r1,=GPIO_PORTF_DATA
waitsw			LDR			R2,[R1]
				BIC			R2,#0X0E
				cmp			r2,#0x11
				bne			waitsw
				push		{lr}
				bl			DELAY10
				POP			{LR}
				ldr			r1,=GPIO_PORTD_ICR
				mov			r2,#0x11
				str			r2,[r1]
				pop			{r1-r12}
				bx			lr	
				endp
				end