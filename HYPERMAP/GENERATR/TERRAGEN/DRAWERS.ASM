;===========================================================================
; Lekonvert†lja 0-15 sz°nekre a terrains.dat tartalm†t.
;===========================================================================
Convert_Terrains PROC NEAR
                mov     bx,offset terra_in      ; Terrain kÇpek
                mov     cx,40*40*15             ; 15 darab 40x4-es terrain
                                                ; van.
KonviTerra:     mov     ah,byte ptr ds:[bx]
                cmp     ah,"a"
                jge     Kisbetus
                sub     ah,"A"                  ; ha nagybetÅs volt, "A"-t
                mov     byte ptr ds:[bx],ah     ; kell levonni
                jmp     Nagyvolt
Kisbetus:       sub     ah,"a"                  ; ha kisbetÅs volt, "a"-t
                mov     byte ptr ds:[bx],ah     ; kell levonni
Nagyvolt:       inc     bx                      ; mutat¢ nîv.
                loop    KonviTerra              ; next karakter
		ret
Convert_Terrains ENDP

;===========================================================================
;Lekonvert†lja 0-15 sz°nekre az item.dat tartalm†t.
;===========================================================================
Convert_Items	PROC NEAR
                mov     bx,offset ItemDat 	; Terrain kÇpek
                mov     cx,33*15*20             ; 20 darab 31x13-as item
                                                ; van.
KonvItem:	mov     ah,byte ptr ds:[bx]
                cmp     ah,"a"
                jge     KicsiBetu
                sub     ah,"A"                  ; ha nagybetÅs volt, "A"-t
                mov     byte ptr ds:[bx],ah     ; kell levonni
                jmp     Nagybetu
Kicsibetu:  	sub     ah,"a"                  ; ha kisbetÅs volt, "a"-t
                mov     byte ptr ds:[bx],ah     ; kell levonni
Nagybetu:       inc     bx                      ; mutat¢ nîv.
                loop    KonvItem		; next karakter
		ret
Convert_Items	ENDP

