SzoVegeE:	cmp	byte ptr ds:[bx],32
		jz	JaVege
		cmp	byte ptr ds:[bx],13
		jz	JaVege
		cmp	byte ptr ds:[bx],10
		jz	JaVege
		cmp	byte ptr ds:[bx],9
		jz	JaVege
		clc
		ret
JaVege:		stc	
		ret

WordSeek:	cmp	byte ptr ds:[bx],32
		jnz	TanEnter
		inc	bx
		jmp	WordSeek
TanEnter:	cmp	byte ptr ds:[bx],13
		jnz	TanTizes
		inc	bx
		jmp	WordSeek
TanTizes:	cmp	byte ptr ds:[bx],10
		jnz	TanTab
		inc	bx
		jmp	WordSeek
TanTab:		cmp	byte ptr ds:[bx],9
		jnz	AkkorSzoveg
		inc	bx
		jmp	WordSeek
Akkorszoveg:	ret
