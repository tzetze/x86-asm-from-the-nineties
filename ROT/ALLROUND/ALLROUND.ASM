.286
.model small

BMP_WDTH	equ	132
BMP_HGTH	equ	130

MODIFY1		equ	POINT_1+1
MODIFY2		equ	POINT_2+2
MODIFY3		equ	POINT_3+1
MODIFY4		equ	POINT_4+2

.stack
.data
FILENAME	db	'ADDIN.BMP',0
FILENAME2	db	'SINE.TAB',0
ERRORMSG 	db	'GRAB5.BMP??? Hol van?$',0
ERRORMSG2	db	'No Çs a SINE.TAB nÇlkÅl mihez kezdjek?! $',0

.code		
		push	@data
		pop	ds
		push	0a000h
		pop	es

		call	LOADDATA

		mov	ax,13h
		int	10h
		push	8000h
		pop	ds
		call	PUTPAL
		call	SORTDTA
		call	LOADDATA2

		mov	cx,2880
		mov	bx,0
		mov	si,360
NXTFRAME:	push	bx
		push	cx
		push	si
		call 	SETUP_ROT
		mov	dx,3dah
VR:		in	al,dx
		and	al,8
		jz	VR
		call	ROT8
                call	KEYZ
		pop	si
		pop	cx
		pop	bx
		add	bx,2
		loop	NXTFRAME

CLOSE:		call	KEYZ
		jmp	CLOSE
		jmp	QUIT2DOS

SETUP_ROT:	cmp	bx,1440
		jl	BOUNDED
		sub	bx,1440
		jmp	SETUP_ROT
BOUNDED:	add	bx,2000h
		cmp	bx,2000h+359
		jg	QUADRAT2

QUADRAT1:	mov	ax,word ptr ds:[bx]
		mov	dx,word ptr ds:[bx+si]
		mov	word ptr cs:[MODIFY2],ax		; sinuses
		mov	word ptr cs:[MODIFY3],ax	
		mov	ax,dx
		mov	word ptr cs:[MODIFY1],ax		; cosinuses
		mov	word ptr cs:[MODIFY4],ax	
		mov	al,0D6h
		mov	byte ptr cs:[DEST_SI_I+1],al
		mov	ax,0084h
		mov	word ptr cs:[BOUN_SI_I+2],ax
		mov	ax,0
		mov	word ptr cs:[RESE_SI_I+1],ax
		mov	al,0C5h
		mov	byte ptr cs:[DEST_BP_I+1],al
		mov	byte ptr cs:[DEST_BP_O+1],al
		mov	ax,0C308h
		mov	word ptr cs:[BOUN_BP_I+2],ax
		mov	word ptr cs:[BOUN_BP_O+2],ax
		mov	ax,08000h
		mov	word ptr cs:[RESE_BP_I+1],ax
		mov	word ptr cs:[RESE_BP_O+1],ax
		mov	al,0DEh					
		mov	byte ptr cs:[DEST_SI_O+1],al
		mov	ax,0FFFFh
		mov	word ptr cs:[BOUN_SI_O+2],ax
		mov	ax,0083h
		mov	word ptr cs:[RESE_SI_O+1],ax
		jmp	OK_QUADS

QUADRAT2:	cmp	bx,2000h+719
		jg 	QUADRAT3
		sub	bx,360
		mov	ax,word ptr ds:[bx]
		mov	dx,word ptr ds:[bx+si]
		mov	word ptr cs:[MODIFY1],ax		; sinuses
		mov	word ptr cs:[MODIFY4],ax	
		mov	ax,dx
		mov	word ptr cs:[MODIFY2],ax		; cosinuses
		mov	word ptr cs:[MODIFY3],ax	
		mov	al,0DEh
		mov	byte ptr cs:[DEST_SI_I+1],al
		mov	byte ptr cs:[DEST_SI_O+1],al
		mov	ax,0FFFFh
		mov	word ptr cs:[BOUN_SI_I+2],ax
		mov	word ptr cs:[BOUN_SI_O+2],ax
		mov	ax,0083h
		mov	word ptr cs:[RESE_SI_I+1],ax
		mov	word ptr cs:[RESE_SI_O+1],ax
		mov	al,0C5h
		mov	byte ptr cs:[DEST_BP_I+1],al
		mov	ax,0C308h
		mov	word ptr cs:[BOUN_BP_I+2],ax
		mov	ax,08000h
		mov	word ptr cs:[RESE_BP_I+1],ax
		mov	al,0EDh
		mov	byte ptr cs:[DEST_BP_O+1],al
		mov	ax,07F7Ch
		mov	word ptr cs:[BOUN_BP_O+2],ax
		mov	ax,0C284h
		mov	word ptr cs:[RESE_BP_O+1],ax
		jmp	OK_QUADS

QUADRAT3:	cmp	bx,2000h+1079
		jg	QUADRAT4
		sub	bx,720
		mov	ax,word ptr ds:[bx]
		mov	dx,word ptr ds:[bx+si]

		add	ax,dx

		mov	word ptr cs:[MODIFY2],ax		; sinuses
		mov	word ptr cs:[MODIFY3],ax	
		mov	ax,dx
		mov	word ptr cs:[MODIFY1],ax		; cosinuses
		mov	word ptr cs:[MODIFY4],ax
		mov	al,0DEh					
		mov	byte ptr cs:[DEST_SI_I+1],al
		mov	ax,0FFFFh
		mov	word ptr cs:[BOUN_SI_I+2],ax
		mov	ax,0083h
		mov	word ptr cs:[RESE_SI_I+1],ax
		mov	al,0EDh
		mov	byte ptr cs:[DEST_BP_I+1],al
		mov	byte ptr cs:[DEST_BP_O+1],al
		mov	ax,07F7Ch
		mov	word ptr cs:[BOUN_BP_I+2],ax
		mov	word ptr cs:[BOUN_BP_O+2],ax
		mov	ax,0C284h
		mov	word ptr cs:[RESE_BP_I+1],ax
		mov	word ptr cs:[RESE_BP_O+1],ax
		mov	al,0D6h					
		mov	byte ptr cs:[DEST_SI_O+1],al
		mov	ax,0084h
		mov	word ptr cs:[BOUN_SI_O+2],ax
		mov	ax,0
		mov	word ptr cs:[RESE_SI_O+1],ax
		jmp	OK_QUADS

QUADRAT4:	sub	bx,1080
		mov	ax,word ptr ds:[bx]
		mov	dx,word ptr ds:[bx+si]
		mov	word ptr cs:[MODIFY1],ax		; sinuses
		mov	word ptr cs:[MODIFY4],ax	
		mov	ax,dx
		mov	word ptr cs:[MODIFY2],ax		; cosinuses
		mov	word ptr cs:[MODIFY3],ax	
		mov	al,0D6h
		mov	byte ptr cs:[DEST_SI_I+1],al
		mov	byte ptr cs:[DEST_SI_O+1],al
		mov	ax,0084h
		mov	word ptr cs:[BOUN_SI_I+2],ax
		mov	word ptr cs:[BOUN_SI_O+2],ax
		mov	ax,0000h
		mov	word ptr cs:[RESE_SI_I+1],ax
		mov	word ptr cs:[RESE_SI_O+1],ax
		mov	al,0EDh
		mov	byte ptr cs:[DEST_BP_I+1],al
		mov	ax,07F7Ch
		mov	word ptr cs:[BOUN_BP_I+2],ax
		mov	ax,0C284h
		mov	word ptr cs:[RESE_BP_I+1],ax
		mov	al,0C5h
		mov	byte ptr cs:[DEST_BP_O+1],al
		mov	ax,0C308h
		mov	word ptr cs:[BOUN_BP_O+2],ax
		mov	ax,08000h
		mov	word ptr cs:[RESE_BP_O+1],ax
		jmp	OK_QUADS

OK_QUADS:
		ret


ROT8:		cli
		mov	cx,200
		mov	di,0
		mov	bp,8000h
		mov	si,0
		push	8000h
		pop	ds
LOC8:		push	cx
		push	bx
		push	ax
		push	bp
		push	si
		mov	ax,8000h
		mov	bx,8000h
		mov	cx,320
LOC:		mov	dl,byte ptr ds:[bp+si]
		mov	byte ptr es:[di],dl
		inc	di
POINT_1:	add	ax,08000h
DEST_SI_I:	adc	si,0
BOUN_SI_I:	cmp	si,BMP_WDTH
		jne	POINT_2
RESE_SI_I:	mov	si,0
POINT_2:	add	bx,0ddb0h
		jnc	RIGHT3
DEST_BP_I:	add	bp,BMP_WDTH
BOUN_BP_I:	cmp	bp,8000h+BMP_WDTH*BMP_HGTH
		jne	RIGHT3
RESE_BP_I:	mov	bp,8000h
RIGHT3:		loop	LOC
RIGHT7:		pop	si
		pop	bp
		pop	ax
		pop	bx
		pop	cx
POINT_3:	add	ax,0ddb0h
DEST_SI_O:	sbb	si,0
BOUN_SI_O:	cmp	si,word ptr -1
		jne	POINT_4
RESE_SI_O:	mov	si,BMP_WDTH-1
POINT_4:	add	bx,08000h
		jnc	RIGHT5
DEST_BP_O:	add	bp,BMP_WDTH
BOUN_BP_O:	cmp	bp,8000h+BMP_WDTH*BMP_HGTH
		jne	RIGHT5
RESE_BP_O:	mov	bp,8000h
RIGHT5:
		loop	LOC8
		sti
		ret



KEYZ:		mov	ah,1
		int 	16h
		jnz	ISESC
		ret
ISESC:		xor	ah,ah
		int 	16h
		cmp	al,1bh
		jne	NOESC
		jmp	QUIT2DOS
NOESC:		ret

SORTDTA:	mov	si,1078+BMP_WDTH*(BMP_HGTH-1)
		mov	di,8000h
		mov	cx,BMP_HGTH
NXTLN:		push	cx
		mov	cx,66
NXTPXL:		mov	dx,word ptr ds:[si]
		mov	word ptr ds:[di],dx
		add	si,2
		add	di,2
		loop	NXTPXL
		sub	si,264
		pop	cx
		loop	NXTLN		
		ret		

QUIT2DOS:	mov	ax,03h
		int	10h
		mov	ax,4c00h
		int	21h



PUTPAL:		mov	bx,56
		mov 	al,0
		mov 	dx,03c8h
		out	dx,al
		mov 	cx,256
		mov 	dx,03c9h
LOOP_LOC:	mov	al,ds:[bx]
		shr	al,2
		out	dx,al
		dec	bx
		mov	al,ds:[bx]
		shr	al,2
		out	dx,al
		dec	bx
		mov 	al,ds:[bx]
		shr	al,2
		out	dx,al
		add	bx,6
		loop	LOOP_LOC
		ret

LOADDATA:	mov	ax,3d00h
		lea	dx,FILENAME
		int	21h
		jc	DOSERROR
		push	ds
		push	8000h
		pop	ds
		mov	bx,ax
		mov	cx,18238
		mov	dx,0
		mov	ah,3fh
		int	21h
		mov	ah,3eh
		int	21h
		mov	ah,0dh
		int	21h
		pop	ds
		ret

LOADDATA2:	push	@data
		pop	ds
		mov	ax,3d00h
		lea	dx,FILENAME2
		int	21h
		jc	DOSERROR2
		push	8000h
		pop	ds
		mov	bx,ax
		mov	cx,720
		mov	dx,2000h
		mov	ah,3fh
		int	21h
		mov	ah,3eh
		int	21h
		mov	ah,0dh
		int	21h
		ret

DOSERROR:	mov	ah,9
		lea	dx,ERRORMSG
		int	21h
		mov	ax,4c01h
		int	21h

DOSERROR2:	mov	ah,9
		lea	dx,ERRORMSG2
		int	21h
		mov	ax,4c01h
		int	21h


end