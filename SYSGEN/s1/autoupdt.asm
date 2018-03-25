;autoupdt.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_FileWriteBuffer ;$8de0, $4000 for sysgen
 
L8de0
	ldy #$00
	ldx #$0a
L8de4
	lda $80a8,y
	bmi L8df1
	lda $80aa,y
	and #$f7
	sta $80aa,y
L8df1
	iny
	iny
	iny
	iny
	iny
	dex
	bne L8de4
	lda #$ff
	sta LTK_ReadChanFPTPtr
	lda #$0a
	ldx #$1a
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L8e0b
	lda L8f13
	tax
	sta $8e16
	asl a
	asl a
	clc
	adc #$00
	tay
	sty L8f14
	lda $9be4,y
	bmi L8e64
	stx LTK_Var_ActiveLU
	jsr LTK_ClearHeaderBlock 
	ldx #$0f
L8e28
	lda L8f16,x
	sta LTK_FileHeaderBlock ,x
	dex
	bpl L8e28
	jsr LTK_FindFile 
	bcs L8e64
	ldx #$26
	ldy #$8f
	jsr LTK_Print 
	lda #$41
	ldx #$11
	jsr S8ee2
	lda #$41
	ldx #$52
	jsr S8ee2
	lda #$41
	ldx #$93
	jsr S8ee2
	lda #$1a
	ldx #$d4
	jsr S8ee2
	ldy L8f14
	lda #$08
	ora $9be6,y
	sta $9be6,y
L8e64
	inc L8f13
	inc L8f26 + 32
	lda L8f13
	cmp #$0a
	bne L8e0b
	lda #$00
	tay
	sta $9ddf
	ldx #$02
L8e79
	clc
	adc LTK_FileReadBuffer ,y
	iny
	bne L8e79
	inc $8e7c
	dex
	bne L8e79
	sta $9ddf
	sec
	lda #$1a
	tax
	sbc $9ddf
	sta $9ddf
	lda #$0a
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
	.byte $b2,$c2,$d2 
L8ea1
	ldy #$31
L8ea3
	lda $9be4,y
	sta $80a8,y
	dey
	bpl L8ea3
	lda #$0a
	sta LTK_Var_ActiveLU
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L8ebc
	lda #$00
	
	sta $920a
	lda #$0a
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
	.byte $b2,$c2,$d2 

L8ecd
	jsr LTK_GetPortNumber
	clc
	adc #$9e
	tax
	lda #$02
	adc #$00
	tay
	lda #$0a
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L8ee1
	rts
	
S8ee2
	sta $8f00
	sta $8f0e
	txa
	pha
	ldx #$49
	ldy #$8f
	jsr LTK_Print 
	pla
	tax
	lda #$0a
	ldy #$00
	sty LTK_Krn_BankControl
	clc
	jsr LTK_HDDiscDriver
	.byte $00,$1e,$00
L8f01
	lda L8f13
	sty LTK_Krn_BankControl
	iny
	sec
	jsr LTK_HDDiscDriver 
	.byte $00,$1e,$00
	.byte $b2,$c2,$d2
L8f12
	rts
	
L8f13
	.byte $00
L8f14
	.byte $00
L8f15
	.byte $00
L8f16
	.text "ltkernaldosimage"
L8f26
	.text "{return}updating dos on logical unit {rvs on} 0 "
	.byte $00
L8f49
	.text "."
	.byte $00
