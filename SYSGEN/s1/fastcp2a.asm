;fastcp2a.r.prg

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
	stx Lc789
	lda #$29
	sta $1c4a
	lda #$c7
	sta $1c4b
	lda #$57
	sta $1c48
	lda #$c9
	sta $1c49
Lc023
	jsr $1c95
	jsr Sc4ab
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc031
	ldy #$00
	lda ($31),y
	bmi Lc03a
	jmp Lc2be
	
Lc03a
	cmp #$ff
	bne Lc041
	jmp Lc31d
	
Lc041
	jsr Sc39b
	jsr LTK_ClearHeaderBlock 
	ldx #$00
	ldy #$03
Lc04b
	lda ($33),y
	cmp #$a0
	beq Lc05a
	sta LTK_FileHeaderBlock ,x
	iny
	inx
	cpx #$10
	bne Lc04b
Lc05a
	ldy #$00
	sty $1c42
	lda ($33),y
	sta Lc784
	pha
	ldx #$00
	cmp #$82
	beq Lc06c
	dex
Lc06c
	stx Lcb42
	iny
	lda ($33),y
	sta $1c51
	iny
	lda ($33),y
	sta $1c52
	pla
	cmp #$84
	bne Lc08a
	ldy #$15
	lda ($33),y
	sta $91f5
	sta $1c44
Lc08a
	jsr Sc4fc
	bit Lc789
	bpl Lc095
	jsr Sc43a
Lc095
	jsr $1c71
	bcc Lc0d8
	jsr Sc36b
	jsr Sc41f
	jsr $1c98
Lc0a3
	ldx #$39
	jsr $6c00
	jsr Sc485
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	jsr Sc498
	jsr Sc419
	jsr Sc425
	jsr Scbcd
	ldx #$3a
	jsr Sc40a
	cmp #$51
	bne Lc0ca
	jmp Lc254
	
Lc0ca
	cmp #$52
	bne Lc0d1
	jmp Lc264
	
Lc0d1
	cmp #$53
	bne Lc0a3
	jmp Lc274
	
Lc0d8
	lda $1c46
	clc
	adc $1c43
	pha
	lda $1c47
	adc #$00
	tax
	pla
	sta $33
	stx $34
	cpx #$65
	bcc Lc117
	bne Lc0f7
	cmp #$00
	bcc Lc117
	beq Lc117
Lc0f7
	cpx #$67
	bcc Lc103
	jsr Sc91d
	brk
	
Lc0ff
	bcc Lc103
        bne Lc11a
Lc103
	sec
	sbc #$00
	sta $91fc
	txa
	sbc #$65
	and #$01
	sta $91f9
	jsr Sc353
	jsr Sc78d
Lc117
	jmp Lc13b
	
Lc11a
	sec
	sbc #$00
	sta $91fc
	txa
	sbc #$67
	and #$01
	sta $91f9
	jsr Sc353
	jsr Sc78d
	lda #$00
	sta $c7df
	lda #$67
	sta $c7e0
	jsr Sc78d
Lc13b
	ldx Lc784
	cpx #$82
	beq Lc157
	lda #$0d
	cpx #$81
	beq Lc17e
	lda #$0e
	cpx #$83
	beq Lc17e
	lda #$0f
	cpx #$84
	beq Lc17e
Lc154
	jmp Lc154
	
Lc157
	lda $64fe
	sta $91fb
	lda $64ff
	sta $91fa
	ldx $2b
	ldy $2c
	bit LTK_Var_CPUMode
	bpl Lc170
	ldx $2d
	ldy $2e
Lc170
	lda #$0c
	cpx $91fb
	bne Lc17e
	cpy $91fa
	bne Lc17e
	lda #$0b
Lc17e
	bit Lc78c
	bmi Lc189
	ldx $95ed
	dex
	beq Lc18c
Lc189
	sta $91f8
Lc18c
	jsr Sc36b
	jsr LTK_FindFile 
	sta Lcb46
	stx Lcb48
	sty Lcb47
	bcs Lc215
	ldx $95e7
	beq Lc1a7
	dex
	beq Lc203
	bne Lc1d7
Lc1a7
	jsr Sc41f
	jsr $1c98
Lc1ad
	ldx #$2e
	ldy #$c4
	jsr LTK_Print 
	lda #$00
	sta $91f0
	jsr Sc485
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	jsr Sc498
	jsr Sc419
	jsr Scbcd
	ldx #$3b
	jsr Sc3c9
	bcs Lc1ad
	cmp #$52
	bne Lc1f9
Lc1d7
	ldx $9201
	ldy $9200
	jsr Sc37c
	lda LTK_Var_ActiveLU
	ldx Lcb4a
	ldy Lcb49
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc1f0
	jsr $1c95
	jsr Sc4ab
	jmp Lc215
	
Lc1f9
	cmp #$53
	beq Lc203
	cmp #$51
	bne Lc1ad
	beq Lc254
Lc203
	ldx Lcb4a
	ldy Lcb49
	jsr Sc37c
	jsr $1c95
	jsr Sc4ab
	jmp Lc2b3
	
Lc215
	lda $95e8
	beq Lc286
	bit Lc789
	bpl Lc222
	jsr Sc43d
Lc222
	jsr Sc7eb
	jsr $1c74
	bcc Lc286
	jsr Sc41f
	jsr $1c98
Lc230
	ldx #$25
	jsr $6c00
	jsr Sc485
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	jsr Sc498
	jsr Sc419
	jsr Sc425
	jsr Scbcd
	ldx #$3a
	jsr Sc40a
	cmp #$51
	bne Lc260
Lc254
	ldx Lcb4a
	ldy Lcb49
	jsr Sc37c
	jmp Lc336
	
Lc260
	cmp #$52
	bne Lc270
Lc264
	ldx Lcb4a
	ldy Lcb49
	jsr Sc37c
	jmp Lc023
	
Lc270
	cmp #$53
	bne Lc230
Lc274
	ldx Lcb4a
	ldy Lcb49
	jsr Sc37c
	jsr $1c95
	jsr Sc4ab
	jmp Lc2b3
	
Lc286
	jsr Sc2cc
	lda Lcb46
	pha
	ldx Lcb48
	ldy Lcb47
	lda #$24
	jsr LTK_ExeExtMiniSub 
	jsr Sc36b
	lda $91f8
	cmp #$04
	bne Lc2b3
	lda Lcb4b
	sta $9000
	lda Lcb4c
	sta $9001
	lda #$1f
	jsr LTK_ExeExtMiniSub 
Lc2b3
	ldy #$00
	lda ($31),y
	and #$7f
	sta ($31),y
	iny
	lda ($31),y
Lc2be
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc2c9
	inc $32
Lc2c9
	jmp Lc031
	
Sc2cc
	lda $91f8
	cmp #$0e
	bne Lc318
	ldx #$03
	ldy #$0f
Lc2d7
	lda LTK_FileHeaderBlock ,y
	beq Lc2e4
	cmp Lc319,x
	bne Lc2e7
	dex
	bmi Lc2ea
Lc2e4
	dey
	bpl Lc2d7
Lc2e7
	clc
	bcc Lc318
Lc2ea
	lda #$0f
	sta $91f8
	lda $91f1
	ldx $91f0
	sec
	sbc #$01
	bcs Lc2fb
	dex
Lc2fb
	sta $91f7
	stx $91f6
	lda #$02
	sta $91f4
	ldx #$00
	stx $91f5
	stx $91f9
	stx $91fc
	stx $91f2
	inx
	stx $91f3
Lc318
	rts
	
Lc319
	.text ".icq"
Lc31d
	jsr Sc41f
	jsr $1c98
	jsr Scbcd
	ldx #$3c
	jsr Sc3c9
	bcs Lc31d
	cmp #$4e
	beq Lc335
	cmp #$59
	bne Lc31d
Lc335
	tax
Lc336
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	cpx #$59
	bne Lc352
	lda #$ff
	sta $95f3
	ldx #$18
	ldy #$02
	jmp $95e3
	
Lc352
	rts
	
Sc353
	lda #$00
	tay
	sta ($33),y
	inc $33
	bne Lc35e
	inc $34
Lc35e
	lda $33
	ldx $34
	cmp #$00
	bne Sc353
	cpx #$69
	bne Sc353
	rts
	
Sc36b
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc37b
	rts
	
Sc37c
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc386
	lda $91f8
	cmp #$0a
	bcs Lc395
	jsr LTK_DeallocContigBlks 
	bcc Lc39a
Lc392
	jsr LTK_FatalError 
Lc395
	jsr LTK_DeallocateRndmBlks 
	bcs Lc392
Lc39a
	rts
	
Sc39b
	ldy #$00
	lda ($31),y
	and #$01
	sta Lc78a
	iny
	lda ($31),y
	sta Lc78b
	ldx #$05
Lc3ac
	asl Lc78b
	rol Lc78a
	dex
	bne Lc3ac
	lda $95f0
	clc
	adc Lc78b
	tax
	lda $95ef
	adc Lc78a
	tay
	stx $33
	sty $34
	rts
	
Sc3c9
	stx Lc3e9 + 1
	jsr $6c00
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
Lc3d6
	jsr LTK_KernalCall 
	sta Lc3f9,y
	iny
	cpy #$10
	bcs Lc3e6
	cmp #$0d
	bne Lc3d6
	clc
Lc3e6
	php
	tya
	pha
Lc3e9
	lda #$00
	ldx #$f9
	ldy #$c3
	jsr $6c03
	pla
	tay
	plp
	lda Lc3f9
	rts
	
Lc3f9		  
	.byte $00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
Sc40a
	jsr $6c00
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc412
	jsr LTK_KernalCall 
	tax
	beq Lc412
	rts
	
Sc419
	ldx #$33
	ldy #$c4
	bne Lc429
Sc41f
	ldx #$fa
	ldy #$c4
	bne Lc429
Sc425
	ldx #$2c
	ldy #$c4
Lc429
	jmp LTK_Print 
	
Lc42c
	.text "{Return}"
	.byte $00
Lc42e
	.text "{Clr}{Return}{Return}{Rvs On}"
	.byte $00
Lc433
	.text "{Uppercase}"
	.byte $00
Sc435
	ldx #$2d
	jmp $6c00
	
Sc43a
	clc
	bcc Lc43e
Sc43d
	sec
Lc43e
	bit Lc789
	bpl Lc46e
	php
	ldx #$0c
	ldy #$19
	jsr Sc46f
	plp
	bcs Lc454
	ldx #$d8
	ldy #$c4
	bne Lc458
Lc454
	ldx #$e9
	ldy #$c4
Lc458
	jsr LTK_Print 
	jsr Sc485
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	jsr Sc498
	jsr Sc419
	jsr Sc425
Lc46e
	rts
	
Sc46f
	sec
	stx Lc47d + 1
	sty Lc47f + 1
	ldx #$f0
	ldy #$ff
	jsr LTK_KernalTrapSetup
Lc47d
	ldx #$00
Lc47f
	ldy #$00
	clc
	jmp LTK_KernalCall 
	
Sc485
	lda LTK_Var_CPUMode
	bne Lc491
	lda $d4
	ora #$01
	sta $d4
	rts
	
Lc491
	lda $f4
	ora #$01
	sta $f4
	rts
	
Sc498
	lda LTK_Var_CPUMode
	bne Lc4a4
	lda $d4
	and #$fe
	sta $d4
	rts
	
Lc4a4
	lda $f4
	and #$fe
	sta $f4
	rts
	
Sc4ab
	bit Lc789
	bpl Lc4b8
	jsr Sc435
	ldx #$2c
	jsr $6c00
Lc4b8
	rts
	
Sc4b9
	jsr Sc41f
	jsr $1c98
	ldx #$3f
	jsr $6c00
	jsr Sc485
	lda $33
	ldy $34
	clc
	adc #$03
	bcc Lc4d1
	iny
Lc4d1
	tax
	jsr LTK_Print 
	jmp Sc498
	
Lc4d8
	.text "{uppercase}copying    {$1b}q{rvs on}{lowercase}"
	.byte $00
Lc4e9
	.text "{uppercase}verifying  {$1b}q{rvs on}{lowercase}"
	.byte $00
Lc4fa
	.text "{Clr}"
	.byte $00
Sc4fc
	lda #$00
	sta Lcb3c
	sta Lcb3d
	sta Lcb3e
	sta Lcb3f
	sta Lcb40
	sta Lcb41
	sta Lc786
	sta Lc787
	sta Lc788
	sta Lc78c
	sta Lcb4d
	sta Lcb4e
	ldx $95f1
	ldy $95f2
	lda $95ed
	beq Lc554
	cmp #$02
	beq Lc554
	ldy #$17
	lda ($33),y
	sta $91f8
	beq Lc54f
	cmp #$04
	beq Lc542
	cmp #$05
	bne Lc547
Lc542
	dec Lcb4d
	bne Lc557
Lc547
	cmp #$0b
	bcc Lc54f
	cmp #$10
	bcc Lc557
Lc54f
	dec Lc78c
	bne Lc557
Lc554
	jmp Lc5db
	
Lc557
	ldy #$16
	lda ($33),y
	pha
	lsr a
	lsr a
	lsr a
	lsr a
	sta LTK_Var_Active_User
	pla
	and #$0f
	bit $95ee
	bmi Lc57c
	lda $95f2
	bmi Lc573
	sta LTK_Var_Active_User
Lc573
	lda $95f1
	sta LTK_Var_ActiveLU
	jmp Lc5e1
	
Lc57c
	jsr LTK_SetLuActive 
	bcc Lc5e1
Lc581
	jsr Sc4b9
	ldx #$40
	jsr Sc3c9
	cmp #$51
	bne Lc592
	pla
	pla
	jmp Lc336
	
Lc592
	cmp #$53
	bne Lc59e
	pla
	pla
	jsr $1c95
	jmp Lc2be
	
Lc59e
	cmp #$4e
	bne Lc581
Lc5a2
	ldx #$03
	jsr Sc3c9
	lda #$f9
	ldx #$c3
	ldy #$00
	jsr Scb4f
	bcs Lc5a2
	tay
	bne Lc5a2
	txa
	jsr LTK_SetLuActive 
	bcs Lc5a2
Lc5bb
	ldx #$3e
	jsr Sc3c9
	lda #$f9
	ldx #$c3
	ldy #$00
	jsr Scb4f
	bcs Lc5bb
	tay
	bne Lc5bb
	cpx #$10
	bcs Lc5bb
	stx LTK_Var_Active_User
	jsr $1c95
	jmp Lc5e1
	
Lc5db
	stx LTK_Var_ActiveLU
	sty LTK_Var_Active_User
Lc5e1
	ldy #$1d
	lda ($33),y
	tax
	dey
	lda ($33),y
	bit Lcb4d
	bmi Lc62b
	cpx #$00
	bne Lc5fd
	cmp #$03
	lda #$00
	bcs Lc5fb
	jmp Lc699
	
Lc5fb
	lda ($33),y
Lc5fd
	ldy Lc784
	cpy #$84
	bne Lc625
	ldy #$00
	sty Lcc51
	ldy #$78
	jsr Scc17
	tax
	tya
	beq Lc613
	inx
Lc613
	stx Lc785
	ldy #$1d
	lda ($33),y
	tax
	dey
	lda ($33),y
	sec
	sbc Lc785
	bcs Lc625
	dex
Lc625
	sec
	sbc #$01
	bcs Lc62b
	dex
Lc62b
	stx Lcb3d
	sta Lcb3e
	ldy #$fe
	lda #$00
	tax
Lc636
	clc
	adc Lcb3e
	pha
	txa
	adc Lcb3d
	bcc Lc644
	inc Lcb3c
Lc644
	tax
	pla
	dey
	bne Lc636
	sta Lcb3e
	stx Lcb3d
	bit Lcb4d
	bmi Lc657
	pha
	txa
	pha
Lc657
	ldy #$09
Lc659
	lsr Lcb3c
	ror Lcb3d
	ror Lcb3e
	dey
	bne Lc659
	bit Lcb4d
	bpl Lc67f
	lda Lcb3d
	sta $91f0
	lda Lcb3e
	sta $91f1
	jsr LTK_AllocContigBlks 
	bcc Lc6cb
	lda #$41
	bne Lc6b7
Lc67f
	pla
	tax
	pla
	tay
	txa
	and #$01
	bne Lc68b
	tya
	beq Lc693
Lc68b
	inc Lcb3e
	bne Lc693
	inc Lcb3d
Lc693
	lda Lcb3e
	ldx Lcb3d
Lc699
	sta Lcb3e
	stx Lcb3d
	ldy #$00
	sty Lcb3c
	clc
	adc #$01
	sta $91f1
	txa
	adc #$00
	sta $91f0
	jsr LTK_AllocateRandomBlks 
	bcc Lc6cb
	lda #$38
Lc6b7
	pha
	jsr Sc41f
	jsr $1c98
	jsr Scbcd
	pla
	tax
	jsr Sc40a
	pla
	pla
	jmp Lc336
	
Lc6cb
	lda #$00
	ldx #$65
	sta $c7df
	stx $c7e0
	bit Lcb42
	bmi Lc6de
	lda #$fe
	ldx #$64
Lc6de
	ldy Lc784
	cpy #$84
	bne Lc6ec
	clc
	adc $91f5
	bcc Lc6ec
	inx
Lc6ec
	sta Lc782
	stx Lc783
	cpy #$84
	bne Lc71c
	ldy #$09
Lc6f8
	asl Lcb3e
	rol Lcb3d
	rol Lcb3c
	dey
	bne Lc6f8
	lda Lcb3c
	sta Lcc51
	lda Lcb3e
	ldx Lcb3d
	ldy $91f5
	jsr Scc17
	sta $91f7
	stx $91f6
Lc71c
	lda $9200
	sta Lcb49
	lda $9201
	sta Lcb4a
	rts
	
Lc729
	lda Lc782
	ldx Lc783
	cpx #$67
	bcc Lc75b
	bne Lc739
	cmp #$00
	bcc Lc75b
Lc739
	jsr Sc78d
	lda Lc782
	sec
	sbc #$00
	beq Lc753
	tay
	dey
	tax
Lc747
	lda $6700,y
	sta $6500,y
	dey
	cpy #$ff
	bne Lc747
	txa
Lc753
	ldx #$65
	clc
	adc #$00
	bcc Lc75b
	inx
Lc75b
	sta $1c46
	stx $1c47
	clc
	adc #$fe
	sta Lc782
	txa
	adc #$00
	sta Lc783
	lda Lc788
	clc
	adc $1c43
	sta Lc788
	bcc Lc781
	inc Lc787
	bne Lc781
	inc Lc786
Lc781
	rts
	
Lc782
	.byte $00
Lc783
	.byte $65 
Lc784
	.byte $00
Lc785
	.byte $00
Lc786
	.byte $00
Lc787
	.byte $00
Lc788
	.byte $00
Lc789
	.byte $00
Lc78a
	.byte $00
Lc78b
	.byte $00
Lc78c
	.byte $00
Sc78d
	lda Lcb41
	ldx Lcb40
	jsr Scaa1
	bit Lcb4d
	bpl Lc7c8
	bit Lcb4e
	bmi Lc7db
	ldy #$10
Lc7a2
	lda $6500,y
	sta LTK_FileHeaderBlock ,y
	iny
	bne Lc7a2
	lda $6520
	sta Lcb4b
	lda $6521
	sta Lcb4c
	lda Lcb49
	sta $9200
	lda Lcb4a
	sta $9201
	dec Lcb4e
	bne Lc7e2
Lc7c8
	cpx #$00
	bne Lc7db
	cpy #$00
	bne Lc7db
	dex
	stx Lcb35
	jsr LTK_AppendBlocks 
	bcc Sc78d
Lc7d9
	bcs Lc7d9
Lc7db
	sec
	jsr LTK_HDDiscDriver 
	.byte $00,$65,$01 
Lc7e2
	inc Lcb41
	bne Lc7ea
	inc Lcb40
Lc7ea
	rts
	
Sc7eb
	ldx #$00
	stx Lcb36
	stx Lcb37
	stx Lcb38
	stx Lcb42
	stx Lcb39
	stx Lcb3a
	stx Lcb3b
	stx Lcb40
	stx Lcb41
	stx Lcb44
	stx Lcb45
	stx Lcb4e
	bit Lcb4d
	bpl Lc827
	lda $91f0
	sta Lcb37
	lda $91f1
	sta Lcb38
	dec Lcb42
	bne Lc897
Lc827
	lda $91f8
	cmp #$0f
	bne Lc849
	ldx $91f5
	stx Lcb3b
	lda Lc788
	sta Lcb38
	lda Lc787
	sta Lcb37
	lda Lc786
	sta Lcb36
	jmp Lc8cf
	
Lc849
	ldy #$02
	sty Lc866 + 1
	dey
	sty Lc860 + 1
	dey
	lda $91f1
	ldx $91f0
	bne Lc85f
	cmp #$f1
	bcc Lc879
Lc85f
	iny
Lc860
	cpx #$00
	bcc Lc879
	bne Lc86c
Lc866
	cmp #$00
	bcc Lc879
	beq Lc879
Lc86c
	inc Lc866 + 1
	bne Lc874
	inc Lc860 + 1
Lc874
	inc Lc860 + 1
	bne Lc85f
Lc879
	iny
	iny
	sty Lc88b + 1
	lda $91f1
	ldy $91f0
	bne Lc88a
	cmp #$02
	beq Lc8aa
Lc88a
	sec
Lc88b
	sbc #$00
	sta Lcb38
	bcs Lc893
	dey
Lc893
	tya
	sta Lcb37
Lc897
	ldy #$09
Lc899
	asl Lcb38
	rol Lcb37
	rol Lcb36
	dey
	bne Lc899
	bit Lcb4d
	bmi Lc8e9
Lc8aa
	ldy $91fc
	lda $91f9
	and #$01
	bne Lc8ba
	cpy #$00
	bne Lc8ba
	lda #$02
Lc8ba
	pha
	tya
	clc
	adc Lcb38
	sta Lcb38
	pla
	adc Lcb37
	sta Lcb37
	bcc Lc8cf
	inc Lcb36
Lc8cf
	lda $91fb
	sta $64fe
	lda $91fa
	sta $64ff
	ldx $91f8
	cpx #$0b
	beq Lc8e9
	cpx #$0c
	beq Lc8e9
	dec Lcb42
Lc8e9
	lda Lcb36
	sta Lcb3c
	lda Lcb37
	sta Lcb3d
	lda Lcb38
	sta Lcb3e
	bit Lcb42
	bmi Lc910
	clc
	adc #$02
	sta Lcb3e
	bcc Lc910
	inc Lcb3d
	bne Lc910
	inc Lcb3c
Lc910
	lda Lcb3c
	sta Lcc51
	lda Lcb3e
	ldx Lcb3d
Sc91d = * + 1       
	ldy #$fe
	jsr Scc17
	cpy #$00
	beq Lc92b
	clc
	adc #$01
	bcc Lc92b
	inx
Lc92b
	sta Lcb3e
	stx Lcb3d
	ldx $91f8
	cpx #$0f
	bne Lc946
	lda Lcb3e
	clc
	adc #$07
	sta Lcb3e
	bcc Lc946
	inc Lcb3d
Lc946
	lda Lcb3d
	cmp $1c4f
	bcc Lc956
	bne Lc956
	lda Lcb3e
	cmp $1c4e
Lc956
	rts
	
Lc957
	lda Lcb38
	sec
	sbc Lcb3b
	tay
	lda Lcb37
	sbc Lcb3a
	tax
	lda Lcb36
	sbc Lcb39
	bne Lc984
	txa
	bne Lc984
	tya
	bit Lcb42
	bmi Lc97c
	clc
	adc #$02
	bcs Lc984
Lc97c
	ldx #$00
	cmp #$fe
	bcc Lc988
	beq Lc988
Lc984
	ldx #$ff
	lda #$fe
Lc988
	sta $1c43
	stx Lcb43
	ldx Lcb3a
	ldy Lcb39
	clc
	adc Lcb3b
	bcc Lc99e
	inx
	bne Lc99e
	iny
Lc99e
	bit Lcb42
	sec
	bmi Lc9a6
	sbc #$02
Lc9a6
	sta Lcb3b
	txa
	sbc #$00
	sta Lcb3a
	tya
	sbc #$00
	sta Lcb39
	ldy Lcb44
	ldx Lcb45
	bne Lc9c0
	tya
	beq Lc9e6
Lc9c0
	lda $ca11
	clc
	adc #$fe
	sta $1c46
	sta $ca11
	sta $33
	lda $ca12
	adc #$00
	sta $ca12
	sta $1c47
	sta $34
	txa
	bne Lc9e3
	cpy $1c43
	bcc Lc9e6
Lc9e3
	jmp Lca86
	
Lc9e6
	tya
	beq Lc9f6
	pha
	dey
Lc9eb
	lda ($33),y
	sta $6500,y
	dey
	cpy #$ff
	bne Lc9eb
	pla
Lc9f6
	ldx #$65
	clc
	adc #$00
	sta $ca11
	bcc Lca01
	inx
Lca01
	stx $ca12
	lda Lcb41
	ldx Lcb40
	jsr Scaa1
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$65,$01 
Lca14
	bit Lcb4d
	bpl Lca2d
	bit Lcb4e
	bmi Lca2d
	lda Lcb4b
	sta $6520
	lda Lcb4c
	sta $6521
	dec Lcb4e
Lca2d
	ldx #$00
	ldy #$65
	bit Lcb42
	bmi Lca3f
	ldx #$fe
	ldy #$64
	lda #$02
	sta Lcb44
Lca3f
	inc Lcb45
	inc Lcb45
	txa
	ldx $91f8
	cpx #$0f
	bne Lca72
	ldx Lcb41
	bne Lca72
	ldx Lcb40
	bne Lca72
	clc
	adc $91f5
	bcc Lca5e
	iny
Lca5e
	pha
	lda Lcb44
	sec
	sbc $91f5
	sta Lcb44
	lda Lcb45
	sbc #$00
	sta Lcb45
	pla
Lca72
	sta $1c46
	sta $ca11
	sty $1c47
	sty $ca12
	inc Lcb41
	bne Lca86
	inc Lcb40
Lca86
	lda Lcb44
	sec
	sbc $1c43
	sta Lcb44
	lda Lcb45
	sbc #$00
	sta Lcb45
	lda #$ff
	sta Lcb42
	lda Lcb43
	rts
	
Scaa1
	stx Lcb32
	sta Lcb33
	sta Lcb34
	bit Lcb4d
	bpl Lcac2
	lda $9201
	clc
	adc Lcb33
	tax
	lda $9200
	adc Lcb32
	tay
	lda LTK_Var_ActiveLU
	rts
	
Lcac2
	tay
	bne Lcacd
	txa
	bne Lcacd
	lda #$ff
	sta Lcb35
Lcacd
	lda #$02
	ldx #$92
	jsr Scb16
	lda $91f0
	bne Lcae0
	lda $91f1
	cmp #$f1
	bcc Lcb0c
Lcae0
	ldy #$08
Lcae2
	lsr Lcb32
	ror Lcb33
	dey
	bne Lcae2
	lda Lcb33
	cmp Lcb35
	beq Lcb03
	sta Lcb35
	jsr Scb1d
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
Lcb03
	lda $cb00
	ldx $cb01
	jsr Scb16
Lcb0c
	lda Lcb34
	jsr Scb1d
	lda LTK_Var_ActiveLU
	rts
	
Scb16
	sta Scb2d + 1
	stx Scb2d + 2
	rts
	
Scb1d
	asl a
	tax
	bcc Lcb24
	inc Scb2d + 2
Lcb24
	jsr Scb2d
	tay
	jsr Scb2d
	tax
	rts
	
Scb2d
	lda Scb2d,x
	inx
	rts
	
Lcb32
	.byte $00
Lcb33
	.byte $00
Lcb34
	.byte $00
Lcb35
	.byte $ff 
Lcb36
	.byte $00
Lcb37
	.byte $00
Lcb38
	.byte $00
Lcb39
	.byte $00
Lcb3a
	.byte $00
Lcb3b
	.byte $00
Lcb3c
	.byte $00
Lcb3d
	.byte $00
Lcb3e
	.byte $00
Lcb3f
	.byte $00
Lcb40
	.byte $00
Lcb41
	.byte $00
Lcb42
	.byte $00
Lcb43
	.byte $00
Lcb44
	.byte $00
Lcb45
	.byte $00
Lcb46
	.byte $00
Lcb47
	.byte $00
Lcb48
	.byte $00
Lcb49
	.byte $00
Lcb4a
	.byte $00
Lcb4b
	.byte $00
Lcb4c
	.byte $00
Lcb4d
	.byte $00
Lcb4e
	.byte $00
Scb4f
	sta Lcb60 + 1
	stx Lcb60 + 2
	lda #$00
	sta Lcbca
	sta Lcbcb
	sta Lcbcc
Lcb60
	lda Lcb60,y
	cmp #$30
	bcc Lcbb8
	cmp #$3a
	bcc Lcb7d
	ldx Lcb88 + 1
	cpx #$0a
	beq Lcbb8
	cmp #$41
	bcc Lcbb8
	cmp #$47
	bcs Lcbb8
	sec
	sbc #$07
Lcb7d
	ldx Lcbca
	beq Lcba1
	pha
	tya
	pha
	lda #$00
	tax
Lcb88
	ldy #$0a
Lcb8a
	clc
	adc Lcbcc
	pha
	txa
	adc Lcbcb
	tax
	pla
	dey
	bne Lcb8a
	sta Lcbcc
	stx Lcbcb
	pla
	tay
	pla
Lcba1
	inc Lcbca
	sec
	sbc #$30
	clc
	adc Lcbcc
	sta Lcbcc
	bcc Lcbb5
	inc Lcbcb
	beq Lcbc2
Lcbb5
	iny
	bne Lcb60
Lcbb8
	cmp #$20
	beq Lcbb5
	clc
	ldx Lcbca
	bne Lcbc3
Lcbc2
	sec
Lcbc3
	lda Lcbcb
	ldx Lcbcc
	rts
	
Lcbca
	.byte $00
Lcbcb
	.byte $00
Lcbcc
	.byte $00
Scbcd
	lda LTK_BeepOnErrorFlag
	beq Lcc0c
	ldy #$18
	lda #$00
Lcbd6
	sta SID_V1_FreqLo,y
	dey
	bpl Lcbd6
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lcbe8
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scc0d
	iny
	tya
	cmp #$10
	bne Lcbe8
	ldx #$50
	jsr Scc0d
	ldy #$10
	sta SID_V1_Control
Lcc00
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scc0d
	tya
	bne Lcc00
Lcc0c
	rts
	
Scc0d
	dec Lcc16
	bne Scc0d
	dex
	bne Scc0d
	rts
	
Lcc16
	.byte $00
Scc17
	sta Lcc53
	stx Lcc52
	sty Lcc54
	lda #$00
	ldx #$18
Lcc24
	clc
	rol Lcc53
	rol Lcc52
	rol Lcc51
	rol a
	bcs Lcc36
	cmp Lcc54
	bcc Lcc46
Lcc36
	sbc Lcc54
	inc Lcc53
	bne Lcc46
	inc Lcc52
	bne Lcc46
	inc Lcc51
Lcc46
	dex
	bne Lcc24
	tay
	ldx Lcc52
	lda Lcc53
	rts
	
Lcc51
	.byte $00
Lcc52
	.byte $00
Lcc53
	.byte $00
Lcc54
	.byte $00
