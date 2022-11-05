Do_Terrains	PROC NEAR
		call	Say_Coords		; Koordin ta ki¡rat sok
		push	@data
		pop	es			; ES kiv‚telesen dataseg-re
						; mutat
		mov	si,word ptr es:[WindowX]
		mov	di,word ptr es:[WindowY]
		mov	ax,TERKEPKEZD_Y		;bal fels“ sarok y
		mov	cx,TERKEPMERETY
Lejjebb:	push	cx
		  mov	bx,TERKEPKEZD_X		;bal felso sarok x
		  mov	cx,TERKEPMERETX
Jobbran:	  call	TerrDrwMag
		  loop	Jobbran
		  pop	cx
		  add	ax,40
		  inc	di
		  sub	si,TERKEPMERETX
		loop	Lejjebb
		push	0a000h
		pop	es
		ret		
Do_Terrains	ENDP

TerrDrwMag	PROC NEAR
	pusha
	mov		cx,si
	mov		ax,di
	call		PointMap
	push		@data
	pop		es
	mov		bx,word ptr ds:[si]
	mov		byte ptr es:[IsmJel],bl
	and		bx,003fh
	mov		word ptr es:[hanyas],bx
	mov		bx,word ptr ds:[si+2]
	rol		bx,5
	and		bx,001fh
	mov		word ptr es:[Ikon1],bx
	mov		bx,word ptr ds:[si+2]
	and		bx,07ffh
	mov		word ptr es:[Szam1],bx
	mov		bx,word ptr ds:[si+4]
	rol		bx,5
	and		bx,001fh
	mov		word ptr es:[Ikon2],bx
	mov		bx,word ptr ds:[si+4]
	and		bx,07ffh
	mov		word ptr es:[Szam2],bx
	popa
	pusha
	call	DrawBox
	popa
	pusha
	call	DrawIkons
	popa
	add		bx,40
	inc		si
	ret
TerrDrwMag	ENDP
;--------------------------------------------------------------------------;
; Terrain kirajzol sa x,y koordin t kra
; Input : * AX       - y koordin ta
;         * BX       - x koordin ta
;         * [hanyas] - a terrain sz ma
;--------------------------------------------------------------------------;
DrawBox		PROC NEAR
		push	es
		push	ds
		push 	@data
		pop	ds
		push	0a000h
		pop	es
		mov	word ptr ds:[XBuf],bx
		mov	word ptr ds:[YBuf],ax
		add	ax,1
		add	bx,1
		mov	dx,SCR_WIDTH
		mul	dx		; DX:AX = y. sor kezd“c¡me
		add	ax,bx
		adc	dx,0		; DX:AX = a kezd“pont koordin t i
		mov	di,ax
		mov	ax,dx		; bankswitch sz m...
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch
		mov	cx,40*40
		mov	ax,word ptr ds:[hanyas]
		mul	cx
		mov	si,ax
		mov	ax,word ptr ds:[CONV_SEG1]
		mov	ds,ax
		mov	cx,39
Pang01:		push	cx
		  mov	cx,19
		  rep	movsw
		  movsb
		  inc	si
		  add	di,scr_width-39
		  jc	OuttaHere01
StayIn01:	pop	cx
		loop	Pang01
		push	@data
		pop	ds
		jmp	EzenAtmegy01
OuttaHere01:	call 	SwapUp
		jmp	Stayin01
EzenAtmegy01:	mov	bx,word ptr ds:[XBuf]
		mov	ax,word ptr ds:[YBuf]
		mov	dh,byte ptr ds:[IsmJel]
		test	dh,80h
		jnz	Knowos
		and	dh,10111111b
		jz	Knowos
		mov	dx,word	ptr ds:[Ikon1]
		cmp	dx,0
		jnz	Knowos

		add	ax,10
		add	bx,10
		mov	dx,SCR_WIDTH
		mul	dx		
		add	ax,bx
		adc	dx,0		
		mov	di,ax
		mov	ax,dx		
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch
		lea	si,NoIsmert
		mov	cx,20
Pang02:		push	cx
		  mov	cx,10
		  rep	movsw
		  add	di,scr_width-20
		  jc	OuttaHere02
StayIn02:	pop	cx
		loop	Pang02
		jmp	EzenAtmegy02
OuttaHere02:	call	SwapUp
		jmp	StayIn02
EzenAtmegy02:
Knowos:		pop	ds
		pop	es
		ret
DrawBox		ENDP

;--------------------------------------------------------------------------;
; Ikon(ok) kirajzol sa x,y koordin t j£ kock ba
; Input : * AX       - y koordin ta
;         * BX       - x koordin ta
;         * [Ikonx]  - az ikon sz ma
;--------------------------------------------------------------------------;
DrawIkons	PROC NEAR
		push	es
		push	ds
		push 	@data
		pop	ds
		push	0a000h
		pop	es
		cmp	word ptr ds:[Ikon1],0
		jnz	TovabbMehet
		jmp	TokreVege
TovabbMehet:	mov	word ptr ds:[XBuf],bx
		mov	word ptr ds:[YBuf],ax
		add	ax,4
		add	bx,4

		mov	dx,SCR_WIDTH
		mul	dx		; DX:AX = y. sor kezd“c¡me
		add	ax,bx
		adc	dx,0		; DX:AX = a kezd“pont koordin t i
		mov	di,ax
		mov	ax,dx		; bankswitch sz m...
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch

		mov	cx,33*15
		mov	ax,word ptr ds:[Ikon1]
		mul	cx
		mov	si,24000
		add	si,ax
		mov	ax,word ptr ds:[CONV_SEG1]
		mov	ds,ax
		mov	cx,15
Pang03:		push	cx
		  mov	cx,16
		  rep	movsw
		  movsb
		  add	di,scr_width-33
		  jc	OuttaHere03
StayIn03:	pop	cx
		loop	Pang03
		push	@data
		pop	ds
		jmp	EzenAtmegy03
OuttaHere03:	call	SwapUp
		jmp	StayIn03
EzenAtmegy03:	mov	ax,word ptr ds:[Szam1]
		mov	word ptr ds:[coord_memo],ax
		mov	si,word ptr ds:[XBuf]
		mov	di,word ptr ds:[YBuf]
		add	si,21
		add	di,8
		call    Graph_Say

		cmp	word ptr ds:[Ikon2],0
		jz	MarVegeis
		mov	bx,word ptr ds:[XBuf]
		mov	ax,word ptr ds:[YBuf]
		add	ax,23
		add	bx,4

		mov	dx,SCR_WIDTH
		mul	dx		; DX:AX = y. sor kezd“c¡me
		add	ax,bx
		adc	dx,0		; DX:AX = a kezd“pont koordin t i
		mov	di,ax
		mov	ax,dx		; bankswitch sz m...
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch

		mov	cx,33*15
		mov	ax,word ptr ds:[Ikon2]
		mul	cx
		mov	si,24000
		add	si,ax
		mov	ax,word ptr ds:[CONV_SEG1]
		mov	ds,ax
		mov	cx,15
Pang04:		push	cx
		  mov	cx,16
		  rep	movsw
		  movsb
		  add	di,scr_width-33
		  jc	OuttaHere04
StayIn04:	pop	cx
		loop	Pang04
		push	@data
		pop	ds
		jmp	EzenAtmegy04
OuttaHere04:	call	SwapUp
		jmp	StayIn04
EzenAtmegy04:	mov	ax,word ptr ds:[Szam2]
		mov	word ptr ds:[coord_memo],ax
		mov	si,word ptr ds:[XBuf]
		mov	di,word ptr ds:[YBuf]
		add	si,21
		add	di,27
		call    Graph_Say

MarVegeis:	mov	bx,word ptr ds:[XBuf]
		mov	ax,word ptr ds:[YBuf]

TokreVege:	push	@data
		pop	ds
		mov	dh,byte ptr ds:[IsmJel]
		test	dh,40h
		jnz	JeloltBiza	
		jmp	NagyonVege
JeloltBiza:	add	ax,1
		add	bx,1
		mov	dx,SCR_WIDTH
		mul	dx	
		add	ax,bx
		adc	dx,0	
		mov	bx,ax
		mov	ax,dx	
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch
		mov	cx,39
Pang05:		push	cx
		  mov	cx,39
Kovcsi:		  mov	al,byte ptr es:[bx]
		  mov	ah,15
		  sub 	ah,al
		  mov	byte ptr es:[bx],ah
		  inc   bx
		  loop	Kovcsi	
		  add	bx,scr_width-39
		  jc	OuttaHere05
StayIn05:	pop	cx
		loop	Pang05
		jmp	EzenAtmegy05
OuttaHere05:	call	Swapup
		jmp	StayIn05
Ezenatmegy05:
NagyonVege:	pop	ds
		pop	es
		ret
DrawIkons	ENDP

;===========================================================================
; Bankswitchel egyet f”lfele...
;===========================================================================
SwapUp		PROC NEAR
		push	ds
		push	@data
		pop	ds
		mov	ax,word ptr ds:[act_bank]
		inc	ax
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch
		pop	ds
		ret
SwapUp		ENDP

; -------------------------------------------------------------------------;
; Sz mjegy kirajzol sa x,y koordin t kra
; Input : * AX           - y koordin ta
;         * BX           - x koordin ta
;         * [coord_memo] - a sz mjegy maga
;--------------------------------------------------------------------------;
DrawNumba	PROC NEAR
		pusha
		push 	@data
		pop	ds
		push	0a000h
		pop	es
		mov	dx,SCR_WIDTH
		mul	dx		; DX:AX = y. sor kezd“c¡me
		add	ax,bx
		adc	dx,0		; DX:AX = a kezd“pont koordin t i
		mov	di,ax
		mov	ax,dx		; bankswitch sz m...
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch
		mov	cx,7
		mov	ax,word ptr ds:[hanyas]
		mul	cx
		lea	si,SZAMOK
		add	si,ax
		mov	cx,7
NextPlz:	push	cx
		  mov	word ptr es:[di],0
		  mov	word ptr es:[di+2],0	; el“t”rl‚s
		  mov	ah,byte ptr ds:[si]	; a fels“ 3 bit a fontos
		  test	ah,128
		  jz	ElsoNincs
		  mov	byte ptr es:[di],255
ElsoNincs:	  inc	di
		  test 	ah,64
		  jz	MasodikNincs
		  mov	byte ptr es:[di],255
MasodikNincs:	  inc	di
		  test	ah,32
		  jz 	HarmadikNincs
		  mov	byte ptr es:[di],255
HarmadikNincs:	  inc	di
		  test 	ah,16
		  jz	NegyedikNincs
		  mov	byte ptr es:[di],255
NegyedikNincs:	  inc	si
		  add	di,SCR_WIDTH-3
		  jc	OuttaHere
Maradt:		pop	cx
		loop	NextPlz
		jmp	EzenAtmegy
Outtahere:	call	Swapup
		jmp	Maradt		
EzenAtmegy:	popa
		ret
DrawNumba	ENDP
