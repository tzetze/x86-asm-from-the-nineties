.286
.model small

MODIFY1		equ	MOD2_1+1
MODIFY2		equ	RIGHT+2
MODIFY3		equ	MOD1_1+1
MODIFY4		equ	RIGHT4+2

.stack
.data
FILENAME	db	'SINE.TAB',0
ERRORMSG	db	'No Çs a SINE.TAB nÇlkÅl mihez kezdjek?! $',0

.code		
		push	8000h
		pop	ds
		mov	word ptr ds:[0],1234h
		push	@data
		pop	ds
		push	0a000h
		pop	es
		mov	ax,13h
		int	10h
		call	PUTPAL
		call	CLEARMEM
		call	LOADDATA
		mov	cx,180
		mov	bx,2000h
		mov	si,360
NXTFRAME:	push	cx
		push	bx
		push	si
		mov	ax,word ptr ds:[bx]
		mov	dx,word ptr ds:[bx+si]
		push	@code
		pop	ds
		mov	word ptr [MODIFY2],ax
		mov	word ptr [MODIFY3],ax
		mov	ax,dx
		mov	word ptr [MODIFY1],ax
		mov	word ptr [MODIFY4],ax
		call	MAKEFIRE
		mov	dx,3dah
VR:		in	al,dx
		and	al,8
		jz	VR
		call	ROT8
		pop	si
		pop	bx
		pop	cx
		add	bx,2
		loop	NXTFRAME

CLOSE:		call	KEYZ
		jmp	CLOSE
		jmp	QUIT2DOS


ROT8:		cli
		mov	cx,200
		mov	di,0
		mov	bp,8000h+132*100
		mov	si,0
		push	8000h
		pop	ds
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
MOD2_1:		add	ax,0ddb0h
		adc	si,0
		cmp	si,132
		jne	RIGHT
		mov	si,0
RIGHT:		add	bx,08000h
		jnc	RIGHT3
		sub	bp,132
		cmp	bp,8000h+132*99
		jne	RIGHT3
		mov	bp,8000h+132*129
RIGHT3:		loop	LOC
		pop	si
		pop	bp
		pop	ax
		pop	bx
		pop	cx
MOD1_1:		add	ax,08000h
		adc	si,0
		cmp	si,132
                jne     RIGHT4
		mov	si,0
RIGHT4:		add	bx,0ddb0h
		jnc	RIGHT5
		add	bp,132
		cmp	bp,8000h+130*132
		jne	RIGHT5
		mov	bp,8000h+90*132
RIGHT5:
		loop	LOC8
		sti
		ret

KEYZ:		mov	ah,1
		int 	16h
		jnz	ISESC
		ret
ISESC:		xor	ah,ah
		int 	16h
		cmp	al,1bh
		jne	NOESC
		jmp	QUIT2DOS
NOESC:		ret

QUIT2DOS:	mov	ax,03h
		int	10h
		mov	ax,4c00h
		int	21h

LOADDATA:	push	@data
		pop	ds
		mov	ax,3d00h
		lea	dx,FILENAME
		int	21h
		jc	DOSERROR
		push	8000h
		pop	ds
		mov	bx,ax
		mov	cx,720
		mov	dx,2000h
		mov	ah,3fh
		int	21h
		mov	ah,3eh
		int	21h
		mov	ah,0dh
		int	21h
;		call	CONVERTABIT
		ret

DOSERROR:	mov	ah,9
		lea	dx,ERRORMSG
		int	21h
		mov	ax,4c01h
		int	21h


PUTLINE:	mov	di,8000h+132*130
		mov	cx,132/2
LOC20:		mov	ax,word ptr ds:[0]
		imul	ax,8805h  ;8905
		inc	ax
		mov	word ptr ds:[0],ax
		mov	word ptr ds:[di],ax
		add	di,2
		loop	LOC20
		ret


MAKEFIRE:	push	8000h
		pop	ds
		call	PUTLINE
		mov	bx,8000h+34*3*132
		mov	cx,(130/4)+1
BLUR1:		push	cx
		mov	cx,132
BLUR2:		mov	ax,0
		add	al,byte ptr ds:[bx]
		adc	ah,0
		add 	al,byte ptr ds:[bx+131]
		adc	ah,0
		add	al,byte ptr ds:[bx+132]
		adc	ah,0
		add	al,byte ptr ds:[bx+132]
		adc	ah,0
		add	al,byte ptr ds:[bx+133]
		adc	ah,0
		mov	dx,14
		mul	dx
		mov	dl,15*5
		div 	dl
		mov	byte ptr ds:[bx],al
		inc	bx
		loop	BLUR2
		pop 	cx
		loop	BLUR1
		ret

PUTPAL:		mov 	al,0
		mov 	dx,03c8h
		out	dx,al
		mov 	cx,256
		mov 	dx,03c9h
LOC3:		mov	al,byte ptr 0
		sub	al,cl
		shr	al,2
		out	dx,al
		mov	al,0
		out	dx,al
		out	dx,al
		loop	LOC3
		ret

CLEARMEM:	push	es
		push	8000h
		pop	es
		mov	ax,0000
		mov	cx,0000
		mov	di,0000
		rep	stosw
		pop	es
		ret

CONVERTABIT:	push	ds
		push	8000h
		pop	ds
		mov	bx,2000h
		mov	cx,720/2
CONV1:		mov	ax,word ptr ds:[bx]
		mov	dx,0
		push	bx
		mov	bx,4
		div	bx
		pop	bx
		mov	word ptr ds:[bx],ax
		add	bx,2
		loop	CONV1
		pop	ds
		ret
	

END