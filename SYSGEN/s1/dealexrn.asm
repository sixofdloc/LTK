;dealexrn.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 	
L93e0
	lda $31
	pha
	lda $32
	pha
	clc
	jsr S957b
	lda $9201
	ldx $9200
	jsr S945c
L93f3
	lda #$02
	sta $31
	lda #$92
	sta $32
	lda L959c
	asl a
	tay
	bcc L9404
	inc $32
L9404
	lda ($31),y
	tax
	iny
	lda ($31),y
	sta $31
	stx $32
	jsr S945c
	inc L959c
	ldy $32
	ldx $31
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L9422
	lda #$e0
	sta $31
	lda #$9b
	sta $32
L942a
	ldy #$00
	lda ($31),y
	tax
	iny
	lda ($31),y
	jsr S945c
	lda L959a
	cmp $91f0
	bne L944a
	lda L959b
	cmp $91f1
	bne L944a
	lda #$00
	jmp L9514
	
L944a
	lda $31
	clc
	adc #$02
	sta $31
	bcc L9455
	inc $32
L9455
	inc L959d
	bne L942a
	beq L93f3
S945c
	ldy #$00
	sty $95da
	ldy $9ec5
	jsr S95a0
	sty L9594
	ldy #$00
	sty $95da
	ldy $9ec3
	jsr S95a0
	sty L9596
	sec
	adc L959e
	sta L9598
	lda L9597
	beq L9498
	cmp L9598
	beq L94aa
	lda LTK_Var_ActiveLU
	ldx L9597
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9498
	ldx L9598
	stx L9597
	lda LTK_Var_ActiveLU
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L94aa
	lda L9594
	ldx #$00
	stx $95da
	ldy #$08
	jsr S95a0
	sta L9599
	sty L9594
	lda $9ec4
	ldx #$00
	ldy L9596
	jsr LTK_TPMultiply 
	clc
	adc L9599
	bcc L94cf
	inx
L94cf
	clc
	adc #$e3
	bcc L94d5
	inx
L94d5
	sta $9509
	sta L94f5 + 1
	txa
	clc
	adc #$8f
	sta $950a
	sta L94f5 + 2
	lda #$80
	sta L9595
	ldy L9594
	beq L94f5
L94ef
	lsr L9595
	dey
	bne L94ef
L94f5
	lda L94f5
	tay
	and L9595
	bne L9504
	pla
	pla
	lda #$ff
	bne L9514
L9504
	tya
	eor L9595
	sta $9508
	inc L959b
	bne L9513
	inc L959a
L9513
	rts
	
L9514
	sta L959f
	lda LTK_Var_ActiveLU
	ldx L9597
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9526
	clc
	jsr S957b
	lda $9075
	sec
	sbc L959b
	sta $9075
	lda $9074
	sbc L959a
	sta $9074
	lda L959b
	clc
	adc $9072
	sta $9072
	lda L959a
	adc $9071
	sta $9071
	lda $9200
	sta $9076
	lda $9201
	sta $9077
	sec
	jsr S957b
	lda #$ff
	sta LTK_ReadChanFPTPtr
	pla
	sta $32
	pla
	sta $31
	clc
	lda L959f
	beq L9572
	sec
L9572
	php
	lda #$01
	clc
	jsr $9f00
	plp
	rts
	
S957b
	php
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L9587
	ldx #$00
L9587
	ldy #$00
	plp
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9590
	stx L959e
	rts
	
L9594
	.byte $00
L9595
	.byte $00
L9596
	.byte $00
L9597
	.byte $00
L9598
	.byte $00
L9599
	.byte $00
L959a
	.byte $00
L959b
	.byte $00
L959c
	.byte $00
L959d
	.byte $00
L959e
	.byte $00
L959f
	.byte $00
S95a0
	sta $95dc
	stx $95db
	sty $95dd
	lda #$00
	ldx #$18
L95ad
	clc
	rol $95dc
	rol $95db
	rol $95da
	rol a
	bcs L95bf
	cmp $95dd
	bcc L95cf
L95bf
	sbc $95dd
	inc $95dc
	bne L95cf
	inc $95db
	bne L95cf
	inc $95da
L95cf
	dex
	bne L95ad
	tay
	ldx $95db
	lda $95dc
	rts
	
	.byte $00,$00,$00,$00 
