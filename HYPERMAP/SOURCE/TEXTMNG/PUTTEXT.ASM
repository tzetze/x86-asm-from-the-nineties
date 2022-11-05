PutWord:	push	@data
		pop	ds
		mov	bx,word ptr ds:[WordStart]
		call	WordSeek
		mov	word ptr ds:[WordStart],bx
Ujabbetu:	push	es
		mov	ax,word ptr ds:[CONV_SEG3]
		mov	es,ax
		mov	ah,byte ptr es:[bx]
		pop	es
		mov	byte ptr ds:[ChNumber],ah
		push	es
		call	PutChar
		pop	es
		inc	word ptr ds:[WordStart]
		mov	bx,word ptr ds:[WordStart]
		call	SzoVegeE
		jc	KomplettaSzo
		jmp	Ujabbetu
KomplettaSzo:	ret

SzoVegeE:	push	es
		mov	ax,word ptr ds:[CONV_SEG3]
		mov	es,ax
		cmp	byte ptr es:[bx],32
		jz	JaVege
		cmp	byte ptr es:[bx],13
		jz	JaVege
		cmp	byte ptr es:[bx],10
		jz	JaVege
		cmp	byte ptr es:[bx],9
		jz	JaVege
		pop	es
		clc
		ret
JaVege:		pop	es
		stc	
		ret

WordSeek:	push	es
		mov	ax,word ptr ds:[CONV_SEG3]
		mov	es,ax
WSk:		cmp	byte ptr es:[bx],32
		jnz	TanEnter
		inc	bx
		jmp	WSk
TanEnter:	cmp	byte ptr es:[bx],13
		jnz	TanTizes
		inc	bx
		jmp	WSk
TanTizes:	cmp	byte ptr es:[bx],10
		jnz	TanTab
		inc	bx
		jmp	WSk
TanTab:		cmp	byte ptr es:[bx],9
		jnz	AkkorSzoveg
		inc	bx
		jmp	WSk
Akkorszoveg:	pop	es
		ret

PutChar:	push	@data
		pop	ds
		push	0a000h
		pop	es

		xor	bh,bh
		mov	bl,byte	ptr ds:[ChNumber]	; BX = karakterk¢d
		add	bx,offset HypChMatrix		; + T bl zatc¡m ...

		mov	cl,byte ptr ds:[bx]		
		xor	ch,ch				; CX = hanyadik a
							; sorban a karakter
		lea	bx,HypChars			; BX az els“ karakterre
							; mutat
		cmp	cx,0				; Ha a 0. karakter,
		jz	MarIndulhatIs			; akkor helyben is 
							; vagyunk
SeekTovabb:	push	cx
		mov	al,byte ptr ds:[bx]
		inc	bx
		mov	cl,15
		mul	cl
		add	bx,ax
		pop	cx
		loop	SeekTovabb
		; BX most mutat a karakter sz‚less‚gi adat ra.

MarIndulhatIs:	mov	ax,word ptr ds:[ChPutAddr]
		mov	di,ax				; c¡m a k‚pen
		add	al,byte ptr ds:[bx]
		adc	ah,0
		add	ax,1
		mov	word ptr ds:[ChPutAddr],ax
		mov	ax,word ptr ds:[ChPutBank]
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch
		mov	cl,byte ptr ds:[bx]
		mov	byte ptr ds:[ChWidth],cl
		xor	ch,ch
		mov	dx,SCR_WIDTH
		sub	dx,cx
		inc	bx
		mov	cx,15
KovSorJon:	push	cx
		 xor	ch,ch
		 mov	cl,byte ptr ds:[ChWidth]
SorVegig:	  mov	ah,byte ptr ds:[bx]
		  mov	byte ptr es:[di],ah
		  inc	di
		  inc	bx
		 loop	SorVegig
		 add	di,dx
		 jnc	NemSzviccs
		 mov	ax,word ptr ds:[act_bank]
		 inc	ax
		 mov	word ptr ds:[act_bank],ax
		 push	dx
		 call	BankSwitch
		 pop	dx
NemSzviccs:	pop	cx
		loop	KovSorJon		
		ret

PutSpace:	push	@data
		pop	ds
		add	word ptr ds:[ChPutAddr],4
		ret


PutAllText:	push	@data
		pop	ds
		mov	word ptr ds:[TextXPos],500
		mov	word ptr ds:[TextYPos],40
		lea	bp,RowDatas
VammegSor:	call	InitPos
		cmp	byte ptr ds:[bp+2],0
		jz	TextStop
		mov	ax,word ptr ds:[bp]
		mov	word ptr ds:[WordStart],ax	; WordStart az els“ sz¢
		mov	cl,byte ptr ds:[bp+2]
		xor	ch,ch				; cx = # of szavak
GoWordz:	push	cx
		call	PutWord
		call	PutSpace
		pop	cx
		loop	GoWordz
		add	bp,4
		push	@data
		pop	ds
		add	word ptr ds:[TextYPos],16
		jmp	VammegSor
TextStop:
		ret