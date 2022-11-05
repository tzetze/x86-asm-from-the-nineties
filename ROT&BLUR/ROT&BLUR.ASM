.286
.MODEL SMALL
		include	equ.asm
.STACK
		dw	2000 	dup(?)
.DATA
		include	text.asm
		include rotchars.asm

mem1		dw	0
mem2		dw	8
FILENAME2	db	'SINE.TAB',0
ERRORMSG2	db	'No Çs a SINE.TAB nÇlkÅl mihez kezdjek?! $',0
PSP_Address	dw	0
CONV_SEG1	dw	0
CONV_SEG2	dw	0
CONV_SEG3	dw	0

.CODE		
		push	@data
		pop	ds
		mov	ax,es
		mov	word ptr ds:[PSP_Address],ax
		call	ConvMemAlloc
		push	0a000h
		pop	es
		call	LOADDATA2
		call	CLEARBUFS
		mov	ax,13h
		int	10h
		call	PUTPAL
		call	convert
		lea	bx,text
		push	@data
		pop	ds
                mov	word ptr ds:[mem1],bx

		mov	cx,2880
		mov	bx,0
		mov	si,360
NXTFRAME:	push	si
		push	cx
		push	bx
		call 	SETUP_ROT
		push	@data
		pop	ds
		mov	bx,word ptr ds:[mem2]
		dec	bx
		jnz	oksi
		call	wrt
		mov	bx,4
oksi:		mov	word ptr ds:[mem2],bx
		mov	dx,3dah
VR:		in	al,dx
		and	al,8
		jz	VR
		call	ROT8
                call	KEYZ
		call	BLUR

		pop	bx
		pop	cx
		pop	si
		add	bx,6
		loop	NXTFRAME

CLOSE:		call	KEYZ
		jmp	CLOSE
		jmp	QUIT2DOS

KEYZ:		push	ax
		push	ds
		mov	ah,1
		int 	16h
		jnz	ISESC
		pop	ds
		pop	ax
		ret
ISESC:		xor	ah,ah
		int 	16h
		cmp	al,1bh
		jne	NOESC
		jmp	QUIT2DOS
NOESC:		cmp	ax,4B00h
		jne	NO_L
		mov	ax,word	ptr cs:[Y_COORD+1]
		sub	ax,BMP_WDTH*4
		cmp	ax,0
		jnl	KOKI1
		add	ax,BMP_WDTH*BMP_HGTH
KOKI1:		mov	word ptr cs:[Y_COORD+1],ax
NO_L:		cmp	ax,4D00h
		jne	NO_R
		mov	ax,word	ptr cs:[Y_COORD+1]
		add	ax,BMP_WDTH*4
		cmp	ax,BMP_WDTH*(BMP_HGTH-1)
		jng	KOKI2
		sub	ax,BMP_WDTH*BMP_HGTH
KOKI2:		mov	word ptr cs:[Y_COORD+1],ax
NO_R:		cmp	ax,5000h
		jne	NO_D
		mov	ax,word	ptr cs:[X_COORD+1]
		add	ax,4
		cmp	ax,BMP_WDTH-1
		jng	KOKI3
		sub	ax,BMP_WDTH
KOKI3:		mov	word ptr cs:[X_COORD+1],ax
NO_D:		cmp	ax,4800h
		jne	NO_U
		mov	ax,word	ptr cs:[X_COORD+1]
		sub	ax,4
		cmp	ax,0
		jnl	KOKI4
		add	ax,BMP_WDTH
KOKI4:		mov	word ptr cs:[X_COORD+1],ax
NO_U:		pop	ds
		pop	ax
		ret

		include	rot8.asm
		include blur.asm
		include	textout.asm
		include	loader.asm
		include	works.asm
		include	convmem.asm
end

