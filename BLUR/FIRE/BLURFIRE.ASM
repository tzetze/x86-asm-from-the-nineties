.286
.model small
BUFXSIZE	equ	80
BUFYSIZE	equ	50
BUFSEG		equ	2000h
.stack		
		db	2000 dup (?)
.data
SEED		dw	1834h
.code		
START:		push	@data
		pop	ds
		mov	ax,13h		;set 320x200x256
		int	10h		;graphmode ON!
		call 	CLEARBUF
		call	PUTPAL
NEVEREND:	call	PUTLINE
		call	BLUR
		call	TOSCR
		call	KEYS
		jmp	NEVEREND

TOSCR:		push	ds
		mov	ax,2000h
		mov	ds,ax
		mov	ax,0a000h
		mov	es,ax
		xor	si,si
		xor	di,di
		mov	cx,BUFYSIZE
L2:		push	cx
		mov	cx,BUFXSIZE
L1:		mov	al,byte ptr ds:[si]
		mov	byte ptr es:[di+000],al
		mov	byte ptr es:[di+001],al
		mov	byte ptr es:[di+002],al
		mov	byte ptr es:[di+003],al
		mov	byte ptr es:[di+320],al
		mov	byte ptr es:[di+321],al
		mov	byte ptr es:[di+322],al
		mov	byte ptr es:[di+323],al
		mov	byte ptr es:[di+640],al
		mov	byte ptr es:[di+641],al
		mov	byte ptr es:[di+642],al
		mov	byte ptr es:[di+643],al
		mov	byte ptr es:[di+960],al
		mov	byte ptr es:[di+961],al
		mov	byte ptr es:[di+962],al
		mov	byte ptr es:[di+963],al
		inc	si
		add	di,4
		loop	L1
		add	di,960
		pop	cx
		loop	L2
		pop	ds
		ret
		
PUTLINE:	push	2000h
		pop	es
		mov	di,BUFXSIZE*(BUFYSIZE)
		mov	cx,40
LOC20:		call	RND
		mov	word ptr es:[di],ax
		add	di,2
		loop	LOC20
		ret

CLEARBUF:	push	es
		push	ds
		mov	ax,2000h
		mov	es,ax
		mov	ds,ax
		mov	si,0
		mov	di,2
		mov	word ptr ds:[si],0
		mov 	cx,BUFXSIZE*BUFYSIZE
		cld
		rep	movsw
		pop	ds
		pop	es
RND:		mov	ax,word ptr ds:[SEED]
		imul	ax,8605h  ;8905
		inc	ax
		mov	word ptr ds:[SEED],ax
		ret

BLUR:		push	2000h
		pop	es
		xor	bx,bx
		mov	cx,BUFYSIZE
BLUR1:		push	cx
		mov	cx,BUFXSIZE
BLUR2:		xor	ax,ax
		mov	al,byte ptr es:[bx]
		add 	al,byte ptr es:[bx-1]
		adc	ah,0
		add	al,byte ptr es:[bx+1]
		adc	ah,0
		add	al,byte ptr es:[bx+BUFXSIZE-1]
		adc	ah,0
		add	al,byte ptr es:[bx+BUFXSIZE]
		adc	ah,0
		add	al,byte ptr es:[bx+BUFXSIZE]
		adc	ah,0
		add	al,byte ptr es:[bx+BUFXSIZE+1]
		adc	ah,0
		mov	dx,9
		mul	dx
		mov	dl,16*4+3
		div 	dl
		mov	byte ptr es:[bx],al
		inc	bx
		loop	BLUR2
		pop 	cx
		loop	BLUR1
		ret

QUIT2DOS:	mov	ax,03h
		int	10h
		mov	ax,4c00h
		int	21h

KEYS:		mov	ah,1
		int 	16h
		jnz	ISKEYESC
		ret
ISKEYESC:	xor	ah,ah
		int 	16h
		cmp	al,1bh
		jne	NOESC
		jmp	QUIT2DOS
NOESC:		ret

PUTPAL:		mov 	al,0
		mov 	dx,03c8h
		out	dx,al
		mov 	cx,256
		mov 	dx,03c9h
LOC3:		mov	al,byte ptr 0
		sub	al,cl
		shr	al,2
		out	dx,al
		out	dx,al
		out	dx,al
		loop	LOC3
		ret
end