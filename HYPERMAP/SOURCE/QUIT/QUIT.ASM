Quit2Dos:	call	StopEMS
		mov	ax,03h
		int	10h
		mov	ax,4c00h
		int	21h
