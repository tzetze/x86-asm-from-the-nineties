InitSaverTime:	push	@data
		pop	ds
		mov	word ptr ds:[DownCounter],5
		ret