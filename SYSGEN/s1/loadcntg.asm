;loadcntg.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea 
 
L93e0
	ldx $91fb
	ldy $91fa
	lda $91f8
	cmp #$04
	bcc L93f7
	lda $b9
	bne L93f7
	ldx LTK_Save_XReg
	ldy LTK_Save_YReg
L93f7
	lda $91f8
	cmp #$03
	bne L9418
	ldx $91f1
	dex
	txa
	ldx $91f3
	ldy $91f2
	sec
	jsr LTK_MemSwapOut 
	lda #$4c
	sta LTK_DOSOverlay 
	stx $95e1
	sty $95e2
L9418
	stx $9474
	stx L9560
	sty $9475
	sty L955f
	ldx $91f1
	dex
	bne L942c
	sec
	rts
	
L942c
	stx L955e
	lda $91f9
	lsr a
	bcs L943a
	lda $91fc
	beq L943b
L943a
	dex
L943b
	stx $9476
	stx L955d
	lda $9200
	sta L9561
	lda $9201
	sta L9562
	inc L9562
	bne L9455
	inc L9561
L9455
	cpx #$00
	beq L948b
	lda $91fd
	and #$0f
	ldx $91f8
	cpx #$02
	beq L946a
	ldx #$00
	stx LTK_Krn_BankControl
L946a
	ldx L9562
	ldy L9561
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$00,$00 
L9477
	lda L955d
	cmp L955e
	beq L94ea
	clc
	adc L9562
	sta L9562
	bcc L948b
	inc L9561
L948b
	lda #$8f
	sta L94da + 2
	lda #$e0
	sta L94da + 1
	lda $91fd
	and #$0f
	ldx L9562
	ldy L9561
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L94a7
	lda $31
	pha
	lda $32
	pha
	lda L9560
	sta $31
	lda L955d
	asl a
	clc
	adc L955f
	sta $32
	lda $91f9
	and #$01
	beq L94d3
	ldy #$00
L94c5
	lda LTK_MiscWorkspace,y
	jsr $fc6b
	iny
	bne L94c5
	inc $32
	inc L94da + 2
L94d3
	ldx $91fc
	beq L94e4
	ldy #$00
L94da
	lda L94da,y
	jsr $fc6b
	iny
	dex
	bne L94da
L94e4
	pla
	sta $32
	pla
	sta $31
L94ea
	ldx $91f1
	dex
	lda $91f9
	lsr a
	bcs L94f9
	lda $91fc
	beq L94fa
L94f9
	dex
L94fa
	txa
	asl a
	clc
	adc L955f
	tay
	lda $91f9
	lsr a
	bcc L9508
	iny
L9508
	lda $91fc
	clc
	adc L9560
	bcc L9512
	iny
L9512
	tax
	lda $91f8
	cmp #$04
	bcs L951f
	lda #$ff
	sta LTK_BLKAddr_DosOvl
L951f
	lda $91f8
	cmp #$0b
	bne L953a
	lda $91fd
	and #$0f
	sta LTK_Var_SAndRData
	lda $9200
	sta $8026
	lda $9201
	sta $8027
L953a
	lda $91f8
	cmp #$04
	bcc L9545
	stx $ae
	sty $af
L9545
	lda LTK_Var_CurRoutine
	cmp #$f0
	bne L955b
	txa
	pha
	tya
	pha
	ldx #$63
	ldy #$95
	jsr LTK_Print 
	pla
	tay
	pla
	tax
L955b
	clc
	rts
	
L955d
	.byte $00
L955e
	.byte $00
L955f
	.byte $00
L9560
	.byte $00
L9561
	.byte $00
L9562
	.byte $00
L9563
	.text "{Return}{Return}"
L9565
	.byte $00
