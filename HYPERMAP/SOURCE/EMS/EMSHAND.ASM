;***********************************************;
;** EMS jelenl?tileg megvan?s?nak kifigyel?se **;
;***********************************************;
Detect_EMS	PROC NEAR
		xor	ax,ax
		mov	si,ax
		mov	es,ax
		mov	word ptr ds:[MAP_HANDLE],ax
		mov	ax,word ptr es:[4*67h+2]
		mov	es,ax
		cmp	word ptr es:[10],"ME"
		jne	short NotEMSPresent
		cmp	word ptr es:[12],"XM"
		jne	short NotEmsPresent
		cmp	word ptr es:[14],"XX"
		jne	short NotEMSPresent
		cmp	word ptr es:[16],"0X"
		jne	short NotEMSPresent
		push	@data
		pop	ds
		mov	ah,9
		lea	dx,EMS_RDYTXT1
		int	21h
		ret
NotEMSPresent:	
		mov	ah,9
		lea	dx,EMS_ERRTXT1
		int	21h
		mov	ax,4c01h
		int	21h
Detect_EMS	ENDP

;************************************************************
;** EMS mem?ria mennyis?g?nek megfelel?s?gi fel?lb?r?l?sa **;
;************************************************************
HowMany_EMS	PROC NEAR
		push	@data
		pop	ds
		mov	ah,9
		lea	dx,EMS_SZOVEG1
		int	21h
		mov	ah,42h
		int	67h		
		mov	ax,bx			; ax-ben a rendelkez?sre
						; ?ll? EMS lapok sz?ma
		mov	cx,16			; 16-al szorozva pedig
		mul	cx			; a szabad ter?let Kbyte-ban
		push	ax
		call	SAYDEC			; Ki?ratva...
		mov	ah,9
		lea	dx,KILOBYTETXT
		int	21h
		mov	ah,9
		lea	dx,EMS_SZOVEG2
		int	21h
		mov	ax,MEMORYNEEDED		
		call	SAYDEC			; Ennyi kell...
		pop	ax
		cmp	ax,MEMORYNEEDED
		jb	KevesEMS
		mov	ah,9
		lea	dx,OKTXT
		int	21h
		ret
KevesEMS:	
		lea	dx,KEVESTXT
Outta		LABEL NEAR		
		call	StopEMS
		push	@data
		pop	ds
		mov	ah,9
		int	21h
		mov	ax,4c01h
		int	21h
HowMany_EMS	ENDP
;***********************************;
;** EMS kezel? ind?t?sos bel?v?se **;
;***********************************;
StartEMS	PROC	NEAR
		push	ds
		push	es
		
		push	@data
		pop	ds
		mov	ah,43h
		mov	bx,MAXMAPLAP
		int	67h
		or	ah,ah
		jz	Ems_AllocOK
		lea	dx,ALLOCERROR
		jmp	Outta
EMS_AllocOK:	
		mov	word ptr ds:[MAP_HANDLE],dx
		mov	ah,41h		; Hol van az EMS-frame szegmensc?me?
		int	67h
		or	ah,ah
		jz	Ems_FindOK
		lea	dx,EMSEGERROR
		jmp	Outta		
Ems_FindOK:	
		mov	word ptr ds:[EMS_FRAMESEG],bx
		pop	es
		pop	ds
		ret
StartEMS	ENDP
;*****************************************;
;** EMS le?ll?t?sa, mernemk?llm?rs?gb?l **;
;*****************************************;
StopEMS		PROC NEAR
		pusha
		mov	ah,45h
		mov	dx,word ptr ds:[MAP_HANDLE]
		int	67h
		popa
		ret
StopEMS		ENDP
;**************************************************************************;
;** MAPLAP : Azaz  a megadott sz?m? EMS lapot meg ami m?g ut?na j?n, azt **;
;**          belapozza. Eg?szen 4 lapot, vagy MaxMapLap-ig               **;
;**          AX-ben k?ri a kezd?lap sz?m?t.                              **;
;**************************************************************************;
MapLap		PROC NEAR
		cmp	ax,32			; Ez m?r sok lenne.
		jng	Lapozhato
		lea	dx,LAPOZERROR		; T?ll?v?s volt... hiba!
		jmp	Outta
Lapozhato:	
		mov	bx,ax			; BX = kezd? lap sz?ma
		mov	ax,4400h		
		mov	dx,word ptr ds:[MAP_HANDLE]
		push	bx
		int	67h			; Els? lap belapoz?sa
		pop	bx
		inc	bx			; k?v lap sz?ma...
		cmp	bx,32			; 32-n?l ha nagyobb,
						; kiugrik
		jg	LapozVeg

		mov	ax,4401h		
		mov	dx,word ptr ds:[MAP_HANDLE]
		push	bx
		int 	67h
		pop	bx
		inc 	bx
		cmp	bx,32
		jg	LapozVeg

		mov	ax,4402h
		mov	dx,word ptr ds:[MAP_HANDLE]
		push	bx
		int 	67h
		pop	bx
		inc	bx
		cmp	bx,32
		jg	LapozVeg

		mov	ax,4403h
		mov	dx,word ptr ds:[MAP_HANDLE]
		int 	67h
LapozVeg:	
		ret
MapLap		ENDP

;----------------------------------------------------------------------- 
; A megadott koordin?t?k alapj?n (CX=x,Ax=y) kisz?molja a c?met, ahol
; a 14 darab byte kezd?dik, ?s belapozza a megfelel? EMS lapot is.
; a c?m SI-be ker?l, amit DS-el kell kombin?lni, ezt szint?n be?ll?tja.
;----------------------------------------------------------------------- 
PointMap	PROC NEAR
		push 	@data
		pop	ds
		mov	bx,300
		mul	bx
		add	ax,cx
		mov	bx,14
		mul	bx		; Itt megvan DX:AX-ben a c?m
		mov	si,ax
		and	si,3fffh	; 0-3fffh-ig terjedhet, hogy
					; az els? 4K-s lapra mutasson.
					; vagyis ez lesz a c?m az els?
					; 4K lapon bel?l.
		push	si
		mov	al,ah		; AL-be ker?l AX k?t fels? bitje
		mov	cx,6		; DL als? hat bitj?b?l lesz AL fels?
					; 6 bijte, a fels?k meg lecs?sznak
					; a 0. ?s els? bitekbe, ?gy AL-be
					; ker?l, hogy melyik az 1. EMS lap.
KovBit:		
		sar	dl,1		; ?tpakol?s a CARRY biten
		rcr	al,1 		; kereszt?l...
		loop	KovBit
		xor	ah,ah		; AX=AL :)
		cmp	ax,word ptr ds:[EMS_STRT]
		jz	UgyanazLenne

		call	MapLap

UgyanazLenne:	
		mov	ax,word ptr ds:[EMS_FRAMESEG]
		mov	ds,ax
		pop	si
		ret			; k?sz. Belapozva, ?s DS:SI-ben 
					; mutatva.
PointMap	ENDP

