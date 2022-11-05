.MODEL SMALL
.286
.CODE
Blur PROC NEAR
	push	ds
	push	es
	push	09000h
	pop	es
	push	07000h
	pop	ds
	call	StoreScr		
	mov	di,0
	mov	si,0
	mov	cx,200
blur1:
	push	cx
	mov	cx,320
blur2:	
	mov	ax,0
	mov	al,byte ptr ds:[si-321]
	add 	al,byte ptr ds:[si-319]
	adc	ah,0
	add 	al,byte ptr ds:[si]
	adc	ah,0
	add 	al,byte ptr ds:[si]
	adc	ah,0
	add 	al,byte ptr ds:[si]
	adc	ah,0
	add 	al,byte ptr ds:[si+321]
	adc	ah,0
	add 	al,byte ptr ds:[si+319]
	adc	ah,0
	xor	dh,dh
	mov 	dl,ah
	mov	ah,al
	xor	al,al
	mov	bx,256*7+48
	div 	bx
	mov	byte ptr es:[di],al
	inc	di
	inc	si
	loop	blur2
	pop 	cx
	loop	blur1
	call	storescr
	pop	es
	pop	ds
	ret
Blur ENDP

StoreScr PROC NEAR
	mov	cx,32000		
	mov	si,0			
	mov	di,0
	mov	ax,ds
	mov     bx,es
	mov	es,ax
	mov	ds,bx
	rep	movsw
	mov	ax,ds
	mov     bx,es
	mov	es,ax
	mov	ds,bx
	ret
StoreScr ENDP

END