ACT_BANK        dw      0		; bankswitchelìs rutinoknak
MEMMY           dw      0			

ElozoEgerX      dw      0		; egÇr utols¢ helye
ElozoEgerY      dw      0
JelX		dw	0		; az xorolt keret helye
JelY		dw	0
WindowX		dw	0		; MAP ablaban a bal felsì sarok
WindowY		dw	0		; koordin†t†i
TotalX		dw	0		; Elvileg JelX+WindowX, valamint
TotalY		dw	0		; JelY+WindowY megfelelìi
TarCX		dw	0
TarDX		dw	0
TextXPos	dw	0
TextYPos	dw	0

MAP_HANDLE      dw      0
EMS_FRAMESEG	dw	0
POINTSEG	dw	0
EMS_STRT	dw	101

PSP_Address	dw	0

DEC_BUFFER	db	5 dup (32)	; Ide pakol¢dik a decim†lis sz†m
		db	"$",0		; ezmeg hozz†jîn ki°r†skor
LINEAREA        dw      0,0,0,0		; line rutin puffere

CHPUTADDR	dw	0
CHPUTBANK	dw	0
CHNUMBER	db	0
CHWIDTH		db	0
SCROLLMEM1	dw	0
SCROLLMEM2	dw	0
WORDSTART	dw	0

MEM1		dw	0
MEM2		dw	0

CLOCKLOCK	db	0
CONV_SEG1	dw	0
CONV_SEG2	dw	0
CONV_SEG3	dw	0
CONV_SEG4	dw	0

SzMatrix	db	256 dup (?)
RowDatas	db	8000 dup (?)

EgerForma1      db	660 dup (?)
EgerTorol       db      660 dup (?)
Load_Buffer	db	4096 dup (?)

Paletta		db	768 dup (?)
HypChMatrix	db	256 dup (?)
HypChars	db	13000 dup (?)

SAVEHANDLE	dw	0
LOADHANDLE	dw	0

ProbaName	db	".\DATA\PROBA.TXT",0
FileName	db 	".\DATA\HYPERMAP.PAL",0
FileName2	db	".\DATA\EGER01.KEP",0
MapFileName	db	".\DATA\MAP.MPD",0
ImpMapFName	db	".\DATA\MAP.DAT",0
CharFname	db	".\DATA\HYPCHARS.DAT",0
TerrFName	db	".\DATA\TERRA.GRA",0
ItemFName	db	".\DATA\ITEM.GRA",0
MemoFileName	db	".\data\memo.mem",0
SeekPointer	dw	0		; a Load Bufferben a Pointer helye

MOU_ERRTXT1	db      "Nem ÇrzÇkelem egÇr jelenlÇtÇt!",13,10,"$",0
MOU_RDYTXT1	db	"EgÇr ..................... rendben.",13,10,"$",0
EMS_ERRTXT1	db	"Nincs EMS meghajt¢ install†lva!",13,10,"$",0
EMS_RDYTXT1	db	"EMS kezelì ............... rendben.",13,10,"$",0	
EMS_SZOVEG1	db	"A rendelkezÇre †ll¢ EMS mÇrete     : $",0
EMS_SZOVEG2	db	13,10,"A programhoz szÅksÇges EMS terÅlet : $",0
CONVMEMTXT1	db	13,10,"Konencion†lis mem¢ria              : $",0
CONVMEMTXT2	db	13,10,"SzÅksÇges konvencion†lis mem¢ria   : $",0
KILOBYTETXT	db	"K$",0
LOADERRTXT1	db      13,10,"A HYPERMAP.PAL hi†nyzik!",13,10,"$",0
LOADERRTXT2	db	13,10,"A TERRA.GRA hi†nyzik!",13,10,"$",0
LOADERRTXT3	db	13,10,"Az ITEM.GRA hi†nyzik!",13,10,"$",0
LOADERRTXT4	db	13,10,"A HYPCHARS.DAT hi†nyzik!",13,10,"$",0
LOADERRTXT5	db	13,10,"Az EGER01.KEP hi†nyzik!",13,10,"$",0
LOADERRTXT6	db	13,10,"A MAP.DAT hi†nyzik!",13,10,"$",0
LOADRDYTXT1	db	13,10,"HYPERMAP.PAL ............. rendben.$",0
LOADRDYTXT2	db	13,10,"TERRA.GRA ................ rendben.$",0
LOADRDYTXT3	db	13,10,"ITEM.GRA ................. rendben.$",0
LOADRDYTXT4	db	13,10,"HYPCHARS.DAT ............. rendben.$",0
LOADRDYTXT5	db	13,10,"EGER01.KEP ............... rendben.$",0
LOADRDYTXT6	db	13,10,"MAP.DAT $",0

OKTXT		db	"K ... OK.$",0
KEVESTXT	db	13,10,"*** KevÇs az EMS mem¢ri†d!$",0
KEVESCONVMEM	db	13,10,"*** KevÇs a konvencion†lis mem¢ria!$",0
ALLOCERROR	db	13,10,"*** Hiba az EMS mem¢riafoglal†sakor!$",0
EMSEGERROR	db	13,10,"*** EMS szegmensc°m keresÇsekori hiba!$",0
LAPOZERROR	db	13,10,"*** MAP lapoz†sakor EMS t£lcsordul†s!$",0
CONVERROR	db	13,10,"*** Konvencion†lis mem¢ria lefoglal†sakori hiba!$",0
TextProba	db	0

Hanyas		dw	4

Ikon1		dw	0	; felsì ikon t°pus - t†rol¢
Ikon2		dw	0	; als¢ ikon t°pus  - t†rol¢
Szam1		dw	0	; felsì ikon sz†ma - t†rol¢
Szam2		dw	0	; als¢ ikon sz†ma  - t†rol¢
IsmJel		db	0	; IsmertsÇg meg satîbbi - t†rol¢
coord_memo	dw	0	; sz†mki°rat†shoz †tmeneti t†rol¢
XPoint		dw	0	
YPoint		dw	0	
XBuf		dw	0
YBuf		dw	0

DownCounter	dw	0

Szavak		dw	0
Szelesseg	dw	0
EddigSzeles	dw	0
SzoEleje	dw	0
SorEleje	dw	0


SZAMOK		db	240,144,144,144,144,144,240	; 0
		db	16,16,16,16,16,16,16		; 1
		db      240,16,16,240,128,128,240	; 2
		db	240,16,16,240,16,16,240		; 3
		db	144,144,144,240,16,16,16	; 4
		db	240,128,128,240,16,16,240	; 5
		db	240,128,128,240,144,144,240	; 6
		db	240,16,16,16,16,16,16		; 7
		db	240,144,144,240,144,144,240	; 8
		db	240,144,144,240,16,16,16	; 9
		db	0,0,0,0,0,0,0			; Åreske		

NoIsmert	db	0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255
		db	0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255
		db      255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0
		db      255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0
		db	0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255
		db	0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255
		db      255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0
		db      255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0
		db	0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255
		db	0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255
		db      255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0
		db      255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0
		db	0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255
		db	0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255
		db      255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0
		db      255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0
		db	0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255
		db	0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255
		db      255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0
		db      255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0,255,255,0,0

Ezapottyi	db	".$",0

; *****************************************************************
; ** 18x23 ¢rakarakter sablon *************************************
; *****************************************************************

WatchSablon	db	"    111111111111  "
		db	"  4  1111111111  5"
		db	"  44  11111111  55"
		db	"  444          555"
		db	"  444          555"
		db	"  444          555"
		db	" 444          555 "
   		db	" 444          555 "   
		db	" 444          555 "   
		db	" 444          555 "
		db	"  4  22222222  5  "
		db	"    2222222222    "
		db	"  6  22222222  7  "
		db	" 666          777 "
		db	" 666          777 "
		db	" 666          777 "
		db	"666          777  "
		db	"666          777  "
		db	"666          777  "
		db	"666          777  "
		db	"66  33333333  77  "
		db	"6  3333333333  7  "
		db	"  333333333333    "

NumbaPalcak	db	40,184,40,40,40,40,40 		; 0
		db	184,184,184,184,40,184,40	; 1
		db	40,40,40,184,40,40,184		; 2
		db	40,40,40,184,40,184,40		; 3
		db	184,40,184,40,40,184,40		; 4
		db	40,40,40,40,184,184,40		; 5
		db	40,40,40,40,184,40,40		; 4
		db	40,184,184,184,40,184,40	; 7
		db	40,40,40,40,40,40,40		; 8
		db	40,40,40,40,40,184,40		; 9

TheDigit	db	0
PlotAddr	dw	0
TheNumba	db	0
NumberAddr	dw	0

Terra_In	db	0
ItemDat		db	0

