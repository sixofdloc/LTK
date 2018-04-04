;****************************************
;*   _                                 
;*  | | _   _     __ _  ___  _ __ ___  
;*  | || | | |   / _` |/ __|| '_ ` _ \ 
;*  | || |_| | _| (_| |\__ \| | | | | |
;*  |_| \__,_|(_)\__,_||___/|_| |_| |_|
;*                                     

;lu.r.prg


; ****************************
; * 
; * VIM settings for David.
; * 
; * vim:syntax=a65:hlsearch:background=dark:ai:
; * 
; ****************************


	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	
	*=$95e0 ; relocate to $4000 for sysgen 
L95e0
	pha			; save .A
	ldx $c8
	lda LTK_Var_CPUMode	; check host CPU mode
	beq is_in_c64_mode	;  C64 mode? Keep .X at $c8
	ldx $ea			;  $ea for c128 mode
is_in_c64_mode
	stx cpumode
	jsr LTK_GetPortNumber	; get our port number
	clc
	adc #$9e
	tax
	lda #$02		; add $029e (defaults.r)
	adc #$00
	tay
	lda #$0a		; LU 10
	clc
	jsr LTK_HDDiscDriver	; Load our defaults according to port# (lu $a sector $029e+PortNumber)
	.word LTK_MiscWorkspace	;  to LT_MiscWorkspace
	.byte $01		;  one sector.
L9602               
	pla			; restore caller .A reg
	tay			;  put in index
	ldx cpumode
	lda #$ff
	sta LTK_Command_Buffer,x; clear LTK Command buffer out
	iny
	cpy cpumode		; Done copying?
	bcc L9620		;  Yes, exit loop
	lda LTK_MiscWorkspace+$a; $8fea
	bit LTK_Var_CPUMode	; c64 mode?
	bpl L962f		;  C128 mode, branch
	lda LTK_MiscWorkspace+$b; $8feb
	jmp L962f
                    
L9620	; .Y comes from caller
	lda #$00		; start at $0200
	ldx #$02
	jsr HexToVal		; convert hex digits to binary
	txa			; save low byte
	bcc L962f		;  conversion was ok, proceed to change LU.
	lda LTK_MiscWorkspace+$d; $8ffd FIXME: Whats this?
	and #$0f
L962f
	cmp LTK_Var_ActiveLU	; $8000 ; Check against current LU
	beq L9640		;  Already in the chosen LU? Skip ahead
	jsr LTK_SetLuActive	; $8099 ; Set chosen LU active
	bcc L9640		;  Everything good? SKip ahead
	ldx #<Errmsg		; $54
	ldy #>Errmsg		; $96
	jsr LTK_ErrorHandler	; $8051 ; Handle error.
L9640
	lda #$ff		; Set LU to -1 (FIXME: Does this get the current LU?)
	jsr LTK_SetLuActive	; $8099
	lda LTK_Var_Active_User ; $8001 ; Get current user
	asl a
	asl a
	asl a
	asl a			; move to high bit
	ora LTK_Var_ActiveLU	; $8000 ; combine with active LU
	sta $9e45		; save result in system table (FIXME: make a label for this)
	rts			; return to system
                    
cpumode	; $c8 for c64, $ea for c128
	.byte $00 
Errmsg	; 9654
	.text "invalid logical unit number !!{return}"
	.byte $00 

HexToVal
	sta GetDigit + 1	; set starting address
	stx GetDigit + 2
	lda #$00
	sta DigitC		;  ; Clear our result
	sta GD_High		; high
	sta GD_Low		; low

GetDigit
	lda GetDigit,y		; Load byte
	cmp #$30		; check against '0'
	bcc BadByte		;  less than '0'.
	cmp #$3a		; check against ':' (one past 9 on ascii)
	bcc GotDigit		;  byte is between 0 and 9, go to 96a2
	ldx $96ae		; FIXME: what loads this?
	cpx #$0a		; is 96ae 10 (LU?)
	beq BadByte		;  yes
	cmp #$41		; $41 (65) ('A')?
	bcc BadByte		;  less than, skip ahead
	cmp #$47		; 'F'+1?
	bcs BadByte		;  larger, skip
	sec
	sbc #$07		; Offset for hex digit A-F (ASCII A - ASCII : = 7)

GotDigit ; indented to follow stack levels
	ldx DigitC		; 
	beq L96c6		;  skip addition if zero
	pha			; save our digit's value
	 tya
	 pha			; save our index
	  lda #$00
	  tax			; clear .X and .A
	  ldy #$0a		; Start counting at 10
L96af	  clc			; prep for adding
	  adc GD_Low		; add low byte
	  pha			; save the result
	   txa			;  get high byte from .X
	   adc GD_High		;  add
	   tax			;  put back in .X
	  pla			; restore low byte add
	  dey			; decrement our counter
	  bne L96af		;  more to do!
	  sta GD_Low		; save result low byte
	  stx GD_High		; save result high byte
	 pla			; restore our index
	tay			;  back to .Y
	pla			; restore next digit value

L96c6	inc DigitC		; increment digit counter
	sec
	sbc #$30		; subtract '0' for ascii->binary
	clc
	adc GD_Low		; add to low byte
	sta GD_Low
	bcc L96da		; skip if no carry
	inc GD_High		; add high byte
	beq L96e7		;  overflow? exit with error
L96da	iny			; increment index
	bne GetDigit		;  more to do? Get the next digit

BadByte	cmp #$20		; ' '?
	beq L96da		;  skip whitespace and continue.
	clc			; clear carry to indicate no error
	ldx DigitC		; Get the digit count
	bne L96e8		;  Did we find some digits?  Good.
L96e7	sec			; ERROR
L96e8	lda GD_High		; binary result in .A.X
	ldx GD_Low
	rts			; return
                    
DigitC	.byte $00 
GD_High	.byte $00 
GD_Low	.byte $00 
