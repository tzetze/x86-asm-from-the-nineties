LOADDATA2:	push	ds
		mov	ax,3d00h
		lea	dx,FILENAME2
		int	21h
		jc	DOSERROR2
		push	@data
		pop	ds
		mov	ax,word ptr ds:[CONV_SEG3]
		mov	ds,ax
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

DOSERROR2:	mov	ah,9
		lea	dx,ERRORMSG2
		int	21h
		mov	ax,4c01h
		int	21h

