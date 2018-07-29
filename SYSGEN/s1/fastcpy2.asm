;fastcpy2.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"


    *=$c000    
Lc000
	lda $31
	pha
	lda $32
	pha
	lda $33
	pha
	lda $34
	pha
	lda $95e6
	ldx #$90
	ldy #$00
	cmp #$38
	bne Lc01b
	ldx #$28
	ldy #$01
Lc01b
	stx Lc2b5 + 1
	sty Lc2bc + 1
	ldx #$10
	lda LTK_Var_CPUMode
	beq Lc030
	ldx #$13
	lda $d7
	beq Lc030
	ldx #$30
Lc030
	stx Lc3f1 + 1
	bit $95f3
	bmi Lc050
	lda #$03
	ldx LTK_Var_ActiveLU
	jsr Sc91e
	lda #$04
	ldx LTK_Var_Active_User
	jsr Sc91e
	lda #$3e
	ldx LTK_Var_Active_User
	jsr Sc91e
Lc050
	lda LTK_Var_CPUMode
	beq Lc06f
	lda $d7
	beq Lc06f
	ldx #$4f
	stx Lc41d + 1
	ldx #$3e
	stx Lc495 + 1
	lda #$a0
	sta Lc4d9 + 1
	sta Lc508 + 1
	lsr a
	sta Lc545 + 1
Lc06f
	lda #$00
	sta $31
	sta $33
	lda #$a0
	sta $32
	sta $34
	ldx #$03
	lda #$ff
	ldy #$00
	sty Lc7ff
Lc084
	sta ($31),y
	iny
	bne Lc084
	inc $32
	dex
	bne Lc084
Lc08e
	ldx #$37
	jsr $6c00
	ldx #$32
	jsr Sc729
	cmp #$45
	beq Lc0be
	ldx #$00
	cmp #$4d
	beq Lc0c1
	cmp #$41
	bne Lc08e
Lc0a6
	ldx #$33
	jsr Sc729
	ldx #$01
	cmp #$53
	beq Lc0c1
	inx
	cmp #$52
	beq Lc0c1
	ldx #$08
	jsr Sc2ee
	jmp Lc0a6
	
Lc0be
	jmp Lc597
	
Lc0c1
	stx $95e7
Lc0c4
	ldx #$02
	jsr Sc729
	bcs Lc0c4
	ldx #$00
	cmp #$4e
	beq Lc0de
	dex
	cmp #$59
	beq Lc0de
	ldx #$08
	jsr Sc2ee
	jmp Lc0c4
	
Lc0de
	stx $95e8
	ldx #$05
	jsr $6c00
	ldx #$36
	jsr $6c00
Lc0eb
	ldx #$06
	jsr Sc729
	bcs Lc153
	ldx #$00
	cpy #$01
	beq Lc15b
	cpy #$02
	bne Lc12c
	ldx #$ff
	cmp #$50
	beq Lc15b
	ldx #$0b
	cmp #$42
	beq Lc15b
	ldx #$0c
	cmp #$4d
	beq Lc15b
	ldx #$0d
	cmp #$53
	beq Lc15b
	ldx #$0e
	cmp #$55
	beq Lc15b
	ldx #$0f
	cmp #$52
	beq Lc15b
	ldx #$04
	cmp #$4b
	beq Lc15b
	ldx #$05
	cmp #$43
	beq Lc15b
Lc12c
	lda #$43
	ldx #$c9
	ldy #$00
	jsr Sc973
	bcs Lc153
	cpx #$0b
	beq Lc15b
	cpx #$0c
	beq Lc15b
	cpx #$0d
	beq Lc15b
	cpx #$0e
	beq Lc15b
	cpx #$0f
	beq Lc15b
	cpx #$04
	beq Lc15b
	cpx #$05
	beq Lc15b
Lc153
	ldx #$0c
	jsr Sc2ee
	jmp Lc0eb
	
Lc15b
	stx $95e9
Lc15e
	ldx #$07
	jsr Sc729
	lda #$00
	bcs Lc15e
	cpy #$01
	beq Lc16d
	dey
	tya
Lc16d
	sta $95ec
	lda Lc7fc
	sta Lc8d4 + 1
	sta $95eb
	lda Lc7fb
	sta Lc8d4 + 2
	sta $95ea
	ldx #$34
	jsr Sc75f
Lc187
	jsr $1c95
	jsr $1c62
	bcc Lc1a7
Lc18f
	jsr Sc6e9
	jsr $1c98
	ldx #$2e
	jsr Sc75f
	cmp #$51
	bne Lc1a1
	jmp Lc08e
	
Lc1a1
	cmp #$52
	beq Lc187
	bne Lc18f
Lc1a7
	jsr $1c98
	lda $1c4c
	ldx $1c4d
	clc
	adc #$04
	bcc Lc1b6
	inx
Lc1b6
	ldy $95e6
	cpy #$38
	beq Lc1c3
	clc
	adc #$8c
	bcc Lc1c3
	inx
Lc1c3
	sta $31
	sta Lc3b2 + 1
	stx $32
	stx Lc3b4 + 1
	ldx #$00
	ldy #$09
Lc1d1
	lda ($31),y
	cmp Lc954,y
	bne Lc1dd
	dey
	bpl Lc1d1
	bmi Lc1ed
Lc1dd
	inx
	ldy #$09
Lc1e0
	lda ($31),y
	cmp Lc954 + 10,y
	bne Lc1ec
	dey
	bpl Lc1e0
	bmi Lc1ed
Lc1ec
	inx
Lc1ed
	stx $95ed
	cpx #$02
	beq Lc236
	cpx #$01
	beq Lc220
	ldy #$0a
	lda $31
	ldx $32
	jsr Sc973
	stx $95f1
	tay
	bne Lc236
	txa
	jsr LTK_SetLuActive 
	bcs Lc236
	ldy #$0e
	lda $31
	ldx $32
	jsr Sc973
	stx $95f2
	tay
	bne Lc236
	cpx #$10
	bcs Lc236
Lc220
	ldx #$35
	jsr Sc729
	ldx #$00
	cmp #$44
	beq Lc230
	dex
	cmp #$4f
	bne Lc220
Lc230
	stx $95ee
	txa
	bne Lc26b
Lc236
	jsr Sc6e9
	ldx #$03
	jsr Sc2c3
	bcs Lc236
	stx $95f1
	cpx #$ff
	beq Lc236
Lc247
	ldx #$3e
	lda $95ed
	cmp #$01
	bne Lc252
	ldx #$04
Lc252
	jsr Sc2da
	bcs Lc247
	stx $95f2
	cpx #$ff
	bne Lc26b
	lda $95ed
	cmp #$01
	beq Lc26b
	jsr Sc2e8
	jmp Lc247
	
Lc26b
	lda $1c4c
	clc
	adc #$02
	sta $95f0
	lda $1c4d
	adc #$01
	sta $95ef
	lda #$00
	sta Lc7fd
	sta Lc7fe
	lda $95f0
	sta $31
	lda $95ef
	sta $32
Lc28e
	jsr Sc82f
	bcs Lc29f
	lda Lc7fd
	jsr Sc359
	lda Lc7fe
	jsr Sc359
Lc29f
	lda $31
	clc
	adc #$20
	sta $31
	bcc Lc2aa
	inc $32
Lc2aa
	inc Lc7fe
	bne Lc2b2
	inc Lc7fd
Lc2b2
	lda Lc7fe
Lc2b5
	cmp #$00
	bne Lc28e
	lda Lc7fd
Lc2bc
	cmp #$00
	bne Lc28e
	jmp Lc368
	
Sc2c3
	jsr Sc32a
	bcs Lc2d6
	cpx #$ff
	clc
	beq Lc2ed
	txa
	pha
	jsr LTK_SetLuActive 
	pla
	tax
	bcc Lc2ed
Lc2d6
	ldx #$0a
	bne Lc2ea
Sc2da
	jsr Sc32a
	bcs Sc2e8
	cpx #$ff
	clc
	beq Lc2ed
	cpx #$10
	bcc Lc2ed
Sc2e8
	ldx #$0b
Lc2ea
	jsr Sc2ee
Lc2ed
	rts
	
Sc2ee
	php
	stx Lc306 + 1
	jsr Sc705
	txa
	pha
	tya
	pha
	lda #$00
	sta Lc6e1
	lda #$18
	sta Lc6e2
	jsr Sc702
Lc306
	ldx #$00
	jsr $6c00
	jsr Sca94
	lda #$02
	jsr Sc76e
	jsr Sc702
	ldx #$09
	jsr $6c00
	pla
	sta Lc6e1
	pla
	tax
	dex
	stx Lc6e2
	jsr Sc702
	plp
	rts
	
Sc32a
	jsr Sc729
	bcs Lc358
	ldx #$ff
	cpy #$01
	beq Lc357
	cpy #$03
	bne Lc347
	lda Lc943
	cmp #$41
	bne Lc347
	lda Lc944
	cmp #$4c
	beq Lc357
Lc347
	lda #$43
	ldx #$c9
	ldy #$00
	jsr Sc973
	bcs Lc358
	sec
	pha
	pla
	bne Lc358
Lc357
	clc
Lc358
	rts
	
Sc359
	ldy #$00
	sta ($33),y
	dey
	sty Lc7ff
	inc $33
	bne Lc367
	inc $34
Lc367
	rts
	
Lc368
	lda Lc7ff
	bne Lc383
Lc36d
	ldx #$0d
	jsr $6c00
	jsr Sca94
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc37a
	jsr LTK_KernalCall 
	tax
	beq Lc37a
	jmp Lc06f
	
Lc383
	lda #$00
	sta Lc6e5
	lda #$a0
	sta Lc6e4
Lc38d
	lda #$00
	sta Lc6e6
	sta Lc6e3
	lda Lc3b2 + 1
	sta $31
	lda Lc3b4 + 1
	sta $32
	ldy #$14
	lda #$00
	sta ($31),y
	lda Lc6e4
	sta $32
	lda Lc6e5
	sta $31
	jsr Sc719
Lc3b2
	ldx #$00
Lc3b4
	ldy #$00
	jsr LTK_Print 
	ldx #$0e
	jsr $6c00
Lc3be
	ldy Lc6e6
	jsr Sc93d
	cmp #$ff
	beq Lc3d5
	jsr Sc5d5
	beq Lc3d5
	inc Lc6e6
	inc Lc6e6
	bne Lc3be
Lc3d5
	lda #$00
	sta Lc6e6
	lda #$02
	sta Lc6e1
	lda #$05
	sta Lc6e2
Lc3e4
	jsr Sc6ef
	lda #$00
	sta Lc6e7
Lc3ec
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc3f1
	lda #$00
	sta Lc6e8
Lc3f6
	jsr LTK_KernalCall 
	tax
	bne Lc416
	dec Lc6e8
	bne Lc3f6
	bit Lc6e7
	bpl Lc40e
	jsr Sc6ef
	inc Lc6e7
	beq Lc3ec
Lc40e
	jsr Sc6f8
	dec Lc6e7
	bne Lc3ec
Lc416
	cmp #$11
	bne Lc456
	ldx Lc6e6
Lc41d
	cpx #$27
	bcs Lc3f6
	inx
	txa
	asl a
	tay
	jsr Sc93d
	cmp #$ff
	beq Lc3f6
	stx Lc6e6
	jsr Sc6f8
	lda Lc6e6
	cmp #$14
	beq Lc446
	cmp #$28
	beq Lc446
	cmp #$3c
	beq Lc446
	inc Lc6e2
	bne Lc3e4
Lc446
	lda #$14
	clc
	adc Lc6e1
	sta Lc6e1
	lda #$05
	sta Lc6e2
	bne Lc3e4
Lc456
	cmp #$91
	bne Lc48b
	lda Lc6e6
	beq Lc3f6
	jsr Sc6f8
	ldx Lc6e6
	dex
	stx Lc6e6
	cpx #$13
	beq Lc47b
	cpx #$27
	beq Lc47b
	cpx #$3b
	beq Lc47b
	dec Lc6e2
Lc478
	jmp Lc3e4
	
Lc47b
	lda Lc6e1
	sec
	sbc #$14
	sta Lc6e1
	lda #$18
	sta Lc6e2
	bne Lc478
Lc48b
	cmp #$1d
	bne Lc4b6
	jsr Sc6f8
	lda Lc6e1
Lc495
	cmp #$16
	bcs Lc478
	lda Lc6e6
	adc #$14
	tax
	asl a
	tay
	jsr Sc93d
	cmp #$ff
	beq Lc478
	stx Lc6e6
	lda Lc6e1
	clc
	adc #$14
	sta Lc6e1
	bne Lc478
Lc4b6
	cmp #$9d
	bne Lc4d5
	jsr Sc6f8
	lda Lc6e1
	cmp #$02
	beq Lc478
	sec
	sbc #$14
	sta Lc6e1
	lda Lc6e6
	sec
	sbc #$14
	sta Lc6e6
	bne Lc478
Lc4d5
	cmp #$4e
	bne Lc4f2
Lc4d9
	ldy #$50
	jsr Sc93d
	cmp #$ff
	beq Lc53c
	tya
	clc
	adc Lc6e5
	sta Lc6e5
	bcc Lc4ef
	inc Lc6e4
Lc4ef
	jmp Lc38d
	
Lc4f2
	cmp #$50
	bne Lc518
	lda Lc6e4
	cmp #$a0
	bne Lc504
	lda Lc6e5
	cmp #$00
	beq Lc53c
Lc504
	lda Lc6e5
	sec
Lc508
	sbc #$50
	sta Lc6e5
	lda Lc6e4
	sbc #$00
	sta Lc6e4
	jmp Lc38d
	
Lc518
	cmp #$20
	bne Lc53f
	dec Lc6e1
	dec Lc6e1
	asl Lc6e6
	ldy Lc6e6
	jsr Sc93d
	eor #$80
	jsr Sc940
	jsr Sc60f
	inc Lc6e1
	inc Lc6e1
	lsr Lc6e6
Lc53c
	jmp Lc3e4
	
Lc53f
	cmp #$54
	bne Lc55e
	ldy #$00
Lc545
	ldx #$28
Lc547
	jsr Sc93d
	cmp #$ff
	beq Lc558
	eor #$80
	jsr Sc940
	iny
	iny
	dex
	bne Lc547
Lc558
	jmp Lc38d
	
Lc55b
	jmp Lc383
	
Lc55e
	cmp #$43
	bne Lc565
	jmp Lc788
	
Lc565
	cmp #$45
	bne Lc58c
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc571
	ldy #$00
	jsr Sc93d
	cmp #$ff
	beq Lc55b
	eor #$80
	jsr Sc940
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc571
	inc $32
	bne Lc571
Lc58c
	cmp #$13
	beq Lc55b
	cmp #$51
	bne Lc53c
	jmp Lc06f
	
Lc597
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	rts
	
Sc5a4
	ldy Lc6e6
	jsr Sc93d
	and #$01
	sta Lc7fd
	iny
	jsr Sc93d
	sta Lc7fe
	ldx #$05
Lc5b8
	asl Lc7fe
	rol Lc7fd
	dex
	bne Lc5b8
	lda $95f0
	clc
	adc Lc7fe
	tax
	lda $95ef
	adc Lc7fd
	tay
	stx $33
	sty $34
	rts
	
Sc5d5
	jsr Sc60f
	inc Lc6e2
	inc Lc6e3
	lda #$14
	cmp Lc6e3
	beq Lc606
	lda #$28
	ldx LTK_Var_CPUMode
	beq Lc5f0
	ldx $d7
	bne Lc5f4
Lc5f0
	cmp Lc6e3
	rts
	
Lc5f4
	cmp Lc6e3
	beq Lc606
	lda #$3c
	cmp Lc6e3
	beq Lc606
	lda #$50
	cmp Lc6e3
	rts
	
Lc606
	sta Lc6e1
	lda #$05
	sta Lc6e2
	rts
	
Sc60f
	jsr Sc702
	jsr Sc5a4
	ldy #$00
	lda ($33),y
	ldx #$53
	cmp #$81
	beq Lc665
	ldx #$50
	cmp #$82
	bne Lc641
	ldy $95ed
	dey
	bne Lc665
	ldy #$17
	lda ($33),y
	beq Lc665
	ldx #$42
	cmp #$0b
	beq Lc665
	ldx #$4d
	cmp #$0c
	beq Lc665
	ldx #$50
	bne Lc665
Lc641
	ldx #$55
	cmp #$83
	bne Lc663
	ldy $95ed
	dey
	bne Lc665
	ldy #$17
	lda ($33),y
	beq Lc665
	ldx #$4b
	cmp #$04
	beq Lc665
	ldx #$43
	cmp #$05
	beq Lc665
	ldx #$55
	bne Lc665
Lc663
	ldx #$52
Lc665
	stx Lc6b4 + 2
	ldy #$16
	lda ($33),y
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #$30
	cmp #$3a
	bcc Lc679
	adc #$06
Lc679
	sta Lc6b4 + 3
	ldy Lc6e6
	ldx #$12
	jsr Sc93d
	bmi Lc688
	ldx #$92
Lc688
	stx Lc6b4 + 1
	ldx #$b4
	ldy #$c6
	jsr LTK_Print 
	jsr Sc6bb
	ldy #$13
	lda ($33),y
	pha
	lda #$00
	sta ($33),y
	ldy $34
	lda $33
	clc
	adc #$03
	bcc Lc6a8
	iny
Lc6a8
	tax
	jsr LTK_Print 
	ldy #$13
	pla
	sta ($33),y
	jmp Lc6ce
	
Lc6b4
	.text "{$0e}vtu{rvs off} "
	.byte $00
Sc6bb
	lda LTK_Var_CPUMode
	bne Lc6c7
	lda $d4
	ora #$01
	sta $d4
	rts
	
Lc6c7
	lda $f4
	ora #$01
	sta $f4
	rts
	
Lc6ce
	lda LTK_Var_CPUMode
	bne Lc6da
	lda $d4
	and #$fe
	sta $d4
	rts
	
Lc6da
	lda $f4
	and #$fe
	sta $f4
	rts
	
Lc6e1
	.byte $00
Lc6e2
	.byte $02 
Lc6e3
	.byte $00
Lc6e4
	.byte $00
Lc6e5
	.byte $00
Lc6e6
	.byte $00
Lc6e7
	.byte $00
Lc6e8
	.byte $00
Sc6e9
	ldx #$6c
	ldy #$c9
	bne Lc6ff
Sc6ef
	jsr Sc702
	ldx #$6a
	ldy #$c9
	bne Lc6ff
Sc6f8
	jsr Sc702
	ldx #$68
	ldy #$c9
Lc6ff
	jmp LTK_Print 
	
Sc702
	clc
	bcc Lc706
Sc705
	sec
Lc706
	php
	sec
	ldx #$f0
	ldy #$ff
	jsr LTK_KernalTrapSetup
	plp
	ldx Lc6e2
	ldy Lc6e1
	jmp LTK_KernalCall 
	
Sc719
	ldx #$31
	jsr $6c00
	lda #$00
	sta Lc6e1
	lda #$05
	sta Lc6e2
	rts
	
Sc729
	stx Lc749 + 1
	jsr $6c00
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
Lc736
	jsr LTK_KernalCall 
	sta Lc943,y
	iny
	cpy #$10
	bcs Lc746
	cmp #$0d
	bne Lc736
	clc
Lc746
	php
	tya
	pha
Lc749
	lda #$00
Lc74b
	ldx #$43
Lc74d
	ldy #$c9
	jsr $6c03
	stx Lc7fc
	sty Lc7fb
	pla
	tay
	plp
	lda Lc943
	rts
	
Sc75f
	jsr $6c00
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc767
	jsr LTK_KernalCall 
	tax
	beq Lc767
	rts
	
Sc76e
	sta Lc787
Lc771
	lda #$00
	tax
	ldy #$02
Lc776
	sec
	adc #$00
	bne Lc776
	inx
	bne Lc776
	dey
	bne Lc776
	dec Lc787
	bne Lc771
	rts
	
Lc787
	.byte $00
Lc788
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc790
	ldy #$00
	lda ($31),y
	bpl Lc79d
	cmp #$ff
	bne Lc7aa
	jmp Lc36d
	
Lc79d
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc790
	inc $32
	bne Lc790
Lc7aa
	ldx #$3d
	jsr $6c00
	lda #$00
	sta Lc6e6
	tay
	ldx $95f1
	jsr Sc938
	ldx #$87
	ldy #$ca
	lda $95ed
	cmp #$01
	bne Lc7cf
	bit $95ee
	bpl Lc7cf
	ldx #$6e
	ldy #$c9
Lc7cf
	jsr LTK_Print 
	lda $95f2
	jsr Sc800
	ldx #$15
	jsr $6c00
	ldx #$16
	jsr $6c00
Lc7e2
	ldx #$11
	jsr Sc729
	bcs Lc7e2
	cmp #$59
	beq Lc7f4
	cmp #$4e
	bne Lc7e2
	jmp Lc383
	
Lc7f4
	ldx #$20
	ldy #$02
	jmp $95e3
	
Lc7fb
	.byte $00
Lc7fc
	.byte $00
Lc7fd
	.byte $00
Lc7fe
	.byte $00
Lc7ff
	.byte $00
Sc800
	pha
	ldx #$10
	jsr $6c00
	lda $95ed
	cmp #$01
	bne Lc819
	bit $95ee
	bpl Lc819
	pla
	ldx #$6e
	ldy #$c9
	bne Lc829
Lc819
	ldx #$12
	pla
	bmi Lc82c
	tax
	lda #$00
	tay
	jsr Sc938
	ldx #$87
	ldy #$ca
Lc829
	jmp LTK_Print 
	
Lc82c
	jmp $6c00
	
Sc82f
	ldy #$00
	jsr Sc93d
	cmp #$81
	bcc Lc8a4
	cmp #$85
	bcs Lc8a4
	ldx $95e9
	beq Lc8a6
	inx
	bne Lc84a
	cmp #$82
	beq Lc8a6
	bne Lc8a4
Lc84a
	ldx $95e9
	cpx #$0d
	bne Lc857
	cmp #$81
	beq Lc8a6
	bne Lc8a4
Lc857
	cpx #$0f
	bne Lc861
	cmp #$84
	beq Lc8a6
	bne Lc8a4
Lc861
	ldy $95ed
	dey
	beq Lc873
	cpx #$0e
	bcc Lc8a4
	bne Lc8a4
	cmp #$83
	beq Lc8a6
	bne Lc8a4
Lc873
	tax
	ldy #$17
	jsr Sc93d
	ldy $95e9
	cpy #$04
	beq Lc888
	cpy #$05
	beq Lc888
	cpy #$0e
	bne Lc893
Lc888
	cmp $95e9
	bne Lc8a4
	cpx #$83
	beq Lc8a6
	bne Lc8a4
Lc893
	cpy #$0b
	beq Lc89b
	cpy #$0c
	bne Lc8a4
Lc89b
	cmp $95e9
	bne Lc8a4
	cpx #$82
	beq Lc8a6
Lc8a4
	sec
	rts
	
Lc8a6
	ldy #$12
Lc8a8
	lda ($31),y
	cmp #$a0
	bne Lc8b7
	lda #$00
	sta ($31),y
	dey
	cpy #$02
	bne Lc8a8
Lc8b7
	lda #$00
	sta Lc91d
	sta Lc91b
	sta Lc91c
	tax
	ldy #$03
	lda $95ec
	bne Lc8cc
Lc8ca
	clc
	rts
	
Lc8cc
	jsr Sc93d
	sta Lc91a
	beq Lc8a4
Lc8d4
	lda Lc8d4,x
	cmp #$3f
	beq Lc90d
	cmp #$2a
	bne Lc8e4
	sta Lc91d
	beq Lc90d
Lc8e4
	cmp Lc91a
	beq Lc8fd
	lda Lc91d
	bne Lc913
	ldy Lc91c
	ldx Lc91b
	beq Lc8a4
	lda #$2a
	sta Lc91d
	bne Lc913
Lc8fd
	lda Lc91d
	beq Lc90d
	stx Lc91b
	sty Lc91c
	lda #$00
	sta Lc91d
Lc90d
	inx
	cpx $95ec
	bcs Lc8ca
Lc913
	iny
	cpy #$13
	bne Lc8cc
	beq Lc8a4
Lc91a
	.byte $00
	
Lc91b
	.byte $00
Lc91c
	.byte $00
Lc91d
	.byte $00
Sc91e
	pha
	lda #$00
	tay
	jsr Sc938
	ldx #$87
	ldy #$ca
	lda Lca87
	cmp #$30
	bne Lc934
	inx
	bne Lc934
	iny
Lc934
	pla
	jmp $6c03
	
Sc938
	clc
	jsr Sc9f1
	rts
	
Sc93d
	lda ($31),y
	rts
	
Sc940
	sta ($31),y
	rts
	
Lc943
	.byte $00
Lc944
	.byte $00
Lc945
	.byte $00
Lc946
	.byte $00
Lc947
	.byte $00
Lc948
	.byte $00
Lc949
	.byte $00
Lc94a
	.byte $00
Lc94b
	.byte $00
Lc94c
	.byte $00
Lc94d
	.byte $00
Lc94e
	.byte $00
Lc94f
	.byte $00
Lc950
	.byte $00
Lc951
	.byte $00
Lc952
	.byte $00
Lc953
	.byte $00
Lc954
	.text "ltkbackup fastcopy{$a0}{$a0} "
	.byte $00
Lc96a
	.text ">"
	.byte $00
Lc96c
	.text "{Clr}"
	.byte $00
Lc96e
	.text "org."
	.byte $00
Sc973
	sta Lc984 + 1
	stx Lc984 + 2
	lda #$00
	sta Lc9ee
	sta Lc9ef
	sta Lc9f0
Lc984
	lda Lc984,y
	cmp #$30
	bcc Lc9dc
	cmp #$3a
	bcc Lc9a1
	ldx Lc9ac + 1
	cpx #$0a
	beq Lc9dc
	cmp #$41
	bcc Lc9dc
	cmp #$47
	bcs Lc9dc
	sec
	sbc #$07
Lc9a1
	ldx Lc9ee
	beq Lc9c5
	pha
	tya
	pha
	lda #$00
	tax
Lc9ac
	ldy #$0a
Lc9ae
	clc
	adc Lc9f0
	pha
	txa
	adc Lc9ef
	tax
	pla
	dey
	bne Lc9ae
	sta Lc9f0
	stx Lc9ef
	pla
	tay
	pla
Lc9c5
	inc Lc9ee
	sec
	sbc #$30
	clc
	adc Lc9f0
	sta Lc9f0
	bcc Lc9d9
	inc Lc9ef
	beq Lc9e6
Lc9d9
	iny
	bne Lc984
Lc9dc
	cmp #$20
	beq Lc9d9
	clc
	ldx Lc9ee
	bne Lc9e7
Lc9e6
	sec
Lc9e7
	lda Lc9ef
	ldx Lc9f0
	rts
	
Lc9ee
	.byte $00
Lc9ef
	.byte $00
Lc9f0
	.byte $00
Sc9f1
	stx Lca83
	sty Lca82
	php
	pha
	lda #$30
	ldy #$04
Lc9fd
	sta Lca84,y
	dey
	bpl Lc9fd
	pla
	beq Lca21
	lda Lca83
	jsr Sca6d
	sta Lca87
	stx Lca88
	lda Lca82
	jsr Sca6d
	sta Lca85
	stx Lca86
	jmp Lca56
	
Lca21
	iny
Lca22
	lda Lca82
	cmp Lca8a,y
	bcc Lca51
	bne Lca34
	lda Lca83
	cmp Lca8f,y
	bcc Lca51
Lca34
	lda Lca83
	sbc Lca8f,y
	sta Lca83
	lda Lca82
	sbc Lca8a,y
	sta Lca82
	lda Lca84,y
	clc
	adc #$01
	sta Lca84,y
	bne Lca22
Lca51
	iny
	cpy #$05
	bne Lca22
Lca56
	plp
	bcc Lca6c
	ldy #$00
Lca5b
	lda Lca84,y
	cmp #$30
	bne Lca6c
	lda #$20
	sta Lca84,y
	iny
	cpy #$04
	bne Lca5b
Lca6c
	rts
	
Sca6d
	pha
	and #$0f
	jsr Sca79
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
Sca79
	cmp #$0a
	bcc Lca7f
	adc #$06
Lca7f
	adc #$30
	rts
	
Lca82
	.byte $ff 
Lca83
	.byte $ff 
Lca84
	.byte $00
Lca85
	.byte $00
Lca86
	.byte $00
Lca87
	.byte $00
Lca88
	.byte $00,$00 
Lca8a
	.byte $27,$03,$00,$00,$00 
Lca8f
	.byte $10,$e8,$64,$0a,$01 
Sca94
	lda LTK_BeepOnErrorFlag
	beq Lcad3
	ldy #$18
	lda #$00
Lca9d
	sta SID_V1_FreqLo,y
	dey
	bpl Lca9d
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lcaaf
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scad4
	iny
	tya
	cmp #$10
	bne Lcaaf
	ldx #$50
	jsr Scad4
	ldy #$10
	sta SID_V1_Control
Lcac7
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scad4
	tya
	bne Lcac7
Lcad3
	rts
	
Scad4
	dec Lcadd
	bne Scad4
	dex
	bne Scad4
	rts
	
Lcadd
	.byte $00

