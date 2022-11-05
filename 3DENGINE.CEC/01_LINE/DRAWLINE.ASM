.286
.model small

SCRWIDTH	equ	320
SCRHEIGTH	equ	200

.stack
		dw	1000 dup (?)
.data		
ENDPOINTS	dw	160,100,200,180

.code		
		push	@data
		pop	ds
		push	0A000h		
		pop	es		
		mov	ax,13h		
		int	10h
		call	PALETTE
NOQ:		mov	dx,3DAh
VR:		in	al,dx
		and	al,8
		jz	VR
		call	CLRSC
		mov	si,offset ENDPOINTS
		call	DRLN
		call	KEYS
		jmp	NOQ

CLRSC:		mov	cx,64000
		mov	bx,0
ANOTHER:	mov	ah,byte ptr es:[bx]
		or 	ah,ah
		jz 	OK_THIS
		sub	byte ptr es:[bx],16
OK_THIS:	inc	bx
		loop	ANOTHER
		ret

PALETTE:	mov	dx,3c8h
		mov	al,0
		out	dx,al
		inc	dx
		mov	cx,256
OTHER_COLOR:	mov	al,0
		sub	al,cl
		shr	al,2
		out	dx,al
		out	dx,al
		out	dx,al
		loop	OTHER_COLOR
		ret
		
DOSQUIT:	mov	ax,03h
		int	10h		
		mov	ax,4c00h
		int	21h		; And back to Dos.



KEYS:		mov	si,offset ENDPOINTS
		mov	ah,1
		int 	16h
		jnz	CHANGE
		ret
CHANGE:		
		xor	ah,ah
		int 	16h
	
		cmp	al,1bh
		jne	NOTESC
		jmp	DOSQUIT
NOTESC:		cmp	ax,4B00h
		jne	NOTLEFT
		dec	word ptr ds:[si+4]
NOTLEFT:	cmp	ax,4D00h
		jne	NOTRIGHT
		inc	word ptr ds:[si+4]
NOTRIGHT:	cmp	ax,5000h	
		jne	NOTDOWN
		inc	word ptr ds:[si+6]
NOTDOWN:	cmp	ax,4800h
		jne	NONE
		dec	word ptr ds:[si+6]
NONE:		
		ret



; --- LINE-DRAWER ROUTINE -------------------------------------------------
; Input: SI, the address of the line coordinates
; DS:[ SI + 00 ] ==> X1
; DS:[ SI + 02 ] ==> Y1
; DS:[ SI + 04 ] ==> X2
; DS:[ SI + 06 ] ==> Y2
; -------------------------------------------------------------------------

DRLN:		mov	bx,ds:[si]			; bx:=X1
		mov	ax,ds:[si+4]			; ax:=X2
		cmp	ax,bx	
		jg	NO_BACK_1			; jmp, ha X2 nagyobb.
		mov	byte ptr cs:[INC_OR_DEC_1],4Bh	; dec BX k¢dja, mert
		mov	byte ptr cs:[INC_OR_DEC_4],4Bh	; x csîkken idìben,
		sub	bx,ax				; mivel X1 a nagyobb:
		mov	cx,bx				; CX = DeltaX
		jmp	SKIP_1				; ennyit X-rìl...
NO_BACK_1:	mov	byte ptr cs:[INC_OR_DEC_1],43h	; inc BX k¢dja, mert
		mov	byte ptr cs:[INC_OR_DEC_4],43h	; x nì idìben, mivel
		sub	ax,bx				; X2 a nagyobb.
		mov	cx,ax				; CX = DeltaX

SKIP_1:		mov	bx,ds:[si+2]			
		mov	ax,ds:[si+6]
		cmp	ax,bx
		jg	NO_BACK_2
		mov	byte ptr cs:[ADD_OR_SUB_2+1],0EBh
		mov	byte ptr cs:[ADD_OR_SUB_3+1],0EBh
		sub	bx,ax
		mov	ax,bx				; AX,BX = DeltaY
		jmp	SKIP_2
NO_BACK_2:	mov	byte ptr cs:[ADD_OR_SUB_2+1],0C3h
		mov	byte ptr cs:[ADD_OR_SUB_3+1],0C3h
		sub	ax,bx
		mov	bx,ax				; AX,BX = DeltaY
SKIP_2:		cmp	ax,cx				; Ha DeltaY nagyobb,
		jg	VERTICAL			; Akkor a fÅgg.h£z†s!

; Amennyiben DeltaX a nagyobb, vagy = DeltaY-al, akkor v°zszintesen megyÅnk.
HORIZONTAL:	call	ST_ADD
		shl	bx,1			
		mov	word ptr cs:[D_ADD1+1],bx ; [D_ADD1] = 2 * DeltaY 
		sub	bx,cx			
		push	bx
		sub	bx,cx			; [D_ADD2] = 2(DeltaY-DeltaX)
		mov	word ptr cs:[D_ADD2+1],bx
		mov	bx,ax			; startc°m BX-ben
		pop	ax			; ax = DeltaY * 2 - DeltaX
		inc	cx
CYCL1:		mov	byte ptr es:[bx],240
INC_OR_DEC_1:	inc	bx
		test	ah,128
		jz	D_ADD2
D_ADD1:		add	ax,0000
		jmp	NXTPIX
D_ADD2:		add	ax,0000
ADD_OR_SUB_2:	add	bx,SCRWIDTH
NXTPIX:		loop    CYCL1

		ret

; Ha fÅggìlegesen nagyobb a koordin†ta-eltÇrÇs, fÅggîlegesen megyÅnk.
VERTICAL:	xchg	bx,cx
		call	ST_ADD
		shl	bx,1
		mov	word ptr cs:[D_ADD3+1],bx ; [D_ADD3] = 2 * DeltaX
		sub	bx,cx
		push	bx
		sub	bx,cx			; [D_ADD2] = 2(DeltaX-DeltaY)
		mov	word ptr cs:[D_ADD4+1],bx
		mov	bx,ax
		pop	ax
		inc	cx
CYCL2:		mov	byte ptr es:[bx],240
ADD_OR_SUB_3:	add	bx,SCRWIDTH
		test	ah,128
		jz	D_ADD4
D_ADD3:		add	ax,0000
		jmp	NXTPX
D_ADD4:		add	ax,0000
INC_OR_DEC_4:	inc	bx
NXTPX:		loop	CYCL2

		ret

ST_ADD:		mov	ax,word ptr ds:[si+2]
		mov	dx,SCRWIDTH
		mul	dx
		add	ax,word ptr ds:[si]
		ret
END