MentBetuket:	mov	si,offset HypChars
CsakNulla:	mov	ah,byte ptr ds:[si]
		cmp	ah,255
		jnz	NemVeges
		jmp	Veges
NemVeges:	mov	byte ptr [Szelesseg],ah
		shr	ah,1
		mov	byte ptr ds:[si],ah
		mov	dx,si
		mov	cx,1
		mov	ah,40h
		mov	bx,word ptr ds:[Handle]
		int	21h

		inc	si
		cmp	byte ptr ds:[si-1],0
		jnz	NemCsakNulla
		add	si,88
		jmp	CsakNulla

NemCsakNulla:	mov	di,offset Bufi
		mov	cx,22
KovSorJon:	push	cx
		 mov	ax,word ptr ds:[si]
		 mov	word ptr ds:[ScrollMem1],ax
		 mov	ax,word	ptr ds:[si+2]
		 mov	word ptr ds:[ScrollMem2],ax
		 mov	cx,32
SorVegig:	  rcl	word ptr ds:[ScrollMem2],1
		  rcl	word ptr ds:[ScrollMem1],1
		  jnc	NincsPotty
		  mov	byte ptr ds:[di],1
		  jmp	PotyiVolt
NincsPotty:	  mov	byte ptr ds:[di],0
PotyiVolt:	  inc	di
		 loop	SorVegig
		 add	si,4
		 pop	cx
		loop	KovSorJon		

		mov	di,offset Bufi
		mov	cx,11
NextRow:	push	cx
		 mov	ah,byte ptr ds:[Szelesseg]
		 mov	al,32
		 sub	al,ah
		 xor	ah,ah
		 add	di,ax
		 mov	cl,byte ptr ds:[Szelesseg]
		 xor	ch,ch
		 shr	cx,1

KovNegy:	 push	cx
		  mov	al,byte ptr ds:[di]
		  add	al,byte ptr ds:[di+1]
		  add	al,byte ptr ds:[di+32]
		  add	al,byte ptr ds:[di+33]
		  xor	ah,ah
		  mov	dx,offset Fkt
		  mov	cx,1
		  add	dx,ax
		  mov	ah,40h
		  mov	bx,word ptr ds:[Handle]
		  int	21h
		  inc	di
		  inc	di
		 pop	cx
		 loop	KovNegy
		 add	di,32
		pop	cx
		loop	NextRow

		jmp	CsakNulla

Veges:		ret

 