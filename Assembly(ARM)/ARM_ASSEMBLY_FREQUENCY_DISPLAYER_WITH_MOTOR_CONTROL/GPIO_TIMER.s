NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI5			EQU 0xE000E414 ; IRQ 16 to 19 Priority Register
	
; 16/32 Timer Registers
TIMER1_CFG			EQU 0x40030000
TIMER1_TAMR			EQU 0x40030004
TIMER1_CTL			EQU 0x4003000C
TIMER1_IMR			EQU 0x40030018
TIMER1_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER1_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER1_TAILR		EQU 0x40030028 ; Timer interval
TIMER1_TAPR			EQU 0x40030038
TIMER1_TAR			EQU	0x40030048 ; Timer register
PB_OUT				EQU	0X400063C0	
nvic				equ	0xE000E102
nvicpr				equ	0xE000E413
;GPIO Registers
GPIO_PORTB_DATA		EQU 0x40005040 ; Access BIT4
GPIO_PORTB_DIR 		EQU 0x40005400 ; Port Direction
GPIO_PORTB_AFSEL	EQU 0x40005420 ; Alt Function enable
GPIO_PORTB_DEN 		EQU 0x4000551C ; Digital Enable
GPIO_PORTB_AMSEL 	EQU 0x40005528 ; Analog enable
GPIO_PORTB_PCTL 	EQU 0x4000552C ; Alternate Functions
GPIO_PORTB_PDR		EQU	0X40005514 ;PULL DOWN REGISTER
	

;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control

;---------------------------------------------------
LOW					EQU	0x00000100
HIGH				EQU	0x00000040	
nu					equ	0x20000240
;---------------------------------------------------
					
			AREA 	routines, CODE, READONLY
			THUMB
			EXPORT 	My_Timer1A_Handler
			EXPORT	EDGE_TIMER
					
;---------------------------------------------------					
My_Timer1A_Handler	PROC
				push	{r1-r2}
				ldr		r1,=nu;;read value from the memort
				ldr		r2,[r1];this memory is written by portf_handler
				cmp		r2,#0;if the value is 0 CW
				
				BNE		CCW
CW				LDR		R1,=PB_OUT
				LDR		R0,[R1]
				BIC		r0,#0x0f
				LSL		R0,#1;shift the output to left to make cw rotation
				CMP		R0,#0X100
				MOVEQ	R0,#0X10
				STR		R0,[R1]
				B		EXIT
CCW				LDR		R1,=PB_OUT;If the value is 1 ccw
				LDR		R0,[R1]
				LSR		R0,#1;shift right for ccw
				CMP		R0,#0X08
				MOVEQ	R0,#0X80
				STR		R0,[R1]
					
EXIT			LDR	R0,=TIMER1_ICR
				ORR	R1,#0X01			;CLEAR BIT2, BECAUSE CAPTURE MODE
				STR	R1,[R0]	
				pop		{r1-r2}
				BX 	LR 
				ENDP
;---------------------------------------------------

EDGE_TIMER	PROC
			LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x02 ; set bit 1 for port B
			STR R0, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			LDR R1, =GPIO_PORTB_DIR ; set direction of PB4
			LDR R0, [R1]
			ORR	R0,#0X40 ; SET BIT4 AS INPUT
			STR R0, [R1]
			LDR R1, =GPIO_PORTB_AFSEL ; ALTERNATE PB4
			LDR R0, [R1]
			ORR R0, R0, #0X40 ;PB4
			STR R0, [R1]
			LDR R1, =GPIO_PORTB_PCTL ; ALTERNATE PB4
			LDR R0, [R1]
			ORR R0, R0, #0x07000000 ;PB4
			STR R0, [R1]
			LDR R1, =GPIO_PORTB_DEN ; enable port digital
			LDR R0, [R1]
			ORR R0, R0, #0x40
			STR R0, [R1]
		
			LDR R1, =SYSCTL_RCGCTIMER ; Start Timer1
			LDR R2, [R1]
			ORR R2, R2, #0x01
			STR R2, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			LDR R1, =TIMER1_CTL ; disable timer during setup 
			LDR R2, [R1]
			BIC R2, R2, #0x01
			STR R2, [R1]
			LDR R1, =TIMER1_CFG ; set 16 bit mode
			MOV R2, #0x04
			STR R2, [R1]
			LDR R1, =TIMER1_TAMR
			MOV R2, #0x02
			STR R2, [R1]
			LDR R1, =TIMER1_TAILR ; initialize match clocks
			LDR R2, =0X2000
			STR R2, [R1]
			LDR R1, =TIMER1_TAPR
			MOV R2, #3 ; divide clock by 16 to
			STR R2, [R1] ; get 1us clocks
			LDR R1, =TIMER1_IMR
			LDR	R2,[R1]
			ORR R2, #0x01
			str	r2,[r1]
			LDR R1, =nvic
			LDR	R2,[R1]
			ORR R2, #0x08
			str	r2,[r1]
			LDR R1, =nvicpr
			LDR	R2,[R1]
			ORR R2, #0xc0
			str	r2,[r1]
			;STR R2, [R1]
; Configure interrupt priorities
; Timer0A is interrupt #19.
; Interrupts 16-19 are handled by NVIC register PRI4.
; Interrupt 19 is controlled by bits 31:29 of PRI4.
; set NVIC interrupt 19 to priority 2
			;LDR R1, =NVIC_PRI5
			;LDR R2, [R1]
			;AND R2, R2, #0xFFFF00FF ; clear interrupt 21 priority
			;ORR R2, R2, #0x00004000 ; set interrupt 21 priority to 2
			;STR R2, [R1]
; NVIC has to be enabled
; Interrupts 0-31 are handled by NVIC register EN0
; Interrupt 19 is controlled by bit 19
; enable interrupt 19 in NVIC
			;LDR R1, =NVIC_EN0
			;MOVT R2, #0x20 ; set bit 21 to enable interrupt 21
			;STR R2, [R1]
; Enable timer
			LDR R1, =TIMER1_CTL
			LDR R2, [R1]
			ORR R2, R2, #0x03 ; set bit0 to enable
			STR R2, [R1] ; and bit 1 to stall on debug, SET BIT 3:2 TO DETECT BOTH EDGES
			BX LR ; return
			ENDP
			END
