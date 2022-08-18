			AREA    	DELAY10, READONLY, CODE
			THUMB
			EXPORT		DELAY10
				
__DELAY10
			push	{r0,r1}
			mov		r0,#0
			mov32	r1,#3200	;number needed for 100ms delay
count		add		r0,#1
			cmp		r0,r1
			bne		count		
			pop		{r0,r1}
			bx 		lr
			
			end