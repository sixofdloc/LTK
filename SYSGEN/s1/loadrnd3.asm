;loadrnd3.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 
L93e0
	pla
	tax
	pla
	tay
	inx
	bne L93e8
	iny
L93e8
	stx L9547 + 1
	sty L9547 + 2
	lda $31
	pha
	lda $32
	pha
	lda LTK_Save_XReg
	sta $c3
	lda LTK_Save_YReg
	sta $c4
	lda #$00
	sta $90
	sta $93
	sta L95b4
	sta L95b5
	ldx $91fb
	ldy $91fa
	lda $b9
	bne L9418
	ldx $c3
	ldy $c4
L9418
	lda $ae
	pha
	lda $af
	pha
	stx $ae
	sty $af
	ldx $91f1
	dex
	bne L9432
	pla
	sta $af
	pla
	sta $ae
	sec
	jmp L9541
	
L9432
	stx L95b6
	lda $91f9
	lsr a
	bcs L9440
	lda $91fc
	beq L9444
L9440
	dex
	dec L95b5
L9444
	stx L95b7
L9447
	lda L95b4
	cmp L95b7
	bne L9452
	jmp L94da
	
L9452
	lda $ff00
	pha
	lda $ae
	sta $94c9
	ldy $af
	sty $94ca
	cpy #$e0
	bcs L94b3
	cpy #$d0
	bcs L946e
	iny
	iny
	cpy #$d0
	bcc L94b3
L946e
	jsr S954a
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9478
	lda #$e0
	sta $31
	lda #$8f
	sta $32
	ldx $c6
	lda $f7f0,x
	sta $9497
	ora #$01
	sta $949d
	ldy #$00
	ldx #$02
	stx LTK_CTPOffsetCounter
L9494
	lda $af
	ldx #$00
	cmp #$df
	bne L949e
	ldx #$00
L949e
	stx $ff00
	lda ($31),y
	sta ($ae),y
	iny
	bne L9494
	inc $32
	inc $af
	dec LTK_CTPOffsetCounter
	bne L9494
	beq L94d0
L94b3
	ldx $c6
	lda $f7f0,x
	and #$ce
	ldx #$00
	stx LTK_Krn_BankControl
	sta $ff00
	jsr S954a
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$00,$01 
L94cc
	inc $af
	inc $af
L94d0
	pla
	sta $ff00
	inc L95b4
	jmp L9447
	
L94da
	lda L95b5
	beq L9504
	jsr S954a
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L94e9
	lda #$e0
	sta $31
	lda #$8f
	sta $32
	lda $91f9
	lsr a
	bcc L94fc
	ldx #$00
	jsr S9560
L94fc
	ldx $91fc
	beq L9504
	jsr S9560
L9504
	lda $91f8
	cmp #$0b
	bne L951f
	lda $91fd
	and #$0f
	sta LTK_Var_SAndRData
	lda $9200
	sta $8026
	lda $9201
	sta $8027
L951f
	pla
	tay
	pla
	tax
	lda $91f8
	cmp #$04
	bcs L952e
	stx $ae
	sty $af
L952e
	lda LTK_Var_CurRoutine
	cmp #$f0
	bne L953c
	ldx #$b8
	ldy #$95
	jsr LTK_Print 
L953c
	ldx $ae
	ldy $af
	clc
L9541
	pla
	sta $32
	pla
	sta $31
L9547
	jmp L9547
	
S954a
	lda L95b4
	clc
	adc #$01
	asl a
	tax
	lda $9200,x
	tay
	lda $9201,x
	tax
	lda $91fd
	and #$0f
	rts
	
S9560
	lda $ff00
	pha
	ldy $c6
	lda $f7f0,y
	sta L958f + 1
	ora #$01
	sta $9596
	and #$ce
	sta $9581
L9576
	ldy $af
	cpy #$a0
	bcs L958f
	cpy #$80
	bcc L958f
	lda #$00
	sta $ff00
	ldy #$00
	lda ($31),y
	jsr $fc80
	jmp L95a0
	
L958f
	lda #$00
	cpy #$df
	bne L9597
	lda #$00
L9597
	sta $ff00
	ldy #$00
	lda ($31),y
	sta ($ae),y
L95a0
	inc $31
	bne L95a6
	inc $32
L95a6
	inc $ae
	bne L95ac
	inc $af
L95ac
	dex
	bne L9576
	pla
	sta $ff00
	rts
	
L95b4
	.byte $00
L95b5
	.byte $00
L95b6
	.byte $00
L95b7
	.byte $00
L95b8
	.text "{Return}{Return}"
	.byte $00
