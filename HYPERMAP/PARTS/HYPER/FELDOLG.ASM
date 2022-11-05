Feldolg:	; *************************************************
		; ** Inicializ l sa a dolgoknak rendj‚n ugye ******
		; *************************************************
		lea	bx,ProbaTXT
		call	WordSeek		; BX most t‚nyleg az 1. karakterre mutat
		lea	di,RowDatas		; T bl zat, a sorok adatair¢l
		mov	word ptr ds:[SzoEleje],bx	; akt. sz¢ c¡me
		mov	word ptr ds:[Soreleje],bx
SorEmeles:	xor	ax,ax
		mov	word ptr ds:[Szavak],ax
		mov	word ptr ds:[Szelesseg],ax
		mov	word ptr ds:[EddigSzeles],ax
		; *************************************************
		; ** Annak vizsg lata, nincs-e itt a v‚g... *******
		; *************************************************
BeolvasBetut:	mov	ax,word ptr ds:[bx]		
		cmp	ax,(35*256)+35		; ## eset‚n end of document...
		jnz	NemSzovegVege
		jmp	SzovegVege
		; *************************************************
		; ** Akkor j”het a GET_CHAR ***********************
		; *************************************************
NemSzovegvege:
		mov	al,byte ptr ds:[bx]
		call	SzovegeE
		jc	EzSzpesz
		; *************************************************
		; ** Innen j”n tov bb, ha leg lis karakter volt ***
		; *************************************************
		push	bx
		lea	bx,SzMatrix
		xlat
		pop	bx
		xor	ah,ah
		add	word ptr ds:[Szelesseg],ax
		mov	ax,word ptr ds:[Szelesseg]
		cmp	ax,SORHOSSZA
		jg	KilogABetu
		; *************************************************
		; ** Ha nem l¢g ki a bet–... **********************
		; *************************************************
		inc	bx
		jmp	BeolvasBetut
KilogABetu:	; *************************************************
		; ** Ha kil¢g a bet–, az eg‚sz sz¢ ugrott *********
		; *************************************************
		mov	ax,word ptr ds:[SorEleje]
		mov	word ptr ds:[di],ax
		mov	ax,word ptr ds:[Szavak]
		mov	byte ptr ds:[di+2],al
		dec	ax				; ennyi sz¢k”z van.
		mov	dx,SORHOSSZA
		sub	dx,word ptr ds:[EddigSzeles]
		mov	ah,SPACEMERET
		mul	ah
		add	dx,ax
		mov	byte ptr ds:[di+3],dl
		add	di,4
		mov	bx,word ptr ds:[Szoeleje]
		mov	ax,word ptr ds:[Szoeleje]
		mov	word ptr ds:[Soreleje],ax
		jmp	SorEmeles
EzSzpesz:	; *************************************************
		; ** Ha SPACE-t vagy olyasmit tal lt, idej”n ******
		; *************************************************
		mov	ax,word ptr ds:[Szelesseg]
		mov	word ptr ds:[EddigSzeles],ax
		add	ax,SPACEMERET
		mov	word ptr ds:[Szelesseg],ax
		cmp	ax,SORHOSSZA
		jg	KilogASpace
		; *************************************************
		; ** Ez most az a r‚sz, amikor nem l¢g  ***********
		; ** ki a SPACE, mehet minden tov bb... ***********
		; *************************************************
		call	WordSeek
		inc	word ptr ds:[Szavak]
		mov	word ptr ds:[SzoEleje],bx
		jmp	BeolvasBetut
KilogASpace:	; *************************************************
		; ** Ha a SPACE kil¢g, az £jsor *******************
		; ** kezd‚st id‚z el“ ugye ja.  *******************
		; *************************************************
		call	WordSeek
		inc	word ptr ds:[Szavak]
		mov	ax,word ptr ds:[SorEleje]
		mov	word ptr ds:[di],ax
		mov	ax,word ptr ds:[Szavak]
		mov	byte ptr ds:[di+2],al
		dec	ax
		mov	dx,SORHOSSZA
		sub	dx,word ptr ds:[EddigSzeles]
		mov	ah,SPACEMERET
		mul	ah
		add	dx,ax
		mov	byte ptr ds:[di+3],dl
		add	di,4
		mov	word ptr ds:[SzoEleje],bx
		mov	word ptr ds:[Soreleje],bx
		jmp	SorEmeles
SzovegVege:	; *************************************************
		; ** Ha megvolt a ##, ide j”n a vez‚rl‚s... :) ****
		; *************************************************
		mov	ax,word ptr ds:[SorEleje]
		mov	word ptr ds:[di],ax
		mov	ax,word ptr ds:[Szavak]
		mov	byte ptr ds:[di+2],al
		dec	ax
		mov	dx,SORHOSSZA
		sub	dx,word ptr ds:[EddigSzeles]
		mov	ah,SPACEMERET
		mul	ah
		add	dx,ax
		mov	byte ptr ds:[di+3],dl
		ret