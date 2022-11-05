EXTRN Blur:proc 
EXTRN StoreScr:proc 
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
SineName	db	'SINE.TAB',0
SineError	db	'No Çs a SINE.TAB nÇlkÅl mihez kezdjek?! $',0

.CODE		
		push	@data
		pop	ds
		push	0a000h
		pop	es
		call	LoadSineTab
		call	ClearBufs
		mov	ax,13h
		int	10h
		call	SSPal
		call	Convert 		; kezdetben!
		lea	bx,text
                mov	word ptr ds:[mem1],bx

UjForgas:	mov	cx,144
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

		mov	ax,word	ptr cs:[X_COORD+1]
		sub	ax,4
		cmp	ax,0
		jnl	KOK
		add	ax,BMP_WDTH
KOK:		mov	word ptr cs:[X_COORD+1],ax

		pop	bx
		pop	cx
		pop	si
		add	bx,10
		loop	NXTFRAME

		jmp	UjForgas


KEYZ:		mov	ah,1
		int 	16h
		jnz	ISEND
		ret
ISEND:		jmp	QUIT2DOS
		ret

		include	rot8.asm
;		include blur.asm
		include	textout.asm
		include	loader.asm
		include	works.asm
end

