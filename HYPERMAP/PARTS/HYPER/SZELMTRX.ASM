SzelesMxGo:	mov	si,offset HypChMatrix	; Karakter k¢dlap c¡m :)
		mov	di,offset SzMatrix	; 256 byteos t bl zat
		mov	cx,256			; a sz‚less‚geknek
UjabbKarak:	push	cx
			mov	cl,byte ptr ds:[si]
			xor	ch,ch
			lea	bx,HypChars
			cmp	cx,0
			jz	TovaMehet
SikkTovabb:		push	cx
				mov	al,byte ptr ds:[bx]
				inc	bx
				mov	cl,15
				mul	cl
				add	bx,ax
			pop	cx
			loop	SikkTovabb
TovaMehet:		mov	al,byte ptr ds:[bx]
			inc	al
			mov	byte ptr ds:[di],al
			inc	di
			inc	si
		pop	cx
		loop	UjabbKarak
		ret