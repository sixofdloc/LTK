;loadrnd2.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea  ;$93e0, $4000 for sysgen

L93e0
	pla
	tax
	pla
	tay
	inx
	bne L93e8
	iny
L93e8
	stx L950a + 1
	sty L950a + 2
	lda LTK_Save_XReg
	sta $c3
	lda LTK_Save_YReg
	sta $c4
	lda #$00
	sta $90
	sta $93
	sta L9543
	sta L9544
	ldx $91fb
	ldy $91fa
	lda $b9
	bne L9412
	ldx $c3
	ldy $c4
L9412     
        stx $ae
	sty $af
	ldx $91f1
	dex
	bne L9420
	sec
	jmp L950a
	
L9420
	stx L9545
	lda $91f9
	lsr a
	bcs L942e
	lda $91fc
	beq L9432
L942e
	dex
	dec L9544
L9432
	stx L9546
L9435
	lda L9543
	cmp L9546
	beq L9495
	jsr S952f
	bcc L9473
	jsr S950d
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L944c
	lda #$e0
	sta S9523 + 1
	lda #$8f
	sta S9523 + 2
	ldx #$02
	stx LTK_CTPOffsetCounter
	ldx #$00
L945d
	jsr S9523
	jsr $fc80
	inc $ae
	bne L9469
	inc $af
L9469
	inx
	bne L945d
	dec LTK_CTPOffsetCounter
	bne L945d
	beq L9490
L9473
	lda $ae
	sta $9489
	lda $af
	sta $948a
	lda #$00
	sta LTK_Krn_BankControl
	jsr S950d
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$00,$01 
L948c
	inc $af
	inc $af
L9490
	inc L9543
	bne L9435
L9495
	lda L9544
	bne L949d
	jmp L94dc
	
L949d
	jsr S950d
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L94a7
	lda #$e0
	sta S9523 + 1
	lda #$8f
	sta S9523 + 2
	lda $91f9
	lsr a
	bcc L94c8
	ldx #$00
L94b9
	jsr S9523
	jsr $fc80
	inc $ae
	bne L94c5
	inc $af
L94c5
	inx
	bne L94b9
L94c8
	ldx $91fc
	beq L94dc
L94cd
	jsr S9523
	jsr $fc80
	inc $ae
	bne L94d9
	inc $af
L94d9
	dex
	bne L94cd
L94dc
	lda $91f8
	cmp #$0b
	bne L94f7
	lda $91fd
	and #$0f
	sta LTK_Var_SAndRData
	lda $9200
	sta $8026
	lda $9201
	sta $8027
L94f7
	lda LTK_Var_CurRoutine
	cmp #$f0
	bne L9505
	ldx #$47
	ldy #$95
	jsr LTK_Print 
L9505
	ldx $ae
	ldy $af
	clc
L950a
	jmp L950a
	
S950d
	lda L9543
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
	
S9523
	lda S9523
	inc S9523 + 1
	bne L952e
	inc S9523 + 2
L952e
	rts
	
S952f
	lda $af
	cmp #$02
	bcc L9541
	cmp #$fe
	bcc L9542
	bne L9541
	lda $ae
	cmp #$ae
	bcc L9542
L9541
	sec
L9542
	rts
	
L9543
	.byte $00 
L9544
	.byte $00 
L9545
	.byte $00 
L9546
	.byte $00 
L9547
	.text "{Return}{Return}"
L9549
	.byte $00 



