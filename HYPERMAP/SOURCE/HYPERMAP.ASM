.286
.MODEL huge
; ** A grafikus k?perny? m?retei **
SCR_WIDTH       equ     1024            ; X
SCR_HEIGTH      equ     768             ; Y

; ** H?nyszor h?nyas a t?rk?p cell?kban? Max. 24x18 lehet. **
TERKEPMERETX    equ     11
TERKEPMERETY    equ     13

; ** Az eg?r indul?si koordin?t?i **
STARTEGERX      equ     512
STARTEGERY      equ     384

; ** Az eg?r mozg?stere **
EGERXMIN        equ     0
EGERXMAX        equ     SCR_WIDTH*4-1
EGERYMIN        equ     0
EGERYMAX        equ     SCR_HEIGTH*4-1

; ** Ennyi EMS mem?ria kell **
MEMORYNEEDED    equ     530
CONVMEMNEEDED	equ	256
; ** Mag?nak a t?rk?pdarabnak a k?perny?n a helye... **
; ** Balfels? sarok                                  **
TERKEPKEZD_X    equ     25
TERKEPKEZD_Y    equ     56

; ** ?s ekkora egy kocka (cella) pixelekben **
EGYKOCKA_X      equ     40
EGYKOCKA_Y      equ     40

; ** Enn?l feljebb ne akarjon senki sem lapozni EMS-t itten! **
MAXMAPLAP       equ     33

; ** K?perny?v?d?nek ?maga adatai
BMP_WDTH	equ	320
BMP_HGTH	equ	200
BO_SI_PLUS	equ	BMP_WDTH
BO_SI_MINUS	equ	-1
RE_SI_PLUS	equ	0
RE_SI_MINUS	equ	BMP_WDTH-1
BO_BP_PLUS	equ	BMP_WDTH*BMP_HGTH
BO_BP_MINUS	equ	-BMP_WDTH
RE_BP_PLUS	equ	0
RE_BP_MINUS	equ	BMP_WDTH*(BMP_HGTH-1)

MODIFY1		equ	POINT_1+1
MODIFY2		equ	POINT_2+2
MODIFY3		equ	POINT_3+1
MODIFY4		equ	POINT_4+2
FRAMENUMBER	equ	100

SPACEMERET	equ	4h
SORHOSSZA	equ	240

.STACK		200h
.DATA
		include .\source\datarea\data.asm
.CODE		
.STARTUP
		call	StorePSP
		call	AskVga
		mov	ax,3
		int	10h

		push	@data			; DS = dataseg.
		pop	ds
		push	0a000h			; ES = screen seg.
		pop	es


		call	EgerInit		; Eg?r van-?e?
		call	Detect_EMS		; EMS van-?lye?
		call	Howmany_EMS		; El?g az EMS?
		call	StartEMS		; EMS bel?ve!
		call	ConvMemAlloc
		call	LoadPalette		; Palettaadatok t?lt?se
		call	LoadChars
		call	PutPalette
		call	LoadTerra
		call	LoadItems
		call	LoadEger

		call	ProbaLoad
		call	SzelesMxGo
		call	Feldolg
		call	SaveMemo
		
		call	ImportMap
;		call	SaveMap
		call	VideoBekapcs

		call	Drwkeret
		call	CoordBoxes

		call	EgerAblak
		call	StartEger
		call	Do_Terrains

		call	DrawMatrix

		call	PutAllText

		push	@data
		pop	ds


		call	Jelol
		call	InitCin
		call	InitSaverTime

;** Ez itten a f?ciklusa a proggynak *********************************
Close:		call	Controls   
		mov	dx,3dah    
VRetr:		in	al,dx
		and	al,8
		jz	VRetr
		call	DrawClock
		call	DrawEger
		jmp	Close

; ** Az egy?b szubrutinok, meg ezek-azok beinkl?dol?z?sa *************
include		.\source\graph\line\vonalak.asm
include		.\source\svga\svga203.asm
include		.\source\mouse\eger.asm
include		.\source\ems\emshand.asm
include		.\source\convmem\convmem.asm
include		.\source\decimal\decimal.asm
include		.\source\graph\terra\drawers.asm
include		.\source\graph\terra\nagyikon.asm
include		.\source\graph\palette\putpal.asm
include		.\source\graph\coordbox\coordbox.asm
include		.\source\control\control.asm
include		.\source\filemng\filemng.asm
include		.\source\quit\quit.asm
include		.\source\textmng\puttext.asm
include		.\source\textmng\initpos.asm
include		.\source\textmng\szelmtrx.asm
include		.\source\textmng\feldolg.asm
include		.\source\scrsaver\saverini.asm
include		.\source\scrsaver\scrsaver.asm
include		.\source\scrsaver\refresh.asm
include		.\source\clock\clock.asm

end
BMP_WDTH	equ	320
