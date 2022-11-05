;
;       …ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
;       ∫                                            ∫
TITLE   ∫ SOUNDBLASTER 16 MODPLAYER  (SB 16 & COMP.) ∫
;       ∫                                            ∫
;       »ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº
;
; THIS MODULE PLAYER WAS CODED IN EARLY 1995
;
;                        BY SILVIO TURELLO (FRONTMAN/CREW242)
;
; PC-CONVERSION OF AMIGA PROTRACKER CODE (FOR SUPER PRO PLAY > MODLIB)
;
;                        BY JOSHUA C. JENSEN (CYBERSTRIKE/FORM. RENAISSANCE)
;
; ORIGIN SOURCE CODE CAME FROM THE PROTRACKER V2.1A
;
;                        BY LARS "ZAP" HAMRE (AMIGA FREELANCERS)
;
; FEATURES: 4/8-CHANNEL-MODS (M.K./FLT4/FLT8/8CHN), 8-FX-CHANNELS (PC/AMIGA)
;
;           8/16 BIT, 10000-44100 HZ, STEREO PANNING E8x, 16 BIT INTERPOLATION
;
;           AMPLIFIED MIXING, FULL MOD-FX SUPPORT EXCEPT FILTER & REVERSE FUNK
;
;           592 KB EMS-MEMORY SUPPORT FOR FX, EMS BUFFERED TRACKTABLE
;
;           THIS ROUTINE NEEDS A REALLY FAST CPU TO HANDLE 16 CHANNELS!
;
; MEMORY:   11K CODE, 32K MIXBUF, 32K VOLTABLE, 0-???K SAMPLES
;
.ALPHA
.MODEL MEDIUM
.STACK
COM_OR_OBJ	= 0
STACKLENGTH     = 0100H
UGROUP2 GROUP CODE_SEG2, DATA_SEG2
ASSUME CS:UGROUP2, DS:UGROUP2, SS:UGROUP2
;=============================================================================
MAX_CHAN_NUMB	= 8
FX_CHAN_NUMB	= 8
IRQ1            = 20H
IRQ2		= 21H
IRQ3		=0A0H
IRQ4		=0A1H
TIMER0		= 40H
PIT1            = 43H
UHR_INDEX	= 70H
UHR_PORT	= 71H
UHR_STATA	= 0AH
UHR_STATB	= 0BH
UHR_STATC	= 0CH
;-----------------------------------------------------------------------------
DATA_SEG2 SEGMENT WORD ;USE16
PROG_START_SEG  DW 0
PROG_END_SEG    DW 0
IF COM_OR_OBJ
VAR_BUFSEG	DW 0
ELSE
VAR_BUFSEG	DW 8000H
ENDIF
SYSTEM		DB 0
IRQCOUNT	DB 56
SB_MODUS	DB 0		;0=MUSIC&FX, 1=MUSIC, 2=FX, 3=NO_SOUND
CD_MIXER	DB 0		;0=MODULES ONLY, 1=CD MIXED
IRQ_REENTER	DW 0
LOADMOD_FLAG	DB 0
PAN_FX		DB 0		;FLIP SAMPLE CHANNEL
SAM_FLAG1	DB 0
SAM_CH		DB 0
SAMPLE_RATE	DW 22222
SBP_MIXERI	DW 0224H
SBP_MIXERD	DW 0225H
SB_RESET	DW 0226H
SB_READ		DW 022AH
SB_WRITE	DW 022CH
SB_RSTAT	DW 022EH
IRQ_NUMBER	DB 7
DMA_CHANNEL	DB 1
DMA_POFF	DW 0
MAINFREQ	DD 0
DMA_CX		DW 0
DMA_MORE	DW 0
DMA_MAX		DW 0
DMA_NEWPTR	DW 0
DMA_PTR		DW 0
DMA_SEG		DW 0
DMA_OFFSET	DW 0
MIXMUL_OFFSET	DW 0
COMP_SPEED2     DW 0106H
COMP_SPEED3     DW 4006H
COMP_SPEED4     DW 0
COMP_SPEED5     DW 1165
HOLD70  LABEL   DWORD
		DW OFFSET TIMER_HANDLER, 0
HOLDSB  LABEL   DWORD
		DW OFFSET SBIRQ_HANDLER, 0
PAN_REGS	DB 3,12,12,3,3,12,12,3
PANNINGL	DW 256,256,256,256,248,240,232,224,208,192,176,160,128,096,064,032
PANNINGR	DW 032,064,096,128,160,176,192,208,224,232,240,248,256,256,256,256
DMA_ADR		DB 0,2,4,6,0C0H,0C4H,0C8H,0CCH
DMA_CNT		DB 1,3,5,7,0C2H,0C6H,0CAH,0CEH
DMA_PAGE	DB 87H,83H,81H,82H,8FH,8BH,89H,8AH
DMA_MASK	DB 0AH,0AH,0AH,0AH,0D4H,0D4H,0D4H,0D4H
DMA_MOD		DB 0BH,0BH,0BH,0BH,0D6H,0D6H,0D6H,0D6H
DMA_FLIP	DB 0CH,0CH,0CH,0CH,0D8H,0D8H,0D8H,0D8H
;-----------------------------------------------------------------------------
GDDLENGTH	DD 0
GDDREST		DW 0
GDDHANDLE	DW 0
GDDZEIG		DB 0
SONG_START	DB 0
;-----------------------------------------------------------------------------
ERROR1_TEXT	DB "MOD ERROR",13,10,"$"
ERROR2_TEXT	DB "FX ERROR",13,10,"$"
ERROR3_TEXT	DB "SB ERROR",13,10,"$"
OUT_TEXT	DB "+/- VOLUME",13,10
		DB "1   PLAY SAMPLE",13,10
		DB "9   INIT REPEAT",13,10
		DB "0   MUSIC MODE",13,10,"$"
SAMPLE_NAME	DB "SAMPLE1.SAM",0
CONFIG_NAME     DB "SS3.CFG",0
CFG_TEXT2       DB "DEFAULT MUSIC MODE = ",0
CFG_TEXT3       DB "SOUNDCARD BASE PORT = ",0
CFG_TEXT4       DB "SOUNDCARD IRQ NUMBER = ",0
CFG_TEXT5       DB "SOUNDCARD DMA NUMBER = ",0
CFG_TEXT6       DB "DEFAULT SAMPLINGRATE = ",0
CFG_TEXT7       DB "SYSTEM COMPATIBILITY = ",0
;-----------------------------------------------------------------------------
; PLAYER - KONTROLLSTRUKTUREN
;-----------------------------------------------------------------------------
ALIGN 2
MUSIC_VOL	DB 255
MUSIC_VOLUME	DB 255
FX_VOL		DB 255
FX_VOLUME	DB 255
MASTER_VOLUME	DB 255
MOD_STAT	DB 0
BPM_RATE	DW 1024
BPM_VALUE	DW 125
BPM_COUNT	DD 0
BPM_SPEED	DD 0
CH_NUMB		DW 4
QUEUE_BUFFER	LABEL	WORD		;256 BYTES
NOTE		DW MAX_CHAN_NUMB DUP(0)
CMD		DB MAX_CHAN_NUMB DUP(0)
CMDLO		DB MAX_CHAN_NUMB DUP(0)
START		DW MAX_CHAN_NUMB DUP(0)
LENGTHI		DW MAX_CHAN_NUMB DUP(0)
LOOPSTART	DW MAX_CHAN_NUMB DUP(0)
REPLEN		DW MAX_CHAN_NUMB DUP(0)
PERIOD		DW MAX_CHAN_NUMB DUP(0)
FINETUNE	DB MAX_CHAN_NUMB DUP(0)
VOLUME		DB MAX_CHAN_NUMB DUP(0)
TONEPORTDIREC	DB MAX_CHAN_NUMB DUP(1)
TONEPORTSPEED	DB MAX_CHAN_NUMB DUP(0)
WANTEDPERIOD	DW MAX_CHAN_NUMB DUP(0)
VIBRATOCMD	DB MAX_CHAN_NUMB DUP(0)
VIBRATOPOS	DB MAX_CHAN_NUMB DUP(0)
TREMOLOCMD	DB MAX_CHAN_NUMB DUP(0)
TREMOLOPOS	DB MAX_CHAN_NUMB DUP(0)
WAVECONTROL	DB MAX_CHAN_NUMB DUP(0)
GLISSFUNK	DB MAX_CHAN_NUMB DUP(0)
SAMPLEOFFSET	DB MAX_CHAN_NUMB DUP(0)
PATTPOS		DB MAX_CHAN_NUMB DUP(0)
LOOPCOUNT	DB MAX_CHAN_NUMB DUP(0)

MPANNING	DB MAX_CHAN_NUMB DUP(0)
MFREQ		DW MAX_CHAN_NUMB DUP(0)
MFIXED		DW MAX_CHAN_NUMB DUP(0)
MOFLOW		DW MAX_CHAN_NUMB DUP(0)
SONG_DATA	LABEL	BYTE		;128 BYTES
MVOL		DB MAX_CHAN_NUMB DUP(0)
MSEG		DW MAX_CHAN_NUMB DUP(0)
MOFS		DW MAX_CHAN_NUMB DUP(0)
MREPEAT		DW MAX_CHAN_NUMB DUP(0)
MREPLEN		DW MAX_CHAN_NUMB DUP(0)
MMAXREP		DW MAX_CHAN_NUMB DUP(0)
MOD_NAME	DB 94 DUP(0)			; Ide kerÅl az 1. paramÇtere az exe-nek,
									; ha az helyes file-nÇv volt.
;-----------------------------------------------------------------------------
; Seg                           Stores the segment of the current sample.  If
;                               the segment is zero, then there is no sample
;                               begin played.
; Offset                        The current offset of the sample being played
;                               in the segment specified.
; MaxRep                        The offset of the place in the sample to
;                               repeat from (i.e. the end of the sample).
; Freq                          The frequency to be played out the output
;                               device.  It is actually a playback period,
;                               the upper byte determining the number of
;                               bytes to be added to the sample offset each
;                               interrupt, and the lower byte to be added
;                               over and over to generate carry flags to be
;                               added to additional offsets.
; Vol                           The actual volume to multiply the frequency
;                               by.
; Repeat                        The place to repeat from when the end of the
;                               loop is found.
; RepLen                        The number of bytes from Repeat to go to.
;                               When the end of this is found, it goes back
;                               to Repeat.
; OFlow                         The overflow variable used to generate the
;                               carry flags.
;-----------------------------------------------------------------------------
; PROTRACKER VARIABLEN
;-----------------------------------------------------------------------------
ALIGN 2
MT_SPEED                DB 6
MT_COUNTER              DB 0
MT_PATTERNPOS           DW 0
MT_SONGPOS              DB 0
MT_PATTDELAYTIME2       DB 0
MT_PATTDELAYTIME        DB 0
MT_PBREAKFLAG           DB 0
MT_PBREAKPOS            DB 0
MT_POSJUMPFLAG          DB 0
MT_LOWMASK              DB 0FFH

ALIGN 2
Effect_Jump_Table1	LABEL	WORD
DW OFFSET Go_Arpeggio, OFFSET Go_PortaUp, OFFSET Go_PortaDown
DW OFFSET Go_TonePortamento, OFFSET Go_vibrato, OFFSET Go_TonePlusVolSlide
DW OFFSET Go_VibratoPlusVolSlide, OFFSET Go_Tremolo, OFFSET Go_Return
DW OFFSET Go_Return, OFFSET Go_VolumeSlide, OFFSET Go_Return, OFFSET Go_Return
DW OFFSET Go_Return, OFFSET Go_E_Commands, OFFSET Go_Return

Effect_Jump_Table2	LABEL	WORD
DW OFFSET Go_PerNop, OFFSET Go_PerNop, OFFSET Go_PerNop
DW OFFSET Go_PerNop, OFFSET Go_PerNop, OFFSET Go_PerNop
DW OFFSET Go_PerNop, OFFSET Go_PerNop, OFFSET Go_PerNop
DW OFFSET Go_SampleOffset, OFFSET Go_PerNop, OFFSET Go_PositionJump
DW OFFSET Go_VolumeChange, OFFSET Go_PatternBreak
DW OFFSET Go_E_Commands, OFFSET Go_SetSpeed

Effect_Jump_Table3	LABEL	WORD
DW OFFSET Go_Return, OFFSET Go_FinePortaUp, OFFSET Go_FinePortaDown
DW OFFSET Go_SetGlissControl, OFFSET Go_SetVibratoControl
DW OFFSET Go_SeTFineTune, OFFSET Go_JumpLoop, OFFSET Go_SetTremoloControl
DW OFFSET Go_PANNING, OFFSET Go_RetrigNote, OFFSET Go_VolumeFineUp
DW OFFSET Go_VolumeFineDown, OFFSET Go_NoteCut, OFFSET Go_NoteDelay
DW OFFSET Go_PatternDelay, OFFSET Go_Return

ALIGN 2
MT_VIBRATOTABLE		DB   0, 24, 49, 74, 97,120,141,161
                        DB 180,197,212,224,235,244,250,253
                        DB 255,253,250,244,235,224,212,197
                        DB 180,161,141,120, 97, 74, 49, 24

ALIGN 2
MT_PERIODTABLE	LABEL	WORD
DW 856,808,762,720,678,640,604,570,538,508,480,453 ;C-1 to H-1 Finetune +0.
DW 428,404,381,360,339,320,302,285,269,254,240,226 ;C-2 to H-2 Finetune +0.
DW 214,202,190,180,170,160,151,143,135,127,120,113 ;C-3 to H-3 Finetune +0.
DW 107,101, 95, 90, 85, 80, 75, 71, 67, 63, 60, 56 ;C-4 to H-4 Finetune +0.

DW 850,802,757,715,674,637,601,567,535,505,477,450 ;C-1 to H-1 Finetune +1.
DW 425,401,379,357,337,318,300,284,268,253,239,225 ;C-2 to H-2 Finetune +1.
DW 213,201,189,179,169,159,150,142,134,126,119,113 ;C-3 to H-3 Finetune +1.
DW 106,100, 94, 89, 84, 79, 75, 71, 67, 83, 59, 56 ;C-4 to H-4 Finetune +1.

DW 844,796,752,709,670,632,597,563,532,502,474,447 ;C-1 to H-1 Finetune +2.
DW 422,398,376,355,335,316,298,282,266,251,237,224 ;C-2 to H-2 Finetune +2.
DW 211,199,188,177,167,158,149,141,133,125,118,112 ;C-3 to H-3 Finetune +2.
DW 105, 99, 94, 88, 83, 79, 74, 70, 66, 62, 59, 56 ;C-4 to H-4 Finetune +2.

DW 838,791,746,704,665,628,592,559,528,498,470,444 ;C-1 to H-1 Finetune +3.
DW 419,395,373,352,332,314,296,280,264,249,235,222 ;C-2 to H-2 Finetune +3.
DW 209,198,187,176,166,157,148,140,132,125,118,111 ;C-3 to H-3 Finetune +3.
DW 104, 99, 93, 88, 83, 78, 74, 70, 66, 62, 59, 55 ;C-4 to H-4 Finetune +3.

DW 832,785,741,699,660,623,588,555,524,495,467,441 ;C-1 to H-1 Finetune +4.
DW 416,392,370,350,330,312,294,278,262,247,233,220 ;C-2 to H-2 Finetune +4.
DW 208,196,185,175,165,156,147,139,131,124,117,110 ;C-3 to H-3 Finetune +4.
DW 104, 98, 92, 87, 82, 78, 73, 69, 65, 62, 58, 55 ;C-4 to H-4 Finetune +4.

DW 826,779,736,694,655,619,584,551,520,491,463,437 ;C-1 to H-1 Finetune +5.
DW 413,390,368,347,328,309,292,276,260,245,232,219 ;C-2 to H-2 Finetune +5.
DW 206,195,184,174,164,155,146,138,130,123,116,109 ;C-3 to H-3 Finetune +5.
DW 103, 97, 92, 87, 82, 77, 73, 69, 65, 61, 58, 54 ;C-4 to H-4 Finetune +5.

DW 820,774,730,689,651,614,580,547,516,487,460,434 ;C-1 to H-1 Finetune +6.
DW 410,387,365,345,325,307,290,274,258,244,230,217 ;C-2 to H-2 Finetune +6.
DW 205,193,183,172,163,154,145,137,129,122,115,109 ;C-3 to H-3 Finetune +6.
DW 102, 96, 91, 86, 81, 77, 72, 68, 64, 61, 57, 54 ;C-4 to H-4 Finetune +6.

DW 814,768,725,684,646,610,575,543,513,484,457,431 ;C-1 to H-1 Finetune +7.
DW 407,384,363,342,323,305,288,272,256,242,228,216 ;C-2 to H-2 Finetune +7.
DW 204,192,181,171,161,152,144,136,128,121,114,108 ;C-3 to H-3 Finetune +7.
DW 102, 96, 90, 85, 80, 76, 72, 68, 64, 60, 57, 54 ;C-4 to H-4 Finetune +7.

DW 907,856,808,762,720,678,640,604,570,538,504,480 ;C-1 to H-1 Finetune -8.
DW 453,428,404,381,360,339,320,302,285,269,254,240 ;C-2 to H-2 Finetune -8.
DW 226,214,202,190,180,170,160,151,143,135,127,120 ;C-3 to H-3 Finetune -8.
DW 113,107,101, 95, 90, 85, 80, 75, 71, 67, 63, 60 ;C-4 to H-4 Finetune -8.

DW 900,850,802,757,715,675,636,601,567,535,505,477 ;C-1 to H-1 Finetune -7.
DW 450,425,401,379,357,337,318,300,284,268,253,238 ;C-2 to H-2 Finetune -7.
DW 225,212,200,189,179,169,159,150,142,134,126,119 ;C-3 to H-3 Finetune -7.
DW 112,106,100, 94, 89, 84, 79, 75, 71, 67, 63, 59 ;C-4 to H-4 Finetune -7.

DW 894,844,796,752,709,670,632,597,563,532,502,474 ;C-1 to H-1 Finetune -6.
DW 447,422,398,376,355,335,316,298,282,266,251,237 ;C-2 to H-2 Finetune -6.
DW 223,211,199,188,177,167,158,149,141,133,125,118 ;C-3 to H-3 Finetune -6.
DW 111,105, 99, 94, 88, 83, 79, 74, 70, 66, 62, 59 ;C-4 to H-4 Finetune -6.

DW 887,838,791,746,704,665,628,592,559,528,498,470 ;C-1 to H-1 Finetune -5.
DW 444,419,395,373,352,332,314,296,280,264,249,235 ;C-2 to H-2 Finetune -5.
DW 222,209,198,187,176,166,157,148,140,132,125,118 ;C-3 to H-3 Finetune -5.
DW 111,104, 99, 93, 88, 83, 78, 74, 70, 66, 62, 59 ;C-4 to H-4 Finetune -5.

DW 881,832,785,741,699,660,623,588,555,524,494,467 ;C-1 to H-1 Finetune -4.
DW 441,416,392,370,350,330,312,294,278,262,247,233 ;C-2 to H-2 Finetune -4.
DW 220,208,196,185,175,165,156,147,139,131,123,117 ;C-3 to H-3 Finetune -4.
DW 110,104, 98, 92, 87, 82, 78, 73, 69, 65, 61, 58 ;C-4 to H-4 Finetune -4.

DW 875,826,779,736,694,655,619,584,551,520,491,463 ;C-1 to H-1 Finetune -3.
DW 437,413,390,368,347,338,309,292,276,260,245,232 ;C-2 to H-2 Finetune -3.
DW 219,206,195,184,174,164,155,146,138,130,123,116 ;C-3 to H-3 Finetune -3.
DW 109,103, 97, 92, 87, 82, 77, 73, 69, 65, 61, 58 ;C-4 to H-4 Finetune -3.

DW 868,820,774,730,689,651,614,580,547,516,487,460 ;C-1 to H-1 Finetune -2.
DW 434,410,387,365,345,325,307,290,274,258,244,230 ;C-2 to H-2 Finetune -2.
DW 217,205,193,183,172,163,154,145,137,129,122,115 ;C-3 to H-3 Finetune -2.
DW 108,102, 96, 91, 86, 81, 77, 72, 68, 64, 61, 57 ;C-4 to H-4 Finetune -2.

DW 862,814,768,725,684,646,610,575,543,513,484,457 ;C-1 to H-1 Finetune -1.
DW 431,407,384,363,342,323,305,288,272,256,242,228 ;C-2 to H-2 Finetune -1.
DW 216,203,192,181,171,161,152,144,136,128,121,114 ;C-3 to H-3 Finetune -1.
DW 108,101, 96, 90, 85, 80, 76, 72, 68, 64, 60, 57 ;C-4 to H-4 Finetune -1.
;-----------------------------------------------------------------------------
; MTM - TRACKSTRUKTUR
;-----------------------------------------------------------------------------
ALIGN 2
TRACK_NUMBER	DW 0
TRACK_INFO	DB 8 DUP(0)
TRACK_SEG	DW 0
TRACK_HANDLE	DW 0
TRACKS_OFFSET	DW OFFSET TRACK1_DATA, OFFSET TRACK2_DATA, OFFSET TRACK3_DATA
		DW OFFSET TRACK4_DATA, OFFSET TRACK5_DATA, OFFSET TRACK6_DATA
		DW OFFSET TRACK7_DATA, OFFSET TRACK8_DATA
TRACK1_DATA	DB 128 DUP(0)
TRACK2_DATA	DB 128 DUP(0)
TRACK3_DATA	DB 128 DUP(0)
TRACK4_DATA	DB 128 DUP(0)
TRACK5_DATA	DB 128 DUP(0)
TRACK6_DATA	DB 128 DUP(0)
TRACK7_DATA	DB 128 DUP(0)
TRACK8_DATA	DB 128 DUP(0)
;-----------------------------------------------------------------------------
; MOD - DATEISTRUKTUR
;-----------------------------------------------------------------------------
ALIGN 2
SAMPLE_SIZE	DW 0
PATTERN_SIZE	DW 0
PATTERN_SEG	DW 0
PATTERN_NUMBER	DW 0
PATTERN_CURRENT	DW 0
ISIZE		DW 31 DUP(0)
IVOL_FINETUNE	DW 31 DUP(0)
ILOOP_START	DW 31 DUP(0)
ILOOP_SIZE	DW 31 DUP(0)
SONG_SIZE	DB 0
SONG_LOOP	DB 0
MOD_SIGN	DD 0
SAMPLE_SEG	DW 31 DUP(0)
;-----------------------------------------------------------------------------
; SINGLE SAMPLE VARIABLES
;-----------------------------------------------------------------------------
SAMPLE_ZEIG	DW 0
SAMPLE_MEM	DW 64 DUP(0)
SAMPLE_BIG	DW 64 DUP(0)
EMS_SEG		DW 0
EMS_OFFSET	DW 0
EMS_HANDLE	DW 0
SAM_SEG		DW FX_CHAN_NUMB DUP(0)
SAM_OFS		DD FX_CHAN_NUMB DUP(0)
SAM_FRQ		DW FX_CHAN_NUMB DUP(0)
SAM_FIX		DW FX_CHAN_NUMB DUP(0)
SAM_OFL		DW FX_CHAN_NUMB DUP(0)
SAM_MAX		DW FX_CHAN_NUMB DUP(0)
SAM_PAN		DW FX_CHAN_NUMB DUP(0)
;-----------------------------------------------------------------------------
PROG_END        LABEL   BYTE    ;MUSS LETZE ZEILE IM DATENSEGMENT SEIN!
;-----------------------------------------------------------------------------
DATA_SEG2 ENDS

.386
CODE_SEG2 SEGMENT PAGE USE16
ORG 100H
;=============================================================================
PUBLIC _MAIN2
_MAIN2 PROC FAR
	JMP	MAIN_CONT		;0100
	RETF
	CALL	CONFIG_INIT		;0104
	RETF
	CALL	LOAD_MOD		;0108
	RETF
	CALL	PLAY_MUSIC		;010C
	RETF
	CALL	STOP_MUSIC		;0110
	RETF
	CALL	END_MUSIC		;0114
	RETF
	CALL	LOAD_SAMPLE		;0118
	RETF
	CALL	PLAY_SAMPLE		;011C
	RETF
	CALL	END_SAMPLE		;0120
	RETF
	CALL	SET_SAMPLERATE		;0124
	RETF
	CALL	GET_VOLUME		;0128
	RETF
	CALL	SET_VOLUME		;012C
	RETF
	CALL	SET_SONGLOOP		;0130
	RETF
	CALL	GET_SONGPOSITION	;0134
	RETF
	CALL	SET_SONGPOSITION	;0138
	RETF
	CALL	GET_SONGMOD		;013C
	RETF
	CALL	SET_SONGMOD		;0140
	RETF
	CALL	DSP_OFF			;0144
	RETF
	CALL	DSP_RESET		;0148
	RETF
_MAIN2 ENDP
;=============================================================================
;
; MOD ROUTINEN
;
;=============================================================================
; Format of a note: (ORIGINALLY MOD)
;
;                   0 0          0 0          0 0           0 0
;                   | |          | |          | |           | |
;                  /   \        / /          /   \           \ \
;         MSB of Ins.     Note        LSB Ins.  Spec. Com.   Data for special
;
; Format of a note: (MODIFIED BY LOADER)
;
;                   0 0          0 0          0 0           0 0
;                   | |          | |          | |           | |
;                  / /          /   \         \ \           \ \
;            LSB NOTE   SPEC.COM.    MSB NOTE  INSTRUMENT    DATA FOR SPECIAL
;
;’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
;≥ DESCRIPTION: This procedure shouldn't need to be called by anything else  ≥
;≥              but the interrupt (ever).  It handles all note updating,     ≥
;≥              special effects, pointers, etc.                              ≥
;≥                                                                           ≥
;≥              *** This code came directly from the Amiga Protracker        ≥
;≥                  playback code, written by Lars "Zap" Hamre.  Give this   ≥
;≥                  guy a pat on the back for such excellent code.           ≥
;≥                                                                           ≥
;≥ BUGS       : Or rather, non-implementations.  Command EF - Funk it is     ≥
;≥              not all the way implemented.  Command E0 - Filter is not     ≥
;≥              implemented at all.  It is Amiga-specific, directly with     ≥
;≥              the Paula chip.                                              ≥
;≥                                                                           ≥
;≥ IMPROVEMENTS:    Optimized code for PC-architecure by the Frontman        ≥
;≥                                                                           ≥
;‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
CONTROL_CHANNELS PROC NEAR
	CMP	LOADMOD_FLAG,0
	JNE	Go_NoNewPosYet
	CMP	MOD_STAT,3
	JAE	Go_NoNewPosYet
	INC	MT_COUNTER
	MOV	AL,MT_COUNTER
	CMP	AL,MT_SPEED		; Does it match the current speed?
	JB	SHORT Go_NoNewNote	; No, just do fx.
	MOV	MT_COUNTER,0
	CMP	MT_PATTDELAYTIME2,0
	JE	SHORT Go_GetNewNote
        CALL	Go_CheckEfx		; Otherwise, just do fx only.
        JMP	Go_Dskip                ; Then, jump to update block values.
Go_NoNewNote:
	CALL	Go_CheckEfx		; Do fx.
        JMP	Go_NoNewPosYet		; We don't update block values
					; when we are just doing fx.
Go_GetNewNote:
	CALL	TRACK_SAVE		;SAVE EMS PAGES
	CALL	TRACK_PAGING		;GET TRACKS INTO EMS PAGES
	MOV	ES,TRACK_SEG
	XOR	SI,SI
Go_PlayVoice:
	PUSH	SI
	MOV	DI,SI
	SHL	DI,1
	MOVZX	BX,MT_SONGPOS		; BLOCK BEGINNING TO ES:BX
	ADD	BX,[TRACKS_OFFSET+DI]
	MOVZX	BX,[BX]
	XCHG	BL,BH			; MULTIPLY WITH 256 (TRACK-SIZE)
	ADD	BX,MT_PATTERNPOS
	CMP	[NOTE+DI],0		; See if there is a note.
	JNE	SHORT Go_plvskip	; No, go on.
	CMP	[CMD+SI],0
	JNE	SHORT Go_plvskip
	CMP	[CMDLO+SI],0
	JNE	SHORT Go_plvskip
	CALL	Go_PerNop		; Otherwise, figure out the frequency.
Go_plvskip:
	MOV	AX,ES:[BX]		; Load this channel's information
	MOV	[NOTE+DI],AX		; from the actual track block and
	AND	[NOTE+DI],0FFFH
	SHR	AH,4			; into our own internal structure
	MOV	[CMD+SI],AH		; to access it from.
	MOV	AX,ES:[BX+2]
	MOV	[CMDLO+SI],AH
	OR	AL,AL			; Instrument byte.  Is there an ins?
	JZ	SHORT Go_SetRegs
	DEC	AL
	MOVZX	BX,AL			; GET SAMPLE SEGMENT
	SHL	BX,1
	MOV	AX,[SAMPLE_SEG+BX]
	MOV	[START+DI],AX		; Store it in our structure.
	MOV	AX,[ISIZE+BX]		; Get the length.
	MOV	[LENGTHI+DI],AX		; Store it appropriately.
	MOV	AX,[IVOL_FINETUNE+BX]	; Get the instrument volume and fine tune.
	MOV	[VOLUME+SI],AL		; Store it appropriately.
	MOV	[FINETUNE+SI],AH
	MOV	[MVOL+SI],AL
	MOV	CX,[ILOOP_SIZE+BX]	; Get Repeat length
	CMP	CX,8			; If the length is less than four,
	JB	SHORT Go_NoLoop		; then there is no loop.
	MOV	AX,[ILOOP_START+BX]	; Get the Repeat start.
	MOV	[MREPEAT+DI],AX		; Move it into the appropriate
	MOV	[LOOPSTART+DI],AX	; structures and locations.
	MOV	[REPLEN+DI],CX		; Move the length into its storage.
	ADD	AX,CX			; We're figuring out the offset of
	MOV	[MREPLEN+DI],AX
	MOV	[MMAXREP+DI],AX		; where the repeat length breaks.
	JMP	SHORT Go_SetRegs	; Skip the no loop part.
Go_NoLoop:
	XOR	AX,AX			; Zero out AX.
	MOV	[REPLEN+DI],AX
	MOV	[MREPLEN+DI],AX		; Make sure that no loop exists and
	MOV	[MREPEAT+DI],AX
	MOV	[LOOPSTART+DI],AX
Go_SetRegs:
	CMP	[NOTE+DI],0		; Grab the note.
	JE	Go_CheckMore		; Check the fx.
	MOV	AH,[CMD+SI]		; Get the special fx command.
	MOV	AL,[CMDLO+SI]
	AND	AL,0F0H			; Mask out the bits we don't want.
	CMP	AX,0E50H		; Is there a fine tune command
	JE	SHORT Go_DoSetFineTune
	CMP	AH,3			; Is it a tone portamento?
	JE	SHORT Go_ChkTonePorta
	CMP	AH,5			; Is it a tone and volume slide?
	JE	SHORT Go_ChkTonePorta
	CMP	AH,9			; Is it a sample offset command?
	JNE	SHORT Go_SetPeriod	; If not, go do the actual note.
	PUSH	AX			; keep the command byte in mem
	CALL	Go_CheckMoreEfx
	POP	AX
	JMP	SHORT Go_SetPeriod	; Go do the actual note.
Go_ChkTonePorta:
	CALL	Go_SetTonePorta		; Do part of the tone portamento.
	JMP	Go_CheckMore		; Go do the fx.
Go_DoSetFineTune:
	PUSH	AX
	MOV	AL,[CMDLO+SI]
	AND	AL,0FH
	CALL	Go_SetFineTune		; Update the fine tune.
	POP	AX
;-----------------------------------------------------------------------------
; ƒƒƒƒ We are now going to find the note in the period table.  If it
; ƒƒƒƒ doesn't exist, then no fine tuning can be performed.  If it
; ƒƒƒƒ does, and fine tuning is specified, then we can update it.
;-----------------------------------------------------------------------------
Go_SetPeriod:
	MOV	CL,AH
	MOV	AX,[NOTE+DI]		; Get the note.
	DEC	AX
	MOV	BX,OFFSET MT_PERIODTABLE; Set pointer to beginning of table.
	CMP	CL,3
	JE	SHORT Seek_Period
	CMP	CL,5
	JNE	SHORT Go_ftufound
Seek_Period:
	INC	AX
	MOV	CX,36+12		; 36 periods to cycle through.
Go_ftuloop:
	CMP	AX,[BX]			; Check the note against the period.
	JAE	SHORT Go_Wizzyfound	; We found it!
	INC	BX
	INC	BX			; Otherwise, update the pointer and
	LOOP	Go_ftuloop		; keep looping.
	JMP	SHORT Go_Wizzyfound
Go_ftufound:
	ADD	BX,AX
Go_WizzyFound:
	MOV	AL,[FINETUNE+SI]	; Get the fine tune.
	MOV	CL,(36+12)*2		; The period table's size is 72.
	MUL	CL			; Multiply it by the fine tune.
	ADD	BX,AX			; Add it onto the pointer to point to
	MOV	AX,[BX]			; the new period and get it.
	MOV	[PERIOD+DI],AX		; Store it.
	MOV	AH,[CMD+SI]		; Get the special fx command.
	MOV	AL,[CMDLO+SI]
	AND	AL,0F0H			; Mask out the bits we don't want.
	CMP	AX,0ED0H
	JE	SHORT Go_delnoc
	MOV	AL,[WAVECONTROL+SI]	; Get the WaveControl.
	TEST	AL,00000100B		; Amiga: BTST #2,WaveControl.
	JZ	SHORT Go_vibnoc		; If it is zero, then skip.
	MOV	[VIBRATOPOS+SI],0
Go_vibnoc:
	TEST	AL,01000000B		; Amiga: BTST #6,WaveControl
	JZ	SHORT Go_trenoc		; If it is zero, then skip.
	MOV	[TREMOLOPOS+SI],0	; Zero the Tremolo offset.
Go_trenoc:
	MOV	AX,[START+DI]		; Get the start segment.
	MOV	[MSEG+DI],AX		; Store it to be updated.
	MOV	[MOFS+DI],0		; Set the offset to zero.
	MOV	[MOFLOW+SI],0
	MOV	AX,[LENGTHI+DI]
	MOV	[MMAXREP+DI],AX		; Store in MaxRepeat
	MOV	CX,[PERIOD+DI]
	CALL	Go_PerNop2
	JMP	SHORT Go_CheckMore
Go_delnoc:
	MOV	AX,[MMAXREP+DI]
	MOV	[MOFS+DI],AX
Go_CheckMore:
	CALL	Go_CheckMoreEfx
Go_DoNext:
	POP	SI			;SKIP TO NEXT CHANNEL
	INC	SI
	CMP	SI,CH_NUMB
	JB	Go_PlayVoice
	CALL	TRACK_RESTORE		;RESTORE EMS PAGES
;-----------------------------------------------------------------------------
Go_Dskip:
	ADD	MT_PATTERNPOS,4		; Increment position by one
	MOV	AL,MT_PATTDELAYTIME
	OR	AL,AL
	JZ	SHORT Go_dskc
	MOV	MT_PATTDELAYTIME2,AL
	MOV	MT_PATTDELAYTIME,0
Go_dskc:
	CMP	MT_PATTDELAYTIME2,0
	JE	SHORT Go_dska
	DEC	MT_PATTDELAYTIME2
	JZ	SHORT Go_dska
	SUB	MT_PATTERNPOS,4
Go_dska:
	CMP	MT_PBREAKFLAG,0
	JE	SHORT Go_nnpysk
	MOV	MT_PBREAKFLAG,0
	MOVZX	AX,MT_PBREAKPOS
	MOV	MT_PBREAKPOS,AH
	SHL	AX,2
	MOV	MT_PATTERNPOS,AX
Go_nnpysk:
	CMP	MT_PATTERNPOS,256
	JB	SHORT Go_NoNewPosYet
Go_NextPosition:
	MOVZX	AX,MT_PBREAKPOS
	SHL	AX,2
	MOV	MT_PATTERNPOS,AX
	MOV	MT_PBREAKPOS,0
	MOV	MT_POSJUMPFLAG,0
	MOV	AL,MT_SONGPOS
	INC	AL
	AND	AL,7FH
	MOV	MT_SONGPOS,AL
	CMP	AL,SONG_SIZE
	JB	SHORT Go_NoNewPosYet
	MOV	AL,SONG_LOOP
	CMP	AL,SONG_SIZE
	JB	SHORT Go_NoSongRestart
	MOV	MOD_STAT,3
	XOR	AL,AL
Go_NoSongRestart:
	MOV	MT_SONGPOS,AL
	MOV	MT_SPEED,6		;DEFAULT PROTRACKER SPEED
	MOV	MT_COUNTER,0		;RESET PROTRACKER VARIABLES
	MOV	AL,125
	CALL	Go_SetBPM
	MOV	BPM_COUNT,0
Go_NoNewPosYet:
	CMP	MT_POSJUMPFLAG,0
	JNE	Go_NextPosition
	RET
CONTROL_CHANNELS ENDP
;=============================================================================
Go_CheckEfx PROC NEAR
	XOR	SI,SI
Go_DoEfx:
	PUSH	SI
	MOV	DI,SI
	SHL	DI,1
	MOV	BL,[CMD+SI]              ; Get the special command
	MOV	BH,[CMDLO+SI]
	OR	BX,BX
	JNZ	SHORT SetBack1
	CALL	Go_PerNop
	JMP	SHORT SetBack2
SetBack1:
	XOR	BH,BH
	SHL	BX,1
	CALL	[Effect_Jump_Table1+BX]
SetBack2:
	POP	SI
	INC	SI
	CMP	SI,CH_NUMB
	JB	Go_DoEfx
Go_Return:
	RET
;-----------------------------------------------------------------------------
Go_PerNop PROC NEAR
	MOV	CX,[PERIOD+DI]
Go_PerNop2 PROC NEAR
	PUSH	EAX
	PUSH 	ECX 
	PUSH	EDX
	XOR	EAX,EAX
	JCXZ	SHORT Go_DivZero
	AND	ECX,0FFFFH
	XOR	EDX,EDX
	MOV	EAX,MAINFREQ
	DIV	ECX
Go_DivZero:
	MOV	[MFIXED+DI],AX
	SHR	EAX,16
	MOV	[MFREQ+DI],AX
	POP	EDX 
	POP ECX 
	POP EAX
	RET
Go_PerNop2 ENDP
Go_PerNop ENDP
Go_CheckEfx ENDP
;=============================================================================
;
; SI IS THE CHANNEL-BYTE-INDEX, DI IS THE CHANNEL-WORD-INDEX
;
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect 0 -- Arpeggio
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_Arpeggio PROC NEAR
	MOVZX	AX,MT_COUNTER
	MOV	BL,3
	MOV	CX,[PERIOD+DI]
	DIV	BL
	OR	AH,AH
	JZ	SHORT Go_Arpeggio1
	MOV	AL,[CMDLO+SI]
	CMP	AH,2
	JE	SHORT Go_Arpeggio2
	SHR	AL,4
Go_Arpeggio2:
	AND	AL,0FH
	SHL	AL,1
	MOVZX	BX,AL
	MOV	AL,[FINETUNE+SI]
	MOV	DX,CX
	MOV	CL,(36+12)*2
	MUL	CL
	PUSH	DI
	MOV	DI,OFFSET MT_PERIODTABLE
	ADD	DI,AX
	MOV	AH,36+12
Go_arploop:
	MOV	CX,[BX+DI]
	CMP	DX,[DI]
	JAE	SHORT Go_arpafterloop
        INC	DI
	INC	DI
	DEC	AH
	JNZ	Go_arploop
	POP	DI
	RET
Go_arpafterloop:
	POP	DI
Go_Arpeggio1:
	CALL	Go_PerNop2
        RET
Go_Arpeggio ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect 1 -- Portamento Up
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_PortaUp PROC NEAR
	MOVZX	AX,[CMDLO+SI]		; Number to slide up (was lo)
	AND	AL,MT_LOWMASK
	MOV	MT_LOWMASK,0FFH
	SUB	[PERIOD+DI],AX
	MOV	CX,[PERIOD+DI]
	CMP	CX,113
	JGE	SHORT Go_PortaUSkip
	MOV	CX,113
	MOV	[PERIOD+DI],CX
Go_PortaUSkip:
	CALL	Go_PerNop2
	RET
Go_PortaUp ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect 2 -- Portamento Down
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_PortaDown PROC NEAR
	MOVZX	AX,[CMDLO+SI]		; Number to slide down
	AND	AL,MT_LOWMASK
	MOV	MT_LOWMASK,0FFH
	ADD	[PERIOD+DI],AX
	MOV	CX,[PERIOD+DI]
	CMP	CX,856
	JL	SHORT Go_PortaDSkip
	MOV	CX,856
	MOV	[PERIOD+DI],CX
Go_PortaDSkip:
	CALL	Go_PerNop2
	RET
Go_PortaDown ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect 3 -- Tone Portamento
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_TonePortamento PROC NEAR
	MOV	AL,[CMDLO+SI]
	OR	AL,AL
	JZ	SHORT Go_TonePortNoChange
	MOV	[TONEPORTSPEED+SI],AL
	MOV	[CMDLO+SI],0
Go_TonePortNoChange:
	CMP	[WANTEDPERIOD+DI],0
	JZ	Go_Return
	MOVZX	DX,[TONEPORTSPEED+SI]
	MOV	CX,[PERIOD+DI]
	MOV	AX,[WANTEDPERIOD+DI]
	CMP	[TONEPORTDIREC+SI],0
	JNE	SHORT Go_TonePortaUp
Go_TonePortaDown:
	ADD	CX,DX
	CMP	AX,CX
	JG	SHORT Go_TonePortaSetPer
	JMP	SHORT Go_TonePortaEnd
Go_TonePortaUp:
	SUB	CX,DX
	CMP	AX,CX
	JL	SHORT Go_TonePortaSetPer
Go_TonePortaEnd:
	MOV	CX,AX
	MOV	[WANTEDPERIOD+DI],0
Go_TonePortaSetPer:
	MOV	[PERIOD+DI],CX
	MOV	AL,[GLISSFUNK+SI]
	AND	AL,0FH
	JZ	SHORT Go_GlissSkip
	MOV	AL,[FINETUNE+SI]
	MOV	BL,(36+12)*2
	MUL	BL
	PUSH	DI
	MOV	DI,OFFSET MT_PERIODTABLE
	ADD	DI,AX
	XOR	BX,BX
Go_GlissLoop:
	CMP	CX,[BX+DI]
	JAE	SHORT Go_GlissFound
	INC	BX
	INC	BX
	CMP	BX,(36+12)*2
	JB	Go_GlissLoop
	MOV	BX,(35+12)*2
Go_GlissFound:
	MOV	CX,[BX+DI]
	POP	DI
Go_GlissSkip:
	CALL	Go_PerNop2
	RET
Go_TonePortamento ENDP
;-----------------------------------------------------------------------------
Go_SetTonePorta PROC NEAR
	MOV	DX,[NOTE+DI]
	MOV	AL,[FINETUNE+SI]
	MOV	CL,48*2			;37
	MUL	CL
	PUSH	DI
	MOV	DI,OFFSET MT_PERIODTABLE
	ADD	DI,AX
	XOR	BX,BX
Go_StpLoop:
	CMP	DX,[BX+DI]
	JAE	SHORT Go_StpFound
	INC	BX
	INC	BX
	CMP	BX,48*2			;37
	JB	Go_StpLoop
	MOV	BX,47*2			;35
Go_StpFound:
	MOV	DL,[FINETUNE+SI]
	AND	DL,8
	JZ	SHORT Go_StpGoss
	OR	BX,BX
	JZ	SHORT Go_StpGoss
	DEC	BX
	DEC	BX
Go_StpGoss:
	MOV	DX,[BX+DI]
	POP	DI
	MOV	[WANTEDPERIOD+DI],DX
	MOV	AX,[PERIOD+DI]
	MOV	[TONEPORTDIREC+SI],0
	CMP	DX,AX
	JE	SHORT Go_ClearTonePorta
	JA	Go_Return
	INC	[TONEPORTDIREC+SI]
	RET
Go_ClearTonePorta:
	MOV	[WANTEDPERIOD+DI],0
	RET
Go_SetTonePorta ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect 4 -- Vibrato
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_Vibrato PROC NEAR
	MOV	AL,[CMDLO+SI]
	OR	AL,AL
	JZ	SHORT Go_Vibrato2
	MOV	BL,[VIBRATOCMD+SI]
	AND	AL,0FH
	JZ	SHORT Go_vibskip
	AND	BL,0F0H
	OR	BL,AL
Go_vibskip:
	MOV	AL,[CMDLO+SI]
	AND	AL,0F0H
	JZ	SHORT Go_vibskip2
	AND	BL,0FH
	OR	BL,AL
Go_vibskip2:
	MOV	[VIBRATOCMD+SI],BL
Go_Vibrato2:
	MOV	AL,[VIBRATOPOS+SI]
	SHR	AL,2
	AND	AX,1FH
	MOV	BL,[WAVECONTROL+SI]
	AND	BL,3
	JZ	SHORT Go_vib_sine
	SHL	AL,3
	CMP	BL,1
	JE	SHORT Go_vib_rampdown
	MOV	BL,255
	JMP	SHORT Go_vib_set
Go_vib_rampdown:
	CMP	[VIBRATOPOS+SI],0
	JG	SHORT Go_vib_rampdown2
	MOV	BL,AL
	NOT	BL
	JMP	SHORT Go_vib_set
Go_vib_rampdown2:
	MOV	BL,AL
	JMP	SHORT Go_vib_set
Go_vib_sine:
	MOVZX	BX,AL
	MOV	BL,[MT_VIBRATOTABLE+BX]
Go_vib_set:
	MOV	AL,[VIBRATOCMD+SI]
	AND	AL,0FH
	MUL	BL
	SHR	AX,7
	MOV	BX,AX
	MOV	AX,[PERIOD+DI]
	CMP	[VIBRATOPOS+SI],0
	JG	SHORT Go_VibratoNeg	; BMI
	NEG	BX
Go_VibratoNeg:
	ADD	AX,BX
Go_Vibrato3:
	MOV	CX,AX
	CALL	Go_PerNop2
	MOV	AL,[VIBRATOCMD+SI]
	AND	AL,0F0H
	SHR	AL,2
	ADD	[VIBRATOPOS+SI],AL
	RET
Go_Vibrato ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect 5 -- Tone and Volume Slide
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_TonePlusVolSlide PROC NEAR
	CALL	Go_TonePortNoChange
	JMP	Go_VolumeSlide
Go_TonePlusVolSlide ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect 6 -- Vibrato and Volume Slide
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_VibratoPlusVolSlide PROC NEAR
	CALL	Go_Vibrato2		;was mt_vibrato2
	JMP	Go_VolumeSlide
Go_VibratoPlusVolSlide ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect 7 -- Tremolo
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_Tremolo PROC NEAR
	MOV	AL,[CMDLO+SI]
	OR	AL,AL
	JZ	SHORT Go_Tremolo2
	MOV	BL,[TREMOLOCMD+SI]
	AND	AL,0FH
	JZ	SHORT Go_treskip
	AND	BL,0F0H
	OR	BL,AL
Go_treskip:
	MOV	AL,[CMDLO+SI]
	AND	AL,0F0H
	JZ	SHORT Go_treskip2
	AND	BL,0FH
	OR	BL,AL
Go_treskip2:
	MOV	[TREMOLOCMD+SI],BL
Go_Tremolo2:
	MOV	AL,[TREMOLOPOS+SI]
	SHR	AL,2
	AND	AX,1FH
	MOV	BL,[WAVECONTROL+SI]
	SHR	BL,4
	AND	BL,3
	JZ	SHORT Go_tre_sine
	SHL	AL,3
	CMP	BL,1
	JE	SHORT Go_tre_rampdown
	MOV	BL,255
	JMP	SHORT Go_tre_set
Go_tre_rampdown:
	CMP	[TREMOLOPOS+SI],0
	JG	SHORT Go_tre_rampdown2
	MOV	BL,AL
	NOT	BL
	JMP	SHORT Go_tre_set
Go_tre_rampdown2:
	MOV	BL,AL
	JMP	SHORT Go_tre_set
Go_tre_sine:
	MOVZX	BX,AL
	MOV	BL,[MT_VIBRATOTABLE+BX]
Go_tre_set:
	MOV	AL,[TREMOLOCMD+SI]
	AND	AL,0FH
	MUL	BL
	MOV	BX,AX
	SHR	BX,6
	MOV	AL,[VOLUME+SI]
	CMP	[TREMOLOPOS+SI],0
	JG	SHORT Go_TremoloNeg		; BMI  jns
	ADD	AL,BL
	JMP	SHORT Go_Tremolo3
Go_TremoloNeg:
	SUB	AL,BL
Go_Tremolo3:
	JNC	SHORT Go_TremoloSkip
	XOR	AX,AX
Go_TremoloSkip:
	CMP	AL,40H
	JBE	SHORT Go_TremoloOK		; BLS
	MOV	AL,40H
Go_TremoloOK:
	MOV	[MVOL+SI],AL			;was ah
	MOV	AL,[TREMOLOCMD+SI]
	AND	AL,0F0H
	SHR	AL,2
	ADD	[TREMOLOPOS+SI],AL
	RET
Go_Tremolo ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect 9 -- Sample Offset
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_SampleOffset PROC NEAR
	MOVZX	AX,[CMDLO+SI]
	OR	AL,AL
	JZ	SHORT Go_sononew
	MOV	[SAMPLEOFFSET+SI],AL
Go_sononew:
	MOVZX	AX,[SAMPLEOFFSET+SI]
	XCHG	AL,AH
	CMP	AX,[MMAXREP+DI]
	JAE	SHORT Go_sofskip
	MOV	[MOFS+DI],AX
	RET
Go_sofskip:
	MOV	AX,[MOFS+DI]
	MOV	[MMAXREP+DI],AX
	RET
Go_SampleOffset ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect A -- Volume Slide
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_VolumeSlide PROC NEAR
	MOV	AL,[CMDLO+SI]
	SHR	AL,4
	OR	AL,AL
	JZ	SHORT Go_VolSlideDown
Go_VolSlideUp:
	ADD	[VOLUME+SI],AL
	CMP	[VOLUME+SI],40H
	JBE	SHORT Go_vsdskip
	MOV	[VOLUME+SI],40H
	JMP	SHORT Go_vsdskip
Go_VolSlideDown:
	MOV	AL,[CMDLO+SI]
	AND	AL,0FH
Go_VolSlideDown2:
	SUB	[VOLUME+SI],AL
	JNC	SHORT Go_vsdskip
	MOV	[VOLUME+SI],0
Go_vsdskip:
	MOV	AL,[VOLUME+SI]
	MOV	[MVOL+SI],AL		;was ah
	RET
Go_VolumeSlide ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect B -- Position Jump
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_PositionJump PROC NEAR
	MOV	AL,[CMDLO+SI]		; Get where to jump
	DEC	AL			; Update the
	MOV	MT_SONGPOS,AL		; information.
Go_pj2:	MOV	MT_PBREAKPOS,0
	MOV	MT_POSJUMPFLAG,1
	RET
Go_PositionJump ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect C -- Volume Change
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_VolumeChange PROC NEAR
	MOV	AL,[CMDLO+SI]		; Get value for volume
	CMP	AL,40H			; Is it greater than 40h?
	JBE	SHORT Go_VolumeOK	; Nope
	MOV	AL,40H
Go_VolumeOK:
	MOV	[VOLUME+SI],AL
	MOV	[MVOL+SI],AL		;was ah
	RET
Go_VolumeChange ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect D -- Pattern Break
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_PatternBreak PROC NEAR
	MOV	AL,[CMDLO+SI]		; Break to where?
	MOV	BL,AL			; POSITION IS IN DECIMAL
	SHR	AL,4
	MOV	CL,10
	MUL	CL
	AND	BL,0FH
	ADD	AL,BL
	CMP	AL,63
	JG	Go_pj2
	MOV	MT_PBREAKPOS,AL
	MOV	MT_POSJUMPFLAG,1
	RET
Go_PatternBreak ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect F -- Set Speed
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_SetSpeed PROC NEAR
	MOV	AL,[CMDLO+SI]		; Get value for speed
	OR	AL,AL
	JZ	Go_Return
	CMP	AL,32			; Is it a BPM value ?
	JAE	SHORT Go_SetBPM
	MOV	MT_COUNTER,0
	MOV	MT_SPEED,AL
	RET
Go_SetBPM:
	XOR	AH,AH
	MOV	BPM_VALUE,AX
	CMP	AL,76			; MIXROUTINE CANT HANDLE LESS THAN 76
	JAE	SHORT Go_CheckBPM1
	MOV	AL,76
Go_CheckBPM1:
	CMP	AL,202			; MIXROUTINE CANT HANDLE MORE THAN 202
	JBE	SHORT Go_CheckBPM2
	MOV	AL,202
Go_CheckBPM2:
	SHL	AX,1
	MOV	BL,5			; Denna bit Ñr fîr att stÑlla
	DIV	BL			; EFFECTs till annat Ñn 50Hz
	MOV	DL,AL			; Detta ger automatiskt en annan
	XOR	DH,DH			; PATT_SPEED.; Hz=2*BPM/5
	XOR	AX,AX
	MOV	BX,BPM_RATE
	DIV	BX
	MOV	WORD PTR BPM_SPEED,AX
	XOR	AX,AX
	DIV	BX
	MOV	WORD PTR BPM_SPEED+2,AX
	RET
Go_SetSpeed ENDP
;=============================================================================
Go_CheckMoreEfx PROC NEAR
	MOVZX	BX,[CMD+SI]
	SHL	BL,1
	JMP	[Effect_Jump_Table2+BX]
Go_CheckMoreEfx ENDP
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; Effect E
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
Go_E_Commands PROC NEAR
	MOVZX	BX,[CMDLO+SI]
	SHR	BL,4
	SHL	BL,1
	MOV	AL,[CMDLO+SI]
	AND	AL,0FH
	JMP	[Effect_Jump_Table3+BX]
;-----------------------------------------------------------------------------
; Effect 0 -- FilterOnOff
; Effect 1 -- Fine Porta Up
;-----------------------------------------------------------------------------
Go_FinePortaUp:
	CMP	MT_COUNTER,0
	JNE	Go_Return
	MOV	MT_LOWMASK,0FH
	JMP	Go_PortaUp
;-----------------------------------------------------------------------------
; Effect 2 -- Fine Porta Down
;-----------------------------------------------------------------------------
Go_FinePortaDown:
	CMP	MT_COUNTER,0
	JNE	Go_Return
	MOV	MT_LOWMASK,0FH
	JMP	Go_PortaDown
;-----------------------------------------------------------------------------
; Effect 3 -- Set Gliss Control
;-----------------------------------------------------------------------------
Go_SetGlissControl:
	AND	[GLISSFUNK+SI],0F0H
	OR	[GLISSFUNK+SI],AL
	RET
;-----------------------------------------------------------------------------
; Effect 4 -- Set Vibrato Control
;-----------------------------------------------------------------------------
Go_SetVibratoControl:
	AND	[WAVECONTROL+SI],0F0H
	OR	[WAVECONTROL+SI],AL
	RET
;-----------------------------------------------------------------------------
; Effect 5 -- Set Fine Tune
;-----------------------------------------------------------------------------
Go_SetFineTune:
	MOV	[FINETUNE+SI],AL
	RET
;-----------------------------------------------------------------------------
; Effect 6 -- Jump Loop
;-----------------------------------------------------------------------------
Go_JumpLoop:
	CMP	MT_COUNTER,0
	JNE	Go_Return
	OR	AL,AL
	JZ	SHORT Go_SetLoop
	CMP	[LOOPCOUNT+SI],0
	JE	SHORT Go_jumpcnt
	DEC	[LOOPCOUNT+SI]
	JZ	Go_Return
Go_jmploop:
	MOV	AL,[PATTPOS+SI]
	MOV	MT_PBREAKPOS,AL
	MOV	MT_PBREAKFLAG,1
	RET
Go_jumpcnt:
	MOV	[LOOPCOUNT+SI],AL
	JMP	Go_jmploop
Go_SetLoop:
	MOV	AX,MT_PATTERNPOS
	SHR	AX,2
	MOV	[PATTPOS+SI],AL
	RET
;-----------------------------------------------------------------------------
; Effect 7 -- Set Tremolo Control
;-----------------------------------------------------------------------------
Go_SetTremoloControl:
	SHL	AL,4
	AND	[WAVECONTROL+SI],0FH
	OR	[WAVECONTROL+SI],AL
	RET
;-----------------------------------------------------------------------------
; Effect 8 -- Set PANNING
;-----------------------------------------------------------------------------
Go_PANNING:
	MOV	[MPANNING+SI],AL
	RET
;-----------------------------------------------------------------------------
; Effect 9 -- Retrig Note
;-----------------------------------------------------------------------------
Go_RetrigNote:
	MOV	BL,AL
	OR	BL,BL
	JZ	SHORT Go_rtnend
	MOVZX	AX,MT_COUNTER
	OR	AL,AL
	JNZ	SHORT Go_rtnskp
	CMP	[NOTE+DI],0
	JNE	SHORT Go_rtnskp
	MOV	MT_COUNTER,0
Go_rtnskp:
	DIV	BL
	XCHG	AL,AH
	OR	AL,AL
	JNZ	SHORT Go_rtnend
Go_DoRetrig:
	XOR	AX,AX
	MOV	[MOFS+DI],AX
	MOV	[MOFLOW+SI],AX
	MOV	AX,[LENGTHI+DI]
	MOV	[MMAXREP+DI],AX
	MOV	AX,[LOOPSTART+DI]
	MOV	[MREPEAT+DI],AX
	ADD	AX,[REPLEN+DI]
	MOV	[MREPLEN+DI],AX
Go_rtnend:
	RET
;-----------------------------------------------------------------------------
; Effect A -- Volume Fine Up
;-----------------------------------------------------------------------------
Go_VolumeFineUp:
	CMP	MT_COUNTER,0
	JNE	Go_Return
	JMP	Go_VolSlideUp
;-----------------------------------------------------------------------------
; Effect B -- Volume Fine Down
;-----------------------------------------------------------------------------
Go_VolumeFineDown:
	CMP	MT_COUNTER,0
	JNZ	Go_Return
	JMP	Go_VolSlideDown2
;-----------------------------------------------------------------------------
; Effect C -- Note Cut
;-----------------------------------------------------------------------------
Go_NoteCut:
	CMP	AL,MT_COUNTER
	JNE	Go_Return
	MOV	[VOLUME+SI],0
	MOV	[MVOL+SI],AL
	RET
;-----------------------------------------------------------------------------
; Effect D -- Note Delay
;-----------------------------------------------------------------------------
Go_NoteDelay:
	CMP	AL,MT_COUNTER
	JNE	Go_Return
	CMP	[NOTE+DI],0
	JE	Go_Return
	JMP	Go_DoRetrig
;-----------------------------------------------------------------------------
; Effect E -- Pattern Delay
;-----------------------------------------------------------------------------
Go_PatternDelay:
	CMP	MT_COUNTER,0
	JNE	Go_Return
	CMP	MT_PATTDELAYTIME2,0
	JNZ	Go_Return
	INC	AL
	MOV	MT_PATTDELAYTIME,AL
	RET
;-----------------------------------------------------------------------------
; Effect F -- Funk It
;-----------------------------------------------------------------------------
Go_E_Commands ENDP
;=============================================================================


;=============================================================================
MIXUP_CHANNELS PROC NEAR
	CMP	MOD_STAT,3		;MOD HAS FINISHED
	JB	SHORT GMX7
	XOR	AX,AX
	XOR	BX,BX
	MOV	CX,MAX_CHAN_NUMB
LMX4:	MOV	[MSEG+BX],AX
	INC	BX
	INC	BX
	LOOP	LMX4
GMX7:	MOV	CX,DMA_CX
	CMP	MOD_STAT,2
	JB	SHORT GMX3
	MOVZX	SI,DMA_CHANNEL
	MOVZX	DX,[DMA_FLIP+SI]
	OUT	DX,AL			;FLIP-FLOP CLEAR
	MOVZX	DX,[DMA_ADR+SI]
	IN	AL,DX			;GET DMA POSITION
	XCHG	AL,AH
	IN	AL,DX
	XCHG	AL,AH
	SUB	AX,DMA_POFF		;AX IS OFFSET OF DMA-POS
	CMP	SI,4
	JB	SHORT GMX0
	SHL	AX,1
GMX0:	AND	AX,0FFFEH
	ADD	AX,DMA_MORE
	CMP	AX,DMA_MAX
	JB	SHORT GMX1
	SUB	AX,DMA_MAX
GMX1:	ADD	AX,DMA_OFFSET
	SUB	AX,DMA_PTR
	JNC	SHORT GMX2
	ADD	AX,DMA_MAX
GMX2:	MOV	CX,AX			;CX IS NUMBER OF BYTES TO CALCULATE
	ADD	AX,DMA_PTR
	SUB	AX,DMA_OFFSET
	SUB	AX,8000H
	JC	SHORT GMX3
	SUB	CX,AX

GMX3:	CMP	IRQ_REENTER,1		;OVERLOAD?
	JA	GMX20
	XOR	BX,BX
	XOR	DI,DI
	CLD
	SHR	CX,1
	CMP	DMA_CHANNEL,4
	JB	SHORT GMX10
	SHR	CX,1
GMX10:	CMP	CX,40H
	JB	GMX5
	CALL	MIX_CHANNELA
	INC	BX
	INC	DI
	INC	DI
LMX1:	CALL	MIX_CHANNELM		;MIX CHANNELS
	INC	BX
	INC	DI
	INC	DI
	CMP	BX,CH_NUMB
	JB	LMX1
	CALL	EMS_SAVE
	XOR	BX,BX
	XOR	DI,DI
LMX2:	CALL	MIX_CHANNELS		;MIX FX CHANNELS
	ADD	BX,4
	INC	DI
	INC	DI
	CMP	DI,2*FX_CHAN_NUMB
	JB	LMX2
	CALL	EMS_RESTORE
	MOV	AX,DMA_NEWPTR		;CHECK DMA-BUFFER OVERFLOW
	MOV	SI,DMA_MAX		;ITS A RING BUFFER
	ADD	SI,DMA_OFFSET
	CMP	AX,SI
	JB	SHORT GMX4
	MOV	CX,AX
	MOV	DI,DMA_OFFSET
	SUB	CX,SI
	JZ	SHORT GMX6
	CLD
	SHR	CX,1
	PUSH	DS
	MOV	ES,DMA_SEG
	MOV	DS,DMA_SEG
	REP MOVSW			;MOVE OVERFLOW DATA
	POP	DS
GMX6:	MOV	AX,DI
GMX4:	MOV	DMA_PTR,AX		;START DSP OUTPUT
	CMP	MOD_STAT,1
	JNE	SHORT GMX5
	INC	MOD_STAT
	CALL	DSP_OUT
	JMP	SHORT GMX5
GMX20:	MOV	AX,DMA_NEWPTR		;IF OVERLOADED JUST CLEAR SOUND
	SUB	AX,DMA_PTR
	SUB	CX,AX
	XOR	AX,AX
	CLD
	SHR	CX,1
	JZ	SHORT GMX5
	MOV	ES,DMA_SEG
	MOV	DI,DMA_NEWPTR
	REP STOSW
	MOV	DMA_NEWPTR,DI
GMX5:	RET
MIXUP_CHANNELS ENDP
;-----------------------------------------------------------------------------
MIX_CHANNELA PROC NEAR
	PUSH	CX 
	PUSH	BX 
	PUSH	DI
	MOV	AX,[MFIXED+DI]		;OFF ADD AFTER FIXED POINT (X/256)
	MOV	WORD PTR MIXAS4+2,AX
	MOV	DX,[MFREQ+DI]		;OFF ADD AFTER FIXED POINT (X/256)
	MOV	BYTE PTR MIXAS5+2,DL
	MOV	WORD PTR MIXAS2,01A72H	;JB SHORT +26
	OR	DL,DL
	JNZ	SHORT MIXA_NOIP
	MOV	WORD PTR MIXAS2,0C38BH	;MOV AX,BX
MIXA_NOIP:
	MOV	BP,MIXMUL_OFFSET
	MOV	WORD PTR MIXAS3+2,BP
	MOV	AL,[MVOL+BX]		;SAMPLE VOLUME
	MOV	DL,MUSIC_VOL		;MASTER VOLUME
	MOV	BL,[MPANNING+BX]
	MUL	DL
	SHL	BX,1
	MOV	SI,AX
	MOV	DX,[PANNINGL+BX]
	MUL	DX
	SHL	DX,9
	ADD	DX,BP
	MOV	WORD PTR MIXAS6+2,DX
	MOV	AX,SI
	MOV	DX,[PANNINGR+BX]
	MUL	DX
	SHL	DX,9
	ADD	DX,BP
	MOV	WORD PTR MIXAS7+2,DX
	MOV	DX,[MOFLOW+DI]		;ACTUAL AFTER FIXED POINT VALUE
	MOV	SI,[MOFS+DI]		;GET OFFSET IN SAMPLE (START=0)
	MOV	ES,[MSEG+DI]
	MOV	AX,[MMAXREP+DI]		;OFFSET OF SAMPLE ENDING
	DEC	AX
	MOV	WORD PTR MIXAS1+2,AX
	JMP	SHORT CLEAR_PREF1	;CLEAR PREFETCH QUEUE!!!
CLEAR_PREF1:
	MOV	DI,DMA_PTR
	MOV	DS,DMA_SEG		;DS:DI IS DMA-BUFFER POINTER
	MOV	AX,ES
	OR	AX,AX
	JZ	SHORT SILENTA_FILL
MIXA_LOOP:
MIXAS1:	CMP	SI,0F000H		;SMCODE FOR SAMPLE END
	JAE	SHORT RESTA_FILL
	MOV	BX,ES:[SI]		;GET SAMPLE BYTES
	XCHG	BL,BH

MIXAS2:	MOV	AX,BX			;SMCODE FOR JB +XX
	SAR	BL,1			;BEGIN INTERPOLATION
	SAR	BH,1
	XOR	AL,AL
	SUB	BL,BH
	MOV	BH,DH
	SHR	BH,2
	SHL	BX,1
MIXAS3:	ADD	BX,0F000H		;SMCODE FOR MIXMUL TABLE OFFSET
	MOV	BX,[BX]
	SAL	BX,2
	ADD	BX,AX			;END INTERPOLATION

	SHR	BX,7			;CALCULATE VOLUMES
	AND	BX,0000000111111110B
MIXAS4:	ADD	DX,0F000H		;SMCODE FOR FIXED POINT
MIXAS5:	ADC	SI,0			;SMCODE FOR SAMPLE POINTER
MIXAS6:	MOV	AX,[0F000H+BX]		;SMCODE FOR VOLUME TABLE OFFSET LEFT
MIXAS7:	MOV	BP,[0F000H+BX]		;SMCODE FOR VOLUME TABLE OFFSET RIGHT
MOVA1:	MOV	[DI],AX			;SMCODE
	MOV	BX,BP
	INC	DI
NOP1:	INC	DI			;SMCODE
MOVB1:	MOV	[DI],BX			;SMCODE
	INC	DI
NOP2:	INC	DI			;SMCODE
	LOOP	MIXA_LOOP
MIXA_END:
	MOV	AX,CS
	MOV	DS,AX
	MOV	AX,ES
	MOV	DMA_NEWPTR,DI
	POP	DI 
	POP	BX 
	POP	CX
	MOV	[MSEG+DI],AX
	MOV	[MOFLOW+DI],DX
	MOV	[MOFS+DI],SI
	RET
RESTA_FILL:
	POP	BP
	PUSH	BP
	MOV	AX,CS:[MREPLEN+BP]
	OR	AX,AX
	JZ	SHORT SILENTA_FILL
	MOV	CS:[MMAXREP+BP],AX
	DEC	AX
	MOV	WORD PTR CS:MIXAS1+2,AX
	MOV	SI,CS:[MREPEAT+BP]
	JMP	MIXA_LOOP
SILENTA_FILL:
	MOV	BX,DS
	MOV	ES,BX
	CMP	CS:DMA_CHANNEL,4
	JB	SHORT NOT16BITA
	SHL	CX,1
NOT16BITA:
	REP STOSW
	MOV	ES,AX
	JMP	MIXA_END
MIX_CHANNELA ENDP
;-----------------------------------------------------------------------------
MIX_CHANNELM PROC NEAR
	PUSH	CX 
	PUSH	BX 
	PUSH	DI
	MOV	AX,[MFIXED+DI]		;OFF ADD AFTER FIXED POINT (X/256)
	MOV	WORD PTR MIXMS4+2,AX
	MOV	DX,[MFREQ+DI]		;OFF ADD AFTER FIXED POINT (X/256)
	MOV	BYTE PTR MIXMS5+2,DL
	MOV	WORD PTR MIXMS2,01A72H	;JB SHORT +26
	OR	DL,DL
	JNZ	SHORT MIXM_NOIP
	MOV	WORD PTR MIXMS2,0C38BH	;MOV AX,BX
MIXM_NOIP:
	MOV	BP,MIXMUL_OFFSET
	MOV	WORD PTR MIXMS3+2,BP
	MOV	AL,[MVOL+BX]		;SAMPLE VOLUME
	MOV	DL,MUSIC_VOL		;MASTER VOLUME
	MOV	BL,[MPANNING+BX]
	MUL	DL
	SHL	BX,1
	MOV	SI,AX
	MOV	DX,[PANNINGL+BX]
	MUL	DX
	SHL	DX,9
	ADD	DX,BP
	MOV	WORD PTR MIXMS6+2,DX
	MOV	AX,SI
	MOV	DX,[PANNINGR+BX]
	MUL	DX
	SHL	DX,9
	ADD	DX,BP
	MOV	WORD PTR MIXMS7+2,DX
	MOV	DX,[MOFLOW+DI]		;ACTUAL AFTER FIXED POINT VALUE
	MOV	SI,[MOFS+DI]		;GET OFFSET IN SAMPLE (START=0)
	MOV	ES,[MSEG+DI]
	MOV	AX,[MMAXREP+DI]		;OFFSET OF SAMPLE ENDING
	DEC	AX
	MOV	WORD PTR MIXMS1+2,AX
	JMP	SHORT CLEAR_PREF2	;CLEAR PREFETCH QUEUE!!!
CLEAR_PREF2:
	MOV	DI,DMA_PTR
	MOV	DS,DMA_SEG		;DS:DI IS DMA-BUFFER POINTER
	MOV	AX,ES
	OR	AX,AX
	JZ	SHORT MIXM_END
MIXM_LOOP:
MIXMS1:	CMP	SI,0F000H		;SMCODE FOR SAMPLE END
	JAE	SHORT RESTM_FILL
	MOV	BX,ES:[SI]		;GET SAMPLE BYTES
	XCHG	BL,BH

MIXMS2:	MOV	AX,BX			;SMCODE FOR JB +XX
	SAR	BL,1			;BEGIN INTERPOLATION
	SAR	BH,1
	XOR	AL,AL
	SUB	BL,BH
	MOV	BH,DH
	SHR	BH,2
	SHL	BX,1
MIXMS3:	ADD	BX,0F000H		;SMCODE FOR MIXMUL TABLE OFFSET
	MOV	BX,[BX]
	SAL	BX,2
	ADD	BX,AX			;END INTERPOLATION

	SHR	BX,7			;CALCULATE VOLUMES
	AND	BX,0000000111111110B
MIXMS4:	ADD	DX,0F000H		;SMCODE FOR FIXED POINT
MIXMS5:	ADC	SI,0			;SMCODE FOR SAMPLE POINTER
MIXMS6:	MOV	AX,[0F000H+BX]		;SMCODE FOR VOLUME TABLE OFFSET LEFT
MIXMS7:	MOV	BP,[0F000H+BX]		;SMCODE FOR VOLUME TABLE OFFSET RIGHT
ADDA2:	ADD	[DI],AX			;SMCODE
	JNO	SHORT MIXMG1
	SHR	AX,15
	ADD	AX,7FFFH
MOVA2:	MOV	[DI],AX			;SMCODE
MIXMG1:	MOV	BX,BP
	INC	DI
NOP3:	INC	DI			;SMCODE
ADDB2:	ADD	[DI],BX			;SMCODE
	JNO	SHORT MIXMG2
	SHR	BX,15
	ADD	BX,7FFFH
MOVB2:	MOV	[DI],BX			;SMCODE
MIXMG2:	INC	DI
NOP4:	INC	DI			;SMCODE
	LOOP	MIXM_LOOP
MIXM_END:
	MOV	AX,CS
	MOV	DS,AX
	MOV	AX,ES
	POP	DI 
	POP	BX 
	POP	CX
	MOV	[MSEG+DI],AX
	MOV	[MOFLOW+DI],DX
	MOV	[MOFS+DI],SI
	RET
RESTM_FILL:
	POP	BP
	PUSH	BP
	MOV	AX,CS:[MREPLEN+BP]
	OR	AX,AX
	JZ	SHORT SILENTM_FILL
	MOV	CS:[MMAXREP+BP],AX
	DEC	AX
	MOV	WORD PTR CS:MIXMS1+2,AX
	MOV	SI,CS:[MREPEAT+BP]
	JMP	MIXM_LOOP
SILENTM_FILL:
	MOV	ES,AX
	JMP	MIXM_END
MIX_CHANNELM ENDP
;-----------------------------------------------------------------------------
MIX_CHANNELS PROC NEAR
	CMP	[SAM_SEG+DI],0
	JE	GO_BACKS
	PUSH	EAX
	MOV	EAX,[SAM_OFS+BX]
	CALL	EMS_PAGING
	POP	EAX
	PUSH	SI 
	PUSH	CX 
	PUSH	BX 
	PUSH	DI
	MOV	AX,[SAM_FIX+DI]		;OFF ADD AFTER FIXED POINT (X/256)
	MOV	WORD PTR MIXSS4+2,AX
	MOV	DX,[SAM_FRQ+DI]		;OFF ADD AFTER FIXED POINT (X/256)
	MOV	BYTE PTR MIXSS5+2,DL
	MOVZX	AX,FX_VOL		;MASTER VOLUME
	MOV	BX,[SAM_PAN+DI]
	SHL	AX,6
	SHL	BX,1
	MOV	BP,AX
	MOV	DX,[PANNINGL+BX]
	MUL	DX
	SHL	DX,9
	ADD	DX,MIXMUL_OFFSET
	MOV	WORD PTR MIXSS6+2,DX
	MOV	AX,BP
	MOV	DX,[PANNINGR+BX]
	MUL	DX
	SHL	DX,9
	ADD	DX,MIXMUL_OFFSET
	MOV	WORD PTR MIXSS7+2,DX
	MOV	DX,[SAM_OFL+DI]		;ACTUAL AFTER FIXED POINT VALUE
	MOV	AX,SI			;OFFSET OF SAMPLE ENDING
	ADD	AX,[SAM_MAX+DI]
	JNC	SHORT MIXSG3
	XOR	AX,AX
	DEC	AX
MIXSG3:	MOV	WORD PTR MIXSS1+2,AX
	JMP	SHORT CLEAR_PREF3	;CLEAR PREFETCH QUEUE!!!
CLEAR_PREF3:
	MOV	DI,DMA_PTR
	MOV	DS,DMA_SEG		;DS:DI IS DMA-BUFFER POINTER
MIXS_LOOP:
MIXSS1:	CMP	SI,0F000H		;SMCODE FOR SAMPLE END
	JAE	SHORT RESTS_FILL
	MOV	BL,ES:[SI]		;GET SAMPLE BYTES
	XOR	BH,BH
	SHL	BX,1			;CALCULATE VOLUMES
MIXSS4:	ADD	DX,0F000H		;SMCODE FOR FIXED POINT
MIXSS5:	ADC	SI,0			;SMCODE FOR SAMPLE POINTER
MIXSS6:	MOV	AX,[0F000H+BX]		;SMCODE FOR VOLUME TABLE OFFSET LEFT
MIXSS7:	MOV	BP,[0F000H+BX]		;SMCODE FOR VOLUME TABLE OFFSET RIGHT
ADDA3:	ADD	[DI],AX			;SMCODE
	JNO	SHORT MIXSG1
	SHR	AX,15
	ADD	AX,7FFFH
MOVA3:	MOV	[DI],AX			;SMCODE
MIXSG1:	MOV	BX,BP
	INC	DI
NOP5:	INC	DI			;SMCODE
ADDB3:	ADD	[DI],BX			;SMCODE
	JNO	SHORT MIXSG2
	SHR	BX,15
	ADD	BX,7FFFH
MOVB3:	MOV	[DI],BX			;SMCODE
MIXSG2:	INC	DI
NOP6:	INC	DI			;SMCODE
	LOOP	MIXS_LOOP
MIXS_END:
	MOV	AX,CS
	MOV	DS,AX
	POP	DI 
	POP	BX 
	POP	CX 
	POP AX
	MOV	[SAM_OFL+DI],DX
	SUB	SI,AX
	PUSH	EAX
	MOVZX	EAX,SI
	ADD	[SAM_OFS+BX],EAX
	SUB	[SAM_MAX+DI],AX
	JZ	SHORT MIXS_SAMPEND
	JNC	SHORT MIXS_SAMPOK
MIXS_SAMPEND:
	MOV	[SAM_SEG+DI],0
MIXS_SAMPOK:
	POP	EAX
GO_BACKS:
	RET
RESTS_FILL:
	POP	DI
	PUSH	DI
	MOV	CS:[SAM_SEG+DI],0
	JMP	MIXS_END
MIX_CHANNELS ENDP
;-----------------------------------------------------------------------------
; SET EMS-PAGES
; IN:  EAX= EMS-OFFSET
; OUT: ES:SI= SEGMENT & OFFSET IN EMS PAGE
;-----------------------------------------------------------------------------
EMS_PAGING PROC NEAR
	MOV	SI,AX
	AND	SI,3FFFH
	MOV	ES,EMS_SEG
	PUSHA
	PUSH	EAX
	SHR	EAX,14
	MOV	BX,AX
	XOR	AL,AL
	MOV	DX,EMS_HANDLE
	MOV	AH,44H
	INT	67H
	INC	AL
	INC	BX
	MOV	AH,44H
	INT	67H
	INC	AL
	INC	BX
	MOV	AH,44H
	INT	67H
	INC	AL
	INC	BX
	MOV	AH,44H
	INT	67H
	POP	EAX
	POPA
	RET
EMS_PAGING ENDP
;-----------------------------------------------------------------------------
EMS_SAVE PROC NEAR
	PUSH	AX 
	PUSH	DX
	MOV	DX,EMS_HANDLE		;EMS MAPPING SICHERN
	MOV	AH,47H
	INT	67H
	POP	DX 
	POP	AX
	RET
EMS_SAVE ENDP
;-----------------------------------------------------------------------------
EMS_RESTORE PROC NEAR
	PUSH	AX 
	PUSH	DX
	MOV	DX,EMS_HANDLE		;EMS MAPPING ZURöCKSETZEN
	MOV	AH,48H
	INT	67H
	POP	DX 
	POP	AX
	RET
EMS_RESTORE ENDP
;’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
;≥ DESCRIPTION: Calculates the values for the mixing multiplication table.   ≥
;≥              This table is used during 4/8-channel mixing to speed up the ≥
;≥              operation by avoiding 'mul' instructions.                    ≥
;‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
MAKE_MIXMUL_VOLUMETABLE PROC NEAR
	MOV	ES,DMA_SEG
	MOV	DI,MIXMUL_OFFSET
	CLD
	XOR	BX,BX			; start with volume 0
	INC	BH
VOLUMELOOP:				; start with sample 0
SAMPLELOOP:
	MOV	AL,BL
	IMUL	BH
	SAL	AX,1
	CMP	BH,1
	JA	SHORT GMK1
	XOR	AX,AX
GMK1:	STOSW
	INC	BL
	JNZ	SAMPLELOOP
	INC	BH
	CMP	BH,64
	JBE	VOLUMELOOP
	RET
MAKE_MIXMUL_VOLUMETABLE ENDP
;=============================================================================


;=============================================================================
;
; DOS ROUTINEN
;
;=============================================================================
;-----------------------------------------------------------------------------
; TIMER-IRQ-HANDLER: 1024 HZ CALLING FREQUENCE
;-----------------------------------------------------------------------------
TIMER_HANDLER PROC FAR
	PUSH	AX
	CMP	CS:SYSTEM,0
	JNE	SHORT WT6
	MOV	AL,UHR_STATC
	OUT	UHR_INDEX,AL
	JMP	SHORT WT1
WT1:	JMP	SHORT WT2
WT2:	IN	AL,UHR_PORT
	MOV	AL,20H
	OUT	IRQ3,AL
WT6:	MOV     AL,20H
	OUT	IRQ1,AL
	STI
	CMP	CS:MOD_STAT,0
	JE	SHORT WT3
	MOV	AX,WORD PTR CS:[BPM_SPEED+2]	;1024/20.48 = 50 HZ
	ADD	WORD PTR CS:[BPM_COUNT+2],AX
	MOV	AX,WORD PTR CS:[BPM_SPEED]
	ADC	WORD PTR CS:[BPM_COUNT],AX
	JNC	SHORT WT3
	PUSHA
	PUSH	DS 
	PUSH	ES 
	PUSH	CS
	POP	DS
	INC	IRQ_REENTER
	CALL	CONTROL_CHANNELS
;	MOV	AH,7
;	CALL	RASTER_COL
	CALL	MIXUP_CHANNELS
;	MOV	AH,0
;	CALL	RASTER_COL
	TEST	SB_MODUS,2
	JZ	SHORT WT5
	MOV	MOD_STAT,4
	JMP	SHORT WT4
WT5:	CMP	MOD_STAT,4
	JB	SHORT WT4
	MOV	MOD_STAT,2
WT4:	DEC	IRQ_REENTER
	POP	ES 
	POP DS
	POPA
WT3:	POP	AX
	CMP	CS:VAR_BUFSEG,0
	JNE	SHORT WT8
	CMP	CS:SYSTEM,0
	JE	SHORT WT7
	DEC	CS:IRQCOUNT
	JNZ	SHORT WT7
	MOV	CS:IRQCOUNT,56
WT8:	JMP	DWORD PTR CS:[HOLD70]
WT7:	IRET
TIMER_HANDLER ENDP
;-----------------------------------------------------------------------------
; SOUNDBLASTER-IRQ-HANDLER
;-----------------------------------------------------------------------------
SBIRQ_HANDLER PROC FAR
	PUSH    AX 
	PUSH	DX
	MOV	DX,CS:SB_RSTAT		;CLEAR 8 BIT IRQ
	CMP	CS:DMA_CHANNEL,4
	JB	SHORT GSBI2
	INC	DX			;CLEAR 16 BIT IRQ
GSBI2:	IN	AL,DX
	MOV	AL,20H
	CMP	CS:IRQ_NUMBER,8
	JB	SHORT GSBI1
	OUT	IRQ3,AL
GSBI1:	OUT	IRQ1,AL
	POP	DX 
	POP	AX
	IRET
SBIRQ_HANDLER ENDP
;-----------------------------------------------------------------------------
; SERVICE IRQ UMLEITUNG; USES THE REAL-TIME-CLOCK IRQ
;-----------------------------------------------------------------------------
IRQ_INIT PROC NEAR
	CLI
	XOR     AX,AX
	MOV     ES,AX
	CMP	SYSTEM,0
	JNE	WU11
	MOV     AX,COMP_SPEED2		;XCHANGE INIT & STOP DATA FOR DOS
	MOV     DX,COMP_SPEED3
	MOV     COMP_SPEED2,DX
	MOV     COMP_SPEED3,AX
	CMP	VAR_BUFSEG,0
	JNE	SHORT WU13
	MOV	AL,UHR_STATA		;UHR-IRQ-RATE EINSTELLEN (1024 HZ)
	OUT	UHR_INDEX,AL
	JMP	SHORT WU1
WU1:	JMP	SHORT WU2
WU2:	XCHG	AL,AH
	IN	AL,UHR_PORT
	AND	AL,0F0H
	OR	AL,DL
	XCHG	AL,AH
	OUT	UHR_INDEX,AL
	JMP	SHORT WU3
WU3:	JMP	SHORT WU4
WU4:	XCHG	AL,AH
	OUT	UHR_PORT,AL
	JMP	SHORT WU5
WU5:	JMP	SHORT WU6
WU6:	MOV	AL,UHR_STATB		;UHR-IRQ-MODUS EINSTELLEN
	OUT	UHR_INDEX,AL
	JMP	SHORT WU7
WU7:	JMP	SHORT WU8
WU8:	XCHG	AL,AH
	IN	AL,UHR_PORT
	AND	AL,08FH
	MOV	DL,DH
	AND	DL,40H
	OR	AL,DL
	XCHG	AL,AH
	OUT	UHR_INDEX,AL
	JMP	SHORT WU9
WU9:	JMP	SHORT WU10
WU10:	XCHG	AL,AH
	OUT	UHR_PORT,AL
	IN	AL,IRQ4			;IRQ8 DE-/MASKIEREN
	AND	AL,0FEH
	MOV	DL,DH
	AND	DL,1
	OR	AL,DL
	OUT	IRQ4,AL
WU13:	MOV	DL,DH
	AND	DL,1
	MOV	CL,IRQ_NUMBER
	CMP	CL,8
	JAE	SHORT WU20
	IN	AL,IRQ2			;SBIRQ 0-7 DE-/MASKIEREN
	SHL	DL,CL
	MOV	DH,0FEH
	ROL	DH,CL
	AND	AL,DH
	OR	AL,DL
	OUT	IRQ2,AL
	JMP	SHORT WU21
WU20:	SUB	CL,8			;SBIRQ 8-15 DE-/MASKIEREN
	IN	AL,IRQ4
	SHL	DL,CL
	MOV	DH,0FEH
	ROL	DH,CL
	AND	AL,DH
	OR	AL,DL
	OUT	IRQ4,AL
WU21:	MOV     BX,4*70H                ;UHR-IRQ VERBIEGEN
	MOV     EAX,ES:[BX]
	MOV     EDX,HOLD70
	MOV     ES:[BX],EDX
	MOV     HOLD70,EAX
	JMP	WU12
WU11:	CMP	VAR_BUFSEG,0
	JNE	SHORT WU14
	MOV     AX,COMP_SPEED4		;FOR WINDOWS
	MOV     DX,COMP_SPEED5
	MOV     COMP_SPEED4,DX
	MOV     COMP_SPEED5,AX
	MOV     AL,00110110B            ;TIMER0 AUF 1.024 KHZ EINSTELLEN
	OUT     PIT1,AL                 ;TEILER=1193
	MOV     AL,DL
	OUT     TIMER0,AL
	JMP     SHORT OUT40
OUT40:  MOV     AL,DH
	OUT     TIMER0,AL
WU14:	MOV     AX,COMP_SPEED2		;XCHANGE INIT & STOP DATA FOR DOS
	MOV     DX,COMP_SPEED3
	MOV     COMP_SPEED2,DX
	MOV     COMP_SPEED3,AX
	MOV	DL,DH
	AND	DL,1
	MOV	CL,IRQ_NUMBER
	CMP	CL,8
	JAE	SHORT WU30
	IN	AL,IRQ2			;SBIRQ 0-7 DE-/MASKIEREN
	SHL	DL,CL
	MOV	DH,0FEH
	ROL	DH,CL
	AND	AL,DH
	OR	AL,DL
	OUT	IRQ2,AL
	JMP	SHORT WU31
WU30:	SUB	CL,8
	IN	AL,IRQ4			;SBIRQ 8-15 DE-/MASKIEREN
	SHL	DL,CL
	MOV	DH,0FEH
	ROL	DH,CL
	AND	AL,DH
	OR	AL,DL
	OUT	IRQ4,AL
WU31:	MOV     BX,4*8H                 ;TIMEOUT-IRQ VERBIEGEN
	MOV     EAX,ES:[BX]
	MOV     EDX,HOLD70
	MOV     ES:[BX],EDX
	MOV     HOLD70,EAX
WU12:	MOVZX	BX,CL			;SOUNDBLASTER-IRQ VERBIEGEN
	ADD	BX,08H
	CMP	IRQ_NUMBER,8
	JB	SHORT WU40
	ADD	BX,68H
WU40:	SHL	BX,2
	MOV     EAX,ES:[BX]
	MOV     EDX,HOLDSB
	MOV     ES:[BX],EDX
	MOV     HOLDSB,EAX
	MOV	AL,20H
	OUT	IRQ3,AL
	OUT	IRQ1,AL
	STI
	RET
IRQ_INIT ENDP
;----------------------------------------------------------------------------
; HELYFOGLALèS A TRACKEKNEK, CF=1 hiba; CF=0 OK
;----------------------------------------------------------------------------
SET_TMEM PROC NEAR
	XOR	SI,SI			; SI=0
	XOR	AX,AX			; AX=0 CHECK FOR EMS-MANAGER
	MOV	ES,AX			; ES=0
	MOV	TRACK_HANDLE,AX		; TRACK_HANDLE = 0

	MOV	AX,ES:[4*67H+2]		; 67. IRQ-n levì szegmensc°m
	MOV	ES,AX			; ES-be
	CMP	ES:[10],"XMME"		; ES:10 nÇl "EMMXXXX0"-nak kell lenni,
	JNE	SHORT STCM1		; ha van EMS install†lva
	CMP	ES:[14],"0XXX"
	JNE	SHORT STCM1		; ha nincs, CY-vel hib†t jelezve kilÇp
	MOV	AH,42H						
	INT	67H			; szabad EMS vizsg†lata
	OR	AH,AH						
	JNZ	SHORT STCM1		; ha valami nem volt OK, CY&rerturn
	CMP	BX,4			; ha kevesebb EMS van, mint 4 lap,
	JB	SHORT STCM1		; az hiba. :) KilÇpÇs...

					; J¢ esetben viszont monden OK...
	MOV	AH,41H
	INT	67H			; EMS szegmensc°me BX-be
	MOV	TRACK_SEG,BX		; TRACK_SEG-re is elmentve...

	MOV	AH,43H			; Teh†t 4*16K EMS kÇrvÇnyezÇse,
	MOV	BX,4			; azaz megnyit†sa hendlerrel.
	INT	67H			; Ez lesz a TRACK_BUFFER
	MOV	TRACK_HANDLE,DX		; HANDLER elmentÇse

	MOV	AH,48H
	MOV	BX,80H			; PATTERNBUFFER foglal†sa: 2K
	INT	21H
	JC	SHORT STCM1		; hiba esetÇn kilÇpÇs
	MOV	PATTERN_SEG,AX		; PATTERN_SEG-ben a patternbuffer c°me

	CLC				; 'minden rendben' jelzi CF
	RET				; Çs kilÇp
STCM1:	
	STC				; 'baj' jelzi CF, Çs kilÇp
	RET
SET_TMEM ENDP
;----------------------------------------------------------------------------
; GIBT SPEICHER VON TRACKS WIEDER FREI
;----------------------------------------------------------------------------
FREE_TMEM PROC NEAR
	MOV	AX,SAMPLE_SEG
	MOV	ES,AX
	MOV	AH,49H
	INT	21H
	CMP	TRACK_SEG,0
	JE	SHORT GFTM1
	MOV	AH,45H
	MOV	DX,TRACK_HANDLE
	INT	67H
	MOV	TRACK_SEG,0
GFTM1:	RET
FREE_TMEM ENDP
;-----------------------------------------------------------------------------
; SET TRACK-PAGES
;-----------------------------------------------------------------------------
TRACK_PAGING PROC NEAR
	PUSHA				; minden mentve...
	XOR	BX,BX			; BX = 0, azaz a 0. EMS lapra
					; mutat.

	XOR	AL,AL			; AL = 0, ì pedig az EMS frame
					; 4 lapja kîzÅl az elsìre

	MOV	DX,TRACK_HANDLE		; a szÅksÇges TRACK-EMS handler
	MOV	AH,44H			
	INT	67H			; Teh†t az elsì 16K belapozva.

	INC	AL
	INC	BX
	MOV	AH,44H
	INT	67H			; a m†sodik is...

	INC	AL
	INC	BX
	MOV	AH,44H
	INT	67H			; nomeg a 3.

	INC	AL
	INC	BX
	MOV	AH,44H
	INT	67H			; Çs a vÇgsì

	POPA				; Mindent viszaPOPol
	RET
TRACK_PAGING ENDP
;-----------------------------------------------------------------------------
TRACK_SAVE PROC NEAR
	PUSH	AX 
	PUSH	DX
	MOV	DX,TRACK_HANDLE				;EMS MAPPING SICHERN
	MOV	AH,47H
	INT	67H
	POP	DX 
	POP AX
	RET
TRACK_SAVE ENDP
;-----------------------------------------------------------------------------
TRACK_RESTORE PROC NEAR
	PUSH	AX 
	PUSH	DX
	MOV	DX,TRACK_HANDLE		;EMS MAPPING ZURöCKSETZEN
	MOV	AH,48H
	INT	67H
	POP	DX 
	POP	AX
	RET
TRACK_RESTORE ENDP
;----------------------------------------------------------------------------
; HELYFOGLALèS A DMA-NAK, êS A MIXMUL-TèBLèNAK, CARRY 0=OK 1=BAJ
;----------------------------------------------------------------------------
SET_DMEM PROC NEAR
	MOV     AH,48H			; 1000h*16 bytenyi (64K) terÅlet
	MOV     BX,1000H                ; lefoglal†sa. Ez lesz a DMA
	INT     21H			; munkaterÅlete.

	JC      SHORT SDCM1		; Ha CF=1, akkor sajnos exitus.

	MOV     DMA_SEG,AX		; SzerencsÇs eset: AX-ben a szegmens
					; c°me, ami imm†r szabadon haszn†lhat¢
					; DMAskod†sra. Ez be is kerÅl a
					; DMA_SEG mem¢riav†ltoz¢ba.

	MOV	DMA_OFFSET,0		; DMA_BUFFER kb.  8K
					; kezdete: DMA_SEG:0000h

	MOV	MIXMUL_OFFSET,8000H	; MIXMUL_TAB kb. 16K
					; kezdete: DMA_SEG:8000h
				
	AND	AX,0FFFH		; ha a kapott szegmens X8000 alatt van,
	CMP	AX,0800H		; akkor is DMA_BUFFER 1 lapon legyen... 
	JBE	SHORT SDCM2				

	MOV	DMA_OFFSET,8000H	; teh†t ha X8000h felett van a c°m,
	MOV	MIXMUL_OFFSET,0		; akkor helycsere

SDCM2:	CLC				; 'rendben' visszajelzÇse
SDCM1:  RET
SET_DMEM ENDP
;----------------------------------------------------------------------------
; GIBT SPEICHER VON DMA & MIXMUL_VOLUMETABLE WIEDER FREI
;----------------------------------------------------------------------------
FREE_DMEM PROC NEAR
	MOV	ES,DMA_SEG
	MOV	AH,49H
	INT	21H
	RET
FREE_DMEM ENDP
;-----------------------------------------------------------------------------
FREE_MEM PROC NEAR
	MOV     BX,PROG_END_SEG         ; ES:=felszabad°tand¢ terÅlet eleje
	SUB     BX,PROG_START_SEG	; BX:=felsz.ter. hossza/16
	MOV     ES,PROG_START_SEG	;
	MOV     AH,4AH                  ; terÅlet felszabad°t†sa...
	INT     21H
	RET
FREE_MEM ENDP
;=============================================================================


;=============================================================================
;
; SOUNDBLASTER HARDWARE ROUTINEN
;
;=============================================================================
; SET MIXER
;-----------------------------------------------------------------------------
MIXER_INIT PROC NEAR
	MOV	DX,SBP_MIXERI
	MOV	AL,3CH
	OUT	DX,AL
	INC	DX
	IN	AL,DX
	OR	AL,00011110B		;ENABLE CD L/R IN,LINE L/R IN
	OUT	DX,AL
	DEC	DX
	MOV	AL,30H
	OUT	DX,AL
	INC	DX
	MOV	AL,255			;MAX MASTERVOLUME L
	OUT	DX,AL
	DEC	DX
	MOV	AL,31H
	OUT	DX,AL
	INC	DX
	MOV	AL,255			;MAX MASTERVOLUME R
	OUT	DX,AL
	DEC	DX
	MOV	AL,32H
	OUT	DX,AL
	INC	DX
	MOV	AL,255			;MAX DSPVOLUME L
	OUT	DX,AL
	DEC	DX
	MOV	AL,33H
	OUT	DX,AL
	INC	DX
	MOV	AL,255			;MAX DSPVOLUME R
	OUT	DX,AL
	DEC	DX
	MOV	AL,0EH
	OUT	DX,AL
	INC	DX
	MOV	AL,2H			;FILTER & STEREO
	OUT	DX,AL
	RET
MIXER_INIT ENDP
;-----------------------------------------------------------------------------
; SET DMA READY FOR TRANSFER WITH AUTOINIT
; IN: DX:BX= BLOCKPOINTER, CX= SIZE
;-----------------------------------------------------------------------------
DMA_INIT PROC NEAR
	CLI
	MOV	AX,DX			;ADRESSE IN PAGE UND OFFSET UMRECHNEN
	SHL	DX,4
	SHR	AH,4			;PAGE
	ADD	BX,DX			;OFFSET NEU
	ADC	AH,0
	MOV	AL,AH
	MOVZX	SI,DMA_CHANNEL
	CMP	SI,4
	JB	SHORT GDMI1
	SHR	CX,1
	SHRD	BX,AX,1			;ADRESSE FöR 16-BIT DMA
GDMI1:	MOV	DMA_POFF,BX
	DEC	CX			;DMA SIZE= BLOCK SIZE -1
	MOVZX	DX,[DMA_MASK+SI]
	MOV	AL,DMA_CHANNEL
	OR	AL,4
	OUT	DX,AL			;DMA-KANAL MASKIEREN
	MOVZX	DX,[DMA_MOD+SI]
	AND	AL,3
	OR	AL,01011000B
	OUT	DX,AL			;DMA-MODUS FöR SB
	MOVZX	DX,[DMA_FLIP+SI]
	OUT	DX,AL			;FLIP-FLOP CLEAR
	MOVZX	DX,[DMA_ADR+SI]
	MOV	AL,BL			;DMA CHANNEL 1-4
	OUT	DX,AL			;OFFSET LOW
	MOV	AL,BH
	OUT	DX,AL			;OFFSET HIGH
	MOVZX	DX,[DMA_CNT+SI]
	MOV	AL,CL
	OUT	DX,AL			;SIZE LOW
	MOV	AL,CH
	OUT	DX,AL			;SIZE HIGH
	MOVZX	DX,[DMA_PAGE+SI]
	MOV	AL,AH
	OUT	DX,AL			;PAGE
	MOVZX	DX,[DMA_MASK+SI]
	MOV	AX,SI
	AND	AL,3
	OUT	DX,AL			;DMA-KANAL DEMASKIEREN
	STI
	RET
DMA_INIT ENDP
;-----------------------------------------------------------------------------
; DSP SET SAMPLE RATE
;-----------------------------------------------------------------------------
DSP_RATE PROC NEAR
	MOV	AH,41H
	CALL	DSP_WRITE
	MOV	AX,SAMPLE_RATE
	CALL	DSP_WRITE
	MOV	AX,SAMPLE_RATE
	MOV	AH,AL
	CALL	DSP_WRITE
	RET
DSP_RATE ENDP
;-----------------------------------------------------------------------------
; DSP OUT BLOCK
;-----------------------------------------------------------------------------
DSP_OUT PROC NEAR
	CALL	DSP_RATE
	MOV	AH,0C6H			;8 BIT OUTPUT, AUTOINIT PCM
	CMP	DMA_CHANNEL,4
	JB	SHORT GDSPO1
	MOV	AH,0B6H			;16 BIT OUTPUT, AUTOINIT PCM
GDSPO1:	CALL	DSP_WRITE
	MOV	AH,30H			;STEREO SIGNED!
	CALL	DSP_WRITE
	MOV	AH,0F0H			;SIZE LOW
	CALL	DSP_WRITE
	MOV	AH,0FFH			;SIZE HIGH
	CALL	DSP_WRITE
	RET
DSP_OUT ENDP
;-----------------------------------------------------------------------------
; DSP RESET
; OUT: CARRY 1= FAILURE
;-----------------------------------------------------------------------------
DSP_RESET PROC NEAR
	CALL	DSP_OFF
	MOVZX	SI,DMA_CHANNEL
	MOVZX	DX,[DMA_MASK+SI]
	MOV	AL,DMA_CHANNEL
	OR	AL,4
	OUT	DX,AL			;DMA-KANAL MASKIEREN
	CALL	MIXER_INIT
	MOV	DX,SB_RESET
	MOV	AL,1
	OUT	DX,AL			;SEND RESET COMMAND
	MOV	CX,4
	CALL	WAIT_TIME		;WAIT
	XOR	AL,AL
	OUT	DX,AL			;CLEAR RESET COMMAND
	MOV	CX,120
	CALL	WAIT_TIME		;WAIT
	MOV	DX,SB_RSTAT
	IN	AL,DX			;CHECK IF SUCCESSFUL
	OR	AL,AL
	JNS	SHORT GDRES1
	MOV	DX,SB_READ
	IN	AL,DX
	CMP	AL,0AAH
	JNE	SHORT GDRES1
	CALL	DSP_ON
	CLC				;RESET OK
	RET
GDRES1:	STC				;RESET FAILURE
	RET
DSP_RESET ENDP
;-----------------------------------------------------------------------------
; LAUTSPRECHER EIN
;-----------------------------------------------------------------------------
DSP_ON PROC NEAR
	MOV	AH,0D1H			;SPEAKER ON
	CALL	DSP_WRITE
	MOV	CX,120
	CALL	WAIT_TIME		;WAIT
	RET
DSP_ON ENDP
;-----------------------------------------------------------------------------
; LAUTSPRECHER AUS
;-----------------------------------------------------------------------------
DSP_OFF PROC NEAR
	PUSH	CS
	POP	DS
	MOV	DX,SBP_MIXERI		;SB16
	CMP	LOADMOD_FLAG,0
	JNE	SHORT GDSPF1
	MOV	AL,30H			;AUSGEBAUT WEGEN CD UNTERBRECHUNG
	OUT	DX,AL
	INC	DX
	MOV	AL,0			;MIN MASTERVOLUME L
	OUT	DX,AL
	DEC	DX
	MOV	AL,31H
	OUT	DX,AL
	INC	DX
	MOV	AL,0			;MIN MASTERVOLUME R
	OUT	DX,AL
	DEC	DX
GDSPF1:	MOV	AL,32H
	OUT	DX,AL
	INC	DX
	MOV	AL,0			;MIN DSPVOLUME L
	OUT	DX,AL
	DEC	DX
	MOV	AL,33H
	OUT	DX,AL
	INC	DX
	MOV	AL,0			;MIN DSPVOLUME R
	OUT	DX,AL
	MOV	CX,240
	CALL	WAIT_TIME
	MOV	DX,SB_RESET
	MOV	AL,1
	OUT	DX,AL			;SEND RESET COMMAND
	MOV	CX,4
	CALL	WAIT_TIME		;WAIT
	XOR	AL,AL
	OUT	DX,AL			;CLEAR RESET COMMAND
	MOV	CX,120
	CALL	WAIT_TIME
	MOV	AH,0D3H			;DSP OFF
	CALL	DSP_WRITE
	MOV	CX,240
	CALL	WAIT_TIME
	RET
DSP_OFF ENDP
;-----------------------------------------------------------------------------
; READ BYTE
; OUT: AL= BYTE
;-----------------------------------------------------------------------------
DSP_READ PROC NEAR
	MOV	DX,SB_READ
	MOV	CX,-1			;FAIL SAFE
LDRD1:	IN	AL,DX
	CMP	AL,0AAH
	JNE	SHORT LDRD2
	LOOP	LDRD1
LDRD2:	RET
DSP_READ ENDP
;-----------------------------------------------------------------------------
; WRITE BYTE
; IN: AH= BYTE
;-----------------------------------------------------------------------------
DSP_WRITE PROC NEAR
	MOV	DX,SB_WRITE
	MOV	CX,1000H		;FAIL SAFE
LDWR1:	IN	AL,DX
	OR	AL,AL
	JNS	SHORT LDWR2
	LOOP	LDWR1
LDWR2:	MOV	AL,AH
	OUT	DX,AL
	RET
DSP_WRITE ENDP
;-----------------------------------------------------------------------------
; WAIT TIME
; CX = XXX MILLISECONDS
;-----------------------------------------------------------------------------
WAIT_TIME PROC NEAR
	PUSH	AX 
	PUSH	BX 
	PUSH	EDX
LWT1:	IN	AL,TIMER0
	MOV	BL,AL
	IN	AL,TIMER0
	MOV	BH,AL
	MOV	EDX,500000		;FAIL SAFE
LWT2:	IN	AL,TIMER0		;1 MILLISEC WARTEN
	XCHG	AL,AH
	IN	AL,TIMER0
	XCHG	AL,AH
	SUB	AX,BX
	NEG	AX
	DEC	EDX
	JZ	SHORT LWT3
	CMP	AX,1193
	JB	LWT2
LWT3:	LOOP	LWT1
	POP	EDX 
	POP BX 
	POP	AX
	RET
WAIT_TIME ENDP
;=============================================================================


;=============================================================================
;
; MOD tîltìrutin
;
;=============================================================================
; egy modfile betîltÇse...
; DS:DX mutat a filenÇvre.
;-----------------------------------------------------------------------------
LOAD_MOD PROC NEAR
	MOV	AX,3D00H		; MOD-File megnyit†sa
	INT	21H
	JC	GLDM1			; ha volt hiba, return
	PUSH 	CS							
	POP 	DS			; DS,CS := CS
	MOV	GDDHANDLE,AX		; kapott handler elmentÇse
GLDM0:
	CALL	SET_DMEM		; DMA-BUFFER helyfoglal†sa.
	CALL	SET_TMEM		; TRACK-BUFFER helyfoglal†sa
	CALL	TRACK_PAGING		; Belapoz†s megtîrpÇnt

	MOV	BX,GDDHANDLE		; MOD loader handlere

	MOV	GDDZEIG,0		; Mutat¢ kinull†z†sa

	CMP	LOADMOD_FLAG,0		; Ha nem nulla (alapban az)
	JNE	GLDM99			; akkor p†r dolog †tugorva...


	MOV	CX,10			; Mivel ez egy primk¢ player, °gy
LLDM1:					; ìt az elsì 20 byte (10 word), ami
	CALL	GET_QUEUE		; a SongName-t tartalmazza, nem Çrdekli.
	JC	GLDM2			; Ha baj volt: ugr†s GLDM2-re
	LOOP	LLDM1			

	; ---------------------------------------------------
	; Teh†t a pointer most Az elsì sample adatara mutat:
	; Ami £gy nÇz ki, hogy...
	; 22 byte a nÇv          [00-21]
	; 2 byte a mintahossz    [22-23]
	; 1 byte finetune        [24-24] az als¢ 4 bit csak
	; hangerì $00-$40        [25-25]
	; 2 byte a repeat start  [26-27]
	; 2 byte a repaat hossz  [28-29]
	; ---------------------------------------------------
        ; Ez îsszesen 30 byte


	MOV	SAMPLE_SIZE,0		; inicializ†l†s SAMPLE_SIZE=0
	XOR	SI,SI			; 31 hangszer lesz... ì mutat
					; a SAPMLE_SEG-en belÅl az Çpp
					; aktu†lis helyre. A SAMPLE_SEG
					; Elsì 62 byte-ja fogja tartalmazni
					; a samplehosszokat.

LLDM2:	MOV	AX,SAMPLE_SIZE
	MOV	[SAMPLE_SEG+SI],AX	; Itt t†rolja az aktu†lis sample
					; szegmensc°mÇt.

	MOV	CX,11			; A hangszer neve ugyancsak
LLDM3:	CALL	GET_QUEUE		; mehet a kuk†ba... :)
	JC	GLDM2
	LOOP	LLDM3

	XOR	EAX,EAX
	CALL	GET_QUEUE		; Hangszer hossz†nak beolvas†sa
					; Wordben adja meg
	XCHG	AL,AH			; Mivel amig†s forma, meg kell 
					; cserÇlni Intel form†ra. 
	CMP	AX,2		
	JAE	SHORT GLDM20		
	XOR	AX,AX			; Ha kettìnÇl kevesebb, az null†val
					; egyenÇrtÇkñ :)

GLDM20:	SHL	AX,1			; EgyÇbkÇnt meg szorozni kell kettìvel,
					; hogy byteban kapjuk meg a hosszt.
	MOV	[ISIZE+SI],AX		; Az 'ISIZE-buffer' t†rolja a hangszer-
					; hosszokat byteokban.

	OR	EAX,EAX			; ha nulla volt a hossz,
	JZ	SHORT GLDM9		; itt akkor nem tîrtÇnik semmi.

	SHR	EAX,4			; EgyÇb esetben a hosszt leosztva
	INC	AX			; szegmensmÇretñre, hozz† lehet adni
	ADD	SAMPLE_SIZE,AX		; a SAMPLE_SIZE-hez.

GLDM9:	CALL	GET_QUEUE		; IVOLUME & FINETUNE
	XCHG	AL,AH			; szok†sos cserebere
	MOV	[IVOL_FINETUNE+SI],AX	; let†rolva a helyÇn...

	CALL	GET_QUEUE		; az ILOOP_START tîmbben t†rol¢dik
	XCHG	AL,AH			; a hangmint†k esetleges loopj†nak
	SHL	AX,1			; kezdìb†jtja. Ugye ezt is wordben
	MOV	[ILOOP_START+SI],AX	; t†rolja a file, de ennek byteban
					; kell.

	CALL	GET_QUEUE		; hasonszìrÅ m¢don megy a loop hossza
	XCHG	AL,AH			; is, amit az ILOOP_SIZE-ben t†rol.
	SHL	AX,1
	MOV	[ILOOP_SIZE+SI],AX	

	INC	SI
	INC	SI			; pointer nîvelÇs

	CMP	SI,62			; ha elfogyott a 31 instrument,
					; akkor jîhetnek a songadatok...

	JB	LLDM2			; kÅlînben ciklusismÇtlÇs.


	CALL	GET_QUEUE		; MuzakmÇret patternsz†mban mÇrve.
					; a m†sik b†jt meg a loop point.
	JC	GLDM2			; persze lehet hiba is.
	MOV	SONG_SIZE,AL
	MOV	SONG_LOOP,AH		; t†rolva...

	XOR	DX,DX
	MOV	CX,64			; 64*2=128, ennyi a maxpattern/song
	MOV	DI,OFFSET SONG_DATA	; ide lesz †trakva.

LLDM4:	CALL	GET_QUEUE		
	JC	GLDM2
	MOV	[DI],AX			

	CMP	AL,DL			; Ez a rÇsz gondoskodik arr¢l
	JBE	SHORT GLDM12		; hogy DL-be kerÅljîn a legnagyobb
	MOV	DL,AL			; patternÇrtÇk.
GLDM12:	CMP	AH,DL
	JBE	SHORT GLDM13
	MOV	DL,AH

GLDM13:	INC	DI
	INC	DI
	LOOP	LLDM4			; DI+2, Çs loop!


	INC	DL
	CLD
	MOV	PATTERN_NUMBER,DX	; PATTERN_NUMBER=maxpattern+1

	CALL	GET_QUEUE
	PUSH	AX
	CALL	GET_QUEUE
	SHL	EAX,16
	POP	AX			; EAX-be kerÅl a kîv 4 byte

	MOV	MOD_SIGN,EAX
	CMP	EAX,"NHC8"		; 8CHN-MOD Çs
	JE	SHORT GLDM3
	CMP	EAX,"8TLF"		; FLT8-MOD esetÇn GLDM3 veszi †t a 
	JE	SHORT GLDM3		; mñkîdÇst

	CMP	EAX,".K.M"		; Ha M.K.-MOD, akkor GLDM10 jîn
	JE	SHORT GLDM10		

	CMP	EAX,"4TLF"		; Ha pedig FLT4-MOD, azt nem szereti
	JNE	GLDM2
;- 4 csatorn†s MOD ---------------------------------------------------------
GLDM10:	MOV	CH_NUMB,4		
	MOV	PATTERN_SIZE,1024	; 4 byte * 4 csatorna * 64 sor = 1024
	MOV	AH,0
	MOV	TRACK_INFO+4,AH		; TRACK 4-7 kikapcs..
	MOV	TRACK_INFO+5,AH		
	MOV	TRACK_INFO+6,AH		
	MOV	TRACK_INFO+7,AH		
	JMP	SHORT GLDM11
;- 8 csatorn†s MOD ---------------------------------------------------------
GLDM3:	MOV	CH_NUMB,8		
	MOV	PATTERN_SIZE,2048	; 4 byte * 8 csatorna * 64 sor = 2048

GLDM11:	MOV	PATTERN_CURRENT,0	; Egy kis inicializ†lgat†s...
	MOV	TRACK_NUMBER,0
LLDM7:	MOV	ES,PATTERN_SEG
	MOV	BX,GDDHANDLE
	XOR	DI,DI
LLDM6:	XOR	SI,SI

LLDM5:	CALL	GET_QUEUE		
	JC	GLDM2
	MOV	DX,AX			
	CALL	GET_QUEUE
	JC	GLDM2			

; Teh†t most be van tîltve DX-AX-be egy note. MÇgpedig £gy hogy...
; DL: EgyrÇszt a felsì 4 biten van a hangminta sz†m†nak felsì 4 bitje a 8-b¢l,
;     Valamint az als¢ 4 bit a 'note preiod' 12 bites ÇrtÇkÇnek a felsì
;     4 bitjÇt tartalmazza
; DH: A 12 bites 'note period' maradÇk (als¢) rÇsze.
; AL: A felsì 4 biten a hangminta sz†m als¢ 4 bitje tal†lhat¢,
;     Az als¢ nÇgyen pedig Az EFFECT parancs elsì karaktere.
; AH: Az EFFECT parancs sz†mrÇsze.

	ROL	AL,4			
	MOV	CL,AL	
	AND	AL,0FH			; A hangminta sz†m†nak als¢ 4 bitje
					; AL-be kerÅl, a felsì 4 bit null†zva.
	AND	CL,0F0H			; CL tetejÇn pedig az effekt k¢d
					; tal†lhat¢, az als¢ 4 bit pedig 0.

	MOV	CH,DL			
	AND	DL,0FH			; DL= note period felsì 4 bitje.
			
	AND	CH,0F0H
	OR	AL,CH			; Most teh†t AL-ben a hangminta sz†ma!

	OR	DL,CL			; DL = felÅl az effekt k¢d, alul meg
					; a note period felsì 4 bitje.
	XCHG	DL,DH			; Mostm†r £gy nÇz ki, hogy DX felsì
					; 4 bitje az effekt k¢d, a maradÇk 12
					; meg a note period.
					; AX meg £gy, hogy felÅl az effekt 
					; parancs sz†mrÇsze, alul meg a
					; hangminta sz†ma tal†lhat¢.
					
; A ProTracker MODfile-ban a note-ok balr¢l jobbra/fentrìl lefele vanna
; t†rolva. De a mem¢ri†ban viszont (TRACK_SEG) fentrìl le/jobbra t†rol¢dik
; a pattern.

	PUSH	DI			
	ADD	DI,SI			; SI lehet 0,256,512...stb, DI pedig
					; 0,4,8,0ch,10h..stb, a kettìbìl
					; jîn îssze, hova kell rakni a
					; note adatot.
	SHL	EAX,16			; EAX := AX:DX
	MOV	AX,DX
	STOSD				; le is t†rolva DI c°men
	POP	DI

	ADD	SI,256			; na, itt nì 256-os†val SI
	CMP	SI,PATTERN_SIZE		; Ha SI elÇri a PATTERN_SIZE mÇretet,
					; akkor jîhet a kîv. sor a patternben.
	JB	LLDM5			; 1ÇbkÇnt vissza...

	ADD	DI,4			; Teh†t ha megvolt, DI is nìhet vÇgre
					; nÇggyel.
	CMP	DI,256			; Ha mÇg nem a 64. sor lenne, lehet
					; SI-t null†zni, azt tov†bb :)
	JB	LLDM6			

	CALL	SET_FREQUENCIES		;
	MOV	ES,TRACK_SEG		;TRACK1-8 INTEGRIEREN
	MOV	DX,TRACK_NUMBER
	XCHG	DL,DH
	MOV	DS,PATTERN_SEG
	XOR	SI,SI
	XOR	BX,BX
LLDM8:	XOR	DI,DI
LLDM9:	CMP	DX,DI
	JBE	SHORT GLDM4
	PUSH	SI 
	PUSH	DI
	MOV	CX,256/4
	REPE CMPSD			;TRACK ALREADY EXISTS?
	POP	DI 
	POP	SI
	PUSHF
	ADD	DI,256
	POPF
	JNE	LLDM9
	JMP	SHORT GLDM5
GLDM4:	INC	DH			;NO, ADD TRACK TO BUFFER
	PUSH	SI
	MOV	CX,256/4
	REP MOVSD
	POP	SI
GLDM5:	MOV	AX,DI			;YES
	DEC	AH
	MOV	CS:[TRACK_INFO+BX],AH
	INC	BX
	ADD	SI,256
	CMP	BX,CS:CH_NUMB
	JB	LLDM8
	PUSH	CS
	POP	DS
	XCHG	DL,DH
	MOV	TRACK_NUMBER,DX
	XOR	BX,BX			;TRACKLISTE NACHFöHREN
	MOV	AX,PATTERN_CURRENT
LLDM10:	CMP	[SONG_DATA+BX],AL
	JNE	SHORT GLDM6
	MOV	AH,TRACK_INFO
	MOV	[TRACK1_DATA+BX],AH
	MOV	AH,TRACK_INFO+1
	MOV	[TRACK2_DATA+BX],AH
	MOV	AH,TRACK_INFO+2
	MOV	[TRACK3_DATA+BX],AH
	MOV	AH,TRACK_INFO+3
	MOV	[TRACK4_DATA+BX],AH
	MOV	AH,TRACK_INFO+4
	MOV	[TRACK5_DATA+BX],AH
	MOV	AH,TRACK_INFO+5
	MOV	[TRACK6_DATA+BX],AH
	MOV	AH,TRACK_INFO+6
	MOV	[TRACK7_DATA+BX],AH
	MOV	AH,TRACK_INFO+7
	MOV	[TRACK8_DATA+BX],AH
GLDM6:	INC	BX
	CMP	BL,128
	JB	LLDM10
	INC	PATTERN_CURRENT		;NéCHSTES PATTERN HOLEN
	MOV	AX,PATTERN_CURRENT
	CMP	AX,PATTERN_NUMBER
	JB	LLDM7
	JMP	SHORT GLDM7

GLDM99:	CMP	TRACK_SEG,0		;TRACK SEGMENT WIEDER LôSCHEN
	JE	SHORT GLDM7
	MOV	AH,45H
	MOV	DX,TRACK_HANDLE
	INT	67H
	MOV	TRACK_SEG,0
GLDM7:	MOV	ES,PATTERN_SEG		;PATTERN SEGMENT WIEDER LôSCHEN
	MOV	AH,49H
	INT	21H
	CMP	LOADMOD_FLAG,0
	JNE	SHORT GLDM98
	MOV	BX,SAMPLE_SIZE		;SAMPLE SEGMENT ALLOKIEREN 
	MOV	AH,48H
	INT	21H
	XOR	BX,BX
LLDM11:	ADD	[SAMPLE_SEG+BX],AX
	INC	BX
	INC	BX
	CMP	BX,62
	JB	LLDM11
	MOV	BX,GDDHANDLE
	XOR	SI,SI			;SAMPLES LADEN
LLDM12:	MOV	CX,[ISIZE+SI]
	MOV	ES,[SAMPLE_SEG+SI]
	XOR	DI,DI
	SHR	CX,1
	JCXZ	SHORT GLDM8
LLDM13:	CALL	GET_QUEUE
	STOSW
	LOOP	LLDM13
GLDM8:	INC	SI
	INC	SI
	CMP	SI,62
	JB	LLDM12
GLDM98:	CLC
	JMP	SHORT GLDM15
GLDM2:	STC
GLDM15:	PUSHF
	CMP	VAR_BUFSEG,0
	JNE	SHORT GLDM16
	MOV	AH,3EH
	INT	21H
GLDM16:	POPF
GLDM1:	RET
LOAD_MOD ENDP
;-----------------------------------------------------------------------------
; ERSETZT DIE MEISTEN FREQUENZ-PERIODEN DURCH DEN TABELLEN-INDEX
;-----------------------------------------------------------------------------
SET_FREQUENCIES PROC NEAR
	XOR	DI,DI
SET_FREQ1:
	MOV	AX,ES:[DI]		;get fx
	MOV	DX,AX
	SHR	AH,4
	CMP	AH,3
	JE	SHORT SET_FREQ4
	CMP	AH,5
	JE	SHORT SET_FREQ4
	MOV	AX,DX
	AND	AX,0FFFH		; Mask out unwanted bits.
	JZ	SHORT SET_FREQ4
	XOR	BX,BX
	MOV	CX,48			; 36 periods to cycle through.
SET_FREQ2:
	CMP	AX,[MT_PERIODTABLE+BX]	; Check the note against the period.
	JAE	SHORT SET_FREQ3		; We found it!
	INC	BX			; Otherwise, update the pointer and
	INC	BX
	LOOP	SET_FREQ2		; keep looping.
SET_FREQ3:
	MOV	AX,DX			;recall the Note Value
	AND	AX,0F000H		;just keep fx
	INC	BX
	OR	AX,BX			;put in the new offset
	STOSW				;store it
	DEC	DI
	DEC	DI
SET_FREQ4:
	ADD	DI,4			;and go to next channel
	CMP	DI,PATTERN_SIZE
	JB	SET_FREQ1
	RET
SET_FREQUENCIES ENDP
;-----------------------------------------------------------------------------
; a GDDZEIG †ltal mutatott wordît adja vissza AX-ben
; IN : BX= HANDLE
; OUT: AX= ÇrtÇk
; szÅksÇg esetÇn (ha GDDZEIG=0) a buffert friss°ti is.
;-----------------------------------------------------------------------------
GET_QUEUE PROC NEAR
	CMP     GDDZEIG,0
	JNE     SHORT GTQ1		; Ha GDDZEIG jelzì nem nulla, akkor
					; az inicializ†l¢ rÇszt †tugorja

	PUSH	CX 
	PUSH	DX
	MOV     DX,OFFSET QUEUE_BUFFER	
	MOV     CX,256
	MOV     AH,3FH		
	INT     21H			; QUEUE_BUFFERBE 256 byte betîltÇse

	MOV	GDDREST,AX		; GDDREST = amennyit sikerÅlt beolvasni
	POP	DX 
	POP	CX

GTQ1:
	PUSH	BX			; Handler elmentÇse
	MOV     BL,GDDZEIG
	XOR     BH,BH			; BX=GDDZEIG azaz a mutat¢.

	CMP	BX,GDDREST		; Ha GDDREST m†r kevesebb, mint
	JAE	SHORT GTQ2		; a mutat¢, akkor baj van!

	MOV     AX,[QUEUE_BUFFER+BX]	; EgyÇbkÇnt AX-be kerÅl a GDDZEIG
					; †ltal mutatott WORD

	ADD     GDDZEIG,2		; mutat¢ nîvelÇse.

	POP	BX			; Handler vissza
	CLC				; 'Rendben', jelzi a CF=\CY
	RET
GTQ2:	
	POP	BX
	STC				; Bajt jelez a CF=CY
	RET
GET_QUEUE ENDP
;=============================================================================
; LéDT EIN SAMPLE
; INPUT: DS:DX= FILENAME, CL= 00H AMIGA-SAMPLE, 80H PC-SAMPLE
; OUTPUT: AX= SAMPLE-HANDLE FOR PLAYING
;-----------------------------------------------------------------------------
LOAD_SAMPLE PROC NEAR
	MOV	AX,3D00H		;OPEN SAMPLE
	INT	21H
	JC	GSMP1
	PUSH	CS
	POP	DS
	MOV	GDDHANDLE,AX
	MOV	BX,AX
	PUSH	CX
	CALL	GET_FILESIZE
	POP	CX
GSMP0:	AND	CL,80H
	MOV	SAM_FLAG1,CL
	MOV	GDDZEIG,0
	MOV	CX,AX
	AND	CX,0FFFEH
	SHR	AX,4
	INC	AX
	MOV	BX,AX
	CMP	EMS_SEG,0
	JNE	SHORT GSMP3
	PUSHA
	XOR	SI,SI
	XOR	AX,AX			;CHECK FOR EMS-MANAGER
	MOV	ES,AX
	MOV	EMS_HANDLE,AX
	MOV	AX,ES:[4*67H+2]
	MOV	ES,AX
	CMP	ES:[10],"XMME"
	JNE	GSMP2
	CMP	ES:[14],"0XXX"
	JNE	GSMP2
	MOV	AH,42H
	INT	67H
	OR	AH,AH
	JNZ	GSMP2
	CMP	BX,37
	JB	GSMP2
	MOV	AH,41H
	INT	67H
	MOV	EMS_SEG,BX
	MOV	AH,43H			;ALLOCATE 592K EMS FOR FX
	MOV	BX,37
	INT	67H
	MOV	EMS_HANDLE,DX
	XOR	AX,AX
	MOV	EMS_OFFSET,AX
	MOV	SAMPLE_ZEIG,AX
	POPA
GSMP3:	MOV	AX,EMS_OFFSET
	MOV	SI,SAMPLE_ZEIG
	MOV	[SAMPLE_MEM+SI],AX
	MOV	[SAMPLE_BIG+SI],CX
	ADD	SAMPLE_ZEIG,2
	MOV	DI,CX
	SHR	DI,4
	INC	DI
	ADD	EMS_OFFSET,DI
	XOR	DI,DI
	CLD
	INC	CX
	SHR	CX,1
	MOV	DL,SAM_FLAG1
	MOV	DH,DL
	AND	EAX,0FFFFH
	SHL	EAX,4
LSMP1:	PUSH	EAX 
	PUSH	SI
	OR	DI,DI
	JNZ	SHORT GSMP4
	CALL	EMS_PAGING
	MOV	DI,SI
GSMP4:	MOV	BX,GDDHANDLE
	CALL	GET_QUEUE
	XOR	AX,DX
	STOSW
	POP	SI 
	POP	EAX
	INC	EAX
	INC	EAX
	LOOP	LSMP1
	CLC
	PUSHA
GSMP2:	POPA
	PUSHF
	CMP	VAR_BUFSEG,0
	JNE	SHORT GSMP5
	MOV	BX,GDDHANDLE
	MOV	AH,3EH
	INT	21H
GSMP5:	MOV	AX,SI
	POPF
GSMP1:	RET
LOAD_SAMPLE ENDP
;-----------------------------------------------------------------------------
GET_FILESIZE PROC NEAR
	MOV	AX,4202H
	XOR	CX,CX
	XOR	DX,DX
	INT	21H
	PUSH	AX
	MOV	AX,4200H
	XOR	CX,CX
	XOR	DX,DX
	INT	21H
	POP	AX
	RET
GET_FILESIZE ENDP
;=============================================================================
; LOAD CONFIG DATA (PARSER)
; IN: CX=0C242H, DS:BX= POINTER TO PARAM-BLOCK
;
; PARAM-BLOCK: 	+ 0 BASE PORT		210H-280H, 388H, ETC.
;              	+ 2 DMA NUMBER		0-7
;              	+ 3 IRQ NUMBER		0-15
;		+ 4 SAMPLE RATE		10000-44100
;               + 6 INTERNAL TYPE       0,1,2,3,... (if necessary)
;		+ 7 INTERRUPT TYPE      0,1 (realtime clock, timer)
;               + 8 STARTING POSITION   0-127
;               + 9 LOOP POSITION	0-127,128
;               +10 SONG MODUS		0-3
;               +11 START MASTER VOLUME 0-255
;		+12 START MUSIC VOLUME	0-255
;               +13 START FX VOLUME     0-255
;-----------------------------------------------------------------------------
CONFIG_INIT PROC NEAR
	MOV	DX,DS			; DX := adatszegmens
	MOV	AX,CS			; AX := k¢dszegmens
	MOV	DS,AX			; DS := k¢dszegmens
	MOV	WORD PTR HOLD70+2,AX	; HOLD70+2 := k¢dszegmens
	MOV	WORD PTR HOLDSB+2,AX	; HOLDSB+2 := k¢dszegmens
	CMP	CX,0C242H		
	JNE	SHORT NORMAL_CONFIG	; Ha CX nem C242h, akkor cfg-bìl...
			
					
					; egyÇbkÇnt a param-blockb¢l szedi.
	MOV	ES,DX			; ES := DS
	MOV	AX,ES:[BX]
	ADD	AL,4
	MOV	SBP_MIXERI,AX
	INC	AX
	MOV	SBP_MIXERD,AX
	INC	AX
	MOV	SB_RESET,AX
	ADD	AX,4
	MOV	SB_READ,AX
	ADD	AX,2
	MOV	SB_WRITE,AX
	ADD	AX,2
	MOV	SB_RSTAT,AX
	MOV	AL,ES:[BX+2]
	AND	AL,7
	MOV	DMA_CHANNEL,AL
	MOV	AL,ES:[BX+3]
	AND	AL,15
	MOV	IRQ_NUMBER,AL
	MOV	AX,ES:[BX+4]
	MOV	SAMPLE_RATE,AX
	MOV	AL,ES:[BX+7]
	AND     AL,1
	MOV     SYSTEM,AL
	MOV	AL,ES:[BX+8]
	AND	AL,127
	MOV	SONG_START,AL
	MOV	AL,ES:[BX+9]
	MOV	SONG_LOOP,AL
	MOV	AL,ES:[BX+10]
	AND     AL,3
	MOV	SB_MODUS,AL
	MOV	AL,ES:[BX+11]
	MOV	BX,ES:[BX+12]
	CALL	SET_VOLUME
	JMP	CONT_CONFIG
NORMAL_CONFIG:
	MOV     DX,OFFSET CONFIG_NAME	; DX-ben a config file nevÇnek 
					; c°me
	MOV     AH,3DH			; DS:DX szerinti file
	MOV     AL,80H			; megnyit†sa olvas†sra (none deny)
	INT     21H
	JC      GCFG1			; hiba esetÇn... return
	MOV     GDDHANDLE,AX		; handler elmentÇse
LCFG1:
	XOR     SI,SI			; SI:=0, ì a sz†ml†l¢ lesz.
	MOV     DX,OFFSET QUEUE_BUFFER	; ide tîltìdik majd mindig a config 
					; aktu†lis sora

	; Itten kezdìdik a config file egy sor†nak beolvassa a pufferbe

LCFG2:
	MOV     AH,3FH			;
	MOV     BX,GDDHANDLE		; A config file-b¢l
	MOV     CX,1			; 1 byte...
	INT     21H			; ... beolvas†sa
	JC      GCFG2			; ha hiba, becsuk... return
	OR      AX,AX			;
	JZ      GCFG2			; ha nem m†r volt byte.. return
	MOV     DI,DX							
	CMP     BYTE PTR [DI],0AH	; egyÇbkÇnt...Enter?
	JE      SHORT GCFG6		; ez esetben megvolt a sor,... ugr†s!
	INC     DX			; ha nem, jîhet a kîvetkezì karakter
	INC     SI				
	CMP     SI,256				
	JB      LCFG2			; ha 256 n†l tîbb m†r a karakter
					; akkor exitus, 1ÇbkÇnt nextchar


GCFG6:
	MOV     BX,OFFSET CFG_TEXT2	; 'DEFAULT MUSIC CODE ='-ra mutat
	CALL    SEEK_LINE				
	JNC     SHORT GCFG4		; ha nem ismerte fel a sort,
					; pr¢b†lkozik a 'BASE PORT'-al
	LODSB				; paramÇter AL-be
	AND	AL,1		
	MOV	CD_MIXER,AL		; 1 byte 0. bitje cd mixer
	LODSB			
	AND     AL,3			; 2. byte als¢ kÇt bitje...
	MOV	SB_MODUS,AL		; SB_MODUS-ba
	JMP     LCFG1			; lessÅk meg a next sort!

GCFG4:
	MOV     BX,OFFSET CFG_TEXT3	; 'BASE PORT'-e a szîveg?
	CALL    SEEK_LINE
	JNC     SHORT GCFG5		; ha nem, tov†bb...
	INC	SI			; a 2. byte Çrdekes. 2,3 v. 4
					; ettìl lesz 220, 230, ill. 240
	LODSB				; na, mi is az vÇgÅl?
	DEC	AL			; - 1
	AND	AL,7			; csak 3 bit Çrdekel.
	INC	AL			; + 1, °gy a karakteres sz†mb¢l
					; annak megfelelì byte lesz :)
	SHL	AL,4			; amit fel is szorzunk 16-al
	MOV	AH,2			; hozz†adunk 200h-t, Çs kÇsz a
					; teljes base port ÇrtÇk AX-ben!
	ADD	AL,4				
	MOV	SBP_MIXERI,AX		; mixerindx = baseport+04 
	INC	AX
	MOV	SBP_MIXERD,AX		; mixerdata = baseport+05 
	INC	AX
	MOV	SB_RESET,AX		; sbreset   = baseport+06
	ADD	AX,4
	MOV	SB_READ,AX		; sbread    = baseport+0A
	ADD	AX,2
	MOV	SB_WRITE,AX		; sbwrite   = baseport+0C
	ADD	AX,2
	MOV	SB_RSTAT,AX		; sbrstat   = baseport+0E
	JMP     LCFG1			; look next line!!

GCFG5:  
	MOV     BX,OFFSET CFG_TEXT4	; 'IRQ'-e a szîveg?
	CALL    SEEK_LINE					
	JNC     SHORT GCFG7		; nem, tov†bb.
	LODSW				; 1-bìl 2 byte-ot olvas, hm
	AND     AL,1
	AND	AH,15			; als¢ 4 bit.
	MOV	BH,AH							
	MOV	BL,10
	MUL	BL						
	ADD	AL,BH			; AL=2 helyiÇrtÇk+1 helyiÇrtÇk*10
	MOV	IRQ_NUMBER,AL		; Çs ez IRQ_NUMBER-ban t†rolva
	JMP	LCFG1			; nextline

GCFG7:  
	MOV     BX,OFFSET CFG_TEXT5	; "DMA NUMBER' a sor?
	CALL    SEEK_LINE
	JNC     SHORT GCFG8		; nem, akkor m†s tal†n?
	LODSB									
	AND	AL,7			; als¢ 3 bit elÇg °gy meg is van a
	MOV	DMA_CHANNEL,AL		; DMA csatorna sz†ma :)
	JMP	LCFG1

GCFG8:
	MOV	BX,OFFSET CFG_TEXT6	; 'SAMPLERATE'-e?
	CALL	SEEK_LINE
	JNC	SHORT GCFG9		; neem? akkor tov†bb!
	XOR	BX,BX			; 5 karakter a rate, ugyeb†r
	MOV	CX,5			; BX meg egyelìre 0.

LCFG3:
	MOV	AX,BX			; felszorz†s t°zzel...
	MOV	DX,10				
	MUL	DX		
	MOV	BX,AX			; ....egÇszen ide†ig
	LODSB				; AL az akt helyiÇrtÇk
	AND	AL,0FH			; csak az als¢ 4 bit kell
	XOR	AH,AH			; AX=AL
	ADD	BX,AX			; hozz†adjuk a rate-hoz, hogy
					; azt†n szorozzuk is t°zzel, ha
					; van mÇg helyiÇrtÇk.
	LOOP	LCFG3
	MOV	SAMPLE_RATE,BX		; ha mind az 5 karakter megvolt, 
					; akkor kÇsz.
	JMP     LCFG1			; next sor.

GCFG9:	
	MOV     BX,OFFSET CFG_TEXT7	; 'SYS COMP.'-e?
	CALL    SEEK_LINE			
	JNC     LCFG1			; ha nem, akkor nincs tîbb tipp,
					; jîhet az £j sor..
	LODSB									
	AND     AL,1			; csak 1 bit Çrdekes.
	MOV     SYSTEM,AL		; system-be teh†t 1 vagy 0 kerÅl
	JMP     LCFG1			; next sor
GCFG2:
	MOV     BX,GDDHANDLE		;
	MOV     AH,3EH			; file z†r†sa...
	INT     21H			; ... majd exit
CONT_CONFIG:
GCFG1:
	RET
CONFIG_INIT ENDP
;-----------------------------------------------------------------------------
SEEK_LINE PROC NEAR
	CLD				; innentìl minden blokk inc...
	MOV     SI,OFFSET QUEUE_BUFFER	; SI mutat a beolvasott sorra
LSKL1:  
	PUSH    BX			; BX verembe (ì mutat a keresì sorra)
LSKL2:  
	CMP     BYTE PTR [BX],0		; sorvÇge? Akkor vÇgigÇrt!
	JE      SHORT GSKL1		; ez esetben visszatÇr CY-vel
	CMP     SI,DX			; akt. queue vÇge?
	JAE     SHORT GSKL2		; kilÇpÇs ha nagyobb SI DX-nÇl,
					; vagy = vele, azaz queue vÇge.
	LODSB				; AL=[SI]; SI=SI+1
	CMP     AL,[BX]			; eddig egyezik?
	JNE     SHORT GSKL3		; ha nem
	INC     BX      		; norm†l esetben BX nîvelendì
	JMP     LSKL2			; majd vissza az olvas†shoz
GSKL3:  
	POP     BX			;\
	JMP     LSKL1			;/kezgyÅk £jra innen...back
GSKL2:  
	POP     BX
	CLC				; negat°v visszajelzÇssel tÇr vissza.
	RET
GSKL1:  
	POP     BX			; ha vÇgigÇrt a bizonyos soron :)
	STC				; CF = 1
	RET				; and return...
SEEK_LINE ENDP
;=============================================================================


;=============================================================================
PLAY_MUSIC PROC NEAR
	PUSH	CS
	POP	DS
	MOV	MOD_STAT,0		;DEACTIVATE IRQ-HANDLING
	CALL	DSP_RESET
	JC	GPM1
	CALL	MAKE_MIXMUL_VOLUMETABLE
	CALL	IRQ_INIT
	MOVZX	EBX,SAMPLE_RATE
	MOV	EDX,36H
	MOV	EAX,9E940000H		;1,193,180 * 30000H FOR FREQ CALCS
	DIV	EBX
	MOV	MAINFREQ,EAX
	MOV	CL,DMA_CHANNEL
	SHR	CL,2
	MOV	AX,BX
	XOR	DX,DX
	MOV	BX,50			;AMIGA TIMING IS 50HZ (SCREEN-REFRESH)
	DIV	BX
	SHL	AX,1			;STEREO
	SHL	AX,CL			;8/16 BIT
	MOV	DMA_CX,AX		;# OF BYTE/CYCLE (3445 FOR 44100 HZ)
	SHL	AX,2			;4 TIMES FORWARD
	MOV	DMA_MORE,AX
	SHL	AX,2			;8/16 TIMES MAXIMUM
	SHR	AX,CL			;     (27560 FOR 44100 HZ)
	MOV	DMA_MAX,AX
	MOV	AX,DMA_OFFSET
	MOV	DMA_PTR,AX
	MOV	DMA_NEWPTR,AX
	MOV	AL,125
	CALL	Go_SetBPM
	MOV	BPM_COUNT,0
	MOV	MT_SPEED,6		;DEFAULT PROTRACKER SPEED
	XOR	AX,AX
	MOV	SAM_CH,AL
	MOV	MT_COUNTER,AL		;RESET PROTRACKER VARIABLES
	MOV	MT_PATTERNPOS,AX
	MOV	DL,SONG_START
	MOV	MT_SONGPOS,DL
	MOV	MT_PATTDELAYTIME2,AL
	MOV	MT_PATTDELAYTIME,AL
	MOV	MT_PBREAKFLAG,AL
	MOV	MT_PBREAKPOS,AL
	MOV	MT_POSJUMPFLAG,AL
	MOV	MT_LOWMASK,0FFH
	MOV	CX,47*8/2
	CLD
	PUSH	DS
	POP	ES
	MOV	DI,OFFSET NOTE
	REP STOSW
	INC	AL
	MOV	CX,MAX_CHAN_NUMB
	MOV	DI,OFFSET TONEPORTDIREC
	REP STOSB
	XOR	BX,BX
LPM2:	MOV	AL,[PAN_REGS+BX]
	MOV	[MPANNING+BX],AL
	INC	BX
	CMP	BX,MAX_CHAN_NUMB
	JB	LPM2
	CMP	DMA_CHANNEL,4		;SET 8/16 BIT MIXING SMCODE
	JAE	SHORT GPM3
	MOV	AL,90H			;NOP WITH 8 BIT
	MOV	BYTE PTR NOP1,AL
	MOV	BYTE PTR NOP2,AL
	MOV	BYTE PTR NOP3,AL
	MOV	BYTE PTR NOP4,AL
	MOV	BYTE PTR NOP5,AL
	MOV	BYTE PTR NOP6,AL
	MOV	AX,2588H		;MOV [DI],AH
	MOV	WORD PTR MOVA1,AX
	MOV	WORD PTR MOVA2,AX
	MOV	WORD PTR MOVA3,AX
	MOV	AX,2500H		;ADD [DI],AH
	MOV	WORD PTR ADDA2,AX
	MOV	WORD PTR ADDA3,AX
	MOV	AX,3D88H		;MOV [DI],BH
	MOV	WORD PTR MOVB1,AX
	MOV	WORD PTR MOVB2,AX
	MOV	WORD PTR MOVB3,AX
	MOV	AX,3D00H		;ADD [DI],BH
	MOV	WORD PTR ADDB2,AX
	MOV	WORD PTR ADDB3,AX
	JMP	SHORT GPM2
GPM3:	MOV	AL,47H			;INC DI WITH 16 BIT (DEFAULT)
	MOV	BYTE PTR NOP1,AL
	MOV	BYTE PTR NOP2,AL
	MOV	BYTE PTR NOP3,AL
	MOV	BYTE PTR NOP4,AL
	MOV	BYTE PTR NOP5,AL
	MOV	BYTE PTR NOP6,AL
	MOV	AX,0589H		;MOV [DI],AX
	MOV	WORD PTR MOVA1,AX
	MOV	WORD PTR MOVA2,AX
	MOV	WORD PTR MOVA3,AX
	MOV	AX,0501H		;ADD [DI],AX
	MOV	WORD PTR ADDA2,AX
	MOV	WORD PTR ADDA3,AX
	MOV	AX,1D89H		;MOV [DI],BX
	MOV	WORD PTR MOVB1,AX
	MOV	WORD PTR MOVB2,AX
	MOV	WORD PTR MOVB3,AX
	MOV	AX,1D01H		;ADD [DI],BX
	MOV	WORD PTR ADDB2,AX
	MOV	WORD PTR ADDB3,AX
GPM2:	MOV	CX,3			;PRECALCULATE SAMPLE DATA FOR INIT
LPM1:	PUSH	CX
	CALL	CONTROL_CHANNELS
	CALL	MIXUP_CHANNELS
	POP	CX
	LOOP	LPM1
	MOV	DX,DMA_SEG		;INITIALIZE DMA
	MOV	BX,DMA_OFFSET
	MOV	CX,DMA_MAX
	CALL	DMA_INIT
	MOV	MOD_STAT,1		;ACTIVATE IRQ-HANDLING
	CLC
GPM1:	RET
PLAY_MUSIC ENDP
;-----------------------------------------------------------------------------
STOP_MUSIC PROC NEAR
	PUSH	CS
	POP	DS
	MOV	MOD_STAT,0
	CALL	DSP_RESET
	CALL	IRQ_INIT
	MOV	IRQCOUNT,56
	RET
STOP_MUSIC ENDP
;-----------------------------------------------------------------------------
END_MUSIC PROC NEAR
	PUSH	CS
	POP	DS
	CMP	LOADMOD_FLAG,0
	JNE	SHORT GENM1
	CALL	FREE_TMEM
GENM1:	CALL	FREE_DMEM
	RET
END_MUSIC ENDP
;-----------------------------------------------------------------------------
GET_SONGMOD PROC NEAR
	MOV	AL,CS:SB_MODUS
	RET
GET_SONGMOD ENDP
;-----------------------------------------------------------------------------
SET_SONGMOD PROC NEAR
	AND	AL,3
	MOV	CS:SB_MODUS,AL
	CMP	CS:CD_MIXER,0
	JE	SHORT GSNG1
	PUSH	AX 
	PUSH	DX
	XOR	AH,AH
	TEST	AL,2
	JNZ	SHORT GSNG2
	MOV	AH,CS:MUSIC_VOL
GSNG2:	MOV	DX,CS:SBP_MIXERI
	MOV	AL,36H
	OUT	DX,AL
	INC	DX
	MOV	AL,AH			;CD VOLUME L
	OUT	DX,AL
	DEC	DX
	MOV	AL,37H
	OUT	DX,AL
	INC	DX
	MOV	AL,AH			;CD VOLUME R
	OUT	DX,AL
	DEC	DX
	MOV	AL,38H
	OUT	DX,AL
	INC	DX
	MOV	AL,AH			;LINE IN VOLUME L
	OUT	DX,AL
	DEC	DX
	MOV	AL,39H
	OUT	DX,AL
	INC	DX
	MOV	AL,AH			;LINE IN VOLUME R
	OUT	DX,AL
	POP	DX 
	POP	AX
GSNG1:	RET
SET_SONGMOD ENDP
;-----------------------------------------------------------------------------
GET_SONGPOSITION PROC NEAR
	MOV	AL,CS:MT_SONGPOS
	RET
GET_SONGPOSITION ENDP
;-----------------------------------------------------------------------------
SET_SONGPOSITION PROC NEAR
	PUSH	BX
	AND	AL,7FH
	MOV	CS:MT_SONGPOS,AL
	MOV	CS:MT_PATTERNPOS,0
	XOR	BX,BX
LSET1:	MOV	CS:[MSEG+BX],0
	INC	BL
	INC	BL
	CMP	BL,2*MAX_CHAN_NUMB
	JB	LSET1
	POP	BX
	RET
SET_SONGPOSITION ENDP
;-----------------------------------------------------------------------------
SET_SONGLOOP PROC NEAR
	MOV	CS:SONG_LOOP,AL
	RET
SET_SONGLOOP ENDP
;-----------------------------------------------------------------------------
GET_VOLUME PROC NEAR
	MOV	AL,CS:MASTER_VOLUME	;0= MIN VOLUME, 255= MAX VOLUME
	MOV	BL,CS:MUSIC_VOLUME	;0= MIN VOLUME, 255= MAX VOLUME
	MOV	BH,CS:FX_VOLUME		;0= MIN VOLUME, 255= MAX VOLUME
	RET
GET_VOLUME ENDP
;-----------------------------------------------------------------------------
SET_VOLUME PROC NEAR
	MOV	CS:MASTER_VOLUME,AL	;0= MIN VOLUME, 255= MAX VOLUME
	MOV	CS:MUSIC_VOLUME,BL	;0= MIN VOLUME, 255= MAX VOLUME
	MOV	CS:FX_VOLUME,BH		;0= MIN VOLUME, 255= MAX VOLUME
	PUSH	AX 
	PUSH	DX
	MOVZX	DX,AL
	INC	DX
	PUSH	DX
	MOVZX	AX,BL
	MUL	DX
	MOV	CS:MUSIC_VOL,AH
	CMP	CS:CD_MIXER,0
	JE	SHORT GSTV1
	MOV	DX,CS:SBP_MIXERI
	MOV	AL,36H
	OUT	DX,AL
	INC	DX
	MOV	AL,AH			;CD VOLUME L
	OUT	DX,AL
	DEC	DX
	MOV	AL,37H
	OUT	DX,AL
	INC	DX
	MOV	AL,AH			;CD VOLUME R
	OUT	DX,AL
	DEC	DX
	MOV	AL,38H
	OUT	DX,AL
	INC	DX
	MOV	AL,AH			;LINE IN VOLUME L
	OUT	DX,AL
	DEC	DX
	MOV	AL,39H
	OUT	DX,AL
	INC	DX
	MOV	AL,AH			;LINE IN VOLUME R
	OUT	DX,AL
GSTV1:	POP	DX
	MOVZX	AX,BH
	MUL	DX
	MOV	CS:FX_VOL,AH
	POP	DX 
	POP	AX
	RET
SET_VOLUME ENDP
;-----------------------------------------------------------------------------
SET_LOADMOD_FLAG PROC NEAR
	AND	AL,1
	MOV	CS:LOADMOD_FLAG,AL	;0= NORMAL, 1= CD PLAYER MODUS
	RET
SET_LOADMOD_FLAG ENDP
;-----------------------------------------------------------------------------
SET_SAMPLERATE PROC NEAR
	CMP	AX,10000
	JAE	SHORT GSSR1
	MOV	AX,10000
GSSR1:	CMP	AX,44100
	JBE	SHORT GSSR2
	MOV	AX,44100
GSSR2:	MOV	CS:SAMPLE_RATE,AX	;BEST BETWEEN 22222 - 44100 Hz
	RET
SET_SAMPLERATE ENDP
;-----------------------------------------------------------------------------
SET_IRQ_RATE PROC NEAR
	PUSH	CS
	POP	DS
	MOV	BPM_RATE,AX
	MOV	AX,BPM_VALUE
	CALL	Go_SetBPM
	RET
SET_IRQ_RATE ENDP
;-----------------------------------------------------------------------------
; STARTET SAMPLE AUSGABE
; BX= SAMPLE-HANDLE, CX= SAMPLERATE, AL= PANNING: 0= LEFT, 255=RIGHT
;-----------------------------------------------------------------------------
PLAY_SAMPLE PROC NEAR
	PUSH	CS
	POP	DS
	TEST	SB_MODUS,1
	JNZ	GPSMP1
	CMP	EMS_SEG,0
	JE	GPSMP1
	MOVZX	DI,SAM_CH
	SHL	DI,1
	XOR	AH,AH
	SHR	AL,4
	PUSH	AX
	MOV	AX,CX	
	SHL	EAX,16
	MOVZX	ECX,SAMPLE_RATE
	XOR	EDX,EDX
	DIV	ECX
	POP	DX
	OR	EAX,EAX
	JZ	SHORT GPSMP1
	CLI
	MOV	[SAM_PAN+DI],DX
	MOV	[SAM_FIX+DI],AX
	SHR	EAX,16
	MOV	[SAM_FRQ+DI],AX
	MOV	[SAM_OFL+DI],0
	MOV	AX,[SAMPLE_BIG+BX]
	MOV	[SAM_MAX+DI],AX
	MOV	AX,EMS_SEG
	MOV	[SAM_SEG+DI],AX
	MOVZX	EAX,[SAMPLE_MEM+BX]
	SHL	DI,1
	SHL	EAX,4
	MOV	[SAM_OFS+DI],EAX
	STI
	INC	SAM_CH
	CMP	SAM_CH,FX_CHAN_NUMB
	JB	SHORT GPSMP1
	MOV	SAM_CH,0
GPSMP1:	RET
PLAY_SAMPLE ENDP
;-----------------------------------------------------------------------------
END_SAMPLE PROC NEAR
	PUSH	CS
	POP	DS
	XOR	BX,BX
LENDS1:	MOV	[SAM_SEG+BX],0
	INC	BX
	INC	BX
	CMP	BX,2*FX_CHAN_NUMB
	JB	LENDS1
	CMP	EMS_SEG,0
	JE	SHORT GEMP1
	MOV	AH,45H
	MOV	DX,EMS_HANDLE
	INT	67H
	MOV	EMS_SEG,0
GEMP1:	RET
END_SAMPLE ENDP
;=============================================================================


IF COM_OR_OBJ
;=============================================================================
MAIN_CONT PROC NEAR
	PUSH	BP 
	PUSH	DS 
	PUSH	CS 
	PUSH	ES
	POP	DS
	SHL	DI,2
	ADD	DI,0100H
	CALL	DI			;FAR CALL
	SETC	DL
	XOR	DH,DH
	POP	DS 
	POP	BP			;BP IS ABSOLUTELY IMPORTANT FOR C
	RETF
MAIN_CONT ENDP
;=============================================================================

ELSE
;=============================================================================
;
; MAIN ROUTINE
;
;=============================================================================
MAIN_CONT PROC NEAR
	MOV	AX,CS			
	MOV	DS,AX			; DS:=CS
	MOV     PROG_START_SEG,ES       ; ES elmentve PROG_START_SEG-be
	MOV     AX,SS                   ;
	MOV     BX,OFFSET PROG_END	; ProgramvÇgc°m BX-be
	ADD     BX,STACKLENGTH		; Hozz†adva a veremhossz
	MOV     SP,BX			; SP ide lett helyezve.
	SHR     BX,4			;
	INC     BX			; BX=(BX/16)+1
	ADD     AX,BX				
	MOV     PROG_END_SEG,AX		; PROG_END_SEG:=SS+1+(stackc°m/16)
	XOR	BX,BX			; BX=0
GL1:	
	MOV	AL,ES:[82H+BX]		; teh†t az exe-t h°vva param_1 ES:82-re
					; kerÅl ezexerint.
	OR	AL,AL
	JZ	SHORT GL2		; vÇge, ha 00h kîvetkezik...
	CMP	AL,20H
	JE	SHORT GL2		; ...vagy sz¢kîz esetÇn..
	CMP	AL,0DH
	JE	SHORT GL2		; ...vagy Çpp ENTER-re!
	MOV	[MOD_NAME+BX],AL	; EgyÇbkÇnt t lehet m†solni ezt a 
	INC	BX			; karaktert is a MOD_NAME-be
	CMP	BX,40H			; maximum 64 char(gondolom path-al)
	JB	GL1			; a dolog a MOD_NAME-ben t†rol¢dik
					; helyes paramÇtermegad†s esetÇn.
GL2:	
	OR	BX,BX			; Ha m†r a 0. karakter kilÇpìs volt...
	JZ	GMEND			; Akkor m†ra ennyit!
	XOR	AL,AL		
	MOV	[MOD_NAME+BX],0		; egyÇbkÇnt kÅld 1 null†t a MOD_NAME ut†n
	CALL	FREE_MEM		; programterÅlet+stackter. felszabad°tva..
	MOV	VAR_BUFSEG,0
;-----------------------------------------------------------------------------
; INITIALIZING & STARTING

;	MOV	AX,44100		; SET MAXIMUM SAMPLERATE
;	CALL	SET_SAMPLERATE
;	MOV	AL,255			; SET MAXIMUM VOLUME
;	MOV	BL,AL
;	MOV	BH,AL
;	CALL	SET_VOLUME

	CALL	CONFIG_INIT		; Beconfigol a file-b¢l
	MOV	DX,OFFSET MOD_NAME	;
	CALL	LOAD_MOD		; MOD betîltÇse
	JNC	SHORT GM1		; hiba esetÇn return
	MOV	AH,9
	MOV	DX,OFFSET ERROR1_TEXT
	INT	21H
	JMP	SHORT GM4
GM1:
	MOV	DX,OFFSET SAMPLE_NAME	;GET SAMPLE
	MOV	CL,80H			;PC-SAMPLE
	CALL	LOAD_SAMPLE
	JNC	SHORT GM2
	MOV	AH,9
	MOV	DX,OFFSET ERROR2_TEXT
	INT	21H
GM2:	
	CALL	PLAY_MUSIC		;TRY STARTING
	JNC	SHORT GM3
	MOV	AH,9
	MOV	DX,OFFSET ERROR3_TEXT
	INT	21H
	JMP	SHORT GM4
;-----------------------------------------------------------------------------
; THIS COULD BE THE MAIN ROUTINE
GM3:	MOV	AH,9
	MOV	DX,OFFSET OUT_TEXT
	INT	21H
LM1:	XOR	AH,AH
	INT	16H

	CMP	AL,27
	JE	SHORT GM5

	CMP	AL,"+"
	JNE	SHORT G1
	CALL	GET_VOLUME
	INC	AL
	CALL	SET_VOLUME
	JMP	LM1

G1:	CMP	AL,"-"
	JNE	SHORT G2
	CALL	GET_VOLUME
	DEC	AL
	CALL	SET_VOLUME
	JMP	LM1

G2:	CMP	AL,"9"
	JNE	SHORT G3
	MOV	AL,0
	CALL	SET_SONGLOOP
	JMP	LM1

G3:	CMP	AL,"0"
	JNE	SHORT G4
	INC	SB_MODUS
	MOV	AL,SB_MODUS
	CALL	SET_SONGMOD
	JMP	LM1

G4:	CMP	AL,"1"
	JNE	LM1
	ADD	PAN_FX,10H
	MOV	AL,PAN_FX		;PANNING
	XOR	BX,BX			;HANDLE
	MOV	CX,22050		;FREQUENCE
	CALL	PLAY_SAMPLE
	JMP	LM1

;-----------------------------------------------------------------------------
; CUTTING OFF
GM5:	CALL	STOP_MUSIC		;STOP MUSIC
GM4:	CALL	END_SAMPLE		;UNLOAD SAMPLES
	CALL	END_MUSIC		;UNLOAD MUSIC

GMEND:	MOV     AX,4C00H                ;Vissza a DOS-ba
	INT     21H
MAIN_CONT ENDP
;=============================================================================
ENDIF

;=============================================================================
RASTER_COL PROC NEAR
	MOV	DX,03DAH
	IN	AL,DX
	MOV     DX,03C0H                ;OVERSCAN AENDERN        
	MOV     AL,31H                  ;REGISTER 11H
	OUT     DX,AL                   ;BILDSCHIRM AUS
	MOV     AL,AH                   ;WERT AH IN REGISTER (DAC-INDEX)
	OUT     DX,AL
	RET
RASTER_COL ENDP
;=============================================================================
CODE_SEG2 ENDS

END _MAIN2