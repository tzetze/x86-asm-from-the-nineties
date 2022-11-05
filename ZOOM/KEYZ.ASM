keys:		mov	ah,1
		int 	16h
		jnz	change
		ret
change:		xor	ah,ah
		int 	16h
		cmp	al,1bh
		jne	noesc
		jmp	dosquit
noesc:		cmp	ax,4b00h
		jne	noleft
		;..
noleft:		cmp	ax,4d00h
		jne	noright
		;..
noright:	cmp	ax,5000h
		jne	nodown
		;..
nodown:		cmp	ax,4800h
		jne	none
		;..
none:		ret
