; ********************************* 
; ** A grafikus k?perny? m?retei ** 
; ********************************* 
SCR_WIDTH       equ     1024            ; X
SCR_HEIGTH      equ     768             ; Y

; *********************************************************** 
; ** H?nyszor h?nyas a t?rk?p cell?kban? Max. 24x18 lehet. ** 
; *********************************************************** 
TERKEPMERETX    equ     11
TERKEPMERETY    equ     13

; ********************************** 
; ** Az eg?r indul?si koordin?t?i ** 
; ********************************** 
STARTEGERX      equ     512
STARTEGERY      equ     384

; ************************ 
; ** Az eg?r mozg?stere ** 
; ************************ 
EGERXMIN        equ     0
EGERXMAX        equ     SCR_WIDTH*4-1
EGERYMIN        equ     0
EGERYMAX        equ     SCR_HEIGTH*4-1  

; **************************** 
; ** Ennyi EMS mem?ria kell ** 
; **************************** 
MEMORYNEEDED    equ     1024+530

; ***************************************************** 
; ** Mag?nak a t?rk?pdarabnak a k?perny?n a helye... ** 
; ** Balfels? sarok                                  ** 
; ***************************************************** 
TERKEPKEZD_X    equ     25
TERKEPKEZD_Y    equ     25       

; ******************************************** 
; ** ?s ekkora egy kocka (cella) pixelekben ** 
; ******************************************** 
EGYKOCKA_X      equ     40
EGYKOCKA_Y      equ     40

; *************************************************************
; ** Enn?l feljebb ne akarjon senki sem lapozni EMS-t itten! **
; *************************************************************
MAXMAPLAP       equ     33