
.286
.model small

MODIFY1		equ	MOD2_1+1
MODIFY2		equ	RIGHT+2
MODIFY3		equ	MOD1_1+1
MODIFY4		equ	RIGHT4+2

.stack
.data
FILENAME	db	'GRAB5.BMP',0
FILENAME2	db	'SINE.TAB',0
ERRORMSG 	db	'GRAB5.BMP??? Hol van?$',0
ERRORMSG2	db	'No ?s a SINE.TAB n?lk?l mihez kezdjek?! $',0

.code		
		push	@data
		pop	ds
		push	0a000h
		pop	es

		call	LOADDATA
		mov	ax,13h
		int	10h
		push	8000h
		pop	ds
		call	PUTPAL
		call	SORTDTA
		call	LOADDATA2

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
		mov	dx,3dah
VR:		in	al,dx
		and	al,8
		jz	VR
		call	ROT8
                call	KEYZ
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
		mov	bp,8000h
		mov	si,76
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
MOD2_1:		add	ax,08000h
		adc	si,0
		cmp	si,132
		jne	RIGHT
		mov	si,0
RIGHT:		add	bx,0ddb0h
		jnc	RIGHT3
		sub	bp,132
		cmp	bp,8000h-132
		jne	RIGHT3
		mov	bp,8000h+132*129
RIGHT3:		loop	LOC
RIGHT7:	
		pop	si
		pop	bp
		pop	ax
		pop	bx
		pop	cx
MOD1_1:		add	ax,0ddb0h
		adc	si,0
		cmp	si,132
		jne	RIGHT4
		mov	si,0
RIGHT4:		add	bx,08000h
		jnc	RIGHT5
		add	bp,132
		cmp	bp,8000h+132*130
		jne	RIGHT5
		mov	bp,8000h
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

SORTDTA:	mov	si,1078+132*129
		mov	di,8000h
		mov	cx,130
NXTLN:		push	cx
		mov	cx,66
NXTPXL:		mov	dx,word ptr ds:[si]
		mov	word ptr ds:[di],dx
		add	si,2
		add	di,2
		loop	NXTPXL
		sub	si,264
		pop	cx
		loop	NXTLN		
		ret		

QUIT2DOS:	mov	ax,03h
		int	10h
		mov	ax,4c00h
		int	21h



PUTPAL:		mov	bx,55
		mov 	al,0
		mov 	dx,03c8h
		out	dx,al
		mov 	cx,256
		mov 	dx,03c9h
LOOP_LOC:	mov	al,ds:[bx]
		shr	al,2
		out	dx,al
		dec	bx
		mov	al,ds:[bx]
		shr	al,2
		out	dx,al
		dec	bx
		mov 	al,ds:[bx]
		shr	al,2
		out	dx,al
		add	bx,6
		loop	LOOP_LOC
		ret

LOADDATA:	mov	ax,3d00h
		lea	dx,FILENAME
		int	21h
		jc	DOSERROR
		push	ds
		push	8000h
		pop	ds
		mov	bx,ax
		mov	cx,18238
		mov	dx,0
		mov	ah,3fh
		int	21h
		mov	ah,3eh
		int	21h
		mov	ah,0dh
		int	21h
		pop	ds
		ret

LOADDATA2:	push	@data
		pop	ds
		mov	ax,3d00h
		lea	dx,FILENAME2
		int	21h
		jc	DOSERROR2
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
		ret

DOSERROR:	mov	ah,9
		lea	dx,ERRORMSG
		int	21h
		mov	ax,4c01h
		int	21h

DOSERROR2:	mov	ah,9
		lea	dx,ERRORMSG2
		int	21h
		mov	ax,4c01h
		int	21h


end