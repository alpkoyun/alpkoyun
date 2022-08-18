			AREA    	DELAY100, READONLY, CODE
			THUMB
			EXPORT		DELAY100
				
__DELAY100
			push	{r0,r1}
			mov		r0,#0
			mov32	r1,#320000	;number needed for 100ms delay
count		add		r0,#1
			cmp		r0,r1
			bne		count		
			pop		{r0,r1}
			bx 		lr
			
			end