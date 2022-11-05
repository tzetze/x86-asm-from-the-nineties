DosErr		PROC NEAR
                mov     ax,4c01h
                int     21h
DosErr		ENDP

LoadChars	PROC NEAR
		push	@data
		pop	ds
                mov     ax,3d00h
                lea     dx,CharFname
                int     21h		
                jnc     Hibatlanka
		jmp	DosErr
Hibatlanka:	mov     bx,ax			
                mov     cx,20256
                lea	dx,HypChMatrix
		mov     ah,3fh
                int     21h		
                mov     ah,3eh
                int     21h			 
                mov     ah,0dh
                int     21h			
                ret
LoadChars	ENDP
