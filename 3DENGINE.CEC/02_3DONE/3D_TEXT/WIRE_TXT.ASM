.286
.model small

SCRWIDTH	equ	320
SCRHEIGTH	equ	200

.stack
		dw	1000 dup (?)
.data                    		
_3D_COORDS	dw	-200,	 150,	1000
		dw	 -75,	 150,	1000
		dw	 -50,	 125,	1000
		dw	 -50,	  25,	1000
		dw	 -75,	   0,	1000
		dw	 -50,	 -25,	1000
		dw	 -50,	-125,	1000
		dw	 -75,	-150,	1000
		dw	-200,	-150,	1000
		dw	-200,	-100,	1000
		dw	-125,	-100,	1000
		dw	-100, 	 -75,	1000
		dw	-100,	 -50,	1000
		dw	-125,	 -25,	1000
		dw	-175,	 -25,	1000
		dw	-175,	  25,	1000
		dw	-125,	  25,	1000
		dw	-100,	  50,	1000
		dw	-100,	  75,	1000
		dw	-125,	 100,	1000
		dw	-200,	 100,	1000
		dw	 -25,	 150,	1000
		dw	 100,	 150,	1000
		dw	 150,	 100,	1000
		dw	 150,	-100,	1000
		dw	 100,	-150,	1000
		dw	 -75,	-100,	1000
		dw	  25,	 100,	1000
		dw	  75,	 100,	1000
		dw	 100,	  75,	1000
		dw	 100,	 -75,	1000
		dw	  75,	-100,	1000
		dw	  25,	-100,	1000

		dw	-200,	 150,	1150
		dw	 -75,	 150,	1150
		dw	 -50,	 125,	1150
		dw	 -50,	  25,	1150
		dw	 -75,	   0,	1150
		dw	 -50,	 -25,	1150
		dw	 -50,	-125,	1150
		dw	 -75,	-150,	1150
		dw	-200,	-150,	1150
		dw	-200,	-100,	1150
		dw	-125,	-100,	1150
		dw	-100, 	 -75,	1150
		dw	-100,	 -50,	1150
		dw	-125,	 -25,	1150
		dw	-175,	 -25,	1150
		dw	-175,	  25,	1150
		dw	-125,	  25,	1150
		dw	-100,	  50,	1150
		dw	-100,	  75,	1150
		dw	-125,	 100,	1150
		dw	-200,	 100,	1150
		dw	 -25,	 150,	1150
		dw	 100,	 150,	1150
		dw	 150,	 100,	1150
		dw	 150,	-100,	1150
		dw	 100,	-150,	1150
		dw	 -75,	-100,	1150
		dw	  25,	 100,	1150
		dw	  75,	 100,	1150
		dw	 100,	  75,	1150
		dw	 100,	 -75,	1150
		dw	  75,	-100,	1150
		dw	  25,	-100,	1150


_LINEDEFS	dw	0,1, 1,2, 2,3, 3,4, 4,5, 5,6, 6,7, 7,8, 8,9, 9,10
		dw	10,11, 11,12, 12,13, 13,14, 14,15, 15,16, 16,17
		dw	17,18, 18,19, 19,20, 20,0
		dw	33,34, 34,35, 35,36, 36,37, 37,38, 38,39, 39,40
        dw  40,41, 41,42, 42,43, 43,44, 44,45, 45,46, 46,47
		dw	47,48, 48,49, 49,50, 50,51, 51,52, 52,53, 53,33

		dw	21,22, 22,23, 23,24, 24,25, 25,26, 26,21
		dw	54,55, 55,56, 56,57, 57,58, 58,59, 59,54

		dw	27,28, 28,29, 29,30, 30,31, 31,32, 32,27
		dw	60,61, 61,62, 62,63, 63,64, 64,65, 65,27

		dw	0,33, 1,34, 2,35, 3,36, 4,37, 5,38, 6,39, 7,40
		dw	8,41, 9,42, 10,43, 11,44, 12,45, 13,46, 14,47
		dw	15,48, 16,49, 17,50, 18,51, 19,52, 20,53, 21,54
		dw	22,55, 23,56, 24,57, 25,58, 26,59, 27,60, 28,61
 		dw	29,62, 30,63, 31,64, 32,65

_SCR_COORDS	dw	8000 dup (?)


_ENDPOINTS	dw	8000 dup (?)

.code		
		mov	ax,0305h
		mov	bh,0
		mov	bl,3
		int	16h
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
		call	COUNT_SCR
		call	MAKE_NDPTS
		call	DW_ALL_LNZ
		call	KEYS
		jmp	NOQ

COUNT_SCR:	mov	si,offset _3D_COORDS
		mov	di,offset _SCR_COORDS
		mov	cx,66
XTCRDS:		xor	ax,ax
		xor	dx,dx
		mov	al,byte ptr ds:[si+1]
		cbw
		mov	dx,ax
		xor	ax,ax
		mov	ah,byte ptr ds:[si]
		mov	bx,word	ptr ds:[si+4]	;BX=X-coord*256/Z-coord
		idiv	bx
		add	ax,160
		mov	word ptr ds:[di],ax

		xor	ax,ax
		xor	dx,dx
		mov	al,byte ptr ds:[si+3]
		cbw
		mov	dx,ax
		xor	ax,ax
		mov	ah,byte ptr ds:[si+2]
		mov	bx,word ptr ds:[si+4]
		idiv	bx
		add	ax,100
		mov	word ptr ds:[di+2],ax
		add	si,6
		add	di,4
		loop	XTCRDS
		ret

MAKE_NDPTS:	mov	bp,offset _LINEDEFS
		mov	si,offset _SCR_COORDS
		mov	di,offset _ENDPOINTS
		mov	cx,198
NEXT_POINT:	mov	bx,word ptr ds:[bp]
		shl	bx,2
		mov	ax,word ptr ds:[si+bx]
		mov	word ptr ds:[di],ax
		mov	ax,word ptr ds:[si+bx+2]
		mov	word ptr ds:[di+2],ax
		add	di,4
		add	bp,2
		loop	NEXT_POINT
		ret
		
DW_ALL_LNZ:	mov	cx,99
		mov	si,offset _ENDPOINTS
NEXT_LINE:	push	cx
		call	DRLN
		add	si,8
		pop	cx
		loop	NEXT_LINE
		ret

CLRSC:		mov	cx,64000
		mov	bx,0
ANOTHER:	mov	ah,byte ptr es:[bx]
		or 	ah,ah
		jz 	OK_THIS
		sub	byte ptr es:[bx],32
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
		shr	al,1
		out	dx,al
		loop	OTHER_COLOR
		ret
		
DOSQUIT:	mov	ax,03h
		int	10h		
		mov	ax,4c00h
		int	21h		; And back to Dos.



KEYS:		mov	si,offset _3D_COORDS
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
		mov	cx,99
		xor	bx,bx
CSORE1:		add	word ptr ds:[si+bx],16
		add	bx,6
		loop	CSORE1
NOTLEFT:	cmp	ax,4D00h
		jne	NOTRIGHT
		mov	cx,99
		xor	bx,bx
CSORE2:		sub	word ptr ds:[si+bx],16
		add	bx,6
		loop	CSORE2
NOTRIGHT:	cmp	ax,5000h	
		jne	NOTDOWN
		mov	cx,99
		mov	bx,4
CSORE3:		add	word ptr ds:[si+bx],16
		add	bx,6
		loop	CSORE3		
NOTDOWN:	cmp	ax,4800h
		jne	NONE
		mov	cx,99
		mov	bx,4
CSORE4:		sub	word ptr ds:[si+bx],16
		add	bx,6
		loop	CSORE4
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
		mov	byte ptr cs:[INC_OR_DEC_1],4Bh	; dec BX k�dja, mert
		mov	byte ptr cs:[INC_OR_DEC_4],4Bh	; x cs�kken id�ben,
		sub	bx,ax				; mivel X1 a nagyobb:
		mov	cx,bx				; CX = DeltaX
		jmp	SKIP_1				; ennyit X-r�l...
NO_BACK_1:	mov	byte ptr cs:[INC_OR_DEC_1],43h	; inc BX k�dja, mert
		mov	byte ptr cs:[INC_OR_DEC_4],43h	; x n� id�ben, mivel
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
		jg	VERTICAL			; Akkor a f�gg.h�z�s!

; Amennyiben DeltaX a nagyobb, vagy = DeltaY-al, akkor v�zszintesen megy�nk.
HORIZONTAL:	call	ST_ADD
		shl	bx,1			
		mov	word ptr cs:[D_ADD1+1],bx ; [D_ADD1] = 2 * DeltaY 
		sub	bx,cx			
		push	bx
		sub	bx,cx			; [D_ADD2] = 2(DeltaY-DeltaX)
		mov	word ptr cs:[D_ADD2+1],bx
		mov	bx,ax			; startc�m BX-ben
		pop	ax			; ax = DeltaY * 2 - DeltaX
		inc	cx
CYCL1:		mov	byte ptr es:[bx],224
INC_OR_DEC_1:	inc	bx
		test	ah,128
		jz	D_ADD2
D_ADD1:		add	ax,0000
		jmp	NXTPIX
D_ADD2:		add	ax,0000
ADD_OR_SUB_2:	add	bx,SCRWIDTH
NXTPIX:		loop    CYCL1

		ret

; Ha f�gg�legesen nagyobb a koordin�ta-elt�r�s, f�gg�legesen megy�nk.
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
CYCL2:		mov	byte ptr es:[bx],224
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