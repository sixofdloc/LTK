;findfile.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 
L93e0
	ldy #$0f
L93e2
	lda LTK_FileHeaderBlock ,y
	beq L93f0
	cmp #$a0
	bne L93f3
	lda #$00
	sta LTK_FileHeaderBlock ,y
L93f0
	dey
	bpl L93e2
L93f3
	ldy #$00
L93f5
	lda LTK_FileHeaderBlock ,y
	beq L940e
	cmp #$2a
	beq L9409
	cmp #$3f
	beq L9409
	iny
	cpy #$10
	bne L93f5
	beq L940e
L9409
	lda #$20
	jmp LTK_ExeExtMiniSub 
	
L940e
	jsr S9509
	bcc L9416
	ldx #$ff
	rts
	
L9416
	sta L9501
L9419
	ldx #$e0
	ldy #$8f
	jsr S9592
	lda LTK_Var_ActiveLU
	ldx L95a2
	ldy L95a1
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9430
	lda #$10
	sta L9508
L9435
	ldy #$1d
	jsr S9599
	pha
	jsr S9599
	sta L9502
	tax
	jsr S9599
	sta L9503
	tay
	pla
	cpy #$ff
	bne L9464
	cpx #$ff
	bne L9464
	cmp #$ff
	bne L9464
	jsr S9498
L9459
	lda L9505
	ldx L9507
	ldy L9506
	sec
	rts
	
L9464
	asl a
	bcs L946e
	jsr S94b4
	beq L947d
	bne L9471
L946e
	jsr S9498
L9471
	jsr S94de
	beq L9459
	lda L9508
	beq L9419
	bne L9435
L947d
	ldy L9502
	ldx L9503
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L948d
	lda L95a0
	ldx S9599 + 1
	ldy S9599 + 2
	clc
	rts
	
S9498
	lda L9504
	beq L949e
	rts
	
L949e
	lda L95a0
	sta L9505
	lda S9599 + 1
	sta L9507
	lda S9599 + 2
	sta L9506
	sta L9504
	rts
	
S94b4
	ldy #$19
	jsr S9599
	lsr a
	lsr a
	lsr a
	lsr a
	cmp LTK_Var_Active_User
	bne L94d8
	ldx #$00
	ldy #$00
L94c6
	lda LTK_FileHeaderBlock ,x
	beq L94d9
	jsr S9599
	cmp LTK_FileHeaderBlock ,x
	bne L94d8
	inx
	cpx #$10
	bne L94c6
L94d8
	rts
	
L94d9
	jsr S9599
	tax
	rts
	
S94de
	lda S9599 + 1
	clc
	adc #$20
	sta S9599 + 1
	bcc L94ec
	inc S9599 + 2
L94ec
	dec L9508
	beq L94f2
	rts
	
L94f2
	inc L95a2
	bne L94fa
	inc L95a1
L94fa
	inc L95a0
	dec L9501
	rts
	
L9501
	.byte $00
L9502
	.byte $00
L9503
	.byte $00
L9504
	.byte $00
L9505
	.byte $00
L9506
	.byte $00
L9507
	.byte $00
L9508
	.byte $00
S9509
	ldx #$e0
	ldy #$91
	jsr S9592
	lda #$10
	sta L959e
	lda #$00
	tay
	sta L9505
	sta L9507
	sta L9506
	sta L9508
	sta L9504
	sta L959f
	sta L95a0
	sta L95a1
L9530
	jsr S9599
	tax
	beq L9551
	ldx #$03
L9538
	cmp L95a3,x
	beq L955b
	dex
	bpl L9538
	clc
	adc L95a0
	sta L95a0
	bcc L954c
	inc L959f
L954c
	dec L959e
	bne L9530
L9551
	lda L95a0
	bne L955d
	ldx L959f
	bne L955d
L955b
	sec
	rts
	
L955d
	sec
	sbc #$01
	sta L95a0
	bcs L9568
	dec L959f
L9568
	ldx #$03
L956a
	lsr L959f
	ror L95a0
	dex
	bpl L956a
	lda #$f0
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq L957e
	lda #$11
L957e
	sec
	adc L95a0
	sta L95a2
	bcc L958a
	inc L95a1
L958a
	lda #$fe
	sec
	sbc L95a0
	clc
	rts
	
S9592
	stx S9599 + 1
	sty S9599 + 2
	rts
	
S9599
	lda S9599,y
	iny
	rts
	
L959e
	.byte $00
L959f
	.byte $00
L95a0
	.byte $00
L95a1
	.byte $00
L95a2
	.byte $00
L95a3
	.text "=:,?"
