Copy2scr:	push	es
		push	ds
		push	9000h
		pop	ds
		push	0a000h
		pop	es
		mov	cx,32000
		mov	si,0
		mov	di,0
		rep	movsw
		pop	ds
		pop	es
		ret

ClearBufs:	push	ds
		push	es
		cld
		mov	ax,7000h
		mov	es,ax
		mov	ds,ax
		mov	si,0
		mov	di,2
		mov	word ptr [si],0
		mov	cx,07fffh
		rep	movsw
		mov	ax,9000h
		mov	es,ax
		mov	ds,ax
		mov	si,0
		mov	di,2
		mov	word ptr [si],0
		mov	cx,07fffh
		rep	movsw
		pop	es
		pop	ds
		ret

Quit2Dos:	mov	ax,03h
		int	10h
		mov	ax,4c00h
		int	21h

convert:	lea	si,chars
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

SSPal:		mov 	al,0
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
