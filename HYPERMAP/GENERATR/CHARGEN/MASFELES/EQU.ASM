; ********************************* 
; ** A grafikus kÇpernyì mÇretei ** 
; ********************************* 
SCR_WIDTH       equ     1024            ; X
SCR_HEIGTH      equ     768             ; Y

; *********************************************************** 
; ** H†nyszor h†nyas a tÇrkÇp cell†kban? Max. 24x18 lehet. ** 
; *********************************************************** 
TERKEPMERETX    equ     11
TERKEPMERETY    equ     13

; ********************************** 
; ** Az egÇr indul†si koordin†t†i ** 
; ********************************** 
STARTEGERX      equ     512
STARTEGERY      equ     384

; ************************ 
; ** Az egÇr mozg†stere ** 
; ************************ 
EGERXMIN        equ     0
EGERXMAX        equ     SCR_WIDTH*4-1
EGERYMIN        equ     0
EGERYMAX        equ     SCR_HEIGTH*4-1  

; **************************** 
; ** Ennyi EMS mem¢ria kell ** 
; **************************** 
MEMORYNEEDED    equ     1024+530

; ***************************************************** 
; ** Mag†nak a tÇrkÇpdarabnak a kÇpernyìn a helye... ** 
; ** Balfelsì sarok                                  ** 
; ***************************************************** 
TERKEPKEZD_X    equ     25
TERKEPKEZD_Y    equ     25       

; ******************************************** 
; ** ês ekkora egy kocka (cella) pixelekben ** 
; ******************************************** 
EGYKOCKA_X      equ     40
EGYKOCKA_Y      equ     40

; *************************************************************
; ** EnnÇl feljebb ne akarjon senki sem lapozni EMS-t itten! **
; *************************************************************
MAXMAPLAP       equ     33