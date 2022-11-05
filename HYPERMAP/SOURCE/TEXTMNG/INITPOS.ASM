;******************************************************************
;** TextXPos,TextYPos poz¡c¡¢ra  ll¡tja a kurzort *****************
;******************************************************************
InitPos PROC NEAR	
	push	@data
	pop	ds
	mov	ax,word ptr ds:[TextYPos]
	mov	dx,SCR_WIDTH
	mul	dx
	add	ax,word ptr ds:[TextXPos]
	adc	dx,0
	mov     word ptr ds:[ChPutAddr],ax
	mov     word ptr ds:[ChPutBank],dx
	ret
InitPos ENDP