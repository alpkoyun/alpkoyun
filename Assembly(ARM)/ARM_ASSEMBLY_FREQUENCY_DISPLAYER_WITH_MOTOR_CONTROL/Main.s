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
NUM	  	 			EQU	0x20000400
nu	  	 		EQU	0x20000250

SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
GPIO_PORTF_pup		EQU	0x40025510
	
			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	__main
			EXTERN		InitSysTick	
			EXTERN		EDGE_TIMER
			EXTERN		init_gpiof
			EXTERN		arm_cfft_sR_q15_len256
			EXTERN		arm_cfft_q15
			EXTERN		CONVRT
			EXTERN		OutStr
			EXTERN		GPIOE_Init
			EXTERN		ADC0_Init
			EXTERN		SCREEN_INIT
			EXTERN		SCREEN_ALWYS
			extern		PORTC_Init
			extern		KEYPAD_INIT
			
			;Alperen Koyun 2305001_EE447-TERMPROJECT

__main		
			LDR			R1,=nu
			mov			r2,#30;;DEFAULT AMPLITUDE THRESHHOLD
			strh		r2,[r1],#2
			mov			r2,#300;DEFAULT LOWER FREQUENCY THRESHHOLD
			strh		r2,[r1],#2
			mov			r2,#700;DEFAULT HIGHER FREQUENCY THRESHHOLD
			strh		r2,[r1],#2
			
			bl			KEYPAD_INIT;init keypad
			BL			SCREEN_INIT;Init screen
			BL			SCREEN_ALWYS;Print basics to screen
			BL			InitSysTick	;Init the systick for analof read
			bl			init_gpiof;Init	GPIOF FOR SWITCHING AND LEDS
			bl			EDGE_TIMER;INIT PORT B TIMER FOR MOTOR INTERRUPT
			bl			PORTC_Init;iNIT PORTC FOR MOTOR ROTATION
			bl			GPIOE_Init;INIT PORT E FOR ADC READ
			BL			ADC0_Init;INIT ADC
lp			b			lp
			align
			end