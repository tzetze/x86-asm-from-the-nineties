.286
.MODEL small
.STACK 200h
SpaceMeret	equ	4
SorHossza	equ	400
.DATA
include		probatxt.dat
MemoFileName	db	"./FELDMEMO.DAT",0
MemoFileName2	db	"./SZELESS.DAT",0
MemoFileName3	db	"./TEXT.MEM",0
CharFName	db	"./HYPCHARS.DAT",0
HypChMatrix	db	256 dup (?)
HypChars	db	20000 dup (?)
SzMatrix        db      256 dup (?)
RowDatas        db      4000 dup (0)
Szoeleje        dw      0
Soreleje        dw      0
Szavak          dw      0
Szelesseg       dw      0
EddigSzeles     dw      0

.CODE		
		push	@data
		pop	ds
		call	loadchars
		call	szelesmxgo
		call	feldolg
		call	savememo
		call	savememo2
		call	savememo3
		mov	ax,4c00h
		int	21h

include		loadchar.asm
include		feldolg.asm
include 	puttext.asm
include		savememo.asm
include		szelmtrx.asm
end
