FIRST	   	EQU	    	0x20000000	
			AREA    	CONVRT, READONLY, CODE
			THUMB
			EXPORT		CONVRT
				
				;THIS IS THE CODE THAT WE USED IN EXPERIMENT 1
				
__CONVRT
			push	{r0-r4}
			ldr		r5,=FIRST			;initial adress
			mov		r0,#0x30			;ascii value for 0
			mov32	r1,#1000000000		
			mov		r2,#10
			mov		r3,#0xa				;max number of digits
check		subs	r4,r1
			addpl	r0,#1				;increase the digit value if r4-r1 is positive
			bpl		check
			add		r4,r1				;make r4 positive again
			str		r0,[r5]				;store the digit in memory
			cmp		r0,#0x30			;check if most significant digits are zero
			cmpeq	r5,#FIRST			;check if most significant digits are zero
			
			addne	r5,#1				;increase memory address by 1 byte
			mov		r0,#0x30			;reset the digit
			udiv	r1,r2				;prepare r1 for a lower decimal place
			subs	r3,#1				;decrease digit counter
			bne		check
			cmp		r5,#FIRST
			addeq	r5,#1				;if input is zero make sure that it is written in memory
			mov		r0,#0x040d			
			str		r0,[r5]				;put 'new line' and 'end of transmission' characters at the end
			ldr		r5,=FIRST			;reset memory address
			POP		{R0-R4}
			bx		lr
			
			align
			end