ConvMemAlloc	PROC NEAR
	push    @data
	pop     ds
	mov	ax,word ptr ds:[PSP_Address]
	mov	es,ax
	mov	ah,4ah
	mov	bx,4000h
	int	21h
	mov	ah,48h
	mov	bx,1000h
	int	21h
	jc	HibaFoglal
	mov	word ptr ds:[CONV_SEG1],ax
	mov	ah,48h
	mov	bx,1000h
	int	21h
	jc	HibaFoglal
	mov	word ptr ds:[CONV_SEG2],ax
	mov	ah,48h
	mov	bx,1000h
	int	21h
	jc	HibaFoglal
	mov	word ptr ds:[CONV_SEG3],ax
	ret
HibaFoglal	LABEL NEAR
	mov	ax,4c00h
	int	21h	
	ret
ConvMemAlloc	ENDP

 

