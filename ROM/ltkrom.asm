;**************************************
;*   _  _    _                                                    
;*  | || |_ | | __ _ __  ___   _ __ ___      __ _  ___  _ __ ___  
;*  | || __|| |/ /| '__|/ _ \ | '_ ` _ \    / _` |/ __|| '_ ` _ \ 
;*  | || |_ |   < | |  | (_) || | | | | | _| (_| |\__ \| | | | | |
;*  |_| \__||_|\_\|_|   \___/ |_| |_| |_|(_)\__,_||___/|_| |_| |_|
;*                                                                
	;LTK rom re-source
	;Six/DLoC 2018
;*      ;jbevren  2018
;*

; ****************************
; * 
; * VIM settings for David.
; * 
; * vim:syntax=a65:hlsearch:background=dark:ai:
; * 
; ****************************

	.include "../include/misc_equates.asm"
	
	
	*= $8000
firstROM	
	.byte <romStart,>romStart,<romStart,>romStart
	.byte $c3,$c2,$cd,$38,$30 ;CBM80
	.byte $00
	
	.include "serialnumber.asm"
Boot	=$cd00		; ltkbootstub.asm gets copied to $cd00 and executed.
	
romStart		; ..."Let there be light!"  And there was light, and it was good.
	sei		;Let's keep the kernal out of the way for now
	lda #$00	; 
	sta $d011	; Fade to black.
	lda $2f		; 
	pha		; 
	lda $30		; 
	pha		; Save the contents of $2f and $30 for later
	lda #<Bootstub	; $6e	; 	
	sta $31		; 
	lda #>Bootstub	;$80	; 
	sta $32		; $31:32=$806e source
	lda #<Boot	;$00	; 
	sta $33		; 
	lda #>Boot	;$cd	; 
	sta $34		; $33:34=$cd00 destination
	lda #<Bootlen	;$a7	; 
	sta $2f		; 
	lda #>Bootlen	;$02	; 
	sta $30		; $2f:30=$02a7 bytes to copy
	jsr Copy	; Copy
	pla		; 
	sta $30		; 
	pla		; 
	sta $2f		; Restore $2f,$30
	jmp Boot	;$cd00	; Bootstrap L1: Hardware init
                    
Copy	ldy #$00	; Clear the index
L8046	lda ($31),y	; Get source byte
	sta ($33),y	; Store at destination
	inc $31		; increment low byte of source
	bne L8050
	inc $32		; optionally fix high byte

L8050	inc $33		; increment low byte of dest
	bne L8056
	inc $34		; optionally fix high byte

L8056	lda $2f		; get byte count (low)
	bne L8065	; jump to decrement if not zero
	lda $30		; get byte count (high)
	beq L806d	; return if zero
	dec $30
	dec $2f		; low was zero but not high so dec both.
	jmp L8046	; and copy some more

L8065	dec $2f		; decrement low byte
	bne L8046
	lda $30		; check high byte
	bne L8046	; copy more if not done

L806d	rts		; return.

Bootstub =*	; originally $806e
	.include "ltkbootstub.asm"
Bootlen	=*-Bootstub

copyrightText       
	.screen "COPYRIGHT 1985, FII "
dosName
	.screen "LT. KERNAL DOS"
bootWarn
	.screen "THIS BOOT FOR REV. 6.0 AND LATER"
bootVer
	.screen "BOOT ROM VERSION 2 CREATED ON 08/05/87"

firstBlankBloc
	.repeat $0c83,$ff

secondROM
	sei
	jmp romStart
	nop
	nop
	php
	.byte $43,$42,$4d,$38,$37 ;CBM87 - C128 boot rom signature
	.include "serialnumber.asm"
	

	*=$937e
secondBlankBloc
	.repeat $0352,$ff
	
promOS
	.binary "promos.bin"
