LoadSineTab:	push	ds
		mov	ax,3d00h
		lea	dx,SineName
		int	21h
		jc	DosError02
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
		pop	ds
		ret

DosError02:	mov	ah,9
		lea	dx,SineError
		int	21h
		mov	ax,4c01h
		int	21h

