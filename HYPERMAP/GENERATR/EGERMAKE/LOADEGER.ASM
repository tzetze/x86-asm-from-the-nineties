LoadEger:	push	@data
		pop	es
		
                mov     ax,3d00h
                lea     dx,FileName2
                int     21h			; Palette file nyit sa
		mov     bx,ax			
                mov     cx,2678
                mov     dx,offset Load_Buffer
                mov     ah,3fh
                int     21h			
                mov     ah,3eh
                int     21h			 
                mov     ah,0dh
                int     21h			

		mov	si,offset Load_Buffer + 2678 - 40
		mov	di,offset EgerForma1
		mov	cx,40
MegSor:		push	cx
		mov	cx,10
		rep	movsw
		pop	cx
		sub	si,60
		loop	MegSor
                ret

