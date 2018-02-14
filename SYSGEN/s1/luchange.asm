;luchange.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	*=LTK_MiniSubExeArea ;$93e0 - change to $4000 for sysgen
	
START               jmp prg_start
                    
L93e3   
	;I'd be interested to know what all of this is, 
	;since I don't see anything referencing it.
	.byte $ff,$00,$1e,$40,$c8,$11,$00,$e6
	.byte $40,$c8,$11,$01,$ae,$40,$a6,$11 
	.repeat $23,$ff
	
prg_start               
	lda #$20
	bit $9fac
	bmi L941f
	
	lda #$2a
L941f
	sta str_StatusBar + 1
	lda LTK_Var_Active_User
	jsr S9472
	
	stx str_StatusBar + 21
	sta str_StatusBar + 22
	lda LTK_Var_ActiveLU
	jsr S9472
	
	stx str_StatusBar + 12
	sta str_StatusBar + 13
	lda LTK_HD_DevNum
	jsr S9472

	stx str_StatusBar + 5
	sta str_StatusBar + 6
	lda $9e43
	sta $944e
	lda $df04
	and #$0f
	jsr S9472

	stx str_StatusBar + 31
	sta str_StatusBar + 32
	ldx #<str_C64
	ldy #>str_C64
	lda LTK_Var_CPUMode
	beq L9467

	ldx #<str_C128
	ldy #>str_C128
L9467               
	jsr LTK_Print
	ldx #<str_StatusBar
	ldy #>str_StatusBar
	jsr LTK_Print
	rts
                    
S9472
	ldx #$30
L9474
	cmp #$0a
	bcc L947d
	sbc #$0a
	inx
	bne L9474
L947d
	clc
	adc #$30
	rts
                    
str_C64
	.text "{rvs on}c64"
	.byte $00
str_C128
	.text "{rvs on}c128"
	.byte $00
str_StatusBar               
	.text "{rvs off} d#{rvs on}00{rvs off} lu{rvs on}00{rvs off} user{rvs on}00{rvs off} port#{rvs on}00{rvs off}  {rvs on}"
	.byte $00 