MentBetuket:	mov	si,offset HypChars
CsakNulla:	mov	ah,byte ptr ds:[si]
		cmp	ah,255
		jnz	NemVeges
		jmp	Veges
NemVeges:	mov	byte ptr [Szelesseg],ah
		mov	cl,ah
		xor	ch,ch
		call	Mennyiannyi
		mov	ah,cl
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
		mov	byte ptr ds:[Szlalom],0
		mov	cx,15

NextRow:	push	cx
		push	di
		 mov	ah,byte ptr ds:[Szelesseg]
		 mov	al,32
		 sub	al,ah
		 xor	ah,ah
		 add	di,ax
		 mov	cl,byte ptr ds:[Szelesseg]
		 xor	ch,ch
		 call	Mennyiannyi

		 mov	byte ptr ds:[Szlalo],0

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
		  add	byte ptr ds:[Szlalo],80h
		  adc	di,1
		 pop	cx
		 loop	KovNegy
		 pop	di
		 add	di,32
		 add	byte ptr ds:[Szlalom],80h
		 jnc	Csakessor
		 add	di,32
Csakessor:	pop	cx
		loop	NextRovka

		jmp	CsakNulla

Veges:		ret

NextRovka:	jmp	NextRow

Mennyiannyi:	 cmp	cx,0
		 jnz	Kettojon
		 jmp	Nulcsi
Kettojon:	 cmp	cx,2
		 jnz	Neggyun
		 jmp	Nulcsi
Neggyun:	 cmp	cx,4
		 jnz	Hatosjon
		 mov	cx,3
		 jmp 	Nulcsi
HatosJon:	 cmp	cx,6
		 jnz	Nyoccasjon
		 mov	cx,4
		 jmp	Nulcsi
Nyoccasjon:	 cmp	cx,8
		 jnz	Tizzesgyun
		 mov	cx,6
		 jmp	Nulcsi
Tizzesgyun:	 cmp	cx,10
		 jnz	Vizentekno
		 mov	cx,7
		 jmp	Nulcsi
VizenTekno:	 cmp	cx,12
		 jnz	Vizennegy
		 mov	cx,8
		 jmp	Nulcsi
Vizennegy:	 cmp	cx,14
		 jnz	Vizenhat
		 mov	cx,10
		 jmp	Nulcsi
Vizenhat:	 cmp	cx,16
		 jnz	Vizennyoc
		 mov	cx,11
		 jmp	Nulcsi
Vizennyoc:	 cmp	cx,18
		 jnz	House
		 mov	cx,12
		 jmp	Nulcsi
House:		 cmp	cx,20
		 jnz	BuszonTekno
		 mov	cx,14
		 jmp	Nulcsi
BuszonTekno:	 cmp	cx,22
		 jnz	Buszonnegy
		 mov	cx,15
		 jmp	Nulcsi
Buszonnegy:	 cmp	cx,24
		 jnz	Buszonhat
		 mov	cx,16	
		 jmp	Nulcsi
Buszonhat:	 cmp	cx,26
		 jnz	Buszonnyoc
		 mov	cx,18
		 jmp	Nulcsi
Buszonnyoc:	 cmp	cx,28
		 jnz	Harminc
		 mov	cx,19
		 jmp	Nulcsi
Harminc:	 cmp	cx,30
		 jnz	Sokas
		 mov	cx,20
		 jmp	Nulcsi
Sokas:		 mov	cx,22
Nulcsi:		 ret 