CLEARBUFS:	push	ds
		push	es
		cld
		push	@data
		pop	ds
		mov	ax,word ptr ds:[CONV_SEG1]
		mov	es,ax
		mov	ds,ax
		mov	si,0
		mov	di,2
		mov	word ptr [si],24
		mov	cx,07fffh
		rep	movsw
		push	@data
		pop	ds
		mov	ax,word ptr ds:[CONV_SEG2]
		mov	es,ax
		mov	ds,ax
		mov	si,0
		mov	di,2
		mov	word ptr [si],24
		mov	cx,07fffh
		rep	movsw
		pop	es
		pop	ds
		ret


QUIT2DOS:	mov	ax,03h
		int	10h
		mov	ax,4c00h
		int	21h

convert:	push	@data
		pop	ds
		lea	si,chars
		mov	cx,len
newpoint:	mov	al,byte ptr ds:[si]
		cmp	al,'.'
		jne	nempont
		mov	al,0
		jmp	lerak
nempont:	mov	al,255
lerak:		mov	byte ptr ds:[si],al
		inc	si				
		loop	newpoint
		ret

putpal:		mov 	al,0
		mov 	dx,03c8h
		out	dx,al

		mov 	cx,256
		mov 	dx,03c9h
loc3:		mov	al,byte ptr 0
		sub	al,cl
		shr	al,1
		out	dx,al
		shr	al,1
		out	dx,al
		shl	al,0
		out	dx,al
		loop	loc3
		ret
