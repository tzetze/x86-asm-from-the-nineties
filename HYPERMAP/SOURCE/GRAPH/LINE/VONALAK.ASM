DrawMatrix	PROC NEAR
	lea     si,LineArea
	mov	byte ptr ds:[si+8],31
	mov     cx,TERKEPMERETY+1
	mov     ax,TERKEPKEZD_Y
NXHORZ:
        mov	word ptr ds:[si+0],TERKEPKEZD_X
	mov	word ptr ds:[si+2],ax
	mov	word ptr ds:[si+4],TERKEPKEZD_X+TERKEPMERETX*EGYKOCKA_X
	mov	word ptr ds:[si+6],ax
	push	ax
	push	cx
	call	DRLN
	pop	cx
	pop	ax
	add	ax,EGYKOCKA_Y
	loop	NXHORZ
	mov	cx,TERKEPMERETX+1
	mov	ax,TERKEPKEZD_X
NXVERT:
	mov	word ptr ds:[si+0],ax
	mov	word ptr ds:[si+2],TERKEPKEZD_Y
	mov	word ptr ds:[si+4],ax
	mov	word ptr ds:[si+6],TERKEPKEZD_Y+TERKEPMERETY*EGYKOCKA_Y
	push	ax
	push	cx
	call	DRLN
	pop	cx
	pop	ax
	add	ax,EGYKOCKA_X
	loop	NXVERT
	ret
DrawMatrix	ENDP

DrwKeret	PROC NEAR
	push	@data
	pop	ds
	push	0a000h
	pop	es
	lea	si,LineArea
	mov	cx,13
	mov	ax,0
	mov	di,31
	mov	bx,491
	mov	dx,18*256
UppaOne:
	mov	word ptr ds:[si+0],ax
	mov	word ptr ds:[si+2],di
	mov	word ptr ds:[si+4],bx
	mov	word ptr ds:[si+6],di
	mov	byte ptr ds:[si+8],dh
	pusha
	call	DrLn
	popa
	add	dl,0ddh
	jnc	Thrux1
	inc	dh
Thrux1:	
	inc	ax
	inc	di
	dec	bx
	loop	UppaOne
	mov	cx,12
UppaTwo:
	mov	word ptr ds:[si+0],ax
	mov	word ptr ds:[si+2],di
	mov	word ptr ds:[si+4],bx
	mov	word ptr ds:[si+6],di
	mov	byte ptr ds:[si+8],dh
	pusha
	call	DrLn
	popa
	add	dl,0ddh
	jnc	Thrux2
	dec	dh
Thrux2:
	inc	ax
	inc	di
	dec	bx
	loop	UppaTwo
	mov	cx,13
	mov	ax,0
	mov	di,602
	mov	bx,491
	mov	dx,18*256
DonnaOne:
	mov	word ptr ds:[si+0],ax
	mov	word ptr ds:[si+2],di
	mov	word ptr ds:[si+4],bx
	mov	word ptr ds:[si+6],di
	mov	byte ptr ds:[si+8],dh
	pusha
	call	DrLn
	popa
	add	dl,0ddh
	jnc	Thrux3
	inc	dh
Thrux3:	
	inc	ax
	dec	di
	dec	bx
	loop	DonnaOne
	mov	cx,12		
DonnaTwo:
	mov	word ptr ds:[si+0],ax
	mov	word ptr ds:[si+2],di
	mov	word ptr ds:[si+4],bx
	mov	word ptr ds:[si+6],di
	mov	byte ptr ds:[si+8],dh
	pusha
	call	DrLn
	popa
	add	dl,0ddh
	jnc	Thrux4
	dec	dh
Thrux4:	
	inc	ax
	dec	di
	dec	bx
	loop	DonnaTwo
	mov	cx,13
	mov	ax,0
	mov	di,31
	mov	bx,602
	mov	dx,18*256
LeftaOne:
	mov	word ptr ds:[si+0],ax
	mov	word ptr ds:[si+2],di
	mov	word ptr ds:[si+4],ax
	mov	word ptr ds:[si+6],bx
	mov	byte ptr ds:[si+8],dh
	pusha
	call	DrLn
	popa
	add	dl,0ddh
	jnc	Thrux5
	inc	dh
Thrux5:	
	inc	ax
	inc	di
	dec	bx
	loop	LeftaOne
	mov	cx,12		
LeftaTwo:
	mov	word ptr ds:[si+0],ax
	mov	word ptr ds:[si+2],di
	mov	word ptr ds:[si+4],ax
	mov	word ptr ds:[si+6],bx
	mov	byte ptr ds:[si+8],dh
	pusha
	call	DrLn
	popa
	add	dl,0ddh
	jnc	Thrux6
	dec	dh
Thrux6:	
	inc	ax
	inc	di
	dec	bx
	loop	LeftaTwo
	mov	cx,13
	mov	ax,31
	mov	di,602
	mov	bx,491
	mov	dx,18*256
RittaOne:
	mov	word ptr ds:[si+0],bx
	mov	word ptr ds:[si+2],ax
	mov	word ptr ds:[si+4],bx
	mov	word ptr ds:[si+6],di
	mov	byte ptr ds:[si+8],dh
	pusha
	call	DrLn
	popa
	add	dl,0ddh
	jnc	Thrux7
	inc	dh
Thrux7:	
	inc	ax
	dec	di
	dec	bx
	loop	RittaOne
	mov	cx,12		
RittaTwo:
	mov	word ptr ds:[si+0],bx
	mov	word ptr ds:[si+2],ax
	mov	word ptr ds:[si+4],bx
	mov	word ptr ds:[si+6],di
	mov	byte ptr ds:[si+8],dh
	pusha
	call	DrLn
	popa
	add	dl,0ddh
	jnc	Thrux8
	dec	dh
Thrux8:	
	inc	ax
	dec	di
	dec	bx
	loop	RittaTwo
	ret
DrwKeret	ENDP


Jelol		PROC	NEAR
	push	ds
	push	es
	push	@data
	pop	ds
	mov	ax,SCR_WIDTH*(TERKEPKEZD_Y-2)	; 
	xor	dx,dx				;
	add	ax,TERKEPKEZD_X-2		; DX:AX = tÇrkÇp bal-
	adc	dx,0				; felsì sarka koord.
	mov	bx,ax
	mov	di,dx
	mov	ax,word ptr ds:[JelY]
	mov	cx,EGYKOCKA_Y*SCR_WIDTH
	mul	cx
	add	bx,ax
	adc	di,dx		
	mov	ax,word ptr ds:[JelX]
	mov	cx,EGYKOCKA_X
	mul	cx
	add	bx,ax
	adc	dx,di
	mov     ax,dx
	mov     word ptr ds:[act_bank],ax
	call    BankSwitch
	call	VszRaXorol
	add	bx,SCR_WIDTH
	jnc	FeruLe
	mov	ax,word ptr ds:[act_bank]
	inc	ax
	mov	word ptr ds:[act_bank],ax
	call	BankSwitch
FeruLe:	
	call	VszRaXorol
	add	bx,SCR_WIDTH
	jnc	IndulhatLe
	mov	ax,word ptr ds:[act_bank]
	inc	ax
	mov	word ptr ds:[act_bank],ax
	call	BankSwitch
IndulhatLe:
	call	FgRaXorol
	call	VszRaXorol
	add	bx,SCR_WIDTH
	jnc	VegRe
	mov	ax,word ptr ds:[act_bank]
	inc	ax
	mov	word ptr ds:[act_bank],ax
	call	BankSwitch
VegRe:	
	call	VszRaXorol
	pop	es
	pop	ds
	ret
Jelol		ENDP

VszRaXorol	PROC NEAR
	mov	cx,(EGYKOCKA_X+4)
	push	bx
MeXorUl:
	mov	al,byte ptr es:[bx]
	mov	ah,15
	sub	ah,al
	mov	byte ptr es:[bx],ah
	inc	bx
	loop	MeXorUl
	pop	bx
	ret
VszRaXorol	ENDP

FgRaXorol	PROC NEAR
	mov	cx,EGYKOCKA_Y+2
MennyenCsak:
	mov	ax,word ptr es:[bx]
	mov	dx,256*15+15
	sub	dh,ah
	sub	dl,al
	mov	word ptr es:[bx],dx
	add	bx,EGYKOCKA_X+4
	mov	ax,word ptr es:[bx]
	mov	dx,256*15+15
	sub	dh,ah
	sub	dl,al
	mov	word ptr es:[bx],dx
	add	bx,SCR_WIDTH-(EGYKOCKA_X+4)
	jnc	LefeleMegy
	mov	ax,word ptr ds:[act_bank]
	inc	ax
	mov	word ptr ds:[act_bank],ax
	call	BankSwitch
LefeleMegy:
	loop	MennyenCsak
	ret
FgRaXorol	ENDP

; --- LINE-DRAWER ROUTINE -------------------------------------------------
; Input: SI, the address of the line coordinates
; word DS:[ SI + 00 ] ==> X1
; word DS:[ SI + 02 ] ==> Y1
; word DS:[ SI + 04 ] ==> X2
; word DS:[ SI + 06 ] ==> Y2
; byte DS:[ SI + 08 ] ==> color
; -------------------------------------------------------------------------
DRLN		PROC NEAR
		mov	ah,byte ptr ds:[si+8]
		mov	byte ptr cs:[CYCL1+3],ah
		mov	byte ptr cs:[CYCL2+3],ah
		mov	bx,ds:[si]			; bx:=X1
		mov	ax,ds:[si+4]			; ax:=X2
		cmp	ax,bx	
		jg	NO_BACK_1			; jmp, ha X2 nagyobb.
		mov	byte ptr cs:[INC_OR_DEC_1],4Bh	; dec BX k¢dja, mert
		mov	byte ptr cs:[INC_OR_DEC_4],4Bh	; x csîkken idìben,
		mov	byte ptr cs:[SWUPDN1],48h	; megfelelì bankswitch
		mov	byte ptr cs:[SWUPDN4],48h	; ir†nyzÇk!
		sub	bx,ax				; mivel X1 a nagyobb:
		mov	cx,bx				; CX = DeltaX
		jmp	SKIP_1				; ennyit X-rìl...
NO_BACK_1:	mov	byte ptr cs:[INC_OR_DEC_1],43h	; inc BX k¢dja, mert
		mov	byte ptr cs:[INC_OR_DEC_4],43h	; x nì idìben, mivel
		mov	byte ptr cs:[SWUPDN1],40h
		mov	byte ptr cs:[SWUPDN4],40h
		sub	ax,bx				; X2 a nagyobb.
		mov	cx,ax				; CX = DeltaX

SKIP_1:		mov	bx,ds:[si+2]			
		mov	ax,ds:[si+6]
		cmp	ax,bx
		jg	NO_BACK_2
		mov	byte ptr cs:[ADD_OR_SUB_2+1],0EBh ; csîkkenì
		mov	byte ptr cs:[ADD_OR_SUB_3+1],0EBh
		mov	byte ptr cs:[SWUPDN2],48h
		mov	byte ptr cs:[SWUPDN3],48h
		sub	bx,ax
		mov	ax,bx				; AX,BX = DeltaY
		jmp	SKIP_2
NO_BACK_2:	mov	byte ptr cs:[ADD_OR_SUB_2+1],0C3h ; nîvekvì
		mov	byte ptr cs:[ADD_OR_SUB_3+1],0C3h
		mov	byte ptr cs:[SWUPDN2],40h
		mov	byte ptr cs:[SWUPDN3],40h
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
CYCL1:		mov	byte ptr es:[bx],255
		mov	dx,bx
INC_OR_DEC_1:	inc	bx
		jo	NOVER2
		push	bx
		xor	bx,dx
		rcl	bh,1
		jc	VALTO1
		pop	bx
NOVER2:		test	ah,128
		jz	D_ADD2
D_ADD1:		add	ax,0000
		jmp	NXTPIX
D_ADD2:		add	ax,0000
		mov	dx,bx
ADD_OR_SUB_2:	add	bx,SCR_WIDTH
		jo	NXTPIX
		push	bx
		xor	bx,dx
		rcl	bh,1
		jc	VALTO2
		pop	bx
NXTPIX:		loop    CYCL1

		ret

VALTO1:		pop	bx
		push	ax
		push	bx
		push	cx
		mov	ax,word ptr ds:[act_bank]
SWUPDN1:	inc	ax
		mov	word ptr ds:[act_bank],ax
		call 	bankswitch
		pop	cx
		pop	bx
		pop	ax
		jmp	NOVER2

VALTO2:		pop 	bx
		push	ax
		push	bx
		push	cx	
		mov	ax,word ptr ds:[act_bank]
SWUPDN2:	inc 	ax
		mov	word ptr ds:[act_bank],ax
		call	bankswitch
		pop	cx
		pop	bx
		pop	ax
		jmp	NXTPIX

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
CYCL2:		mov	byte ptr es:[bx],255
		mov	dx,bx
ADD_OR_SUB_3:	add	bx,SCR_WIDTH
		jo	NOVER
		push	bx
		xor	bx,dx
		rcl	bh,1
		jc	VALTO3
		pop	bx
NOVER:		test	ah,128
		jz	D_ADD4
D_ADD3:		add	ax,0000
		jmp	NXTPX
D_ADD4:		add	ax,0000
		mov	dx,bx
INC_OR_DEC_4:	inc	bx
		jo	NXTPX
		push	bx
		xor	bx,dx
		rcl	bh,1
		jc	VALTO4
		pop	bx
NXTPX:		loop	CYCL2
		ret

ST_ADD:		mov	ax,word ptr ds:[si+2]
		mov	dx,SCR_WIDTH
		mul	dx
		add	ax,word ptr ds:[si]
		adc	dx,0
		push	ax
		mov	ax,dx
		mov	word ptr ds:[act_bank],ax
		call	bankswitch
		pop	ax
		ret

VALTO3:		pop	bx
		push	ax
		push	bx
		push	cx
		mov	ax,word ptr ds:[act_bank]
SWUPDN3:	inc	ax
		mov	word ptr ds:[act_bank],ax
		call	bankswitch
		pop	cx
		pop	bx
		pop	ax
		jmp	NOVER

VALTO4:		pop	bx
		push	ax
		push	bx
		push	cx
		mov	ax,word ptr ds:[act_bank]
SWUPDN4:	inc	ax
		mov	word ptr ds:[act_bank],ax
		call	bankswitch
		pop	cx
		pop	bx
		pop	ax
		jmp	NXTPX
DRLN		ENDP

