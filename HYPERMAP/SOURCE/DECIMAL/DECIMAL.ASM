; *******************************************************************
; ** Az AX-ben kapott param?tert decim?lis   ************************
; ** sz?mm? alak?tja, DEC_BUFFER-ben t?rolja ************************
; *******************************************************************
; ** Ez itten null?kat el?tev? verzi? *******************************
; *******************************************************************
SayDec_0	PROC NEAR
		call	Conv_AX
		lea	bx,DEC_BUFFER
		mov	cx,5
Loc1:		mov	al,byte ptr ds:[bx]
		add	al,"0"
		mov	byte ptr ds:[bx],al
		inc	bx
		loop	Loc1
		call	Say_All
		ret
SayDec_0	ENDP
; *******************************************************************
; ** Ez meg nem tesz el? semmit, csak jobbra igaz?tja ***************
; *******************************************************************
SayDec		PROC NEAR
		call	Conv_AX
		lea	bx,DEC_BUFFER
		xor	ax,ax
		mov	cx,4
Loc2:		add	al,byte ptr ds:[bx]
		jnz	Loc3
		mov	byte ptr ds:[bx]," "
		inc	bx
		loop	Loc2
		mov	al,byte ptr ds:[bx]
		add	al,"0"
		mov	byte ptr ds:[bx],al
		jmp	Loc5
Loc3:		inc	cx
Loc4:		mov	al,byte ptr ds:[bx]
		add	al,"0"
		mov	byte ptr ds:[bx],al
		inc	bx
		loop	Loc4
Loc5:		call	Say_All
		ret
SayDec		ENDP
; *******************************************************************
; ** Ez a rutin kell mindkett?h?z ***********************************
; *******************************************************************
Conv_AX		PROC NEAR
		push	@data
		pop	ds
		mov	bx,ax
		mov	cx,10000
		xor	dx,dx
		div	cx
		xor	ah,ah
		mov	byte ptr ds:[DEC_BUFFER],al
		mul	cx
		sub	bx,ax
		mov	ax,bx
		mov	cx,1000
		div	cx
		xor	ah,ah
		mov	byte ptr ds:[DEC_BUFFER+1],al
		mul	cx
		sub	bx,ax
		mov	ax,bx
		mov	cx,100
		div	cx
		xor	ah,ah
		mov	byte ptr ds:[DEC_BUFFER+2],al
		mul	cx
		sub	bx,ax
		mov	ax,bx		
		mov	cx,10
		div	cx
		xor	ah,ah
		mov	byte ptr ds:[DEC_BUFFER+3],al
		mul	cx
		sub	bx,ax
		mov	byte ptr ds:[DEC_BUFFER+4],bl
		ret
Conv_AX		ENDP
; *******************************************************************
; ** Ez a 'rutin' v?gzi a t?nyleges ki?rat?st text m?dban ***********
; *******************************************************************
Say_All		PROC NEAR
		mov	ah,9
		lea	dx,DEC_BUFFER
		int	21h
		ret
Say_All		ENDP
; ********************************************************************
; ** Grafikus k?perny?n ki?r egy 3 jegy? sz?mot X,Y koordin?t?ra *****
; ** Adatok: * [cord_memo] - a sz?m maga                         *****
; **         * SI          - X koordin?ta                        *****
; **         * DI          - Y koordin?ta                        *****
; ********************************************************************
Graph_Say	PROC NEAR
		push	@data
		pop	ds				; mexok?sb?l...
		mov	ax,word ptr ds:[coord_memo]	; most k?sz?l a dec.
		call	Conv_AX				; konverzi?

		add	si,10				; utols? szjegy poz.
		mov	al,byte ptr ds:[DEC_BUFFER+4]	; utols? szjegy ?rt.
		xor	ah,ah				; ax := al
		mov	word ptr ds:[hanyas],ax		
		mov	ax,di
		mov	bx,si
		call	DrawNumba			; uccs? szjegy ki?rva.

		sub	si,10				; vissza az els?re
		mov	al,byte ptr ds:[DEC_BUFFER+2]	; ugyancsak
		cmp	al,0				; 0?
		jz	KetJegyMax

		; innen j?n az, hogy ki?rja a m?sik kett?t is alapban.
		; mert nem 0 az els? sz?mjegy.
		xor	ah,ah				; ax = al
		mov	word ptr ds:[hanyas],ax		
		mov	ax,di
		mov	bx,si
		call	DrawNumba			; kirakva az els? is
		add	si,5
		mov	al,byte ptr ds:[DEC_BUFFER+3]
		xor	ah,ah
		mov	word ptr ds:[hanyas],ax
		mov	ax,di
		mov	bx,si
		call	DrawNumba
		jmp	NeTovabb
KetJegyMax:	mov	ax,10
		mov	word ptr ds:[hanyas],ax
		mov	ax,di
		mov	bx,si
		call	DrawNumba
		add	si,5
		mov	al,byte ptr ds:[DEC_BUFFER+3]
		cmp	al,0
		jz	TovabbSe
		xor	ah,ah
		mov	word ptr ds:[hanyas],ax
		mov	ax,di
		mov	bx,si
		call	DrawNumba
		jmp	NeTovabb
TovabbSe:	mov	ax,10
		mov	word ptr ds:[hanyas],ax
		mov	ax,di
		mov	bx,si
		call	DrawNumba
NeTovabb:	ret
Graph_Say	ENDP

Say_Coords	PROC NEAR
		push	@data
		pop	ds
		mov	di,TERKEPKEZD_Y - 15	; fels? vsz. sor magass?ga
		mov	si,TERKEPKEZD_X + 13	; bal koordin?ta az els?nek
		mov	ax,word ptr ds:[WindowX]
		mov	word ptr ds:[coord_memo],ax
		mov	cx,TERKEPMERETX
Next_X:		push	cx
		push	si
		push	di
		call	Graph_Say
		pop	di
		pop	si
		push	si
		push	di
		add	di,TERKEPMERETY * EGYKOCKA_Y + 24
		call	Graph_Say
		pop	di
		pop	si
		pop	cx
		mov	ax,word ptr ds:[coord_memo]
		inc	ax
		mov	word ptr ds:[coord_memo],ax
		add	si,EGYKOCKA_X
		loop	Next_X
		mov	di,TERKEPKEZD_Y + 17	; f?gg. oszlop els? sz?ma y
		mov	si,TERKEPKEZD_X - 19	; ez meg az X
		mov	ax,word ptr ds:[WindowY]
		mov	word ptr ds:[coord_memo],ax
		mov	cx,TERKEPMERETY
Next_Y:		push	cx
		push	si
		push	di
		call	Graph_Say
		pop	di
		pop	si
		push	si
		push	di
		add	si,TERKEPMERETX * EGYKOCKA_X + 25
		call	Graph_Say
		pop	di
		pop	si
		pop	cx
		mov	ax,word ptr ds:[coord_memo]
		inc	ax
		mov	word ptr ds:[coord_memo],ax
		add	di,EGYKOCKA_Y
		loop	Next_Y
		ret
Say_Coords	ENDP

