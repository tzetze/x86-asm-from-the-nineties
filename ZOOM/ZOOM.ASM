.286
.model small

scrwdth		equ	320
scrhgth		equ	200
txtwdth		equ	132
txthgth		equ	130

.stack
.data?		

graph		db	18238 dup (?)
mem		dw	0
mem2		dw	0

.data

zomwdth		dw	159
zomhgth		dw	159

filename	db 'grab5.bmp',0
errortxt	db "Couldn't open 256COLOR.BMP!$",0

zoomtable	dw 	8,8,8,8,8,8,8,9,9,9,9,9,9,10,10,10,10,10,11,11,11,11
		dw 	12,12,12,13,13,13,14,14,15,15,16,16,17,17,18,19,20,20
		dw 	21,22,23,25,26,27,29,31,33,36,39,42,46,51,57,65,75,90
		dw 	132,131,130,128,126,124,122,120,118
		dw	116,114,1512,110,108,106,104,102,100
		dw	90,75,65,57,51,46,42,39,36,33,31,29,27,26,25,23,22,21
		dw	20,20,19,18,17,17,16,16,15,15,14,14,13,13,13,12,12,12
		dw	11,11,11,11,10,10,10,10,10,9,9,9,9,9,9,8,8,8,8,8,8,8
zoomlen         equ 	134


.code		
		push	@data
		pop	ds
 		  call	loaddata	;set up bitmap
		mov	ax,13h		;set 320x200x256
		int	10h		;graphmode
		  mov 	ax,0a000h	;screen A000:0000
		  mov	es,ax		;ES is a source pointer


;		mov 	bx,zoomtable
;		mov 	cx,zoomlen
;felszoroz:	shl 	word ptr ds:[bx],1
;		inc 	bx
;		loop    felszoroz
		
		call 	putpal

itt:		lea 	bx,zoomtable
		mov	cx,zoomlen
biogal:		push	bx
		push	cx
		mov	dx,word ptr ds:[bx]
		mov	word ptr ds:[zomwdth],dx
		mov 	word ptr ds:[zomhgth],dx
		mov	dx,3dah
szink:		in 	al,dx
		and	al,8
		jz	szink
		mov	cx,500
sz:		loop	sz
		mov	dx,3dah
szink2:		in 	al,dx
		and	al,8
		jz	szink2
		mov	cx,500
sz2:		loop	sz2
		mov	dx,3dah
szink3:		in 	al,dx
		and	al,8
		jz	szink3
		mov	cx,500
sz3:		loop	sz3
		call    setupz
		pop	cx
		pop	bx
		inc	bx
		inc	bx
keyz:		mov	ah,1
		int 	16h
		jnz	changeit
		jmp	noeszk
changeit:	xor	ah,ah
		int 	16h
		cmp	al,1bh
		jne	noeszk
		jmp	dosquit
noeszk:		loop	biogal
		jmp	itt

		call    setupz
		jmp	whatsup2
;----Setup Zoomer:
setupz:		mov	cx,txtwdth
		mov	dx,0
		mov	ax,0
		mov	dl,ch
		mov	ah,cl
		mov	bx,word ptr ds:[zomwdth]
		div	bx		;AX=horizontal adder
		mov	byte ptr cs:[modify1+2],al
		mov	byte ptr cs:[modify3+2],ah
	;...
		mov	cx,txthgth
		mov	dx,0
		mov 	ax,0
		mov	dl,ch
		mov	ah,cl
		mov	bx,word ptr ds:[zomhgth]
		div	bx		;AX=vertical adder
		mov	byte ptr cs:[modify2+2],al
		mov	byte ptr cs:[modify4+1],ah
	;-----------------------------------------------------------
		mov	ax,scrwdth
		mov	bx,word ptr ds:[zomwdth]
		cmp	ax,bx		
		jg	vekony	
	;---ha mar tulnotte vizszintbe....
		mov	word ptr cs:[modify5+2],0
		mov	word ptr cs:[modify8+1],scrwdth
		mov	word ptr cs:[modifyd+2],0
		mov	ax,word ptr ds:[zomwdth]
		mov	bx,scrwdth
		sub	ax,bx		;ax:=zomwdth-scrwdth
		shr	ax,1		;ax:=(zomwdth-scrwdth)/2
					;==>ennyi pixel log ki a kepbol		
		mov	dh,0
		mov	dl,ah
		mov	ah,al
		mov	al,0
		mov	bx,word ptr ds:[zomwdth]
		div	bx
		mov	bx,txtwdth
		mul 	bx
		mov	byte ptr cs:[modify9+1],al	;the adderstart
		mov	byte ptr cs:[modify99+1],al
		mov	byte ptr cs:[modifyb+2],ah	;add si,ennyi
		mov	byte ptr cs:[modifyb+3],dl
		jmp	whatsup1

vekony:		mov	ax,scrwdth
		mov	bx,word ptr ds:[zomwdth]
		sub	ax,bx
		mov	word ptr cs:[modifyd+2],ax
		shr	ax,1
		mov	word ptr cs:[modify5+2],ax
		mov	ax,word ptr ds:[zomwdth]
		mov	word ptr cs:[modify8+1],ax

whatsup1:
		mov	ax,scrhgth
		mov	bx,word ptr ds:[zomhgth]
		cmp	ax,bx		
		jg	vekony2	
	;---ha mar tulnotte fuggolegesbe....
		mov	word ptr cs:[modify6+1],0
		mov	word ptr cs:[modify7+1],scrhgth
		mov	ax,word ptr ds:[zomhgth]
		mov	bx,scrhgth
		sub	ax,bx		;ax:=zomhgth-scrhgth
		shr	ax,1		;ax:=(zomhgth-scrhgth)/2
					;==>ennyi pixel log ki a kepbol		
		mov	dh,0
		mov	dl,ah
		mov	ah,al
		mov	al,0
		mov	bx,word ptr ds:[zomhgth]
		div	bx
		mov	bx,txthgth
		mul     bx
		mov	byte ptr cs:[modifya+1],al	;the adderstart
		mov	byte ptr cs:[modifyc+1],ah	;add si,!ennyi*thtwdth!
		mov	byte ptr cs:[modifyc+2],dl      ;high byte van hatul
		jmp	whatsup2

vekony2:	mov	ax,scrhgth
		mov	bx,word ptr ds:[zomhgth]
		sub	ax,bx
		shr	ax,1
		mov	word ptr cs:[modify6+1],ax
		mov     ax,word ptr ds:[zomhgth]
		mov	word ptr cs:[modify7+1],ax
		call	zoom
whatsup2:	ret
;---------------------------------------------------------------------------

		call	putpal		
more:		call	keys
		jmp	more
;--------------------------------------------------------------------------
zoom:		lea	si,graph+1078
modifyb:	add	si,word ptr 0
modifyc:	mov 	cx,0
		cmp	cx,0
		je	goahead
lna:		add	si,word ptr txtwdth
		loop 	lna
goahead:	mov	word ptr ds:[mem],si
		mov	di,0
modify5:	add	di,word ptr 0		;xstart
modify6:	mov	cx,0		;ystart
		cmp	cx,0
		je	modify9
anl:		add	di,word ptr scrwdth
		loop	anl
modify9:	mov	dh,00h		;horiz. counter
modifya:	mov	dl,00h		;vert.  counter
modify7:	mov	cx,200
loop_loc5:	push	cx
modify8:	mov	cx,320
modify99:	mov	dh,0		;horiz. counter
loop_loc6:	mov	al,byte ptr [si]
		mov	byte ptr es:[di],al
modify1:	add	dh,80h		;horiz	add.
modify3:	adc	si,word ptr 0
		inc	di
		loop	loop_loc6
modifyd:	add	di,word ptr 0
		mov	si,word ptr ds:[mem]
modify4:	mov 	cx,1
		cmp	cx,0
		je	modify2
ideloop:	add 	si,word ptr txtwdth
		loop	ideloop
modify2:	add	dl,80h		;vertical add.
		jc	loc1
		jmp	loc2
loc1:		add	si,word ptr txtwdth
loc2:		mov	word ptr ds:[mem],si
		pop	cx
		loop	loop_loc5
		ret
;--------------------------------------------------------------------------
dosquit:	mov	ax,03h
		int	10h
		mov	ax,4c00h
		int	21h
;--------------------------------------------------------------------------
keys:		mov	ah,1
		int 	16h
		jnz	change
		ret
change:		xor	ah,ah
		int 	16h
		cmp	al,1bh
		jne	noesc
		jmp	dosquit
noesc:		cmp	ax,4b00h
		jne	noleft
		add	word ptr cs:[modifyka+2],1
		call	putpal	
noleft:		cmp	ax,4d00h
		jne	noright
		sub	word ptr cs:[modifyka+2],1
		call	putpal
noright:	cmp	ax,5000h
		jne	nodown
		;add     byte ptr cs:[zuzu1+4],1
		;add     byte ptr cs:[zuzu2+4],1
zuzu1:		add	word ptr ds:[zomwdth],2
zuzu2:		add	word ptr ds:[zomhgth],2
nodown:		cmp	ax,4800h
		jne	none
		sub	word ptr ds:[zomwdth],2
		sub	word ptr ds:[zomhgth],2
none:		mov	dx,3dah
sync:		in 	al,dx
		and 	al,8
		jz	sync
		call	setupz
		ret
;---------------------------------------------------------------------
putpal:
		lea	bx,ds:graph
modifyka:	add	bx,word ptr 55		
		mov 	al,0
		mov 	dx,03c8h
		out	dx,al
		mov 	cx,256
		mov 	dx,03c9h
loop_loc3:	mov	al,[bx]
		shr	al,2
		out	dx,al
		dec	bx
		mov	al,[bx]
		shr	al,2
		out	dx,al
		dec	bx
		mov 	al,[bx]
		shr	al,2
		out	dx,al
		add	bx,6
		loop	loop_loc3
		ret
;------------------------------------------------------------------------------
loaddata:	mov	ax,3d00h
		lea	dx,filename
		int	21h
		jc	doserror
		mov	bx,ax
		mov	cx,18238
		lea	dx,graph
		mov	ah,3fh
		int	21h
		mov	ah,3eh
		int	21h
		mov	ah,0dh
		int	21h
		ret
;----------------------------------------------------------------------------
doserror:	mov	ah,9
		lea	dx,errortxt
		int	21h
		mov	ax,4c01h
		int	21h
end