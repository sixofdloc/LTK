;build.r.prg
	
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	
	*=$c000 ;$4000 for sysgen
	
Lc000
	sta Lc434
	ldx $c8
	lda LTK_Var_CPUMode
	beq Lc00c
	ldx $ea
Lc00c
	stx $c379
	ldy $c379
	lda #$ff
	sta LTK_ReadChanFPTPtr
	sta LTK_Command_Buffer,y
	lda LTK_Var_ActiveLU
	sta $c36f
	lda LTK_Var_Active_User
	sta $c370
	jsr LTK_ClearHeaderBlock 
	ldy Lc434
	cpy $c379
	bcc Lc034
	jmp Lc459
	
Lc034
	iny
	cpy $c379
	bcc Lc03d
	jmp Lc459
	
Lc03d
	lda LTK_Command_Buffer,y
	cmp #$22
	bne Lc045
	iny
Lc045
	ldx $c379
	lda $01ff,x
	cmp #$22
	bne Lc052
	dec $c379
Lc052
	cpy $c379
	bcc Lc05a
	jmp Lc459
	
Lc05a
	sty Lc434
	jsr Sc49d
	bcc Lc068
	cmp #$3a
	beq Lc071
	bne Lc080
Lc068
	txa
	jsr LTK_SetLuActive 
	bcc Lc071
	jmp Lc44d
	
Lc071
	jsr Sc49d
	bcs Lc080
	cpx #$10
	bcc Lc07d
	jmp Lc453
	
Lc07d
	stx LTK_Var_Active_User
Lc080
	ldy Lc434
	ldx #$00
Lc085
	lda LTK_Command_Buffer,y
	cmp #$2c
	beq Lc0a0
	sta LTK_FileHeaderBlock ,x
	iny
	cpy $c379
	bcs Lc09d
	inx
	cpx #$11
	bne Lc085
	jmp Lc477
	
Lc09d
	jmp Lc47d
	
Lc0a0
	sty Lc434
	lda #$02
	sec
	jsr $9f00
	bcc Lc0ae
	jmp Lc443
	
Lc0ae
	jsr LTK_FindFile 
	bcs Lc0b6
	jmp Lc46b
	
Lc0b6
	sta $c435
	stx $c36e
	sty $c36d
	cpx #$ff
	bne Lc0c6
	jmp Lc471
	
Lc0c6
	lda $c435
	bne Lc0d4
	txa
	bne Lc0d4
	tya
	bne Lc0d4
	jmp Lc465
	
Lc0d4
	ldy Lc434
	iny
	cpy $c379
	bcs Lc111
	lda #$00
	ldx #$02
	jsr Sc5b8
	bcs Lc111
	sta $91f6
	stx $91f7
	inc $91f7
	bne Lc0f4
	inc $91f6
Lc0f4
	lda LTK_Command_Buffer,y
	cmp #$2c
	bne Lc111
	iny
	cpy $c379
	bcs Lc111
	cmp #$00
	bne Lc108
	txa
	beq Lc111
Lc108
	lda #$00
	ldx #$02
	jsr Sc5b8
	bcc Lc114
Lc111
	jmp Lc47d
	
Lc114
	sta $91f4
	stx $91f5
	cmp #$0d
	bcs Lc111
	tay
	bne Lc124
	txa
	beq Lc111
Lc124
	lda $91f6
	sta $c369
	lda $91f7
	sta $c36a
	jsr Sc321
	sta $c377
	stx $c375
	sty $c373
	ldx #$09
	ldy #$00
Lc140
	lsr $c373
	ror $c375
	ror $c377
	bcc Lc14c
	iny
Lc14c
	dex
	bne Lc140
	tya
	beq Lc15a
	inc $c377
	bne Lc15a
	inc $c375
Lc15a
	ldx $c377
	ldy $c375
	stx $c43c
	sty $c43b
	inx
	bne Lc16a
	iny
Lc16a
	stx $91f1
	sty $91f0
	tya
	bne Lc177
	cpx #$f1
	bcc Lc17a
Lc177
	dec $c436
Lc17a
	lda #$0f
	sta $91f8
	jsr LTK_AllocateRandomBlks 
	bcc Lc18f
	cpx #$80
	bne Lc18c
	tax
	jmp Lc43f
	
Lc18c
	jmp Lc45f
	
Lc18f
	lda #$00
	sta $c373
	sta $91f6
	sta $91f7
	ldx #$09
Lc19c
	asl $c377
	rol $c375
	rol $c373
	dex
	bne Lc19c
Lc1a8
	lda $c373
	bne Lc1bf
	lda $91f4
	cmp $c375
	bcc Lc1bf
	bne Lc1e5
	lda $c377
	cmp $91f5
	bcc Lc1e5
Lc1bf
	inc $91f7
	bne Lc1c7
	inc $91f6
Lc1c7
	sec
	lda $c377
	sbc $91f5
	sta $c377
	lda $c375
	sbc $91f4
	sta $c375
	lda $c373
	sbc #$00
	sta $c373
	jmp Lc1a8
	
Lc1e5
	lda $c435
	pha
	ldx $c36e
	ldy $c36d
	lda #$24
	jsr LTK_ExeExtMiniSub 
	ldy $9200
	ldx $9201
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc204
	lda #$00
	
	sta $c369
	sta $c36a
	sta $c375
	sta $c377
	jsr Sc37a
Lc215
	jsr Sc3b1
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ; $8fe0
Lc222
	ldx #$ca
	ldy #$c4
	jsr LTK_Print 
	inc $c377
	bne Lc231
	inc $c375
Lc231
	lda $c375
	cmp $c43b
	bne Lc215
	lda $c377
	cmp $c43c
	bne Lc215
	jsr Sc321
	sta $c378
	stx $c376
	sty $c374
Lc24d
	lda $c378
	sta $c377
	lda $c376
	sta $c375
	lda $c374
	sta $c373
	ldx #$09
Lc261
	lsr $c373
	ror $c375
	ror $c377
	dex
	bne Lc261
	jsr Sc3b1
	lda Lc368
	bne Lc27e
	sty $c36b
	stx $c36c
	dec Lc368
Lc27e
	cpy $c36b
	bne Lc288
	cpx $c36c
	beq Lc28b
Lc288
	jsr Sc38a
Lc28b
	clc
	lda $c378
	adc #$e0
	sta $c2a1
	lda $c376
	and #$01
	adc #$8f
	sta $c2a2
	lda #$ff
	sta $c2a0
	lda $c378
	clc
	adc $91f5
	sta $c378
	lda $c376
	adc $91f4
	sta $c376
	lda $c374
	adc #$00
	sta $c374
	inc $c36a
	bne Lc2c6
	inc $c369
Lc2c6
	lda $91f6
	cmp $c369
	bne Lc2d6
	lda $91f7
	cmp $c36a
	beq Lc2d9
Lc2d6
	jmp Lc24d
	
Lc2d9
	jsr Sc38a
	ldx #$b4
	ldy #$c5
	jsr LTK_Print 
	lda LTK_Var_ActiveLU
	jsr Sc313
	stx Lc4c3
	sta $c4c4
	lda LTK_Var_Active_User
	jsr Sc313
	stx $c4c6
	sta Lc4c7
	ldx #$c3
	ldy #$c4
	jsr LTK_Print 
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	ldx #$e4
	ldy #$c4
	jsr LTK_Print 
	jmp Lc483
	
Sc313
	ldx #$30
Lc315
	cmp #$0a
	bcc Lc31e
	sbc #$0a
	inx
	bne Lc315
Lc31e
	adc #$30
	rts
	
Sc321
	lda $c369
	sta $c34b
	lda $c36a
	sta $c347
	lda $91f4
	sta $c35c
	lda $91f5
	sta $c363
	lda #$00
	sta $c371
	sta $c372
	tax
	tay
	pha
Lc344
	pla
	clc
	adc #$00
	pha
	txa
	adc #$00
	tax
	bcc Lc350
	iny
Lc350
	inc $c372
	bne Lc358
	inc $c371
Lc358
	lda $c371
	cmp #$00
	bne Lc344
	lda $c372
	cmp #$00
	bne Lc344
	pla
	rts
	
Lc368	
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
Sc37a
	lda #$00
	tay
Lc37d
	sta LTK_MiscWorkspace,y
	iny
	bne Lc37d
Lc383
	sta $90e0,y
	iny
	bne Lc383
	rts
	
Sc38a
	tya
	pha
	txa
	pha
	ldy $c36b
	ldx $c36c
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ; $8fe0
Lc39e
	pla
	sta $c36c
	pla
	sta $c36b
	jsr Sc37a
	ldx #$ca
	ldy #$c4
	jsr LTK_Print 
	rts
	
Sc3b1
	ldx $c375
	lda $c377
	stx $c437
	sta $c438
	sta $c439
	tay
	bne Lc3cb
	txa
	bne Lc3cb
	lda #$ff
	sta $c43a
Lc3cb
	lda #$02
	ldx #$92
	jsr Sc418
	lda $c436
	beq Lc411
	ldy #$08
Lc3d9
	lsr $c437
	ror $c438
	dey
	bne Lc3d9
	lda $c438
	cmp $c43a
	php
	beq Lc3f7
	sta $c43a
	jsr Sc41f
	sty $c43d
	stx $c43e
Lc3f7
	lda #$e0
	ldx #$9b
	jsr Sc418
	plp
	beq Lc411
	lda LTK_Var_ActiveLU
	ldx $c43e
	ldy $c43d
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0
Lc411
	lda $c439
	jsr Sc41f
	rts
	
Sc418
	sta Sc42f + 1
	stx Sc42f + 2
	rts
	
Sc41f
	asl a
	tax
	bcc Lc426
	inc Sc42f + 2
Lc426
	jsr Sc42f
	tay
	jsr Sc42f
	tax
	rts
	
Sc42f
	lda Sc42f,x
	inx
	rts
	
Lc434
	.byte $00,$00,$00,$00,$00,$00,$ff,$00,$00,$00,$00 
Lc43f
	ldy #$04
	bne Lc485
Lc443
	ldy #$05
	bne Lc485
	ldx #$86
	ldy #$c5
	bne Lc485
Lc44d
	ldx #$6d
	ldy #$c5
	bne Lc485
Lc453
	ldx #$9c
	ldy #$c5
	bne Lc485
Lc459
	ldx #$13
	ldy #$c5
	bne Lc485
Lc45f
	ldx #$02
	ldy #$c5
	bne Lc485
Lc465
	ldx #$54
	ldy #$c5
	bne Lc485
Lc46b
	ldx #$cc
	ldy #$c4
	bne Lc485
Lc471
	ldx #$3f
	ldy #$c5
	bne Lc485
Lc477
	ldx #$29
	ldy #$c5
	bne Lc485
Lc47d
	ldx #$f1
	ldy #$c4
	bne Lc485
Lc483
	ldy #$00
Lc485
	jsr LTK_ErrorHandler 
	lda #$02
	clc
	jsr $9f00
	lda $c36f
	sta LTK_Var_ActiveLU
	lda $c370
	sta LTK_Var_Active_User
	jmp LTK_MemSwapOut 
	
Sc49d
	ldy Lc434
	lda #$00
	ldx #$02
	cpy $c379
	bcs Lc4c1
	jsr Sc5b8
	php
	bcs Lc4b3
	pha
	pla
	bne Lc4c0
Lc4b3
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne Lc4c0
	iny
	sty Lc434
	plp
	rts
	
Lc4c0
	plp
Lc4c1
	sec
	rts
	
Lc4c3
	.byte $00,$00 
Lc4c5
	.text ":"
	.byte $00
Lc4c7
	.byte $00
Lc4c8
	.text ":"
	.byte $00
Lc4ca
	.text "."
	.byte $00
Lc4cc
	.text "file already exists !!{return}"
	.byte $00
Lc4e4
	.text "{rvs off}  created.{return}"
	.byte $00
Lc4f1
	.text "syntax error !!{return}"
	.byte $00
Lc502
	.text "disk is full !!{return}"
	.byte $00
Lc513
	.text "no filename given !!{return}"
	.byte $00
Lc529
	.text "filename too long !!{return}"
	.byte $00
Lc53f
	.text "illegal filename !!{return}"
	.byte $00
Lc554
	.text "system index is full !!{return}"
	.byte $00
Lc56d
	.text "invalid logical unit !!{return}"
	.byte $00
Lc586
	.text "invalid file size !!{return}"
	.byte $00
Lc59c
	.text "invalid user number !!{return}"
	.byte $00
Lc5b4
	.text "{return}{return}{rvs on}"
	.byte $00
Sc5b8
	sta Lc5c9 + 1
	stx Lc5c9 + 2
	lda #$00
	sta Lc633
	sta $c634
	sta $c635
Lc5c9
	lda Lc5c9,y
	cmp #$30
	bcc Lc621
	cmp #$3a
	bcc Lc5e6
	ldx $c5f2
	cpx #$0a
	beq Lc621
	cmp #$41
	bcc Lc621
	cmp #$47
	bcs Lc621
	sec
	sbc #$07
Lc5e6
	ldx Lc633
	beq Lc60a
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
Lc5f3
	clc
	adc $c635
	pha
	txa
	adc $c634
	tax
	pla
	dey
	bne Lc5f3
	sta $c635
	stx $c634
	pla
	tay
	pla
Lc60a
	inc Lc633
	sec
	sbc #$30
	clc
	adc $c635
	sta $c635
	bcc Lc61e
	inc $c634
	beq Lc62b
Lc61e
	iny
	bne Lc5c9
Lc621
	cmp #$20
	beq Lc61e
	clc
	ldx Lc633
	bne Lc62c
Lc62b
	sec
Lc62c
	lda $c634
	ldx $c635
	rts
	
Lc633
	.byte $00,$00,$00 
