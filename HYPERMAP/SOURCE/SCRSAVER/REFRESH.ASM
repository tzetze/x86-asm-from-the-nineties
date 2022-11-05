RefreshScr	PROC NEAR
	mov	ax,0
	call	BankSwitch
	call	DrwKeret
	call	CoordBoxes
	call	Do_Terrains
	call	DrawMatrix
	call	Jelol
	call	EgerBe
	ret
RefreshScr	ENDP
