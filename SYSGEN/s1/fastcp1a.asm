;fastcp1a.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"

	*=$c000
 
Lc000
	ldx #$00
	lda LTK_Var_CPUMode
	beq Lc00c
	lda $d7
	beq Lc00c
	dex
Lc00c
	stx $c87c
	lda #$30
	sta $1c30
	sta $1c31
Lc017
	lda #$00
	sta $31
	sta Sc3ff + 1
	lda #$69
	sta $32
	sta Sc3ff + 2
	ldx $1c30
	ldy $1c31
	iny
	cpy #$3a
	bne Lc033
	inx
	ldy #$30
Lc033
	stx $1c30
	sty $1c31
	stx Lc8b8
	sty Lc8b9
	ldx #$03
	ldy #$00
	lda #$ff
Lc045
	sta ($31),y
	iny
	bne Lc045
	inc $32
	dex
	bne Lc045
	lda #$b8
	sta $1c48
	lda #$c6
	sta $1c49
	lda #$00
	sta Lc892
	sta Lc893
	tay
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc06a
	lda ($31),y
	cmp #$ff
	beq Lc08b
	tax
	bpl Lc07b
	inc Lc893
	bne Lc07b
	inc Lc892
Lc07b
	lda $31
	clc
	adc #$02
	sta $31
	lda $32
	adc #$00
	sta $32
	jmp Lc06a
	
Lc08b
	jsr $1c98
	ldx #$bd
	ldy #$c8
	jsr LTK_Print 
	lda #$00
	ldx Lc893
	ldy Lc892
	sec
	jsr Sc98b
	ldx #$1f
	ldy #$ca
	jsr LTK_Print 
	ldx #$cd
	ldy #$c8
	jsr LTK_Print 
	ldx #$b8
	ldy #$c8
	jsr LTK_Print 
	ldx #$21
	jsr Sc3af
	cmp #$51
	bne Lc0c2
	jmp Lc2e5
	
Lc0c2
	cmp #$46
	bne Lc11c
	lda $1c9b
	beq Lc0de
Lc0cb
	ldx #$2b
	jsr Sc3af
	ldx #$00
	cmp #$53
	beq Lc0db
	dex
	cmp #$44
	bne Lc0cb
Lc0db
	stx $1c9c
Lc0de
	jsr Sc903
	ldx #$23
	jsr Sc3f0
	cmp #$51
	beq Lc08b
	cmp #$52
	bne Lc0de
Lc0ee
	jsr $1c95
	bit $c87c
	bpl Lc0fe
	jsr Sc454
	ldx #$29
	jsr $6c00
Lc0fe
	jsr $1c6b
	bcc Lc13f
	jsr Sc443
	jsr $1c98
Lc109
	jsr Sc903
	ldx #$22
	jsr Sc3f0
	cmp #$52
	beq Lc0ee
	cmp #$51
	bne Lc109
Lc119
	jmp Lc08b
	
Lc11c
	cmp #$41
	bne Lc119
Lc120
	ldx #$2a
Lc122
	jsr Sc3f0
	cmp #$51
	beq Lc119
	cmp #$52
	bne Lc120
	jsr $1c95
	jsr $1c62
	bcc Lc142
	jsr Sc443
	jsr $1c98
	ldx #$2e
	bne Lc122
Lc13f
	jsr $1c5f
Lc142
	jsr Sc4f1
Lc145
	lda #$00
	sta Lc88d
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc152
	lda $1c4e
	bne Lc15c
	lda $1c4f
	beq Lc16e
Lc15c
	ldy #$00
	lda ($31),y
	bmi Lc165
Lc162
	jmp Lc27c
	
Lc165
	cmp #$ff
	bne Lc171
	lda Lc88d
	bne Lc145
Lc16e
	jmp Lc28a
	
Lc171
	jsr Sc2f2
	stx $33
	sty $34
	ldy #$1f
	lda ($33),y
	tax
	dey
	lda ($33),y
	tay
	lda $95e9
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc18b
	ldy #$0f
Lc18d
	lda LTK_FileHeaderBlock ,y
	bne Lc194
	lda #$a0
Lc194
	sta $1c32,y
	dey
	bpl Lc18d
	lda $91f8
	ldx #$81
	cmp #$0d
	beq Lc1b6
	inx
	cmp #$0b
	beq Lc1b6
	cmp #$0c
	beq Lc1b6
	inx
	cmp #$0b
	bcc Lc1b6
	cmp #$0e
	beq Lc1b6
	inx
Lc1b6
	stx $1c42
	cmp #$0f
	bne Lc1c8
	jsr Lc4a4
	bcs Lc1c8
	lda $91f5
	sta $1c44
Lc1c8
	jsr Lc4ff
	bcs Lc162
	jsr Lc459
	jsr $1c6e
	bcc Lc21f
	cmp #$ff
	bne Lc1dc
	jmp Lc28a
	
Lc1dc
	jsr Sc443
	jsr $1c98
Lc1e2
	ldx #$27
	jsr $6c00
	jsr Sc4cb
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	jsr Sc4de
	jsr Sc43d
	jsr Sc449
	jsr Sc903
	ldx #$26
	jsr Sc3f0
	cmp #$52
	bne Lc20f
	jsr $1c95
	jsr Sc4f1
	jmp Lc1c8
	
Lc20f
	cmp #$51
	bne Lc1e2
Lc213
	jsr $1c95
	jsr $1c65
	jsr $1c98
	jmp Lc2e5
	
Lc21f
	lda $95e7
	beq Lc266
	jsr Sc45c
	jsr Lc4ff
	jsr $1c74
	bcc Lc266
	jsr Sc443
	jsr $1c98
Lc235
	jsr Sc903
	ldx #$25
	jsr $6c00
	jsr Sc4cb
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	jsr Sc4de
	jsr Sc43d
	jsr Sc449
	ldx #$26
	jsr Sc3f0
	cmp #$51
	beq Lc213
	cmp #$52
	bne Lc235
	jsr $1c95
	jsr Sc4f1
	jmp Lc1c8
	
Lc266
	lda #$ff
	sta Lc88d
	ldy #$00
	lda ($31),y
	jsr Sc3ff
	and #$7f
	sta ($31),y
	iny
	lda ($31),y
	jsr Sc3ff
Lc27c
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc287
	inc $32
Lc287
	jmp Lc152
	
Lc28a
	jsr $1c65
	bcc Lc2c7
	jsr Sc443
	jsr $1c98
Lc295
	jsr Sc903
	ldx #$28
	jsr $6c00
	ldx #$26
	jsr Sc3f0
	cmp #$52
	bne Lc2c0
	jsr Sc362
	ldx $1c30
	ldy $1c31
	dey
	cpy #$2f
	bne Lc2b7
	dex
	ldy #$39
Lc2b7
	stx $1c30
	sty $1c31
	jmp Lc017
	
Lc2c0
	cmp #$51
	bne Lc295
	jmp Lc213
	
Lc2c7
	jsr Sc443
	jsr $1c98
	ldx #$2f
	jsr $6c00
	jsr Sc40b
	jsr Sc340
	bcs Lc2dd
	jmp Lc017
	
Lc2dd
	jsr Sc903
	ldx #$24
	jsr Sc3f0
Lc2e5
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	rts
	
Sc2f2
	ldy #$01
	lda ($31),y
	cmp Lc88e
	beq Lc318
	sta Lc88e
	ldy #$00
	clc
	adc $95e8
	tax
	bcc Lc308
	iny
Lc308
	lda $95e9
	clc
	stx $c335
	sty $c337
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lc318
	ldy #$00
	
	lda ($31),y
	and #$7f
	ldy #$8f
	ldx #$05
Lc322
	asl a
	bcc Lc326
	iny
Lc326
	dex
	bne Lc322
	clc
	adc #$e0
	tax
	bcc Lc330
	iny
Lc330
	rts
	
Sc331
	lda $95e9
	ldx #$00
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lc33f
	rts
	
Sc340
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc348
	ldy #$00
	lda ($31),y
	bpl Lc355
	cmp #$ff
	clc
	bne Lc354
	sec
Lc354
	rts
	
Lc355
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc348
	inc $32
	bne Lc348
Sc362
	lda #$00
	sta $31
	lda #$69
	sta $32
Lc36a
	ldy #$00
	lda ($31),y
	bpl Lc394
	cmp #$ff
	beq Lc3ae
	lda #$00
	sta $33
	lda #$a0
	sta $34
Lc37c
	ldy #$00
	lda ($31),y
	and #$7f
	cmp ($33),y
	bne Lc3a1
	iny
	lda ($31),y
	cmp ($33),y
	bne Lc3a1
	dey
	lda ($33),y
	ora #$80
	sta ($33),y
Lc394
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc36a
	inc $32
	bne Lc36a
Lc3a1
	lda $33
	clc
	adc #$02
	sta $33
	bcc Lc37c
	inc $34
	bne Lc37c
Lc3ae
	rts
	
Sc3af
	stx $c3d0
	jsr $6c00
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
Lc3bc
	jsr LTK_KernalCall 
	sta Lc3df,y
	iny
	cpy #$10
	bcs Lc3cc
	cmp #$0d
	bne Lc3bc
	clc
Lc3cc
	php
	tya
	pha
	lda #$00
	ldx #$df
	ldy #$c3
	jsr $6c03
	pla
	tay
	plp
	lda Lc3df
	rts
	
Lc3df			
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
Sc3f0
	jsr $6c00
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc3f8
	jsr LTK_KernalCall 
	tax
	beq Lc3f8
	rts
	
Sc3ff
	sta Sc3ff
	inc Sc3ff + 1
	bne Lc40a
	inc Sc3ff + 2
Lc40a
	rts
	
Sc40b
	lda #$00
	sta $31
	lda #$69
	sta $32
Lc413
	ldy #$00
	lda ($31),y
	bpl Lc42f
	cmp #$ff
	beq Lc43c
	jsr Sc2f2
	stx $33
	sty $34
	ldy #$1a
	lda ($33),y
	and #$7f
	sta ($33),y
	jsr Sc331
Lc42f
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc413
	inc $32
	bne Lc413
Lc43c
	rts
	
Sc43d
	ldx #$52
	ldy #$c4
	bne Lc44d
Sc443
	ldx #$b6
	ldy #$c8
	bne Lc44d
Sc449
	ldx #$50
	ldy #$c4
Lc44d
	jmp LTK_Print 
	
Lc450
	.text "{Return}"
	.byte $00
Lc452
	.text "{$8e}"
	.byte $00
Sc454
	ldx #$2d
	jmp $6c00
	
Lc459
	clc
	bcc Lc45d
Sc45c
	sec
Lc45d
	bit $c87c
	bpl Lc48d
	php
	ldx #$0c
	ldy #$19
	jsr Sc48e
	plp
	bcs Lc473
	ldx #$94
	ldy #$c8
	bne Lc477
Lc473
	ldx #$a5
	ldy #$c8
Lc477
	jsr LTK_Print 
	jsr Sc4cb
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	jsr Sc4de
	jsr Sc43d
	jsr Sc449
Lc48d
	rts
	
Sc48e
	sec
	stx $c49d
	sty $c49f
	ldx #$f0
	ldy #$ff
	jsr LTK_KernalTrapSetup
	ldx #$00
	ldy #$00
	clc
	jmp LTK_KernalCall 
	
Lc4a4
	ldx #$03
	ldy #$0f
Lc4a8
	lda LTK_FileHeaderBlock ,y
	beq Lc4b5
	cmp Lc4c7,x
	bne Lc4b8
	dex
	bmi Lc4bb
Lc4b5
	dey
	bpl Lc4a8
Lc4b8
	clc
	bcc Lc4c6
Lc4bb
	lda #$0e
	sta $91f8
	ldx #$83
	stx $1c42
	sec
Lc4c6
	rts
	
Lc4c7
	.text ".icq"
Sc4cb
	lda LTK_Var_CPUMode
	bne Lc4d7
	lda $d4
	ora #$01
	sta $d4
	rts
	
Lc4d7
	lda $f4
	ora #$01
	sta $f4
	rts
	
Sc4de
	lda LTK_Var_CPUMode
	bne Lc4ea
	lda $d4
	and #$fe
	sta $d4
	rts
	
Lc4ea
	lda $f4
	and #$fe
	sta $f4
	rts
	
Sc4f1
	bit $c87c
	bpl Lc4fe
	jsr Sc454
	ldx #$2c
	jsr $6c00
Lc4fe
	rts
	
Lc4ff
	ldx #$00
	stx Lc881
	stx Lc882
	stx Lc883
	stx Lc88c
	stx Lc884
	stx Lc885
	stx Lc886
	stx Lc88a
	stx Lc88b
	stx Lc890
	stx Lc891
	lda $91f8
	cmp #$0b
	bcs Lc53a
	lda $91f0
	sta Lc882
	lda $91f1
	sta Lc883
	dec Lc88c
	bne Lc5b0
Lc53a
	cmp #$0f
	bne Lc562
	ldx $91f5
	stx Lc886
Lc544
	lda $91f7
	sec
	adc Lc883
	sta Lc883
	lda $91f6
	adc Lc882
	sta Lc882
	bcc Lc55c
	inc Lc881
Lc55c
	dex
	bne Lc544
	jmp Lc5ea
	
Lc562
	ldy #$02
	sty $c580
	dey
	sty $c57a
	dey
	lda $91f1
	ldx $91f0
	bne Lc578
	cmp #$f1
	bcc Lc592
Lc578
	iny
	cpx #$00
	bcc Lc592
	bne Lc585
	cmp #$00
	bcc Lc592
	beq Lc592
Lc585
	inc $c580
	bne Lc58d
	inc $c57a
Lc58d
	inc $c57a
	bne Lc578
Lc592
	iny
	iny
	sty $c5a5
	lda $91f1
	ldy $91f0
	bne Lc5a3
	cmp #$02
	beq Lc5c5
Lc5a3
	sec
	sbc #$00
	sta Lc883
	bcs Lc5ac
	dey
Lc5ac
	tya
	sta Lc882
Lc5b0
	ldy #$09
Lc5b2
	asl Lc883
	rol Lc882
	rol Lc881
	dey
	bne Lc5b2
	lda $91f8
	cmp #$0b
	bcc Lc604
Lc5c5
	ldy $91fc
	lda $91f9
	and #$01
	bne Lc5d5
	cpy #$00
	bne Lc5d5
	lda #$02
Lc5d5
	pha
	tya
	clc
	adc Lc883
	sta Lc883
	pla
	adc Lc882
	sta Lc882
	bcc Lc5ea
	inc Lc881
Lc5ea
	lda $91fb
	sta $64fe
	lda $91fa
	sta $64ff
	ldx $91f8
	cpx #$0b
	beq Lc604
	cpx #$0c
	beq Lc604
	dec Lc88c
Lc604
	lda Lc881
	sta Lc887
	lda Lc882
	sta Lc888
	lda Lc883
	sta Lc889
	lda $91f8
	cmp #$0f
	bne Lc637
	lda Lc889
	sec
	sbc $91f5
	sta Lc889
	lda Lc888
	sbc #$00
	sta Lc888
	lda Lc887
	sbc #$00
	sta Lc887
Lc637
	bit Lc88c
	bmi Lc64f
	lda Lc889
	clc
	adc #$02
	sta Lc889
	bcc Lc64f
	inc Lc888
	bne Lc64f
	inc Lc887
Lc64f
	lda Lc887
	sta Lc987
	lda Lc889
	ldx Lc888
	ldy #$fe
	jsr Sc94d
	cpy #$00
	beq Lc66a
	clc
	adc #$01
	bcc Lc66a
	inx
Lc66a
	sta Lc889
	stx Lc888
	ldx $91f8
	cpx #$0f
	bne Lc6a4
	lda #$00
	sta Lc987
	lda Lc889
	ldx Lc888
	ldy #$78
	jsr Sc94d
	cpy #$00
	beq Lc68e
	clc
	adc #$01
Lc68e
	ldy $95e6
	cpy #$38
	bne Lc698
	clc
	adc #$01
Lc698
	clc
	adc Lc889
	sta Lc889
	bcc Lc6a4
	inc Lc888
Lc6a4
	lda Lc888
	cmp $1c4f
	bcc Lc6b7
	bne Lc6b7
	lda Lc889
	cmp $1c4e
	bne Lc6b7
	clc
Lc6b7
	rts
	
Lc6b8
	lda Lc883
	sec
	sbc Lc886
	tay
	lda Lc882
	sbc Lc885
	tax
	lda Lc881
	sbc Lc884
	bne Lc6e5
	txa
	bne Lc6e5
	tya
	bit Lc88c
	bmi Lc6dd
	clc
	adc #$02
	bcs Lc6e5
Lc6dd
	ldx #$00
	cmp #$fe
	bcc Lc6e9
	beq Lc6e9
Lc6e5
	ldx #$ff
	lda #$fe
Lc6e9
	sta $1c43
	stx Lc88f
	ldx Lc885
	ldy Lc884
	clc
	adc Lc886
	bcc Lc6ff
	inx
	bne Lc6ff
	iny
Lc6ff
	bit Lc88c
	sec
	bmi Lc707
	sbc #$02
Lc707
	sta Lc886
	txa
	sbc #$00
	sta Lc885
	tya
	sbc #$00
	sta Lc884
	ldy Lc890
	ldx Lc891
	bne Lc721
	tya
	beq Lc747
Lc721
	lda $c772
	clc
	adc #$fe
	sta $1c46
	sta $c772
	sta $33
	lda $c773
	adc #$00
	sta $c773
	sta $1c47
	sta $34
	txa
	bne Lc744
	cpy $1c43
	bcc Lc747
Lc744
	jmp Lc7ce
	
Lc747
	tya
	beq Lc757
	pha
	dey
Lc74c
	lda ($33),y
	sta $6500,y
	dey
	cpy #$ff
	bne Lc74c
	pla
Lc757
	ldx #$65
	clc
	adc #$00
	sta $c772
	bcc Lc762
	inx
Lc762
	stx $c773
	lda Lc88b
	ldx Lc88a
	jsr Sc7e9
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$65,$01 
Lc775
	ldx #$00
	ldy #$65
	bit Lc88c
	bmi Lc787
	ldx #$fe
	ldy #$64
	lda #$02
	sta Lc890
Lc787
	inc Lc891
	inc Lc891
	txa
	ldx $91f8
	cpx #$0f
	bne Lc7ba
	ldx Lc88b
	bne Lc7ba
	ldx Lc88a
	bne Lc7ba
	clc
	adc $91f5
	bcc Lc7a6
	iny
Lc7a6
	pha
	lda Lc890
	sec
	sbc $91f5
	sta Lc890
	lda Lc891
	sbc #$00
	sta Lc891
	pla
Lc7ba
	sta $1c46
	sta $c772
	sty $1c47
	sty $c773
	inc Lc88b
	bne Lc7ce
	inc Lc88a
Lc7ce
	lda Lc890
	sec
	sbc $1c43
	sta Lc890
	lda Lc891
	sbc #$00
	sta Lc891
	lda #$ff
	sta Lc88c
	lda Lc88f
	rts
	
Sc7e9
	stx Lc87d
	sta Lc87e
	sta Lc87f
	ldy $91f8
	cpy #$0b
	bcs Lc80c
	lda $9201
	clc
	adc Lc87e
	tax
	lda $9200
	adc Lc87d
	tay
	lda $95e9
	rts
	
Lc80c
	tay
	bne Lc817
	txa
	bne Lc817
	lda #$ff
	sta Lc880
Lc817
	lda #$02
	ldx #$92
	jsr Sc860
	lda $91f0
	bne Lc82a
	lda $91f1
	cmp #$f1
	bcc Lc856
Lc82a
	ldy #$08
Lc82c
	lsr Lc87d
	ror Lc87e
	dey
	bne Lc82c
	lda Lc87e
	cmp Lc880
	beq Lc84d
	sta Lc880
	jsr Sc867
	lda $95e9
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
Lc84d
	lda $c84a
	ldx $c84b
	jsr Sc860
Lc856
	lda Lc87f
	jsr Sc867
	lda $95e9
	rts
	
Sc860
	sta Sc877 + 1
	stx Sc877 + 2
	rts
	
Sc867
	asl a
	tax
	bcc Lc86e
	inc Sc877 + 2
Lc86e
	jsr Sc877
	tay
	jsr Sc877
	tax
	rts
	
Sc877
	lda Sc877,x
	inx
	rts
	
	.byte $00
Lc87d
	.byte $00
Lc87e
	.byte $00
Lc87f
	.byte $00
Lc880
	.byte $ff 
Lc881
	.byte $00
Lc882
	.byte $00
Lc883
	.byte $00
Lc884
	.byte $00
Lc885
	.byte $00
Lc886
	.byte $00
Lc887
	.byte $00
Lc888
	.byte $00
Lc889
	.byte $00
Lc88a
	.byte $00
Lc88b
	.byte $00
Lc88c
	.byte $00
Lc88d
	.byte $00
Lc88e
	.byte $00
Lc88f
	.byte $00
Lc890
	.byte $00
Lc891
	.byte $00
Lc892
	.byte $00
Lc893
	.byte $00
Lc894
	.text "{$8E}copying    {$1b}q{rvs on}{$0E}"
	.byte $00
Lc8a5
	.text "{$8E}verifying  {$1b}q{rvs on}{$0E}"
	.byte $00
Lc8b6
	.text "{clr}"
	.byte $00
Lc8b8
	.byte $00
Lc8b9
	.byte $00
	.text "{return}{return}"
	.byte $00
Lc8bd
	.text "{clr}{$8E}{return}{rvs off}there are {rvs on}"
	.byte $00
Lc8cd
	.text "{rvs off} file(s) to be copied.{return}{return}please insert disk number: {rvs on}"
	.byte $00
Sc903
	lda LTK_BeepOnErrorFlag
	beq Lc942
	ldy #$18
	lda #$00
Lc90c
	sta SID_V1_FreqLo,y
	dey
	bpl Lc90c
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lc91e
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Sc943
	iny
	tya
	cmp #$10
	bne Lc91e
	ldx #$50
	jsr Sc943
	ldy #$10
	sta SID_V1_Control
Lc936
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Sc943
	tya
	bne Lc936
Lc942
	rts
	
Sc943
	dec Lc94c
	bne Sc943
	dex
	bne Sc943
	rts
	
Lc94c
	.byte $00
Sc94d
	sta Lc989
	stx Lc988
	sty Lc98a
	lda #$00
	ldx #$18
Lc95a
	clc
	rol Lc989
	rol Lc988
	rol Lc987
	rol a
	bcs Lc96c
	cmp Lc98a
	bcc Lc97c
Lc96c
	sbc Lc98a
	inc Lc989
	bne Lc97c
	inc Lc988
	bne Lc97c
	inc Lc987
Lc97c
	dex
	bne Lc95a
	tay
	ldx Lc988
	lda Lc989
	rts
	
Lc987
	.byte $00
Lc988
	.byte $00
Lc989
	.byte $00
Lc98a
	.byte $00
Sc98b
	stx Lca1d
	sty Lca1c
	php
	pha
	lda #$30
	ldy #$04
Lc997
	sta Lca1e,y
	dey
	bpl Lc997
	pla
	beq Lc9bb
	lda Lca1d
	jsr Sca07
	sta Lca21
	stx Lca22
	lda Lca1c
	jsr Sca07
	sta Lca1f
	stx Lca20
	jmp Lc9f0
	
Lc9bb
	iny
Lc9bc
	lda Lca1c
	cmp Lca24,y
	bcc Lc9eb
	bne Lc9ce
	lda Lca1d
	cmp Lca29,y
	bcc Lc9eb
Lc9ce
	lda Lca1d
	sbc Lca29,y
	sta Lca1d
	lda Lca1c
	sbc Lca24,y
	sta Lca1c
	lda Lca1e,y
	clc
	adc #$01
	sta Lca1e,y
	bne Lc9bc
Lc9eb
	iny
	cpy #$05
	bne Lc9bc
Lc9f0
	plp
	bcc Lca06
	ldy #$00
Lc9f5
	lda Lca1e,y
	cmp #$30
	bne Lca06
	lda #$20
	sta Lca1e,y
	iny
	cpy #$04
	bne Lc9f5
Lca06
	rts
	
Sca07
	pha
	and #$0f
	jsr Sca13
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
Sca13
	cmp #$0a
	bcc Lca19
	adc #$06
Lca19
	adc #$30
	rts
	
Lca1c
	.byte $ff 
Lca1d
	.byte $ff 
Lca1e
	.byte $00
Lca1f
	.byte $00
Lca20
	.byte $00
Lca21
	.byte $00
Lca22
	.byte $00,$00 
Lca24
	.byte $27,$03,$00,$00,$00 
Lca29
	.byte $10,$e8,$64,$0a,$01

 
