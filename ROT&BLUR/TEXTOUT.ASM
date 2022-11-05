wrt:		push	@data
		pop	ds
		mov	bx,word ptr ds:[mem1]
		mov	al,byte ptr ds:[bx+1]
		xor	ah,ah
		mov	cx,320
		mul	cx
	        add	al,byte ptr ds:[bx]
		adc	ah,0
		mov	di,ax
		xor	ch,ch
		mov	cl,byte ptr ds:[bx+2]
		add 	bx,3
		mov	si,bx
		add	bx,cx
		mov	al,byte ptr ds:[bx]
		cmp	al,0
		jnz	okk
		lea	bx,text
okk:		mov	word ptr ds:[mem1],bx
		
nextchar:	push	cx
		mov	al,byte ptr ds:[si]
		sub	al,32
		mov	bl,18
		mul	bl
		mov	bx,20	
		mul	bx
		call	plotbetu
		add	di,20
		inc	si
		pop	cx
		loop	nextchar
		ret
plotbetu:	push	es
		push	@data
		pop	ds
		mov	ax,word ptr ds:[CONV_SEG2]
		mov	es,ax
		push	di
		push	si
		lea	si,chars
		add	si,ax
		mov	cx,20
loc10:		push	cx
		mov	cx,18		
loc11:		mov	al,byte ptr ds:[si]
		cmp     al,0
		jz	none
		mov	byte ptr es:[di],al
none:		inc	si
		inc	di
		loop	loc11
		pop	cx
		add	di,320-18
		loop	loc10

		pop	si
		pop	di
		pop	es
		ret
