SETUP_ROT:	push	ds
		push	8000h
		pop	ds
NOT_BNDD:	cmp	bx,1440
		jl	BOUNDED
		sub	bx,1440
		jmp	NOT_BNDD
BOUNDED:	add	bx,2000h
		cmp	bx,2000h+359
		jg	QUADRAT2

QUADRAT1:	mov	ax,word ptr ds:[bx]
		mov	dx,word ptr ds:[bx+si]
		mov	word ptr cs:[MODIFY2],ax		; sinuses
		mov	word ptr cs:[MODIFY3],ax	
		mov	ax,dx
		mov	word ptr cs:[MODIFY1],ax		; cosinuses
		mov	word ptr cs:[MODIFY4],ax	
		mov	al,0D6h
		mov	byte ptr cs:[DEST_SI_I+1],al
		mov	ax,BO_SI_PLUS
		mov	word ptr cs:[BOUN_SI_I+2],ax
		mov	ax,RE_SI_PLUS
		mov	word ptr cs:[RESE_SI_I+1],ax
		mov	al,0C5h
		mov	byte ptr cs:[DEST_BP_I+1],al
		mov	byte ptr cs:[DEST_BP_O+1],al
		mov	ax,BO_BP_PLUS
		mov	word ptr cs:[BOUN_BP_I+2],ax
		mov	word ptr cs:[BOUN_BP_O+2],ax
		mov	ax,RE_BP_PLUS
		mov	word ptr cs:[RESE_BP_I+1],ax
		mov	word ptr cs:[RESE_BP_O+1],ax
		mov	al,0DEh					
		mov	byte ptr cs:[DEST_SI_O+1],al
		mov	ax,BO_SI_MINUS
		mov	word ptr cs:[BOUN_SI_O+2],ax
		mov	ax,RE_SI_MINUS
		mov	word ptr cs:[RESE_SI_O+1],ax
		jmp	OK_QUADS

QUADRAT2:	cmp	bx,2000h+719
		jg 	QUADRAT3
		sub	bx,360
		mov	ax,word ptr ds:[bx]
		mov	dx,word ptr ds:[bx+si]
		mov	word ptr cs:[MODIFY1],ax		; sinuses
		mov	word ptr cs:[MODIFY4],ax	
		mov	ax,dx
		mov	word ptr cs:[MODIFY2],ax		; cosinuses
		mov	word ptr cs:[MODIFY3],ax	
		mov	al,0DEh
		mov	byte ptr cs:[DEST_SI_I+1],al
		mov	byte ptr cs:[DEST_SI_O+1],al
		mov	ax,BO_SI_MINUS
		mov	word ptr cs:[BOUN_SI_I+2],ax
		mov	word ptr cs:[BOUN_SI_O+2],ax
		mov	ax,RE_SI_MINUS
		mov	word ptr cs:[RESE_SI_I+1],ax
		mov	word ptr cs:[RESE_SI_O+1],ax
		mov	al,0C5h
		mov	byte ptr cs:[DEST_BP_I+1],al
		mov	ax,BO_BP_PLUS
		mov	word ptr cs:[BOUN_BP_I+2],ax
		mov	ax,RE_BP_PLUS
		mov	word ptr cs:[RESE_BP_I+1],ax
		mov	al,0EDh
		mov	byte ptr cs:[DEST_BP_O+1],al
		mov	ax,BO_BP_MINUS
		mov	word ptr cs:[BOUN_BP_O+2],ax
		mov	ax,RE_BP_MINUS
		mov	word ptr cs:[RESE_BP_O+1],ax
		jmp	OK_QUADS

QUADRAT3:	cmp	bx,2000h+1079
		jg	QUADRAT4
		sub	bx,720
		mov	ax,word ptr ds:[bx]
		mov	dx,word ptr ds:[bx+si]
		mov	word ptr cs:[MODIFY2],ax		; sinuses
		mov	word ptr cs:[MODIFY3],ax	
		mov	ax,dx
		mov	word ptr cs:[MODIFY1],ax		; cosinuses
		mov	word ptr cs:[MODIFY4],ax
		mov	al,0DEh					
		mov	byte ptr cs:[DEST_SI_I+1],al
		mov	ax,BO_SI_MINUS
		mov	word ptr cs:[BOUN_SI_I+2],ax
		mov	ax,RE_SI_MINUS
		mov	word ptr cs:[RESE_SI_I+1],ax
		mov	al,0EDh
		mov	byte ptr cs:[DEST_BP_I+1],al
		mov	byte ptr cs:[DEST_BP_O+1],al
		mov	ax,BO_BP_MINUS
		mov	word ptr cs:[BOUN_BP_I+2],ax
		mov	word ptr cs:[BOUN_BP_O+2],ax
		mov	ax,RE_BP_MINUS
		mov	word ptr cs:[RESE_BP_I+1],ax
		mov	word ptr cs:[RESE_BP_O+1],ax
		mov	al,0D6h					
		mov	byte ptr cs:[DEST_SI_O+1],al
		mov	ax,BO_SI_PLUS
		mov	word ptr cs:[BOUN_SI_O+2],ax
		mov	ax,RE_SI_PLUS
		mov	word ptr cs:[RESE_SI_O+1],ax
		jmp	OK_QUADS

QUADRAT4:	sub	bx,1080
		mov	ax,word ptr ds:[bx]
		mov	dx,word ptr ds:[bx+si]
		mov	word ptr cs:[MODIFY1],ax		; sinuses
		mov	word ptr cs:[MODIFY4],ax	
		mov	ax,dx
		mov	word ptr cs:[MODIFY2],ax		; cosinuses
		mov	word ptr cs:[MODIFY3],ax	
		mov	al,0D6h
		mov	byte ptr cs:[DEST_SI_I+1],al
		mov	byte ptr cs:[DEST_SI_O+1],al
		mov	ax,BO_SI_PLUS
		mov	word ptr cs:[BOUN_SI_I+2],ax
		mov	word ptr cs:[BOUN_SI_O+2],ax
		mov	ax,RE_SI_PLUS
		mov	word ptr cs:[RESE_SI_I+1],ax
		mov	word ptr cs:[RESE_SI_O+1],ax
		mov	al,0EDh
		mov	byte ptr cs:[DEST_BP_I+1],al
		mov	ax,BO_BP_MINUS
		mov	word ptr cs:[BOUN_BP_I+2],ax
		mov	ax,RE_BP_MINUS
		mov	word ptr cs:[RESE_BP_I+1],ax
		mov	al,0C5h
		mov	byte ptr cs:[DEST_BP_O+1],al
		mov	ax,BO_BP_PLUS
		mov	word ptr cs:[BOUN_BP_O+2],ax
		mov	ax,RE_BP_PLUS
		mov	word ptr cs:[RESE_BP_O+1],ax
OK_QUADS:	pop	ds
		ret

ROT8:		push	es
		push	ds
		cli
		mov	cx,200
		mov	di,0
Y_COORD:	mov	bp,0000h
X_COORD:	mov	si,0000h
		push	9000h
		pop	ds
		push	0a000h
		pop	es
LOC8:		push	cx
		push	bx
		push	ax
		push	bp
		push	si
		mov	ax,8000h
		mov	bx,8000h
		mov	cx,320
LOC:		mov	dl,byte ptr ds:[bp+si]
		mov	byte ptr es:[di],dl
		inc	di
POINT_1:	add	ax,08000h
DEST_SI_I:	adc	si,0
BOUN_SI_I:	cmp	si,BMP_WDTH
		jne	POINT_2
RESE_SI_I:	mov	si,0
POINT_2:	add	bx,0ddb0h
		jnc	RIGHT3
DEST_BP_I:	add	bp,BMP_WDTH
BOUN_BP_I:	cmp	bp,8000h+BMP_WDTH*BMP_HGTH
		jne	RIGHT3
RESE_BP_I:	mov	bp,8000h
RIGHT3:		loop	LOC
RIGHT7:		pop	si
		pop	bp
		pop	ax
		pop	bx
		pop	cx
POINT_3:	add	ax,0ddb0h
DEST_SI_O:	sbb	si,0
BOUN_SI_O:	cmp	si,word ptr -1
		jne	POINT_4
RESE_SI_O:	mov	si,BMP_WDTH-1
POINT_4:	add	bx,08000h
		jnc	RIGHT5
DEST_BP_O:	add	bp,BMP_WDTH
BOUN_BP_O:	cmp	bp,8000h+BMP_WDTH*BMP_HGTH
		jne	RIGHT5
RESE_BP_O:	mov	bp,8000h
RIGHT5:
		loop	LOC8
		sti
		pop	ds
		pop	es
		ret

