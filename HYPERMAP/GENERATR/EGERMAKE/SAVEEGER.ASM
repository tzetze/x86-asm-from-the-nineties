SaveEger:	mov	dx,offset EgerkeName
		mov	ah,3ch
		int	21h			
		mov     bx,ax			
		mov	cx,660
		mov	ah,40h
		mov	dx,offset EgerForma1+120
                int     21h			
		mov     ah,3eh
                int     21h			
                mov     ah,0dh
                int     21h			
		ret
