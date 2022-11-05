.286
.MODEL SMALL
		include	equ.asm
.STACK
.DATA
		include	charset.dat
FileName	db 	'HYPCHARS.DAT',0
Handle		dw	0
Bufi		db	1024 dup (?)
ScrollMem1	dw	0
ScrollMem2	dw	0
Szelesseg	db	0
Fkt		db	0
Sz1		db	21
Sz2		db	25
Sz3		db	29
Fhr		db	31
Szlalo		db	0
Szlalom		db	0
		
.CODE		
		push	@data
		pop	ds
		mov	dx,offset FileName
		xor	cx,cx
		mov	ah,3ch
		int	21h
		mov	word ptr ds:[Handle],ax
		
		mov	dx,offset HypChMatrix
		mov	cx,256
		mov	bx,word ptr ds:[Handle]
		mov	ah,40h
		int	21h			; kezd“ 256 byte ki¡rva
		
		call	MentBetuket

		mov	ah,3eh
		mov	bx,word ptr ds:[Handle]
		int	21h
		mov	ah,0dh
		int	21h
		
		mov	ax,3
		int	10h
		mov	ax,4c00h
		int	21h
		
		include	putchar.asm
END