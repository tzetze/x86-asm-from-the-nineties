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

Savememo2:
		push	@data
		pop	ds
		mov	dx,offset MemoFileName2
		xor 	cx,cx
		mov	ah,3ch
		int	21h			
		mov     bx,ax			
		mov	cx,256
		mov	ah,40h
		mov	dx,offset SzMatrix
                int     21h			
		mov     ah,3eh
                int     21h			
                mov     ah,0dh
                int     21h			
		ret


Savememo3:
		push	@data
		pop	ds
		mov	dx,offset MemoFileName3
		xor 	cx,cx
		mov	ah,3ch
		int	21h			
		mov     bx,ax			
		mov	cx,256
		mov	ah,40h
		mov	dx,0
                int     21h			
		mov     ah,3eh
                int     21h			
                mov     ah,0dh
                int     21h			
		ret


