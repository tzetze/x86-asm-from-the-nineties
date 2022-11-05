; RealTime Interactive 3D rendered mouse runtime library
; for 1024x768 felbontash. By CECE 1997 m†rcius-†prilis
;-----------------------------------------------------------------------
; EGERINIT : Az eger inicializ†lsa, hiba esetÇn pedig kilÇpÇs.
;            Nincs paramÇtere
;-----------------------------------------------------------------------
EgerInit:	push	@data		; DS = dataseg. a szîvegek
		pop	ds		; miatt...
		xor	ax,ax
		int	33h		; EgÇr reset.
		cmp	ax,0		; Ha AX=0, rendben az inic.
		jnz	okEger
		mov	ah,9
		lea	dx,MOU_ERRTXT1	; kÅlînben k†romkod†s + kilÇpÇs
		int	21h
		mov	ax,4c01h
		int	21h

okEger:		mov	ah,9
		lea	dx,MOU_RDYTXT1
		int	21h
		ret
;-----------------------------------------------------------------------
; INITCIN : A Cece-fÇle grafikus renderelt :) egÇr kÇsìbbi mñkîdÇsÇhez
;           szÅksÇges teendìk, azaz a egÇr startoltat†sa egy adott
;           poz°ci¢n, de elìtteis az ottani kÇpernyìrÇszlet mentegetÇse.
;           Nem kell neki paramÇter, csak a STARTEGERX-Y konstansok.
;-----------------------------------------------------------------------
InitCin:	push	@data
		pop	ds
		mov	cx,STARTEGERX
		mov	dx,STARTEGERY
		add	cx,1
		mov	word ptr ds:[ElozoEgerX],cx
		mov	word ptr ds:[ElozoEgerY],dx
		mov	ax,SCR_WIDTH
		mul	dx
		add	ax,cx
		adc	dx,0
		mov	di,ax
		mov	ax,dx
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch
		call	CinCin				; a mentÇs maga
		ret
;-----------------------------------------------------------------------
; ELMENT : A menet kîzbeni mentegetì. Az InitCin p†rja.
;-----------------------------------------------------------------------
Elment:		mov	word ptr ds:[ElozoEgerX],cx
		mov	word ptr ds:[ElozoEgerY],dx
		mov	ax,SCR_WIDTH
		mul	dx
		add	ax,cx
		adc	dx,0
		mov	di,ax
		mov	ax,dx
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch
		call	CinCin
		ret
;-----------------------------------------------------------------------
;ELOZOTOROL : Az elmentett kÇpernyìrÇsz vissza†ll°t†sa, Çs °gy a
;             renderelt :) egerpolyinter tîrlÇse a rÇgi helyÇrìl.
;             ParamÇter minek
;-----------------------------------------------------------------------
ElozoTorol:	mov	cx,word ptr ds:[ElozoEgerX]
		mov	dx,word ptr ds:[ElozoEgerY]
		mov	ax,SCR_WIDTH
		mul	dx
		add	ax,cx
		adc	dx,0
		mov	di,ax
		mov	ax,dx
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch
		call	NicNic
		ret
;-----------------------------------------------------------------------
;CINCIN : CinCin felelìs a kÇpernyìrìl az †tmeneti pufferbe val¢
;         mentÇsÇrt. Mentì Çs inicializ†l¢rutinok szeretik.
;-----------------------------------------------------------------------
CinCin:		push	@data
		pop	ds
		push	0a000h
		pop	es
		lea	si,EgerTorol
		mov	cx,33
VisszSor:	push	cx
		mov	cx,20
VisszOszlop:	mov	ah,byte ptr es:[di]
		mov	byte ptr ds:[si],ah
		inc	si
		inc	di
		jz	OuttaHere06
StayIn06:	loop	VisszOszlop
		add	di,SCR_WIDTH-20
		jc	OuttaHere07
StayIn07:	pop	cx
		Loop	VisszSor
		ret

OuttaHere06:	call	SwapUp
		jmp	StayIn06
OuttaHere07:	call	SwapUp
		jmp	StayIn07

;-----------------------------------------------------------------------
;NICNIC : NÇha vissza is kell tîlteni a mentett kÇprÇszletet, ehhez
;         val¢ NicNic. Hatalmas îtlet, Çs szipork†z¢an tal†l¢, hogy
;         ha megfigyeli az ember CinCin Çs NicNic neve Çs a mñkîdÇse
;	  kîzti kapcsolatot :))))))))))
;-----------------------------------------------------------------------
NicNic:		push	@data
		pop	ds
		push	0a000h
		pop	es
		lea	si,EgerTorol
		mov	cx,33
VisszaSor:	push	cx
		mov	cx,20
VisszaOszlop:	mov	ah,byte ptr ds:[si]
		mov	byte ptr es:[di],ah
		inc	si
		inc	di
		jz	OuttaHere08
StayIn08:	loop	VisszaOszlop
		add	di,SCR_WIDTH-20
		jc	OuttaHere09
StayIn09:	pop	cx
		Loop	VisszaSor
		ret

OuttaHere08:	call	SwapUp
		jmp	StayIn08
OuttaHere09:	call	SwapUp
		jmp	StayIn09

;-----------------------------------------------------------------------
;EGERABLAK : A konstansok alapj†n be†ll°tja az egÇr mozg†sterletÇt.
;-----------------------------------------------------------------------
EgerAblak:	mov	cx,EGERXMIN
		mov	dx,EGERXMAX
		mov	ax,7
		int	33h
		mov	cx,EGERYMIN
		mov	dx,EGERYMAX
		mov	ax,8
		int	33h
		ret
;-----------------------------------------------------------------------
;STARTEGER :  Megadja az egermeghajt¢nak a kezdì koordin†t†kat a konstansok
;             alapj†n, valamint be†ll°tja az ÇrzÇkenysÇget.
;-----------------------------------------------------------------------
StartEger:	mov	cx,STARTEGERX*4
		mov	dx,STARTEGERY*4
		mov	ax,4
		int	33h
		mov	ax,0fh
		mov	cx,1
		mov	dx,1
		int	33h
		ret
;-----------------------------------------------------------------------
;EGERKOORD : Visszaadja az egÇr akt. koordin†t†it CX,DX-ben, kompenz†lva.
;-----------------------------------------------------------------------
EgerKoord:	mov	ax,3
		int	33h
		shr	cx,2
		shr	dx,2
		ret
;-----------------------------------------------------------------------
;DRAWEGER : Ilyen is van! Kirajzolja az egeret a helyÇre, amit mag†t¢l
;           beÇrzÇkel :) Persze elìtte tîrli az elìzìt Çs elmenti a
;           jelenlegi h†tterÇt...
;-----------------------------------------------------------------------
DrawEger:	push	@data
		pop	ds
		call	EgerKoord
		mov	word ptr ds:[TarCX],cx
		mov	word ptr ds:[TarDX],dx
		cmp	cx,word ptr ds:[ElozoEgerX]
		jnz	Mozgott
		cmp	dx,word ptr ds:[ElozoEgerY]
		jnz	Mozgott
		ret

		; ide csak akkor jut el, ha bizerg†lod az egeret.
Mozgott:	call	InitSaverTime
		call	EgerKi
		mov	cx,word ptr ds:[TarCX]
		mov	dx,word ptr ds:[TarDX]
MentRajzol:	mov	word ptr ds:[TarCX],cx
		mov	word ptr ds:[TarDX],dx
		call	Elment
		mov	cx,word ptr ds:[TarCX]
		mov	dx,word ptr ds:[TarDX]
		mov	ax,SCR_WIDTH
		mul	dx
		add	ax,cx
		adc	dx,0
		mov	di,ax
		mov	ax,dx
		mov	word ptr ds:[act_bank],ax
		call	BankSwitch
		push	@data
		pop	ds
		push	0a000h
		pop	es
		lea	si,EgerForma1
		mov	cx,33
EgerSor:	push	cx
		mov	cx,20
EgerOszlop:	mov	ah,byte ptr ds:[si]
		cmp	ah,0
		jz	Semmi
		mov	byte ptr es:[di],ah
Semmi:		inc	si
		inc	di
		jnz	Assem
		mov	ax,word ptr ds:[act_bank]
		inc	ax
		mov	word ptr ds:[act_bank],ax
		call	Bankswitch
Assem:		loop	EgerOszlop
		add	di,SCR_WIDTH-20
		jnc	NoHappen
		mov	ax,word ptr ds:[act_bank]
		inc	ax
		mov	word ptr ds:[act_bank],ax
		call 	bankswitch
NoHappen:	pop	cx
		Loop	EgerSor
		ret

;-----------------------------------------------------------------------
;EGERKI : NÇhanapj†n ki kell †m kapcsolni is az egerpointert!
;-----------------------------------------------------------------------
EgerKi:		push	@data
		pop	ds
		call	ElozoTorol
		ret
;-----------------------------------------------------------------------
;EGERBE : Azt†n egyszercsak bekell...
;-----------------------------------------------------------------------
EgerBe:		push	@data
		pop	ds
		mov	cx,word ptr ds:[ElozoEgerX]
		mov	dx,word ptr ds:[ElozoEgerY]
		call	MentRajzol
		ret
;-----------------------------------------------------------------------
;BALGOMB : Balgomb lenyom¢dotts†g†nak ÇrzÇkelÇse. Ha igen, CF=1 
;          ellenkezì esetben CF=0. M†s eset nincs!
;-----------------------------------------------------------------------         
BalGomb:	mov	ax,3
		int	33h
		rcr	bx,1
		ret
;-----------------------------------------------------------------------
;JOBBGOMB : Jobbgomb lenyom¢dotts†g†nak ÇrzÇkelÇse. Ha igen, CF=1 
;           ellenkezì esetben CF=0. M†s eset nincs!
;-----------------------------------------------------------------------         
JobbGomb:	mov	ax,3
		int	33h
		rcr	bx,2
		ret
