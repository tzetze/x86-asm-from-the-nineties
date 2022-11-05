.286
.MODEL small
		include	equ.asm
.STACK		200h
.DATA
		include	terrain.dat
		include item.dat
Filename	db	".\TERRA.GRA",0
Filename2	db	".\ITEM.GRA",0
.CODE		
		push	@data			; DS = dataseg.
		pop	ds
		call	Convert_Terrains
		call	Convert_Items

		mov     dx,offset Filename
		xor	cx,cx
                mov     ah,3ch
                int     21h
                mov     bx,ax
                mov     cx,40*40*15
                mov     dx,offset Terra_In
		mov	ah,40h
                int     21h
                mov     ah,3eh
                int     21h
                mov     ah,0dh
                int     21h
		

		mov     dx,offset Filename2
		xor	cx,cx
                mov     ah,3ch
                int     21h
                mov     bx,ax
                mov     cx,33*15*20
                mov     dx,offset ItemDat
		mov	ah,40h
                int     21h
                mov     ah,3eh
                int     21h
                mov     ah,0dh
                int     21h
		
		mov	ax,4c00h		
		int	21h

include		drawers.asm
end