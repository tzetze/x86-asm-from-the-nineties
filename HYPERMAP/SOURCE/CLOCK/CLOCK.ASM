DrawClock	PROC NEAR
	mov	ah,2ch
	int	21h
	mov	word ptr ds:[NumberAddr],4100
	mov	byte ptr ds:[TheNumba],ch
	push	dx
	push	cx
	call	KetJegy
	pop	cx
	add	word ptr ds:[NumberAddr],48
	mov	byte ptr ds:[TheNumba],cl
	call	KetJegy
	pop	dx
	add	word ptr ds:[NumberAddr],48
	mov	byte ptr ds:[TheNumba],dh
	push	dx
	call	KetJegy
	pop	dx
	mov	al,dl
	xor	ah,ah
	mov	dl,50
	div	dl
	cmp	al,0
	jz	Villany
	mov	ax,184*256+184
	mov	byte ptr ds:[ClockLock],0
	jmp	Rajzas
Villany:
	cmp	byte ptr ds:[ClockLock],1
	jz	Nyugis
	mov	byte ptr ds:[ClockLock],1
	mov	ax,word ptr ds:[DownCounter]
	mov	word ptr ds:[coord_memo],ax
	mov	si,144
	mov	di,5
	call	Graph_Say
	dec	byte ptr ds:[DownCounter]
	jnz	Nyugis
	jmp	SvScreen
Nyugis:
	mov	ax,40*256+40
Rajzas:	
	mov	byte ptr es:[1024*10+47],al
	mov	byte ptr es:[1024*12+47],al
	mov	word ptr es:[1024*11+46],ax
	mov	byte ptr es:[1024*11+48],al
	mov	byte ptr es:[1024*10+95],al
	mov	byte ptr es:[1024*12+95],al
	mov	word ptr es:[1024*11+94],ax
	mov	byte ptr es:[1024*11+96],al
	mov	byte ptr es:[1024*18+46],al
	mov	byte ptr es:[1024*20+46],al
	mov	word ptr es:[1024*19+45],ax
	mov	byte ptr es:[1024*19+47],al
	mov	byte ptr es:[1024*18+94],al
	mov	byte ptr es:[1024*20+94],al
	mov	word ptr es:[1024*19+93],ax
	mov	byte ptr es:[1024*19+95],al
	ret
DrawClock	ENDP
		
; *****************************************************************
; ** K‚t sz mjegyet kirak a megadot sz m alapj n       ************
; ** Adatok: [NumberAddr] - a c¡m, ahova kezdje rakni  ************
; **         [TheNumba]   - a sz m, amit ki kell tenni ************
; *****************************************************************
KetJegy	PROC NEAR
	mov	al,byte ptr ds:[TheNumba]
	xor 	ah,ah
	mov	dl,10
	div	dl		; AL=tizesek   AH=egyesek
	mov	bx,word ptr ds:[NumberAddr]
	mov	word ptr ds:[PlotAddr],bx
	mov	byte ptr ds:[TheDigit],al
	push	ax
	call	PlotDigit
	pop	ax
	add	word ptr ds:[PlotAddr],20
	mov	byte ptr ds:[TheDigit],ah
	call	PlotDigit
	ret
KetJegy	ENDP		

; ***************************************************************************
; ** PLOTDIGIT - azaz ki¡r eg digit lis sz mot.                   ***********
; ** Kapott adatok: [PlotAddr] Balfels“ sarok offsetc¡me (0-1023) ***********
; **                [TheDigit] Maga a sz m‚rt‚k                   ***********
; ***************************************************************************
PlotDigit	PROC NEAR
	mov	ax,0
	call	BankSwitch
	push	@data
	pop	ds
	push	0a000h
	pop	es
	mov	al,byte ptr ds:[TheDigit]
	mov	bh,7
	mul	bh
	lea	bx,NumbaPalcak-1
	add	bx,ax				; BX-ben a sz mle¡r¢c¡m
	mov	di,word ptr ds:[PlotAddr]	; Ide lesz kirakva
	lea	si,WatchSablon			; Ez pediglen a sablon
	mov	cx,23
DrBubo:	
	push	cx
	mov	cx,18
HildeGard:
	mov	al,byte ptr ds:[si]
	cmp	al,32
	jz	EzegyLyuk
	sub	al,"0"
	xlat
	mov	byte ptr es:[di],al
EzegyLyuk:
	inc	di
	inc	si
	loop	Hildegard
	pop	cx
	add	di,SCR_WIDTH-18
	loop	DrBubo
	ret
PlotDigit	ENDP

