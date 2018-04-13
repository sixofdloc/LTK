;**************************************
;*   _               _                                                         
;*  | | _   _   ___ | |__    __ _  _ __    __ _   ___     __ _  ___  _ __ ___  
;*  | || | | | / __|| '_ \  / _` || '_ \  / _` | / _ \   / _` |/ __|| '_ ` _ \ 
;*  | || |_| || (__ | | | || (_| || | | || (_| ||  __/ _| (_| |\__ \| | | | | |
;*  |_| \__,_| \___||_| |_| \__,_||_| |_| \__, | \___|(_)\__,_||___/|_| |_| |_|
;*                                        |___/                                

;luchange.r.prg

; ****************************
; * 
; * VIM settings for David.
; * 
; * vim:syntax=a65:hlsearch:background=dark:ai:
; * 
; ****************************

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_hw_equates.asm"
	.include "../../include/ltk_equates.asm"
	*=LTK_MiniSubExeArea ;$93e0 - change to $4000 for sysgen
	
START               jmp prg_start
                    
L93e3   ; Partition (LU) table	  five bytes per entry.
	.byte $ff,$00,$1e,$40	; 
	.byte $c8,$11,$00,$e6	; 
	.byte $40,$c8,$11,$01	; 
	.byte $ae,$40,$a6,$11 	; 
	.repeat $23,$ff		; empty for the rest 
	
prg_start
	; set asterisk
	lda #$20		; " "
	bit $9fac		; Not sure what this flag is but it controls the * in the status bar (FIXME etc)
	bmi L941f
	
	lda #$2a		; "*"
L941f	sta sb_ast

	; set user number
	lda LTK_Var_Active_User
	jsr ntoa
	stx sb_user
	sta sb_user+1

	; set LU number
	lda LTK_Var_ActiveLU
	jsr ntoa
	stx sb_lu
	sta sb_lu+1

	; set device number
	lda LTK_HD_DevNum
	jsr ntoa
	stx sb_dev
	sta sb_dev+1

	; set up port number
	lda LTK_HardwarePage
	sta *+5			; Set high byte of LDA
	lda HA_PortNumber	; Get HW port number
	and #$0f		; mask off high bits
	jsr ntoa		; convert to ascii number
	stx sb_port		; update the prompt
	sta sb_port+1

	ldx #<str_C64
	ldy #>str_C64
	lda LTK_Var_CPUMode
	beq L9467		; 0=C64 mode
	ldx #<str_C128
	ldy #>str_C128
L9467	jsr LTK_Print		; Print machine type
	ldx #<str_StatusBar
	ldy #>str_StatusBar
	jsr LTK_Print		; and then status bar
	rts
                    
ntoa	; convert a value in .A to ascii decimal in .X, .A
	ldx #$30		; "0"
L9474	cmp #$0a
	bcc L947d		; <10? done.
	sbc #$0a		;  subtract 10
	inx			;  increment high digit
	bne L9474		;  continue until high digit is set
L947d	clc
	adc #$30		; offset .A for ascii
	rts
                    
str_C64
	.text "{rvs on}c64"
	.byte $00
str_C128
	.text "{rvs on}c128"
	.byte $00
str_StatusBar               
	.text "{rvs off}"
sb_ast	.text " "			; sometimes has a *
	.text "d#{rvs on}"
sb_dev	.text "00"
	.text "{rvs off} lu{rvs on}"
sb_lu	.text "00"
	.text "{rvs off} user{rvs on}"
sb_user	.text "00"
	.text "{rvs off} port#{rvs on}"
sb_port	.text "00"
	.text "{rvs off}  {rvs on}"
	.byte $00 
