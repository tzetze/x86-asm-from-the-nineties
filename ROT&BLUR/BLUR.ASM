blur:		push	ds
		push	es
		push	@data
		pop	ds
		mov	ax,word ptr ds:[CONV_SEG2]
		mov	es,ax
		mov	ax,word ptr ds:[CONV_SEG1]
		mov	ds,ax
		call	StoreScr		

		mov	di,321
		mov	si,321

		mov	cx,198
blur1:		push	cx
		mov	cx,318
blur2:		mov	ax,0
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
		mov	bx,256*7+27
		div 	bx
		mov	byte ptr es:[di],al
		inc	di
		inc	si
		
		loop	blur2
		add	si,2
		add	di,2
		pop 	cx
		loop	blur1

		call	storescr
		pop	es
		pop	ds
		ret

storescr:	mov	cx,32000		
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

