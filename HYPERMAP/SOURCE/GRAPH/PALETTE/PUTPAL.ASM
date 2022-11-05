; *********************************************
; ** Ez pedig kirakja a pufferb“l a palett t **
; *********************************************
PutPalette	PROC NEAR
	 	push	@data
		pop	ds
		lea	bx,Paletta
		mov	cx,256*3
		mov	dx,3c8h
		mov	al,0
		out 	dx,al
		inc	dx
KovBajt:	mov	al,byte ptr ds:[bx]
		out	dx,al
		inc	bx
		loop	KovBajt
		ret
PutPalette	ENDP
