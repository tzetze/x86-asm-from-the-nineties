; ******************************************************************
; ** A billenty–zetkezel“ algoritmus *******************************
; ******************************************************************
Controls	PROC NEAR
	call	BalGomb
	jnc	Billentyuk
	call	InitSaverTime
	call	LeftMousePressed
Billentyuk:
	mov	ah,1
	int 	16h
	jnz	PushedAny
	ret
PushedAny:
	call	InitSaverTime
	xor	ah,ah
	int 	16h
	cmp	al,1bh
	jne	Not_Esc
	jmp	Quit2Dos
Not_Esc:
	cmp	ax,4B00h
	jne	Not_KLeft
	call	EgerKi
	call	Jelol
	mov	ax,word ptr ds:[JelX]
	dec	ax
	cmp	ax,0FFFFh
	jnz	OkLoc1
	mov	ax,word ptr ds:[WindowX]
	dec	ax
	cmp	ax,0FFFFh
	jnz	NotProb1
	mov	ax,300-TERKEPMERETX
NotProb1:
	mov	word ptr ds:[WindowX],ax
	call	Do_Terrains
	call	BigIkon
	xor	ax,ax
OkLoc1:
	mov	word ptr ds:[JelX],ax
	call	Jelol
	call	BigIkon
	call	EgerBe
	jmp	Not_KDown
Not_KLeft:
	cmp	ax,4D00h
	jne	Not_KRight
	call	EgerKi
	call	Jelol
	mov	ax,word ptr ds:[JelX]
	inc	ax
	cmp	ax,TERKEPMERETX
	jnz	OkLoc2
	mov	ax,word ptr ds:[WindowX]
	inc	ax
	cmp	ax,300-TERKEPMERETX+1
	jnz	NotProb2
	xor	ax,ax
NotProb2:
	mov	word ptr ds:[WindowX],ax
	call	Do_Terrains
	call	BigIkon
	mov	ax,TERKEPMERETX-1
OkLoc2:	
	mov	word ptr ds:[JelX],ax
	call	Jelol
	call	BigIkon
	call	EgerBe
	jmp	Not_KDown
Not_KRight:
	cmp	ax,4800h
	jne	Not_KUp
	call	EgerKi
	call	Jelol
	mov	ax,word ptr ds:[JelY]
	dec	ax
	cmp	ax,0FFFFh
	jnz	OkLoc3
	mov	ax,word ptr ds:[WindowY]
	dec	ax
	cmp	ax,0FFFFh
	jnz	NotProb3
	mov	ax,128-TERKEPMERETY
NotProb3:
	mov	word ptr ds:[WindowY],ax
	call	Do_Terrains
	call	BigIkon
	xor	ax,ax
OkLoc3:
	mov	word ptr ds:[JelY],ax
	call	Jelol
	call	BigIkon
	call	EgerBe
	jmp	Not_KDown
Not_KUp:
	cmp	ax,5000h
	jne	Not_KDown
	call	EgerKi
	call	Jelol
	mov	ax,word ptr ds:[JelY]
	inc	ax
	cmp	ax,TERKEPMERETY
	jnz	OkLoc4
	mov	ax,word ptr ds:[WindowY]
	inc	ax
	cmp	ax,128-TERKEPMERETY+1
	jnz	NotProb4
	xor	ax,ax
NotProb4:
	mov	word ptr ds:[WindowY],ax
	call	Do_Terrains
	call	BigIkon
	mov	ax,TERKEPMERETY-1
OkLoc4:
	mov	word ptr ds:[JelY],ax
	call	Jelol
	call	BigIkon
	call	EgerBe
	jmp	Not_KDown
Not_KDown:
	ret
Controls	ENDP

; *******************************************************************
; ** Eg‚rkurzor kifigyel‚se, ha balgomb *****************************
; ** megnyom sa forog fenn              *****************************
; *******************************************************************
Map_X_LeftEdge	equ	TERKEPKEZD_X
Map_X_RightEdge	equ	TERKEPKEZD_X+(TERKEPMERETX*EGYKOCKA_X)-1
Map_Y_LeftEdge	equ	TERKEPKEZD_Y
Map_Y_RightEdge	equ	TERKEPKEZD_Y+(TERKEPMERETY*EGYKOCKA_Y)-1

LeftMousePressed PROC	NEAR
	call	EgerKoord
	cmp	cx,Map_X_LeftEdge
	jb	NemaTerkep
	cmp	cx,Map_X_RightEdge
	ja	NemaTerkep
	cmp	dx,Map_Y_LeftEdge
	jb	NemaTerkep
	cmp	dx,Map_Y_RightEdge
	ja	NemaTerkep
	sub	cx,TERKEPKEZD_X
	sub	dx,TERKEPKEZD_Y
	mov	ax,cx
	push	dx
	mov	cl,EGYKOCKA_X
	div	cl
	xor	ah,ah
	mov	bx,ax
	pop	ax
	mov	cl,EGYKOCKA_Y
	div	cl
	xor	ah,ah
	push	bx
	push	ax
	call	EgerKi
	call	Jelol
	pop	ax
	pop	bx
	mov	word ptr ds:[JelX],bx
	mov	word ptr ds:[JelY],ax
	call	Jelol
	call	BigIkon
	call	EgerBe
NemaTerkep:
	ret
LeftMousePressed ENDP

