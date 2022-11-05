BigIkon		PROC NEAR
		push	@data
		pop	ds
		mov	ax,word ptr ds:[WindowX]
		add	ax,word ptr ds:[JelX]
		mov	word ptr ds:[coord_memo],ax
		mov	si,10
		mov	di,610
		call	Graph_Say
		mov	ax,word ptr ds:[WindowY]
		add	ax,word ptr ds:[JelY]
		mov	word ptr ds:[coord_memo],ax
		mov	si,30
		mov	di,610
		call	Graph_Say
		ret
BigIkon		ENDP