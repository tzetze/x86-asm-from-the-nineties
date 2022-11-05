CoordBoxes	PROC NEAR	
		push	@data
		pop	ds
		mov	ax,TERKEPKEZD_Y - 15	; felsì vsz. sor magass†ga
		mov	bx,TERKEPKEZD_X + 13	; bal koordin†ta az elsìnek
		mov	cx,TERKEPMERETX
KovetkX:	push	cx
		push	ax
		push	bx
		call	Box_Putter
		pop	bx
		pop	ax
		push	ax
		push	bx
		add	ax,TERKEPMERETY * EGYKOCKA_Y + 24
		call	Box_Putter
		pop	bx
		pop	ax
		pop	cx
		add	bx,EGYKOCKA_X
		loop	KovetkX
		mov	ax,TERKEPKEZD_Y + 17	; fÅgg. oszlop elsì sz†ma y
		mov	bx,TERKEPKEZD_X - 19	; ez meg az X
		mov	cx,TERKEPMERETY
KovetkY:	push	cx
		push	ax
		push	bx
		call	Box_Putter
		pop	bx
		pop	ax
		push	ax
		push	bx
		add	bx,TERKEPMERETX * EGYKOCKA_X + 25
		call	Box_Putter
		pop	bx
		pop	ax
		pop	cx
		add	ax,EGYKOCKA_Y
		loop	KovetkY
		ret

Box_Putter:     sub     ax,3
                sub     bx,3
                mov     dx,SCR_WIDTH
                mul     dx
                add     ax,bx
                adc     dx,0
                mov     di,ax
                mov     ax,dx
                mov     word ptr ds:[act_bank],ax
                call    BankSwitch
		mov	ax,24*256+24
		mov	cx,10
		rep	stosw
		add	di,scr_width-20
		jnc	Rendbenes1
		call	SwapUp
Rendbenes1:	mov     cx,11
Pongi:		push    cx
		  mov	al,24
		  stosb
		  mov	cx,9
		  mov	ax,0
		  rep	stosw
		  mov	al,28
		  stosb
                  add   di,scr_width-20
                  jnc	Rendbenes2
		  call	SwapUp
Rendbenes2:     pop     cx
                loop    Pongi
		mov	ax,28*256+28
		mov	cx,10
		rep	stosw
		ret
CoordBoxes	ENDP
