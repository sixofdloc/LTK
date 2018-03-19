;del.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	.include "../../include/basic.asm"

	*=$c000 ;$4000 for sysgen
	
Lc000
	ldx LTK_Var_CPUMode
	beq Lc00f
	ldx #$bc
	ldy #$c2
	jsr LTK_Print 
	jmp Lc23d
	
Lc00f
	jsr LTK_Krn_BankIn
	ldx $c8
	jmp Lc063
	
Lc017
	.byte $0b 
Lc018
	.text "65535-65535"
Sc023
	tay
	iny
	lda #$00
	sta Lc04e + 1
	lda #$02
	sta Lc04e + 2
	stx Lc017
	cpy Lc017
	bcs Lc05d
	dey
	iny
	sty $c052
	lda #$18
	sec
	sbc $c052
	sta $c052
	lda #$c0
	sbc #$00
	sta $c053
	ldx #$00
Lc04e
	lda Lc04e,y
	sta $c051,y
	cpy Lc017
	beq Lc05f
	inx
	iny
	bne Lc04e
Lc05d
	ldx #$0b
Lc05f
	stx Lc017
	rts
	
Lc063
	jsr Sc023
	lda #$18
	sta Lc08f + 1
	sta Lc0c1 + 1
	sta Lc0d9 + 1
	lda #$c0
	sta Lc08f + 2
	sta Lc0c1 + 2
	sta Lc0d9 + 2
	ldy #$ff
	sty Lc26d
	sty Lc26e
	iny
	sty Lc26b
	sty Lc26c
	sty $14
	sty $15
Lc08f
	lda Lc08f,y
	iny
	cmp #$2d
	beq Lc0ac
	jsr Sc241
	cpy Lc017
	bne Lc08f
	lda $14
	sta Lc26b
	lda $15
	sta Lc26c
	jmp Lc0d7
	
Lc0ac
	lda $14
	sta Lc26b
	lda $15
	sta Lc26c
	lda #$00
	sta $14
	sta $15
	cpy Lc017
	beq Lc0d7
Lc0c1
	lda Lc0c1,y
	iny
	jsr Sc241
	cpy Lc017
	bne Lc0c1
	lda $14
	sta Lc26d
	lda $15
	sta Lc26e
Lc0d7
	ldy #$00
Lc0d9
	lda Lc0d9,y
	iny
	cmp #$2d
	bne Lc0e6
	sta Lc2b9
	beq Lc0ee
Lc0e6
	cmp #$30
	bcc Lc105
	cmp #$3a
	bcs Lc105
Lc0ee
	cpy Lc017
	bne Lc0d9
	ldy Lc26e
	cpy Lc26c
	bcc Lc105
	bne Lc10f
	ldy Lc26d
	cpy Lc26b
	bcs Lc10f
Lc105
	ldx #$6f
	ldy #$c2
	jsr Sc29e
	jmp Lc234
	
Lc10f
	ldx #$ff
	ldy #$ff
	tya
	jsr Sc198
	stx $ae
	sty $af
	lda Lc2b9
	bne Lc12c
	lda Lc26b
	sta Lc26d
	lda Lc26c
	sta Lc26e
Lc12c
	ldx Lc26b
	ldy Lc26c
	lda #$00
	jsr Sc198
	stx Lc232
	sty Lc233
	ldx Lc26d
	ldy Lc26e
	lda #$01
	jsr Sc198
	stx Lc15c + 1
	sty Lc15c + 2
	lda Lc232
	sta $c160
	lda Lc233
	sta $c161
	ldy #$00
Lc15c
	lda Lc15c,y
	sta $c15f,y
	lda Lc15c + 2
	cmp $af
	bne Lc170
	lda Lc15c + 1
	cmp $ae
	beq Lc182
Lc170
	inc Lc15c + 1
	bne Lc178
	inc Lc15c + 2
Lc178
	inc $c160
	bne Lc180
	inc $c161
Lc180
	bne Lc15c
Lc182
	lda $c160
	sta $ae
	lda $c161
	sta $af
	ldy #$01
	lda #$00
	sta ($ae),y
	jsr bLINKPRG
	jmp Lc234
	
Sc198
	sta Lc231
	lda #$01
	sta Lc1ab + 1
	lda #$08
	sta $c1c0
	stx Lc2ba
	sty Lc2bb
Lc1ab
	lda #$ab
	sta $c1d8
	sta $c1dd
	sta $c1e7
	sta $c1ec
	sta $c205
	sta $c209
	lda #$c1
	sta $c1d9
	sta $c1de
	sta $c1e8
	sta $c1ed
	sta $c206
	sta $c20a
	ldy #$00
	iny
	iny
	lda $c1d7,y
	tax
	iny
	lda $c1dc,y
	jsr Sc1fd
	bcs Lc1f6
	dey
	dey
	lda $c1e6,y
	tax
	dey
	lda $c1eb,y
	sta Lc1ab + 1
	stx $c1c0
	bcc Lc1ab
Lc1f6
	ldx Lc1ab + 1
	ldy $c1c0
	rts
	
Sc1fd
	pha
	txa
	pha
	tya
	pha
	ldy #$00
	lda $c204,y
	iny
	ora $c208,y
	beq Lc229
	pla
	tay
	pla
	tax
	pla
	cmp Lc2bb
	bcc Lc220
	bne Lc227
	cpx Lc2ba
	beq Lc222
	bcs Lc227
Lc220
	clc
	rts
	
Lc222
	lda Lc231
	bne Lc220
Lc227
	sec
	rts
	
Lc229
	pla
	tax
	pla
	tax
	pla
	jmp Lc227
	
Lc231
	.byte $00
Lc232
	.byte $00
Lc233
	.byte $00
Lc234
	jsr bLINKPRG
	jsr Sc285
	jsr LTK_Krn_BankOut
Lc23d
	clc
	jmp LTK_MemSwapOut 
	
Sc241
	clc
	sbc #$2f
	sta $07
	lda $15
	sta $22
	lda $14
	asl a
	rol $22
	asl a
	rol $22
	adc $14
	sta $14
	lda $22
	adc $15
	sta $15
	asl $14
	rol $15
	lda $14
	adc $07
	sta $14
	bcc Lc26a
	inc $15
Lc26a
	rts
	
Lc26b
	.byte $00
Lc26c
	.byte $00
Lc26d
	.byte $00
Lc26e
	.byte $00
Lc26f
	.text "{return}illegal line-number{return}"
	.byte $00
Sc285
	jsr bLINKPRG
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
	rts
	
Sc29e
	stx Lc2a4 + 1
	sty Lc2a4 + 2
Lc2a4
	lda Lc2a4
	ora #$00
	beq Lc2b8
	jsr CHROUT
	inc Lc2a4 + 1
	bne Lc2a4
	inc Lc2a4 + 2
	bne Lc2a4
Lc2b8
	rts
	
Lc2b9
	.byte $00
Lc2ba
	.byte $00
Lc2bb
	.byte $00
Lc2bc
	.text "{return}{rvs on}not needed in c128 mode"
	.byte $00
