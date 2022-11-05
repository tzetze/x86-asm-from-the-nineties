;-----------------------------------------------------------------------------;
;     THiS CODE iS FREEWARE. YOU MAY USE iT iN YOUR PRODUCTS, FEEL FREE TO    ;
;     MODiFY iT, BUT PLEASE DON'T SPREAD THE  MODiFiED VERSiON. THANK YOU!    ;
;-----------------------------------------------------------------------------;
;        PROGRAMMED BY GABOR SZABO aka CYBERDANCER/SHOCK! iN 1993-94-95       ;
;           bocs, de Cece meg kicsit maga sz m ra modifie zolta :)            ;
;-----------------------------------------------------------------------------;

VideoBekapcs:	cmp	CS:VGACARD,3
		ja	NemVesaAlapu
		mov	ax,4f02h	; VesaBios 02 funkci¢ h¡v sa
		mov	bx,105h		; 105-”s m¢ddal (1024x768x256)
		jmp	FoKapcsoloBe
NemVesaAlapu:	cmp	CS:VGACARD,7
		ja	NemIsTSENG
		mov	ax,38h
		jmp	FoKapcsoloBe
NemIsTSENG:	cmp	CS:VGACARD,9
		ja	NemTrideNCR
		mov	ax,62h
		jmp	FoKapcsoloBe
NemTrideNCR:	cmp	CS:VGACARD,10
		ja	NemIsAhead
		mov	ax,63h
		jmp	FoKapcsoloBe
NemIsAhead:	cmp	CS:VGACARD,11
		ja	NemIsATI
		mov	ax,64h
		jmp	FoKapcsoloBe
NemIsATI:	cmp	CS:VGACARD,12
		ja	NemIsOAK
		mov	ax,59h
		jmp	FoKapcsoloBe
NemIsOAK:	mov	ax,31h
FoKapcsoloBe:	int	10h
		ret

BANKSWITCH:     CMP     CS:VGACARD,1
                JA      S3LAPOZ		
                PUSH    AX		; Innen VESA
		PUSH	BX
		PUSH	DX
                MUL     CS:VESAGRAN     ;SET GRANULARITY
                MOV     DX,AX
                MOV     BX,0
                MOV     AX,4F05H        ;DO THE BANK SWITCHING
                INT     10H
                POP     DX
		POP	BX
		POP	AX
                RET

S3LAPOZ:        CMP     CS:VGACARD,2
                JA      CiRRUSLAPOZ
                MOV     DX,3D4H          ;ENABLE EXTENDED REGiSTERS
                PUSH    AX
                MOV     AL,38H
                OUT     DX,AL
                iNC     DX
                MOV     AL,48H
                OUT     DX,AL
                DEC     DX               ;ENABLE WRiTE TO BANK REGiSTERS
                MOV     AL,31H
                OUT     DX,AL
                iNC     DX
                MOV     AL,89H
                iN      AL,DX
                PUSH    AX
                DEC     DX
                MOV     AL,31H
                OUT     DX,AL
                iNC     DX
                POP     AX
                OR      AL,9
                OUT     DX,AL
                DEC     DX               ;SWiTCH BANKS
                MOV     AL,35H
                OUT     DX,AL
                iNC     DX
                POP     AX
                OUT     DX,AL
                DEC     DX               ;DiSABLE EXTENDED REGiSTERS
                MOV     AL,38H
                OUT     DX,AL
                iNC     DX
                MOV     AL,0
                OUT     DX,AL
                RET

CiRRUSLAPOZ:    CMP     CS:VGACARD,3
                JA      TSENG4000
                PUSH    DX
                PUSH    AX
                PUSH    AX
                MOV     DX,3CEH
                MOV     AL,9
                OUT     DX,AL
                iNC     DX
                POP     AX
                SHL     AX,4
                OUT     DX,AL
                POP     AX
                POP     DX
                RET

TSENG4000:      CMP     CS:VGACARD,4
                JA      DiAMOND
                PUSH    AX
                PUSH    DX
                MOV     AH,AL
                MOV     DX,3BFH        ;ENABLE ACCESS TO EXTENDED REGiSTERS
                MOV     AL,3
                OUT     DX,AL
                MOV     DL,0D8H
                MOV     AL,0A0H
                OUT     DX,AL
                AND     AH,15
                MOV     AL,AH
                SHL     AL,1
                SHL     AL,1
                SHL     AL,1
                SHL     AL,1
                OR      AL,AH
                MOV     DL,0CDH
                OUT     DX,AL
                POP     DX
                POP     AX
                RET

DiAMOND:        CMP     CS:VGACARD,5
                JA      STBVGA
                PUSH    AX
                PUSH    DX
                MOV     AH,AL
                MOV     DX,3BFH        ;ENABLE ACCESS TO EXTENDED REGiSTERS
                MOV     AL,3
                OUT     DX,AL
                MOV     DL,0D8H
                MOV     AL,0A0H
                OUT     DX,AL
                AND     AH,15
                MOV     AL,AH
                SHL     AL,1
                SHL     AL,1
                SHL     AL,1
                SHL     AL,1
                OR      AL,AH
                MOV     DL,0CDH
                OUT     DX,AL
                POP     DX
                POP     AX
                RET

STBVGA:         CMP     CS:VGACARD,6
                JA      COMPAQLAPOZ
                PUSH    AX
                PUSH    DX
                MOV     AH,AL
                MOV     DX,3BFH        ;ENABLE ACCESS TO EXTENDED REGiSTERS
                MOV     AL,3
                OUT     DX,AL
                MOV     DL,0D8H
                MOV     AL,0A0H
                OUT     DX,AL
                AND     AH,15
                MOV     AL,AH
                SHL     AL,1
                SHL     AL,1
                SHL     AL,1
                SHL     AL,1
                OR      AL,AH
                MOV     DL,0CDH
                OUT     DX,AL
                POP     DX
                POP     AX
                RET

COMPAQLAPOZ:    CMP     CS:VGACARD,7
                JA      TRiDENT
                PUSH    DX
                PUSH    AX
                MOV     DX,3CEH
                MOV     AL,45H
                OUT     DX,AL
                POP     AX
                iNC     DX
                SHL     AX,4
                OUT     DX,AL
                POP     DX
                RET

TRiDENT:        CMP     CS:VGACARD,8
                JA      NCRVGA
                PUSH    AX
                PUSH    DX
                PUSH    AX
                MOV     DX,3CEH         ;SET PAGE SiZE TO 64K
                MOV     AL,6
                OUT     DX,AL
                iNC     DL
                iN      AL,DX
                DEC     DL
                OR      AL,4
                MOV     AH,AL
                MOV     AL,6
                OUT     DX,AX
                MOV     DL,0C4H         ;SWiTCH TO BPS MODE
                MOV     AL,0BH
                OUT     DX,AL
                iNC     DL
                iN      AL,DX
                DEC     DL
                POP     AX
                MOV     AH,AL
                XOR     AH,2
                MOV     DX,3C4H
                MOV     AL,0EH
                OUT     DX,AX
                POP     DX
                POP     AX
                RET

NCRVGA:         CMP     CS:VGACARD,9
                JA      AHEADB
                MOV     BX,AX
                MOV     AL,18H
                MOV     DX,3C4H
                OUT     DX,AL
                iNC     DX
                SHL     BX,2
                MOV     AX,BX
                OUT     DX,AL
                RET

AHEADB:         CMP     CS:VGACARD,10
                JA      ATiVGA
                PUSH    AX
                PUSH    DX
                PUSH    CX
                MOV     CH,AL
                MOV     DX,3CEH         ;ENABLE EXTENDED REGiSTERS
                MOV     AX,200FH
                OUT     DX,AX
                MOV     AH,CH
                MOV     CL,4
                SHL     AH,CL
                OR      AH,CH
                MOV     AL,0DH
                OUT     DX,AX
                POP     CX
                POP     DX
                POP     AX
                RET

ATiVGA:         CMP     CS:VGACARD,11
                JA      OAK_
                PUSH    AX
                PUSH    DX
                MOV     AH,AL
                MOV     DX,1CEH
                MOV     AL,0B2H
                OUT     DX,AL
                iNC     DL
                iN      AL,DX
                SHL     AH,1
                AND     AL,0E1H
                OR      AH,AL
                MOV     AL,0B2H
                DEC     DL
                OUT     DX,AX
                POP     DX
                POP     AX
                RET

OAK_:           CMP     CS:VGACARD,12    ;OTi-067
                JA      PRiMUSLAPOZ
                PUSH    AX
                PUSH    DX
                AND     AL,15
                MOV     AH,AL
                SHL     AL,1
                SHL     AL,1
                SHL     AL,1
                SHL     AL,1
                OR      AL,AH
                MOV     DX,3DFH
                OUT     DX,AL
                POP     DX
                POP     AX
                RET

PRiMUSLAPOZ:    CMP     CS:VGACARD,13
                JA      VALAMiMAS
                PUSH    DX
                MOV     DX,3D6H
                OUT     DX,AL
                POP     DX
                RET
VALAMiMAS:      RET

; *******************************************************************
DETECTiONS:     MOV     AX,CS
                MOV     ES,AX
                MOV     AH,3
                iNT     10H
                MOV     BL,3
                MOV     BH,0
                LEA     BP,INFOLiNE
                MOV     AL,1
                MOV     AH,13H
                MOV     CX,21
                iNT     10H

TRiDECT:        PUSH    CS
                POP     DS
                MOV     DX,03C4H
                MOV     AX,14
                OUT     DX,AX
                iNC     DX
                iN      AX,DX
                MOV     CS:OLDVALUE,AX
                MOV     AX,0
                OUT     DX,AX
                iN      AX,DX
                AND     AX,15
                MOV     CS:VALUE,AX
                MOV     AX,CS:OLDVALUE
                OUT     DX,AX
                CMP     CS:VALUE,2
                JNE     PARADiSEDET
                MOV     AH,9
                LEA     DX,TRiDETECTED
                iNT     21H
                JMP     VESADETECT

PARADiSEDET:    MOV     AX,0C000H
                MOV     DS,AX
                MOV     Si,7DH
                LODSW
                CMP     AX,'GV'
                JNE     AHEADDETECT
                LODSW
                CMP     AX,'=A'
                JNE     AHEADDETECT
                MOV     AX,CS
                MOV     DS,AX
                MOV     AH,9
                LEA     DX,PARADETECTED
                iNT     21H
                JMP     VESADETECT

AHEADDETECT:    MOV     AX,0C000H
                MOV     DS,AX
                MOV     Si,25H
                LODSW
                CMP     AX,'HA'
                JNE     TSENGDETECT
                LODSW
                CMP     AX,'AE'
                JNE     TSENGDETECT
                MOV     AX,CS
                MOV     DS,AX
                MOV     AH,9
                LEA     DX,AHEADDETECTED
                iNT     21H
                JMP     VESADETECT
TSENGDETECT:
                MOV     DX,3CDH
                iN      AL,DX
                MOV     AH,AL
                MOV     AL,55H
                OUT     DX,AL
                iN      AL,DX
                XCHG    AH,AL
                OUT     DX,AL
                CMP     AH,55H
                JNE     REALTEKDETECT
                DEC     DX
                iN      AL,DX
                MOV     DL,0D4H
                AND     AL,1
                JNE     ET01
                MOV     DL,0B4H
ET01:           MOV     AL,33H
                OUT     DX,AL
                iNC     DX
                iN      AL,DX
                MOV     CL,AL
                XOR     AL,0FH
                MOV     AH,AL
                OUT     DX,AL
                iN      AL,DX
                XCHG    AL,CL
                OUT     DX,AL
                CMP     AH,CL
                JNE     ET3000
ET4000:         MOV     AX,CS
                MOV     DS,AX
                MOV     AH,9
                LEA     DX,ET4000DET
                iNT     21H
                JMP     VESADETECT
ET3000:         MOV     AX,CS
                MOV     DS,AX
                MOV     AH,9
                LEA     DX,ET3000DET
                iNT     21H
                JMP     VESADETECT
REALTEKDETECT:  MOV     DX,03CCH
                iN      AL,DX
                MOV     DL,0D4H
                SHR     AL,1
                JB      REAL1
                MOV     DL,0B4H
REAL1:          MOV     AL,1FH
                OUT     DX,AL
                iNC     DX
                iN      AL,DX
                MOV     AH,AL
                OUT     DX,AL
                iN      AL,DX
                CMP     AL,2AH
                JNE     VESADETECT
                PUSH    CS
                POP     DS
                LEA     DX,RTVGADET
                MOV     AH,9
                iNT     21H
                JMP     VESADETECT

VESADETECT:     MOV     AX,4F03H
                iNT     10H
                CMP     AL,4FH
                JNE     UNDETECT  
                MOV     AX,CS
                MOV     DS,AX
                LEA	DX,VESADETECTED
                MOV     AH,9
                iNT     21H
                MOV     AX,CS
                MOV     ES,AX
                LEA     Di,VESATABLE
                MOV     CX,100H
                MOV     AX,4F01H
                iNT     10H
                CMP     AL,4FH
                JNE     NOKDET
                MOV     CS:FLAG400,1       ;VAN 640X400X256
NOKDET:         MOV     BX,WORD PTR ES:[DI+4]
                MOV     AX,64
                DIV     BL
                MOV     CS:VESAGRAN,AL
                MOV     AX,CS:[Di+2]
                CMP     AL,7
                JE      WRiTABLEVESA
                MOV     AH,3
                iNT     10H
                MOV     BL,4
                MOV     BH,0
                LEA     BP,VESAWARNiNG
                MOV     AL,1
                MOV     AH,13H
                MOV     CX,128
                iNT     10H
WRiTABLEVESA:   RET

UNDETECT:       MOV     AX,CS
                MOV     DS,AX
                MOV     AH,9
                LEA     DX,UNDETECTED
                iNT     21H
                RET
ASKVGA:         MOV     AX,12H
                iNT     10H
                MOV     AX,CS
                MOV     DS,AX
                CALL    DETECTiONS
                MOV     AX,CS
                MOV     ES,AX
                MOV     AH,3
                iNT     10H
                MOV     BL,3
                MOV     BH,0
                LEA     BP,WHATVGA
                MOV     AL,1
                MOV     AH,13H
                MOV     CX,22
                iNT     10H
                MOV     AX,CS
                MOV     DS,AX
                MOV     AH,9
                LEA     DX,WHATVGA2
                iNT     21H
UJRAASK:        MOV     AH,8
                iNT     21H
                CMP     AL,27
                JNE     NEMAKARKiLEPNi
                MOV     AX,3
                iNT     10H
                MOV     AX,4C00H
                iNT     21H
NEMAKARKiLEPNi: CMP     AL,31H
                JB      NEMSZAM_
                CMP     AL,39H
                JA      NEMSZAM_
                SUB     AL,30H
                MOV     CS:VGACARD,AL
                RET
NEMSZAM_:       CMP     AL,'A'
                JB      NEMNAGYBETU
                CMP     AL,'D'
                JA      NEMNAGYBETU
                SUB     AL,55
                MOV     CS:VGACARD,AL
                RET
NEWASK:         JMP     UJRAASK
NEMNAGYBETU:    CMP     AL,'a'
                JB      NEWASK
                CMP     AL,'d'
                JA      NEWASK
                SUB     AL,87
                MOV     CS:VGACARD,AL
                RET

VGACARD         DB      0
WHATVGA         DB      10,13,10,13
                DB      'CHOOSE A VGA CARD:'
WHATVGA2  DB ' 1. VESA                          ',10,13
DB '                   2. S3 805/801/911                ',10,13
DB '                   3. CIRRUS LOGIC                  ',10,13
DB '                   4. TSENG ET4000                  ',10,13
DB '                   5. DiAMOND SPEEDSTAR 24          ',10,13
DB '                   6. STB                           ',10,13
DB '                   7. COMPAQ QVISION                ',10,13
DB '                   8. TRiDENT                       ',10,13
DB '                   9. NCR                           ',10,13
DB '                   A. AHEAD B                       ',10,13
DB '                   B. ATI                           ',10,13
DB '                   C. OAK                           ',10,13
DB '                   D. PRiMUS P-2000                 ',10,13
DB '                                                     ESC. QUiTS NOW',10,13
DB '$'

iNFOLiNE        DB      10,13
                DB      'DETECTED:          '
TRiDETECTED     DB      'TRiDENT SVGA$'
PARADETECTED    DB      'PARADiSE SVGA$'
AHEADDETECTED   DB      'AHEAD SVGA$'
UNDETECTED      DB      'UNKNOWN SVGA$'
ET3000DET       DB      'TSENG ET-3000 SVGA$'
ET4000DET       DB      'TSENG ET-4000 SVGA$'
RTVGADET        DB      'REALTEK SVGA$'
VESADETECTED    DB      10,13
                DB      '                   VESA COMPATiBLE SVGA',10,13,'$'
OLDVALUE        DW      0
VALUE           DW      0
VESAGRAN        DB      0
FLAG400         DW      0

VESATABLE       DB      256/4   DUP ('VESA')
VESAWARNiNG     DB      10,13,'DON''T SELECT VESA NOW, BECAUSE UNABLE TO'
                DB      ' READ FROM THE WiNDOW A.',10,13
                DB      'PLEASE LOAD A BETTER VESA DRiVER,'
                DB      ' iF YOU WANNA SELECT VESA !'
