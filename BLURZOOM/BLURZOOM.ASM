.286
.model small
SCRWDTH		equ	320
SCRHGTH		equ	200
TXTWDTH		equ	280
TXTHGTH		equ	160
.stack
		dw	1000 dup (?)
.data

SECSCR		db	TXTWDTH*TXTHGTH dup(?)
MEM		dw	0
MEM2		dw	0
ZOMWDTH		dw	28
ZOMHGTH		dw	16
SZOVEG		db	'ABABCA AABBA',0

		; SPACE
CHARSET		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'


		; '!' #33
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'

		; '"' #34
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '#' #35
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '$' #36
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '%' #37
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '&' #38
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; ''' #39
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '(' #40
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; ')' #41
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '*' #42
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '+' #43
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; ',' #44
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '-' #45
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '.' #46
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '/' #47
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '0' #48
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '1' #49
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '2' #50
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '3' #51
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '4' #52
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '5' #53
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '6' #54
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '7' #55
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '8' #56
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '9' #57
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; ':' #58
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; ';' #59
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '<' #60
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '=' #61
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '>' #62
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '?' #63
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; '@' #64
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; 'A' #65
		db      '......oooooo........'
		db      '........oooo........'
		db      '.......oo..oo.......'
		db      '.......oo..oo.......'
		db      '.......oo..oo.......'
		db      '......oo....oo......'
		db      '......oo....oo......'
		db      '......oo....oo......'
		db      '.....oo......oo.....'
		db      '.....oo......oo.....'
		db      '.....oooooooooo.....'
		db      '....oooooooooooo....'
		db      '....oo........oo....'
		db      '....oo........oo....'
		db      '...oo..........oo...'
		db      '...oo..........oo...'
		db      '...oo..........oo...'
		db      '..oo............oo..'
		db      '..oo............oo..'
		db      'oooo............oooo'
		; 'B' #66
		db      'oooooooooooooo......'
		db      '..oooooooooooooo....'
		db      '..oo...........oo...'
		db      '..oo............oo..'
		db      '..oo............oo..'
		db      '..oo............oo..'
		db      '..oo............oo..'
		db      '..oo...........oo...'
		db      '..oooooooooooooo....'
		db      '..ooooooooooooooo...'
		db      '..oo...........ooo..'
		db      '..oo............ooo.'
		db      '..oo.............oo.'
		db      '..oo.............oo.'
		db      '..oo.............oo.'
		db      '..oo.............oo.'
		db      '..oo............ooo.'
		db      '..oo...........ooo..'
		db      '..ooooooooooooooo...'
		db      'ooooooooooooooo.....'
		; 'C' #67
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		; 'D' #68
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
		db      '....................'
LNGSET		equ	$-CHARSET


TAB     dw 79,45
        dw 80,46
        dw 81,46
        dw 82,47
        dw 84,48
        dw 85,48
        dw 86,49
        dw 88,50
        dw 89,51
        dw 90,52
        dw 92,52
        dw 93,53
        dw 95,54
        dw 97,55
        dw 98,56
        dw 100,57
        dw 102,58
        dw 104,59
        dw 106,60
        dw 108,62
        dw 110,63
        dw 112,64
        dw 114,65
        dw 117,67
        dw 119,68
        dw 122,70
        dw 124,71
        dw 127,73
        dw 130,74
        dw 133,76
        dw 137,78
        dw 140,80
        dw 144,82
        dw 147,84
        dw 151,86
        dw 156,89
        dw 160,91
        dw 165,94
        dw 170,97
        dw 175,100
        dw 181,103
        dw 187,107
        dw 193,110
        dw 200,114
        dw 207,119
        dw 215,123
        dw 224,128
        dw 233,133
        dw 243,139
        dw 255,145
        dw 267,152
        dw 280,160
        dw 295,168
        dw 311,178
        dw 329,188
        dw 350,200
        dw 373,213
        dw 400,229
        dw 431,246
        dw 467,267
        dw 509,291
        dw 560,320
        dw 622,356
        dw 700,400
        dw 800,457
        dw 933,533
        dw 1120,640
        dw 1400,800
        dw 1867,1067
        dw 2800,1600
        dw 5600,3200
TABLEN 	equ $-TAB

.code		
		push	@data
		pop	ds
		mov 	ax,0a000h	; screen -> A000:0000
		mov	es,ax		; ES-ben t?rolva
		call	CONVERT
		mov	ax,13h		; 320x200x256 - as m?d
		int	10h
		call	PALETTE		
		call	PUTTEXT
		
		mov	bx,offset TAB
		mov	cx,TABLEN
		shr	cx,2
MORE:		push	cx
		mov	ax,word ptr ds:[bx]
		mov	word ptr ds:[ZOMWDTH],ax
		add	bx,2
		mov	ax,word ptr ds:[bx]
		mov	word ptr ds:[ZOMHGTH],ax
		add	bx,2		
		mov	dx,3dah
VR:		in 	al,dx
		and 	al,8
		jz	VR
		push	bx
		call	SETUPZ
		call	BLUR
		call	ZOOM
		pop	bx
		pop	cx
		loop	MORE
		mov	cx,0
Warj:		push	cx
		mov	cx,300
Wargya:		loop	Wargya
		pop	cx
		loop	Warj
;--------------------------------------------------------------------------
DOSQUIT:	mov	ax,03h
		int	10h
		mov	ax,4c00h
		int	21h
;-------------------------------------------------------------------------
;-- ZOOMER rutin be?ll?tgat?sa a m?retek szerint [ZOOMWDTH ?s ZOOMHGTH] --
;-------------------------------------------------------------------------
SETUPZ:		push	@data
		pop	ds
		mov	cx,TXTWDTH
		xor	dh,dh
		xor	al,al
		mov	dl,ch
		mov	ah,cl			   ; DX:AX := CX*10h
		mov	bx,word ptr ds:[ZOMWDTH]
		div	bx			   ; zoom-olt m?rettel oszt?s
		mov	byte ptr cs:[modify1+2],al ; 
		mov	byte ptr cs:[modify3+2],ah ; 
	
		mov	cx,TXTHGTH
		xor	dh,dh
		xor 	al,al
		mov	dl,ch
		mov	ah,cl
		mov	bx,word ptr ds:[ZOMHGTH]
		div	bx			   ; AX-ben a f?gg?leges adder
		mov	byte ptr cs:[modify2+2],al ;
		mov	byte ptr cs:[modify4+1],ah ; ... a megfelel? helyre.
	
		mov	ax,SCRWDTH
		mov	bx,word ptr ds:[ZOMWDTH]   ; vajon nagyobb-e a zoom,
		cmp	ax,bx			   ; mint maga a screen?
		jg	VEKONY			   ; ha nem, ugr?s!
		; ELLENKEZ? ESETBEN ITT A MEGOLD?S 
		mov	word ptr cs:[modify5+2],0  ; teh?t teljesen balr?l...
		mov	word ptr cs:[modify8+1],SCRWDTH ; ...tot?l v?gig...
		mov	word ptr cs:[modifyd+2],0  ; rajzolja
		mov	ax,word ptr ds:[ZOMWDTH]
		mov	bx,SCRWDTH
		sub	ax,bx		; A teljes ZOOMolt k?p?b?l kivonva a 
		shr	ax,1		; k?p teljes m?ret?t pixelben a kilog?
					; pixelek sz?m?t 'kapjuk', ennek fele
					; l?g ki balra.
		xor	dh,dh
		mov	dl,ah
		mov	ah,al
		xor	al,al		
		mov	bx,word ptr ds:[ZOMWDTH] ; A kil?g? r?sz ?gy ar?nylik
		div	bx			 ; a teljes ZOOM sz?less?ghez,
		mov	bx,TXTWDTH 		 ; mint a kezd?l?ket a text?ra
		mul 	bx			 ; sz?less?g?hez.
		mov	byte ptr cs:[modify9+1],al ; EZ az adder kezd??rt?ke
		mov	byte ptr cs:[modifyb+2],ah ; Ezt meg a c?mhez kell 
		mov	byte ptr cs:[modifyb+3],dl ; adni egy?bk?nt is.
		jmp	COMPLETE1

VEKONY:		mov	ax,SCRWDTH
		mov	bx,word ptr ds:[ZOMWDTH] ; SCR-ZOOMED: ennyit kell
		sub	ax,bx			 ; adni minden sor v?g?n DI-
		mov	word ptr cs:[modifyd+2],ax ; -hez, az ?j sorbal?p?shez.
		shr	ax,1 			 ; A fel?t meg kezd?skor kapja
		mov	word ptr cs:[modify5+2],ax ; DI pluszba.
		mov	ax,word ptr ds:[ZOMWDTH] ; Ilyenkor persze a sz?less?g
		mov	word ptr cs:[modify8+1],ax ; adott...

COMPLETE1:
		mov	ax,SCRHGTH
		mov	bx,word ptr ds:[ZOMHGTH]
		cmp	ax,bx		
		jg	VEKONY2	
	;---ha mar tulnotte fuggolegesbe....
		mov	word ptr cs:[modify6+1],0
		mov	word ptr cs:[modify7+1],scrhgth
		mov	ax,word ptr ds:[ZOMHGTH]
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
		jmp	COMPLETE2

VEKONY2:	mov	ax,SCRHGTH
		mov	bx,word ptr ds:[ZOMHGTH]
		sub	ax,bx
		shr	ax,1
		mov	word ptr cs:[modify6+1],ax
		mov     ax,word ptr ds:[zomhgth]
		mov	word ptr cs:[modify7+1],ax
COMPLETE2:	ret

;-----------------------------------------------------------------------------
ZOOM:
		lea	si,SECSCR		; text?ra kezdete...
modifyb:	add	si,word ptr 0		; + a kezd? x koordin?ta...
modifyc:	mov 	cx,0
		cmp	cx,0
		je	goahead
lna:		add	si,word ptr TXTWDTH	; ?s m?g textsz?less?gszer
		loop 	lna			; a kezd? y koordin?ta.
goahead:	mov	word ptr ds:[MEM],si	; akkor el is mentj?k k?s?bbre.
		mov	di,0			; balfels? cs?cske a szkr?nnek
modify5:	add	di,word ptr 0		; mega kezd?k?pikszkoordin?ta.
modify6:	mov	cx,0			; nomegaz y k?psz.-el fel*va
		cmp	cx,0
		je	modify9			; ha fentr?l kezd?dik a zoom
anl:		add	di,word ptr SCRWDTH
		loop	anl			; k?l?nben ugrik CX sort lefele
modify9:
		mov	dh,00h			; v?zszintes sz?ml?l? kezd??rt. 
modifya:	mov	dl,00h			; f?gg. sz?ml?l? kezd??rt?ke
modify7:	mov	cx,200
loop_loc5:	push	cx
modify8:	mov	cx,320
		mov	dh,00h			; horiz. counter
loop_loc6:	mov	al,byte ptr [si]	; pont m?sol?sa
		mov	byte ptr es:[di],al
modify1:	add	dh,80h			; vsz. sz?ml?l? n?vel?se
modify3:	adc	si,word ptr 0		; ha volt csuri, akkor az is
						; megy si-hez (m?rmint 1).
		inc	di			; k?v. pixel...
		loop	loop_loc6
modifyd:	add	di,word ptr 0		; teljes k?perny?n?l 0.
		mov	si,word ptr ds:[MEM]	; SI vissza
modify4:	mov 	cx,1			; ennyi sort ugrik a tex?r?ban
		cmp	cx,0			; alapban.
		je	modify2
ideloop:	add 	si,word ptr TXTWDTH
		loop	ideloop			
modify2:	add	dl,80h			; ha csuri, m?g 1 sort ugrik!
		jc	loc1
		jmp	loc2
loc1:		add	si,word ptr TXTWDTH
loc2:		mov	word ptr ds:[MEM],si	; mindenesetre most SI ment?dik
		pop	cx
		loop	loop_loc5
		ret

;--------------------------------------------------------------------------
PUTTEXT:	push	es
		push	ds
		pop	es
		mov	bx,offset SZOVEG
		mov	di,(TXTWDTH*70)+14+offset SECSCR

NEXTCHAR:	push	di
		mov	al,byte ptr ds:[bx]
		inc	bx
		or	al,al
		jz	ENDOFTEXT

		sub	al,32
		xor	ah,ah
		mov	cx,400
		mul	cx
		mov	si,offset CHARSET
		add	si,ax
		cld
		mov	cx,20
NEXTSOR:	push	cx

		mov	cx,10
		rep	movsw
		
		add	di,TXTWDTH-20
		pop	cx
		loop	NEXTSOR
		
		pop	di
		add	di,21
		jmp	NEXTCHAR		

ENDOFTEXT:	pop	di
		pop	es
		ret

;--------------------------------------------------------------------------
BLUR:		push	es
		push	5000h
		pop	es
		xor	si,si			; source of bitmap
		xor	di,di
		mov	cx,TXTWDTH*TXTHGTH/2	; and the length...
		rep	movsw			; zzaap!
		mov	bx,TXTWDTH+1
		mov	cx,TXTHGTH-2
NEXTROW:	push	cx
		mov	cx,TXTWDTH-2
NXTPIX:		xor	ax,ax
		mov	al,es:[bx-TXTWDTH]
		add	al,es:[bx-1]
		adc	ah,0
		add	al,es:[bx]
		adc	ah,0
		add	al,es:[bx+1]
		adc	ah,0
		add	al,es:[bx+TXTWDTH]
		adc	ah,0
		mov	dl,5
		div	dl
		mov	byte ptr ds:[bx],al
		inc	bx
		loop	NXTPIX
		pop	cx
		add	bx,2
		loop	NEXTROW
		pop	es
		ret	


		
;--------------------------------------------------------------------------
CONVERT:	mov	bx,offset CHARSET
		mov	cx,LNGSET
KOVETKEZO:	mov	al,byte ptr ds:[bx]
		cmp	al,'.'
		jne	NEMPOTTY
		mov	byte ptr ds:[bx],0
		jmp	POTTYVOLT
NEMPOTTY:	mov	byte ptr ds:[bx],255
POTTYVOLT:	inc	bx
		loop	KOVETKEZO
		ret

;--------------------------------------------------------------------------
PALETTE:	mov	al,0
		mov	dx,3c8h
		out	dx,al
		mov	dx,3c9h
		mov	cx,256
NXP:		mov	al,0
		sub	al,cl
		shr	al,2
		out	dx,al
		out	dx,al
		out	dx,al
		loop	NXP
		ret
;--------------------------------------------------------------------------
KEYS:		mov	ah,1
		int 	16h
		jnz	CHANGE
		ret
CHANGE:		
		xor	ah,ah
		int 	16h
		cmp	al,1bh
		jne	NOTESC
		jmp	DOSQUIT
NOTESC:		cmp	ax,5000h
		jne	NOTDOWN
		add	word ptr ds:[ZOMWDTH],4
		add	word ptr ds:[ZOMHGTH],4
NOTDOWN:	cmp	ax,4800h
		jne	NONE
		sub	word ptr ds:[ZOMWDTH],6
		sub	word ptr ds:[ZOMHGTH],6
NONE:		
		ret

;----------------------------------------------------------------------------

end


