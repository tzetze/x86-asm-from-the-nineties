DosErr		PROC NEAR
		call	StopEMS
		push	@data
		pop	ds
		mov     ah,9
                int     21h
                mov     ax,4c01h
                int     21h
DosErr		ENDP

ImportMap	PROC NEAR
		push	@data
		pop	ds
		xor	ax,ax
		mov	word ptr ds:[XPoint],ax
		mov	word ptr ds:[Ypoint],ax
		lea	dx,ImpMapFName
                mov     ax,3d00h
                int     21h			
                jnc	Hibatlan03
		lea	dx,LOADERRTXT6
		jmp	DosErr
Hibatlan03:	push	ax
		lea	dx,LOADRDYTXT6
		mov	ah,9
		int	21h		
		pop	ax
		mov	word ptr ds:[LOADHANDLE],ax
		mov	cx,2
                mov     bx,word ptr ds:[LOADHANDLE]
                lea	dx,Load_Buffer
                mov     ah,3fh			; 2 byte semmi beolvas†sa.
                int     21h			
		lea	dx,Load_Buffer
		mov	cx,4
		mov	bx,word ptr ds:[LOADHANDLE]
		mov	ah,3fh
		int	21h			; Az elsì nÇgy adat beolv.
		mov	cx,300
Jobbos:		push	cx			; kÅlsì ciklus... a 300 oszl.
		mov	cx,128			; 128 sor, fentrìl lefele...
LeFele:		push	cx
		push	@data
		pop	ds
		mov	cx,word ptr ds:[XPoint]	; ide kell nÇzzen a pointer
		mov	ax,word ptr ds:[YPoint]	
		call	PointMap		; most nÇz oda ;)
		push	@data
		pop	es
		mov	ax,word ptr es:[Load_Buffer]
		mov	byte ptr ds:[si+00],al
		mov	byte ptr ds:[si+01],ah
		xor	ax,ax
		mov	word ptr ds:[si+02],ax
		mov	word ptr ds:[si+04],ax
		mov	word ptr ds:[si+06],ax
		mov	word ptr ds:[si+08],ax
		mov	word ptr ds:[si+10],ax
		mov	word ptr ds:[si+12],ax

		; Terep megvan, jîhetnek a t†rgyak, ha vannak
		
ThruStep:	add	si,2
		mov	ax,ds
		mov	word ptr es:[POINTSEG],ax
		push	@data
		pop	ds
		lea	dx,Load_Buffer
		mov	cx,2
		mov	bx,word ptr ds:[LOADHANDLE]
		mov	ah,3fh
		int	21h
		jc	NoMoreBytes
		mov	ax,word ptr ds:[Load_Buffer]
		test	ah,80h
		jnz	EmmaTerep
		push	@data
		pop	ds
		mov	ax,word ptr es:[POINTSEG]
		mov	ds,ax
		mov	ax,word ptr es:[Load_Buffer]
		mov	ch,ah
		rol	ch,1
		and	ch,0f8h		; ch-ban csak a t†rgyt°pus
		and	ah,003h		; ah-ban csak a sorsz†m felsì 2 bitje
		or	ah,ch		; îsszemont°rozva...
		mov	word ptr ds:[si],ax
		jmp	ThruStep

Segiteske:	jmp	Lefele

EmmaTerep:	lea	dx,Load_Buffer+2
		mov	cx,2
		mov	bx,word ptr ds:[LOADHANDLE]
		mov	ah,3fh
		int	21h
		jc	NoMoreBytes
		pop	cx
		mov	ax,word ptr ds:[YPoint]
		inc	ax
		mov	word ptr ds:[YPoint],ax
		loop	Segiteske
		pop	cx
		xor	ax,ax
		mov	word ptr ds:[YPoint],ax
		mov	ax,word ptr ds:[XPoint]
		inc	ax
		mov	word ptr ds:[XPoint],ax
		mov	ah,9
		lea	dx,EzaPottyi
		int	21h
		loop	Jobbbos
		jmp	RightThen

NoMoreBytes:	pop	cx
		pop	cx
RightThen:	mov     ah,3eh			; File z†r†sa
                int     21h			
                mov     ah,0dh			; Flush
                int     21h			
		mov	ah,9
		ret

Jobbbos:	jmp	Jobbos

ImportMap	ENDP

LoadChars	PROC NEAR
		push	@data
		pop	ds
                mov     ax,3d00h
                lea     dx,CharFname
                int     21h		
                jnc     Hibatlanka
		lea	dx,LOADERRTXT4
		jmp	DosErr
Hibatlanka:	mov     bx,ax			
                mov     cx,20256
                lea     dx,HypChMatrix
                mov     ah,3fh
                int     21h		
                mov     ah,3eh
                int     21h			 
                mov     ah,0dh
                int     21h	
		mov	ah,9
		lea	dx,LOADRDYTXT4
		int	21h
		ret
LoadChars	ENDP

LoadEger	PROC NEAR
		push	@data
		pop	ds
                mov     ax,3d00h
                lea     dx,FileName2
                int     21h			; Palette file nyit†sa
                jnc     Hibatlan01
		lea	dx,LOADERRTXT3
		jmp	DosErr
Hibatlan01:	mov     bx,ax			
                mov     cx,660
                lea     dx,EgerForma1
                mov     ah,3fh
                int     21h			
                mov     ah,3eh
                int     21h			 
                mov     ah,0dh
                int     21h	
		mov	ah,9
		lea	dx,LOADRDYTXT5
		int	21h
                ret
LoadEger	ENDP

; *************************************************************
; ** A palettaadatokat tartalmaz¢ file betîltÇse a pufferbe. **
; *************************************************************
LoadPalette	PROC NEAR
		push    @data
                pop     ds
                mov     ax,3d00h
                lea     dx,FileName
                int     21h			; Palette file nyit†sa
                jnc     Hibatlan02
		lea	dx,LOADERRTXT1
		jmp	DosErr
Hibatlan02:	mov     bx,ax			; BX = handle
                mov     cx,768
                lea     dx,Paletta
                mov     ah,3fh
                int     21h			; TìttÇs :)
                mov     ah,3eh
                int     21h			; Csuk†s 
                mov     ah,0dh
                int     21h			; Flush!
		mov	ah,9
		lea	dx,LOADRDYTXT1
		int	21h
                ret
LoadPalette	ENDP

; ----------------------------------
; A teljes TÇrkÇp†llom†ny elmentÇse.
; ----------------------------------
SaveMap		PROC NEAR
		push	ds
		push	es
		push	@data
		pop	ds
		lea	dx,MapFileName
		mov	ah,3ch
		int	21h			; File nyit†sa mentÇsre
                jnc	Hibatlan04
		jmp	DosErr
Hibatlan04:	mov     bx,ax			;bx-ben a handle
		mov	word ptr ds:[SAVEHANDLE],bx
		mov	cx,128
		xor	si,si			; x koord
		xor	di,di			; y koord
Svmp1:		push	cx
                mov     cx,300
Svmp2:		push	cx
		mov	cx,si
		mov	ax,di
		push	si
		call	PointMap		; vigy†zat! DS=EMS seg.!
		mov	dx,si
		pop	si
                mov	cx,14	
                mov     ah,40h
		push	ds
		push	@data
		pop	ds
		mov	bx,word ptr ds:[SAVEHANDLE]
		pop	ds
                int     21h			; Ki°rja amit Çppen kell
		pop	cx
		inc	si
		loop	Svmp2
		pop	cx
		xor	si,si
		inc	di
		loop	Svmp1
		push	@data
		pop	ds
		mov	bx,word ptr ds:[SAVEHANDLE]
		mov     ah,3eh
                int     21h			; File z†r†sa
                mov     ah,0dh
                int     21h			; Flush!!!
		pop	es
		pop	ds
		ret
SaveMap		ENDP

ProbaLoad	PROC NEAR
		push	@data
		pop	ds
                mov     ax,3d00h
                lea     dx,ProbaName
                int     21h			; Palette file nyit†sa
		mov     bx,ax			
                mov     cx,24000
		mov	dx,0
		mov	ax,word ptr ds:[CONV_SEG3]
		mov	ds,ax
                mov     ah,3fh
                int     21h			
                mov     ah,3eh
                int     21h			 
                mov     ah,0dh
                int     21h
                ret
		push	@data
		pop	ds
ProbaLoad	ENDP



LoadTerra	PROC NEAR
		push	@data
		pop	ds
                mov     ax,3d00h
                lea     dx,TerrFName
                int     21h			; Palette file nyit†sa
                jnc     Hibatlan10
		lea	dx,LOADERRTXT2
		jmp	DosErr
Hibatlan10:	mov     bx,ax			
                mov     cx,24000
		mov	dx,0
		mov	ax,word ptr ds:[CONV_SEG1]
		mov	ds,ax
                mov     ah,3fh
                int     21h			
                mov     ah,3eh
                int     21h			 
                mov     ah,0dh
                int     21h
		push	@data
		pop	ds
		mov	ah,9
		lea	dx,LOADRDYTXT2
		int	21h
                ret
LoadTerra	ENDP

LoadItems	PROC NEAR
	push	@data
	pop	ds
	mov	ax,3d00h
	lea	dx,ItemFName
	int	21h			; Palette file nyit†sa
	jnc	Hibatlan11
	lea	dx,LOADERRTXT3
	jmp	DosErr
Hibatlan11	LABEL	NEAR
	mov     bx,ax			
	mov     cx,9900
	mov	dx,24000
	mov	ax,word ptr ds:[CONV_SEG1]
	mov	ds,ax
	mov	ah,3fh
	int	21h			
	mov	ah,3eh
	int	21h			 
	mov	ah,0dh
	int	21h
	push	@data
	pop	ds			
	mov	ah,9
	lea	dx,LOADRDYTXT3
	int	21h
	ret
LoadItems	ENDP

SaveMemo:
		push	@data
		pop	ds
		mov	dx,offset MemoFileName
		xor 	cx,cx
		mov	ah,3ch
		int	21h			
		mov     bx,ax			
		mov	cx,256
		mov	ah,40h
		mov	dx,offset RowDatas
                int     21h			
		mov     ah,3eh
                int     21h			
                mov     ah,0dh
                int     21h			
		ret

