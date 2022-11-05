.286
.MODEL LARGE
.STACK
.DATA
		include data.asm
.CODE		
		push	@data			; DS = dataseg.
		pop	ds
		call	LoadEger
		call	SaveEger
		mov	ax,4c00h
		int	21h

		include	loadeger.asm
		include	saveeger.asm

END