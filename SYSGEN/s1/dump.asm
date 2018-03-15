;dump.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=$c000 
Lc000
	ldx $c8
	bit LTK_Var_CPUMode
	beq Lc080
	ldx $ea
	pha
	lda #$24
	sta $c21c
	lda #$2f
	sta $c221
	lda #$30
	sta $c22b
	lda #$31
	sta $c223
	lda #$32
	sta $c22d
	lda #$33
	sta $c225
	lda #$34
	sta $c22f
	lda #$3d
	sta $c233
	lda #$3e
	sta $c23a
	lda #$2d
	sta $c44c
	lda #$2e
	sta $c451
	lda #$16
	sta $c1b5
	lda #$17
	sta $c1ba
	lda #$61
	sta $c162
	sta $c1b3
	sta $c1b8
	sta $c16b
	sta $c183
	lda #$62
	sta $c167
	lda #$f8
	sta Lc635
	lda #$50
	sta Lc636
	lda #$4f
	sta Lc633
	lda #$4f
	sta Lc634
	lda #$14
	sta $c0c3
	lda #$fd
	sta $c0c8
	pla
Lc080
	jsr Sc291
	jsr Sc2d1
	lda Lc444
	cmp Lc446
	bne Lc0b1
	lda Lc445
	cmp Lc447
	bne Lc0b1
	ldx #$a0
	ldy #$c0
	jsr Sc254
	jmp Lc20b
	
Lc0a0
	.text "{return}line not found{return}"
	.byte $00
Lc0b1
	lda #$0d
	jsr Sc55e
	lda $0300
	sta Lc216
	lda $0301
	sta Lc217
	lda #$42
	sta $0300
	lda #$fe
	sta $0301
	ldy Lc271
	lda #$2c
	sta Lc272,y
	iny
	iny
	sta Lc272,y
	dey
	lda #$53
	sta Lc272,y
	iny
	iny
	lda #$57
	sta Lc272,y
Lc0e6
	lda Lc272,y
	sta LTK_Command_Buffer,y
	dey
	bpl Lc0e6
	lda Lc271
	tax
	inx
	inx
	inx
	inx
	txa
	pha
	jsr Sc581
	lda #$0f
	tay
	ldx LTK_HD_DevNum
	jsr Sc58b
	lda #$00
	jsr Sc586
	jsr Sc56d
	jsr Sc245
	lda Lc55d
	sec
	bne Lc117
	clc
Lc117
	lda #$00
	adc Lc55d
	tax
	lda #$02
	adc #$00
	tay
	lda Lc55d
	clc
	bne Lc129
	sec
Lc129
	pla
	sbc Lc55d
	jsr Sc586
	lda #$01
	ldx LTK_HD_DevNum
	ldy #$02
	jsr Sc58b
	jsr Sc56d
	jsr Sc245
	beq Lc159
	ldx #$4c
	ldy #$c1
	jsr Sc254
	jmp Lc1f2
	
Lc14c
	.text "{return}file error{return}"
	.byte $00
Lc159
	ldx #$01
	jsr Sc577
Lc15e
	lda Lc446
	sta $5f
	lda Lc447
	sta $60
	ldy #$00
	lda ($5f),y
	sta $c19b
	sta $c1a2
	sta $c1ab
	sta $c1af
	sta $c1cf
	sta $c1d6
	sta Lc446
	iny
	lda ($5f),y
	sta $c19c
	sta $c1a3
	sta $c1ac
	sta $c1b0
	sta $c1d0
	sta $c1d7
	sta Lc447
	dey
	lda $c19a,y
	sta Lc214
	iny
	lda $c1a1,y
	sta Lc215
	dey
	lda #$00
	sta $c1aa,y
	iny
	sta $c1ae,y
	iny
	lda ($5f),y
	sta $14
	iny
	lda ($5f),y
	sta $15
	dey
	jsr Sc595
	bit LTK_Var_CPUMode
	bmi Lc1c9
	lda #$0d
	jsr Sc55e
Lc1c9
	ldy #$00
	lda Lc214
	sta $c1ce,y
	lda Lc215
	iny
	sta $c1d5,y
	lda Lc445
	cmp Lc447
	bcc Lc1f2
	beq Lc1e5
	jmp Lc15e
	
Lc1e5
	lda Lc444
	cmp Lc446
	bcc Lc1f2
	beq Lc1f2
	jmp Lc15e
	
Lc1f2
	lda #$01
	jsr Sc572
	lda #$0f
	jsr Sc572
	jsr Sc568
	lda Lc216
	sta $0300
	lda Lc217
	sta $0301
Lc20b
	jsr Sc218
	ldx #$80
	clc
	jmp LTK_MemSwapOut 
	
Lc214
	.byte $00
Lc215
	.byte $00
Lc216
	.byte $00
Lc217
	.byte $00
Sc218
	jsr Sc590
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
	ldy #$ff
	sty $7a
	iny
	sty LTK_Command_Buffer
	iny
	sty $7b
Lc23b
	jsr Sc5a4
	dec Lc244
	bne Lc23b
	rts
	
Lc244
	.byte $b0 
Sc245
	ldx #$0f
	jsr Sc57c
Lc24a
	jsr Sc563
	cmp #$0d
	beq Lc24a
	cmp #$30
	rts
	
Sc254
	stx $c25d
	sty $c25e
Lc25a
	ldy #$00
	lda $c25c,y
	ora #$00
	beq Lc270
	jsr Sc55e
	inc $c25d
	bne Lc25a
	inc $c25e
	bne Lc25a
Lc270
	rts
	
Lc271
	.byte $1f 
Lc272
	.text "00000-65535 *??????????????????"
Sc291
	tay
	iny
	lda #$00
	sta Lc2bc + 1
	lda #$02
	sta Lc2bc + 2
	stx Lc271
	cpy Lc271
	bcs Lc2cb
	dey
	iny
	sty $c2c0
	lda #$72
	sec
	sbc $c2c0
	sta $c2c0
	lda #$c2
	sbc #$00
	sta $c2c1
	ldx #$00
Lc2bc
	lda Lc2bc,y
	sta $c2bf,y
	cpy Lc271
	beq Lc2cd
	inx
	iny
	bne Lc2bc
Lc2cb
	ldx #$0b
Lc2cd
	stx Lc271
	rts
	
Sc2d1
	lda #$72
	sta Lc302 + 1
	sta Lc347 + 1
	sta $c355
	sta Lc378 + 1
	lda #$c2
	sta Lc302 + 2
	sta Lc347 + 2
	sta $c356
	sta Lc378 + 2
	ldy #$ff
	sty Lc54f
	sty Lc550
	iny
	sty Lc54d
	sty Lc54e
	sty Lc549
	sty Lc54a
Lc302
	lda Lc302,y
	iny
	cmp #$2d
	beq Lc32e
	cmp #$20
	bne Lc317
	dey
	sty Lc55d
	beq Lc371
	jmp Lc31f
	
Lc317
	jsr Sc50d
	cpy Lc271
	bne Lc302
Lc31f
	lda Lc549
	sta Lc54d
	lda Lc54a
	sta Lc54e
	jmp Lc371
	
Lc32e
	lda Lc549
	sta Lc54d
	lda Lc54a
	sta Lc54e
	lda #$00
	sta Lc549
	sta Lc54a
	cpy Lc271
	beq Lc371
Lc347
	lda Lc347,y
	iny
	cmp #$20
	bne Lc35d
	dey
	sty Lc55d
	dey
	lda $c354,y
	cmp #$2d
	beq Lc371
	bne Lc365
Lc35d
	jsr Sc50d
	cpy Lc271
	bne Lc347
Lc365
	lda Lc549
	sta Lc54f
	lda Lc54a
	sta Lc550
Lc371
	lda Lc55d
	beq Lc3dc
	ldy #$00
Lc378
	lda Lc378,y
	iny
	cmp #$2d
	bne Lc385
	sta Lc55a
	beq Lc38d
Lc385
	cmp #$30
	bcc Lc3dc
	cmp #$3a
	bcs Lc3dc
Lc38d
	cpy Lc55d
	bne Lc378
	ldy Lc550
	cpy Lc54e
	bcc Lc3a4
	bne Lc3e7
	ldy Lc54f
	cpy Lc54d
	bcs Lc3e7
Lc3a4
	ldx #$b0
	ldy #$c3
	jsr Sc254
	pla
	pla
	jmp Lc1f2
	
Lc3b0
	.text "{return}{$07}bad range{return}line range must be from0-63999{return}"
	.byte $00
Lc3dc
	lda #$00
	sta Lc55d
	sta Lc54d
	sta Lc54e
Lc3e7
	ldx #$ff
	ldy #$ff
	tya
	jsr Sc448
	stx $ae
	sty $af
	lda Lc55a
	bne Lc409
	lda Lc55d
	beq Lc409
	lda Lc54d
	sta Lc54f
	lda Lc54e
	sta Lc550
Lc409
	ldx Lc54d
	ldy Lc54e
	lda #$00
	jsr Sc448
	stx Lc4e6
	sty Lc4e7
	ldx Lc54f
	ldy Lc550
	lda #$01
	jsr Sc448
	txa
	sec
	sbc #$01
	sta Lc444
	tya
	sbc #$00
	sta Lc445
	lda Lc4e6
	sec
	sbc #$01
	sta Lc446
	lda Lc4e7
	sbc #$00
	sta Lc447
	rts
	
Lc444
	.byte $ff 
Lc445
	.byte $ff 
Lc446
	.byte $00
Lc447
	.byte $00
Sc448
	sta Lc4e5
	lda $2b
	sta Lc45b + 1
	lda $2c
	sta $c470
	stx Lc55b
	sty Lc55c
Lc45b
	lda #$5b
	sta $c488
	sta $c48d
	sta $c497
	sta $c49c
	sta $c4b9
	sta $c4bd
	lda #$c4
	sta $c489
	sta $c48e
	sta $c498
	sta $c49d
	sta $c4ba
	sta $c4be
	ldy #$00
	iny
	iny
	lda $c487,y
	tax
	iny
	lda $c48c,y
	jsr Sc4b1
	bcs Lc4a6
	dey
	dey
	lda $c496,y
	tax
	dey
	lda $c49b,y
	sta Lc45b + 1
	stx $c470
	bcc Lc45b
Lc4a6
	ldx Lc45b + 1
	ldy $c470
	inx
	bne Lc4b0
	iny
Lc4b0
	rts
	
Sc4b1
	pha
	txa
	pha
	tya
	pha
	ldy #$00
	lda $c4b8,y
	iny
	ora $c4bc,y
	beq Lc4dd
	pla
	tay
	pla
	tax
	pla
	cmp Lc55c
	bcc Lc4d4
	bne Lc4db
	cpx Lc55b
	beq Lc4d6
	bcs Lc4db
Lc4d4
	clc
	rts
	
Lc4d6
	lda Lc4e5
	bne Lc4d4
Lc4db
	sec
	rts
	
Lc4dd
	pla
	tax
	pla
	tax
	pla
	jmp Lc4db
	
Lc4e5
	.byte $00
Lc4e6
	.byte $00
Lc4e7
	.byte $00
Lc4e8
	lda #$00
	sta Lc549
	sta Lc54a
	sta Lc548
Lc4f3
	lda LTK_Command_Buffer,y
	cmp #$3a
	bcc Lc4fb
Lc4fa
	rts
	
Lc4fb
	cmp #$30
	bcc Lc4fa
	jsr Sc50d
	sty Lc548
	iny
	cpy Lc271
	beq Lc4fa
	bne Lc4f3
Sc50d
	clc
	sbc #$2f
	sta Lc54c
	lda Lc54a
	sta Lc54b
	lda Lc549
	asl a
	rol Lc54b
	asl a
	rol Lc54b
	adc Lc549
	sta Lc549
	lda Lc54b
	adc Lc54a
	sta Lc54a
	asl Lc549
	rol Lc54a
	lda Lc549
	adc Lc54c
	sta Lc549
	bcc Lc547
	inc Lc54a
Lc547
	rts
	
Lc548
	.byte $00
Lc549
	.byte $00
Lc54a
	.byte $00
Lc54b
	.byte $00
Lc54c
	.byte $00
Lc54d
	.byte $00
Lc54e
	.byte $00
Lc54f
	.byte $00
Lc550
	.byte $00
	.text "-number{return}"
	.byte $00
Lc55a
	.byte $00
Lc55b
	.byte $00
Lc55c
	.byte $00
Lc55d
	.byte $00
Sc55e
	pha
	lda #$00
	beq Lc5ae
Sc563
	pha
	lda #$01
	bne Lc5ae
Sc568
	pha
	lda #$02
	bne Lc5ae
Sc56d
	pha
	lda #$03
	bne Lc5ae
Sc572
	pha
	lda #$04
	bne Lc5ae
Sc577
	pha
	lda #$05
	bne Lc5ae
Sc57c
	pha
	lda #$06
	bne Lc5ae
Sc581
	pha
	lda #$07
	bne Lc5ae
Sc586
	pha
	lda #$08
	bne Lc5ae
Sc58b
	pha
	lda #$09
	bne Lc5ae
Sc590
	pha
	lda #$0a
	bne Lc5ae
Sc595
	pha
	lda #$0b
	bne Lc5ae
	pha
	lda #$0c
	bne Lc5ae
	pha
	lda #$0d
	bne Lc5ae
Sc5a4
	pha
	lda #$0e
	bne Lc5ae
	pha
	lda #$0f
	bne Lc5ae
Lc5ae
	sty Lc617
	stx Lc618
	ldy LTK_Save_PreconfigC
	sty Lc619
	ldy LTK_Save_PreconfigD
	sty Lc61a
	ldy LTK_Save_P
	sty Lc61b
	ldy LTK_Save_Accu
	sty Lc61c
	ldy LTK_Save_XReg
	sty Lc61d
	ldy LTK_Save_YReg
	sty Lc61e
	asl a
	tay
	lda Lc61f,y
	tax
	lda Lc620,y
	tay
	sec
	jsr LTK_KernalTrapSetup
	pla
	ldy Lc617
	ldx Lc618
	jsr LTK_KernalCall2 
	pha
	lda Lc619
	sta LTK_Save_PreconfigC
	lda Lc61a
	sta LTK_Save_PreconfigD
	lda Lc61b
	sta LTK_Save_P
	lda Lc61c
	sta LTK_Save_Accu
	lda Lc61d
	sta LTK_Save_XReg
	lda Lc61e
	sta LTK_Save_YReg
	pla
	rts
	
Lc617
	.byte $00
Lc618
	.byte $00
Lc619
	.byte $00
Lc61a
	.byte $00
Lc61b
	.byte $00
Lc61c
	.byte $00
Lc61d
	.byte $00
Lc61e
	.byte $00
Lc61f
	.byte $d2 
Lc620
	.byte $ff 
Lc621
	.byte $cf 
Lc622
	.byte $ff 
Lc623
	.byte $cc 
Lc624
	.byte $ff 
Lc625
	.byte $c0 
Lc626
	.byte $ff 
Lc627
	.byte $c3 
Lc628
	.byte $ff 
Lc629
	.byte $c9 
Lc62a
	.byte $ff 
Lc62b
	.byte $c6 
Lc62c
	.byte $ff 
Lc62d
	.byte $e7 
Lc62e
	.byte $ff 
Lc62f
	.byte $bd 
Lc630
	.byte $ff 
Lc631
	.byte $ba 
Lc632
	.byte $ff 
Lc633
	.byte $33 
Lc634
	.byte $a5 
Lc635
	.byte $d8 
Lc636
	.byte $a6 
Lc637
	.byte $9f 
Lc638
	.byte $ff 
Lc639
	.byte $79 
Lc63a
	.byte $a5 
Lc63b
	.byte $e4 
Lc63c
	.byte $ff 
Lc63d
	.byte $3d 
Lc63e
	.byte $c6 
