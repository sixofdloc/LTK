;merge.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	.include "../../include/basic.asm"

	*=$c000 ;$4000 for sysgen
 
Lc000
	ldx LTK_HD_DevNum
	stx Lc326
	ldx LTK_Var_CPUMode
	beq Lc015
	ldx #$38
	ldy #$c3
	jsr LTK_Print 
	jmp Lc0b7
	
Lc015
	jsr LTK_Krn_BankIn
	ldx $c8
	jsr Sc126
	ldy Lc11a
	lda #$2c
	sta Lc11b,y
	iny
	iny
	sta Lc11b,y
	dey
	lda #$50
	sta Lc11b,y
	iny
	iny
	lda #$52
	sta Lc11b,y
	lda Lc11a
	tax
	inx
	inx
	inx
	inx
	txa
	pha
	jsr CLALL 
	lda #$0f
	tay
	ldx Lc326
	jsr SETLFS
	lda #$00
	jsr SETNAM
	jsr OPEN  
	jsr Sc0ee
	pla
	ldx #$1b
	ldy #$c1
	jsr SETNAM
	lda #$01
	ldx Lc326
	ldy #$02
	jsr SETLFS
	jsr OPEN  
	jsr Sc0ee
	beq Lc089
	ldx #$7c
	ldy #$c0
	jsr Sc0fd
	jmp Lc0af
	
Lc07c
	.text "{return}file error{return}"
	.byte $00
Lc089
	ldx #$01
	jsr CHKIN 
	jsr Sc0bf
	lda #$01
	sta $22
	lda #$08
	sta $23
	jsr CHRIN 
	jsr CHRIN 
	jsr Sc173
	lda #$01
	jsr CLOSE 
	lda #$0f
	jsr CLOSE 
	jsr CLRCHN
Lc0af
	jsr Sc0bf
	ldx #$80
	jsr LTK_Krn_BankOut
Lc0b7
	clc
	jmp LTK_MemSwapOut 
	
Lc0bb
	.byte $00
Lc0bc
	.byte $00
Lc0bd
	.byte $00
Lc0be
	.byte $00
Sc0bf
	lda #$01
	sta $2b
	lda #$08
	sta $2c
	jsr Sc284
	ldy #$01
	lda #$00
	sta ($22),y
	lda $22
	clc
	adc #$02
	sta $2d
	sta $2f
	sta $31
	lda $23
	adc #$00
	sta $2e
	sta $30
	sta $32
	lda #$01
	sta $2b
	lda #$08
	sta $2c
	rts
	
Sc0ee
	ldx #$0f
	jsr CHKIN 
Lc0f3
	jsr CHRIN 
	cmp #$0d
	beq Lc0f3
	cmp #$30
	rts
	
Sc0fd
	stx $c106
	sty $c107
Lc103
	ldy #$00
	lda $c105,y
	ora #$00
	beq Lc119
	jsr CHROUT
	inc $c106
	bne Lc103
	inc $c107
	bne Lc103
Lc119
	rts
	
Lc11a
	.byte $0b 
Lc11b
	.text "65535-65535"
Sc126
	tay
	iny
	lda #$00
	sta Lc151 + 1
	lda #$02
	sta Lc151 + 2
	stx Lc11a
	cpy Lc11a
	bcs Lc160
	dey
	iny
	sty $c155
	lda #$1b
	sec
	sbc $c155
	sta $c155
	lda #$c1
	sbc #$00
	sta $c156
	ldx #$00
Lc151
	lda Lc151,y
	sta $c154,y
	cpy Lc11a
	beq Lc162
	inx
	iny
	bne Lc151
Lc160
	ldx #$0b
Lc162
	stx Lc11a
	rts
	
Lc166
	ldy #$00
	sty LTK_Command_Buffer
	dey
	sty $7a
	lda $01
	sta $7b
	rts
	
Sc173
	jsr Sc248
	lda LTK_Command_Buffer
	beq Lc166
	stx $7a
	sty $7b
	ldy $0b
	jsr Sc2c7
	jsr bFNDLIN
	bcc Lc1cd
	ldy #$01
	lda ($5f),y
	sta $23
	lda $2d
	sta $22
	lda $60
	sta $25
	lda $5f
	dey
	sbc ($5f),y
	clc
	adc $2d
	sta $2d
	sta $24
	lda $2e
	adc #$ff
	sta $2e
	sbc $60
	tax
	sec
	lda $5f
	sbc $2d
	tay
	bcs Lc1b7
	inx
	dec $25
Lc1b7
	clc
	adc $22
	bcc Lc1bf
	dec $23
	clc
Lc1bf
	lda ($22),y
	sta ($24),y
	iny
	bne Lc1bf
	inc $23
	inc $25
	dex
	bne Lc1bf
Lc1cd
	jsr Sc223
	jsr Sc284
	lda Lc2ee
	beq Lc1e0
	lda #$01
	sta $2b
	lda #$08
	sta $2c
Lc1e0
	clc
	lda $2d
	sta $5a
	adc $0b
	sta $58
	ldy $2e
	sty $5b
	bcc Lc1f0
	iny
Lc1f0
	sty $59
	jsr Sc2ef
	bcc Lc1fa
	jmp Lc0af
	
Lc1fa
	jsr $a3bb
	lda $14
	ldy $15
	sta $01fe
	sty $01ff
	lda $31
	ldy $32
	sta $2d
	sty $2e
	ldy $0b
	dey
Lc212
	lda $01fc,y
	sta ($5f),y
	dey
	bpl Lc212
	jsr Sc223
	jsr Sc284
	jmp Sc173
	
Sc223
	jsr bSTXPT
	lda $37
	ldy $38
	sta $33
	sty $34
	lda $2d
	ldy $2e
	sta $2f
	sty $30
	sta $31
	sty $32
	jsr bRESTOR
	ldx #$19
	stx $16
	lda #$00
	sta $3e
	sta $10
	rts
	
Sc248
	ldx #$00
	jsr CHRIN 
	jsr CHRIN 
	ora #$00
	bne Lc257
	jmp Lc166
	
Lc257
	jsr CHRIN 
	sta $14
	jsr CHRIN 
	sta $15
Lc261
	jsr CHRIN 
	cmp #$00
	beq Lc26e
	sta LTK_Command_Buffer,x
	inx
	bne Lc261
Lc26e
	lda #$00
	sta LTK_Command_Buffer,x
	inx
	inx
	inx
	inx
	inx
	stx $0b
	lda #$2e
	jsr CHROUT
	ldx #$ff
	ldy #$01
	rts
	
Sc284
	lda $2b
	ldy $2c
	sta $22
	sty $23
	clc
Lc28d
	ldy #$01
	lda $22
	sta $2b
	lda $23
	sta $2c
	lda ($22),y
	beq Lc2c4
	ldy #$02
	lda ($22),y
	sta Lc2c5
	iny
	lda ($22),y
	sta Lc2c6
	iny
Lc2a9
	iny
	lda ($22),y
	bne Lc2a9
	iny
	tya
	adc $22
	tax
	ldy #$00
	sta ($22),y
	lda $23
	adc #$00
	iny
	sta ($22),y
	stx $22
	sta $23
	bcc Lc28d
Lc2c4
	rts
	
Lc2c5
	.byte $00
Lc2c6
	.byte $00
Sc2c7
	php
	pha
	lda #$00
	sta Lc2ee
	lda $15
	cmp Lc2c6
	bcc Lc2e0
	bne Lc2eb
	lda $14
	cmp Lc2c5
	bcc Lc2e0
	bne Lc2eb
Lc2e0
	lda #$01
	sta $2b
	lda #$08
	sta $2c
	sta Lc2ee
Lc2eb
	pla
	plp
	rts
	
Lc2ee
	.byte $00
Sc2ef
	cpy $34
	bcc Lc31b
	bne Lc2f9
	cmp $33
	bcc Lc31b
Lc2f9
	pha
	ldx #$09
	tya
Lc2fd
	pha
	lda $57,x
	dex
	bpl Lc2fd
	jsr bGARBAG
	ldx #$f7
Lc308
	pla
	sta $61,x
	inx
	bmi Lc308
	pla
	tay
	pla
	cpy $34
	bcc Lc31b
	bne Lc31d
	cmp $33
	bcs Lc31d
Lc31b
	clc
	rts
	
Lc31d
	ldx #$27
	ldy #$c3
	jsr Sc0fd
	sec
	rts
	
Lc326
	.byte $00
Lc327
	.text "{return}?out of memory{return}"
	.byte $00
Lc338
	.text "{return}{rvs on}not yet implemented in c128 mode"
	.byte $00
