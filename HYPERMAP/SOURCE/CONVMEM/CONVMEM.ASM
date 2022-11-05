ConvMemAlloc	PROC NEAR
	push    @data
	pop     ds
	mov	ah,9
	lea	dx,CONVMEMTXT1
	int	21h
	mov	ax,word ptr ds:[PSP_Address]
	mov	es,ax
	mov     ah,4ah
	mov	bx,0ffffh
	int     21h		; BX-ben van, hogy mennyi konvenc.
	mov	ax,bx		; mem. van / 16 byteban 
	mov	bl,64
	shr	ax,6		; AX= konvmem kbyteban
	push	ax
	call	SAYDEC
	mov	ah,9
	lea	dx,KILOBYTETXT
	int	21h
	mov	ah,9
	lea	dx,CONVMEMTXT2
	int	21h
	mov	ax,CONVMEMNEEDED
	call	SAYDEC
	pop	ax
	cmp	ax,CONVMEMNEEDED
	jng	KevesLeszEz
	mov	ah,9
	lea	dx,OKTXT
	int	21h
	mov	ah,4ah
	mov	bx,4000h
	int	21h
	mov	ah,48h
	mov	bx,1000h
	int	21h
	jc	HibaFoglal
	mov	word ptr ds:[CONV_SEG1],ax
;	mov	ah,48h
;	mov	bx,1000h
;	int	21h
;	jc	HibaFoglal
;	mov	word ptr ds:[CONV_SEG2],ax
	mov	ah,48h
	mov	bx,1000h
	int	21h
	jc	HibaFoglal
	mov	word ptr ds:[CONV_SEG3],ax
	mov	ah,48h
	mov	bx,1000h
	int	21h
	jc	HibaFoglal
	mov	word ptr ds:[CONV_SEG4],ax
	ret
HibaFoglal	LABEL NEAR
call	SAYDEC
	mov	ah,9
	lea	dx,CONVERROR
	int	21h
	mov	ax,4c00h
	int	21h	
	ret
KevesLeszez	LABEL NEAR
	mov	ah,9
	lea	dx,KEVESCONVMEM
	int	21h
	mov	ax,4c00h
	int	21h	
	ret
ConvMemAlloc	ENDP

StorePSP	PROC NEAR
	push	@data
	pop	ds
	mov	ax,es 
	mov	word ptr ds:[PSP_Address],ax
	ret
StorePSP	ENDP
 

