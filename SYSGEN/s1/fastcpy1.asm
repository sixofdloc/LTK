;fastcpy1.r.prg

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
	ldx #$49
	ldy #$01
	cmp #$38
	bne Lc01b
	ldx #$1f
	ldy #$06
Lc01b
	stx Lc7ea + 1
	sty Lc7e4 + 1
	ldx #$10
	lda LTK_Var_CPUMode
	beq Lc030
	ldx #$13
	lda $d7
	beq Lc030
	ldx #$30
Lc030
	stx Lc31e + 1
	lda #$03
	ldx LTK_Var_ActiveLU
	stx $95e9
	jsr Sc894
	lda #$04
	ldx LTK_Var_Active_User
	stx Lc75d
	jsr Sc894
	lda LTK_Var_CPUMode
	beq Lc068
	lda $d7
	beq Lc068
	ldx #$4f
	stx Lc34a + 1
	ldx #$3e
	stx Lc3c2 + 1
	lda #$a0
	sta Lc406 + 1
	sta Lc435 + 1
	lsr a
	sta Lc472 + 1
Lc068
	lda #$00
	sta $31
	sta $33
	lda #$a0
	sta $32
	sta $34
	lda #$fe
	sta Lc758
	ldx #$20
	lda #$ff
	ldy #$00
	sty Lc759
	sty Lc75c
Lc085
	sta ($31),y
	iny
	bne Lc085
	inc $32
	dex
	bne Lc085
Lc08f
	ldx #$00
	jsr $6c00
Lc094
	ldx #$01
	jsr Sc662
	bcs Lc094
	cmp #$45
	beq Lc0b8
	tax
	lda #$40
	cpx #$47
	beq Lc0bb
	asl a
	cpx #$41
	beq Lc0bb
	asl a
	cpx #$4d
	beq Lc0bb
	ldx #$08
	jsr Sc232
	jmp Lc08f
	
Lc0b8
	jmp Lc4c4
	
Lc0bb
	sta Lc757
Lc0be
	ldx #$02
	jsr Sc662
	bcs Lc0be
	ldx #$00
	cmp #$4e
	beq Lc0d8
	dex
	cmp #$59
	beq Lc0d8
	ldx #$08
	jsr Sc232
	jmp Lc0be
	
Lc0d8
	stx $95e7
	ldx #$03
	jsr Sc207
	bcs Lc08f
	stx $95e9
	cpx #$ff
	beq Lc08f
Lc0e9
	ldx #$04
	jsr Sc21e
	bcs Lc0e9
	stx Lc75d
	ldx #$05
	jsr $6c00
Lc0f8
	ldx #$06
	jsr Sc662
	bcs Lc15a
	ldx #$00
	cpy #$01
	beq Lc162
	cpy #$02
	bne Lc133
	ldx #$0b
	cmp #$42
	beq Lc162
	ldx #$0c
	cmp #$4d
	beq Lc162
	ldx #$0d
	cmp #$53
	beq Lc162
	ldx #$0e
	cmp #$55
	beq Lc162
	ldx #$0f
	cmp #$52
	beq Lc162
	ldx #$04
	cmp #$4b
	beq Lc162
	ldx #$05
	cmp #$43
	beq Lc162
Lc133
	lda #$b9
	ldx #$c8
	ldy #$00
	jsr Sc8ce
	bcs Lc15a
	cpx #$0b
	beq Lc162
	cpx #$0c
	beq Lc162
	cpx #$0d
	beq Lc162
	cpx #$0e
	beq Lc162
	cpx #$0f
	beq Lc162
	cpx #$04
	beq Lc162
	cpx #$05
	beq Lc162
Lc15a
	ldx #$0c
	jsr Sc232
	jmp Lc0f8
	
Lc162
	stx Lc892
Lc165
	ldx #$07
	jsr Sc662
	lda #$00
	bcs Lc165
	cpy #$01
	beq Lc174
	dey
	tya
Lc174
	sta Lc893
	ldx #$f0
	lda $95e9
	cmp #$0a
	beq Lc182
	ldx #$11
Lc182
	ldy #$00
	clc
	stx $95e8
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc18e
	lda Lc758
	beq Lc1a1
	ldy Lc759
Lc196
	lda $9202,y
	bne Lc1a4
	iny
	dec Lc758
	bne Lc196
Lc1a1
	jmp Lc2ac
	
Lc1a4
	iny
	tya
	sta Lc759
	ldy #$00
	dec Lc758
	clc
	adc $95e8
	tax
	bcc Lc1b6
	iny
Lc1b6
	lda #$e0
	sta $31
	lda #$8f
	sta $32
	lda $95e9
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lc1c8
	lda $8ffc
	sta Lc75b
	lda #$00
	sta Lc75a
Lc1d3
	ldy #$1d
	jsr Sc8b3
	bmi Lc1f7
	jsr Lc79c
	bcs Lc1f2
	lda Lc75a
	ldy Lc757
	beq Lc1e9
	ora #$80
Lc1e9
	jsr Lc29d
	lda Lc759
	jsr Lc29d
Lc1f2
	dec Lc75b
	beq Lc18e
Lc1f7
	inc Lc75a
	clc
	lda $31
	adc #$20
	sta $31
	bcc Lc1d3
	inc $32
	bne Lc1d3
Sc207
	jsr Sc26e
	bcs Lc21a
	cpx #$ff
	clc
	beq Lc231
	txa
	pha
	jsr LTK_SetLuActive 
	pla
	tax
	bcc Lc231
Lc21a
	ldx #$0a
	bne Lc22e
Sc21e
	jsr Sc26e
	bcs Lc22c
	cpx #$ff
	clc
	beq Lc231
	cpx #$10
	bcc Lc231
Lc22c
	ldx #$0b
Lc22e
	jsr Sc232
Lc231
	rts
	
Sc232
	php
	stx Lc24a + 1
	jsr Sc625
	txa
	pha
	tya
	pha
	lda #$00
	sta Lc607
	lda #$18
	sta Lc608
	jsr Sc622
Lc24a
	ldx #$00
	jsr $6c00
	jsr Sc9ef
	lda #$02
	jsr Sc692
	jsr Sc622
	ldx #$09
	jsr $6c00
	pla
	sta Lc607
	pla
	tax
	dex
	stx Lc608
	jsr Sc622
	plp
	rts
	
Sc26e
	jsr Sc662
	bcs Lc29c
	ldx #$ff
	cpy #$01
	beq Lc29b
	cpy #$03
	bne Lc28b
	lda Lc8b9
	cmp #$41
	bne Lc28b
	lda Lc8ba
	cmp #$4c
	beq Lc29b
Lc28b
	lda #$b9
	ldx #$c8
	ldy #$00
	jsr Sc8ce
	bcs Lc29c
	sec
	pha
	pla
	bne Lc29c
Lc29b
	clc
Lc29c
	rts
	
Lc29d
	ldy #$00
	sta ($33),y
	dey
	sty Lc75c
	inc $33
	bne Lc2ab
	inc $34
Lc2ab
	rts
	
Lc2ac
	lda Lc75c
	bne Lc2c7
Lc2b1
	ldx #$0d
	jsr $6c00
	jsr Sc9ef
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc2be
	jsr LTK_KernalCall 
	tax
	beq Lc2be
	jmp Lc068
	
Lc2c7
	lda #$00
	sta Lc60b
	lda #$a0
	sta Lc60a
Lc2d1
	lda #$00
	sta Lc60c
	sta Lc609
	lda Lc60a
	sta $32
	lda Lc60b
	sta $31
	jsr Sc639
	ldx #$0e
	jsr $6c00
Lc2eb
	ldy Lc60c
	jsr Sc8b3
	cmp #$ff
	beq Lc302
	jsr Sc528
	beq Lc302
	inc Lc60c
	inc Lc60c
	bne Lc2eb
Lc302
	lda #$00
	sta Lc60c
	lda #$02
	sta Lc607
	lda #$05
	sta Lc608
Lc311
	jsr Sc60f
	lda #$00
	sta Lc60d
Lc319
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc31e
	lda #$00
	sta Lc60e
Lc323
	jsr LTK_KernalCall 
	tax
	bne Lc343
	dec Lc60e
	bne Lc323
	bit Lc60d
	bpl Lc33b
	jsr Sc60f
	inc Lc60d
	beq Lc319
Lc33b
	jsr Sc618
	dec Lc60d
	bne Lc319
Lc343
	cmp #$11
	bne Lc383
	ldx Lc60c
Lc34a
	cpx #$27
	bcs Lc323
	inx
	txa
	asl a
	tay
	jsr Sc8b3
	cmp #$ff
	beq Lc323
	stx Lc60c
	jsr Sc618
	lda Lc60c
	cmp #$14
	beq Lc373
	cmp #$28
	beq Lc373
	cmp #$3c
	beq Lc373
	inc Lc608
	bne Lc311
Lc373
	lda #$14
	clc
	adc Lc607
	sta Lc607
	lda #$05
	sta Lc608
	bne Lc311
Lc383
	cmp #$91
	bne Lc3b8
	lda Lc60c
	beq Lc323
	jsr Sc618
	ldx Lc60c
	dex
	stx Lc60c
	cpx #$13
	beq Lc3a8
	cpx #$27
	beq Lc3a8
	cpx #$3b
	beq Lc3a8
	dec Lc608
Lc3a5
	jmp Lc311
	
Lc3a8
	lda Lc607
	sec
	sbc #$14
	sta Lc607
	lda #$18
	sta Lc608
	bne Lc3a5
Lc3b8
	cmp #$1d
	bne Lc3e3
	jsr Sc618
	lda Lc607
Lc3c2
	cmp #$16
	bcs Lc3a5
	lda Lc60c
	adc #$14
	tax
	asl a
	tay
	jsr Sc8b3
	cmp #$ff
	beq Lc3a5
	stx Lc60c
	lda Lc607
	clc
	adc #$14
	sta Lc607
	bne Lc3a5
Lc3e3
	cmp #$9d
	bne Lc402
	jsr Sc618
	lda Lc607
	cmp #$02
	beq Lc3a5
	sec
	sbc #$14
	sta Lc607
	lda Lc60c
	sec
	sbc #$14
	sta Lc60c
	bne Lc3a5
Lc402
	cmp #$4e
	bne Lc41f
Lc406
	ldy #$50
	jsr Sc8b3
	cmp #$ff
	beq Lc469
	tya
	clc
	adc Lc60b
	sta Lc60b
	bcc Lc41c
	inc Lc60a
Lc41c
	jmp Lc2d1
	
Lc41f
	cmp #$50
	bne Lc445
	lda Lc60a
	cmp #$a0
	bne Lc431
	lda Lc60b
	cmp #$00
	beq Lc469
Lc431
	lda Lc60b
	sec
Lc435
	sbc #$50
	sta Lc60b
	lda Lc60a
	sbc #$00
	sta Lc60a
	jmp Lc2d1
	
Lc445
	cmp #$20
	bne Lc46c
	dec Lc607
	dec Lc607
	asl Lc60c
	ldy Lc60c
	jsr Sc8b3
	eor #$80
	jsr Sc8b6
	jsr Sc562
	inc Lc607
	inc Lc607
	lsr Lc60c
Lc469
	jmp Lc311
	
Lc46c
	cmp #$54
	bne Lc48b
	ldy #$00
Lc472
	ldx #$28
Lc474
	jsr Sc8b3
	cmp #$ff
	beq Lc485
	eor #$80
	jsr Sc8b6
	iny
	iny
	dex
	bne Lc474
Lc485
	jmp Lc2d1
	
Lc488
	jmp Lc2c7
	
Lc48b
	cmp #$43
	bne Lc492
	jmp Lc6ac
	
Lc492
	cmp #$45
	bne Lc4b9
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc49e
	ldy #$00
	jsr Sc8b3
	cmp #$ff
	beq Lc488
	eor #$80
	jsr Sc8b6
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc49e
	inc $32
	bne Lc49e
Lc4b9
	cmp #$13
	beq Lc488
	cmp #$51
	bne Lc469
	jmp Lc068
	
Lc4c4
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	rts
	
Sc4d1
	ldy Lc60c
	iny
	jsr Sc8b3
	cmp Lc759
	beq Lc4fa
	sta Lc759
	ldy #$00
	clc
	adc $95e8
	tax
	bcc Lc4ea
	iny
Lc4ea
	lda $95e9
	clc
	stx Lc51c + 1
	sty Lc51e + 1
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lc4fa
	ldy Lc60c
	jsr Sc8b3
	and #$7f
	ldy #$8f
	ldx #$05
Lc506
	asl a
	bcc Lc50a
	iny
Lc50a
	dex
	bne Lc506
	clc
	adc #$e0
	tax
	bcc Lc514
	iny
Lc514
	stx $33
	sty $34
	rts
	
Sc519
	lda $95e9
Lc51c
	ldx #$00
Lc51e
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lc527
	rts
	
Sc528
	jsr Sc562
	inc Lc608
	inc Lc609
	lda #$14
	cmp Lc609
	beq Lc559
	lda #$28
	ldx LTK_Var_CPUMode
	beq Lc543
	ldx $d7
	bne Lc547
Lc543
	cmp Lc609
	rts
	
Lc547
	cmp Lc609
	beq Lc559
	lda #$3c
	cmp Lc609
	beq Lc559
	lda #$50
	cmp Lc609
	rts
	
Lc559
	sta Lc607
	lda #$05
	sta Lc608
	rts
	
Sc562
	jsr Sc622
	jsr Sc4d1
	ldy #$16
	lda ($33),y
	ldx #$42
	cmp #$0b
	beq Lc592
	ldx #$4d
	cmp #$0c
	beq Lc592
	ldx #$53
	cmp #$0d
	beq Lc592
	ldx #$55
	cmp #$0e
	beq Lc592
	ldx #$52
	cmp #$0f
	beq Lc592
	ldx #$4b
	cmp #$04
	beq Lc592
	ldx #$43
Lc592
	stx Lc5da + 2
	ldy #$19
	lda ($33),y
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #$30
	cmp #$3a
	bcc Lc5a6
	adc #$06
Lc5a6
	sta Lc5da + 3
	ldy Lc60c
	ldx #$12
	jsr Sc8b3
	bmi Lc5b5
	ldx #$92
Lc5b5
	stx Lc5da + 1
	ldx #$da
	ldy #$c5
	jsr LTK_Print 
	jsr Sc5e1
	ldy #$10
	lda ($33),y
	pha
	lda #$00
	sta ($33),y
	ldx $33
	ldy $34
	jsr LTK_Print 
	ldy #$10
	pla
	sta ($33),y
	jmp Lc5f4
	
Lc5da
	.text "{$0e}vtu{rvs off} "
	.byte $00
Sc5e1
	lda LTK_Var_CPUMode
	bne Lc5ed
	lda $d4
	ora #$01
	sta $d4
	rts
	
Lc5ed
	lda $f4
	ora #$01
	sta $f4
	rts
	
Lc5f4
	lda LTK_Var_CPUMode
	bne Lc600
	lda $d4
	and #$fe
	sta $d4
	rts
	
Lc600
	lda $f4
	and #$fe
	sta $f4
	rts
	
Lc607
	.byte $00
Lc608
	.byte $02 
Lc609
	.byte $00
Lc60a
	.byte $00
Lc60b
	.byte $00
Lc60c
	.byte $00
Lc60d
	.byte $00
Lc60e
	.byte $00
Sc60f
	jsr Sc622
	ldx #$cc
	ldy #$c8
	bne Lc61f
Sc618
	jsr Sc622
	ldx #$ca
	ldy #$c8
Lc61f
	jmp LTK_Print 
	
Sc622
	clc
	bcc Lc626
Sc625
	sec
Lc626
	php
	sec
	ldx #$f0
	ldy #$ff
	jsr LTK_KernalTrapSetup
	plp
	ldx Lc608
	ldy Lc607
	jmp LTK_KernalCall 
	
Sc639
	ldx #$1f
	jsr $6c00
	ldx #$13
	jsr $6c00
	lda #$00
	sta Lc607
	tay
	ldx $95e9
	jsr Sc8ae
	ldx #$e2
	ldy #$c9
	jsr LTK_Print 
	lda Lc75d
	jsr Sc75e
	lda #$05
	sta Lc608
	rts
	
Sc662
	stx Lc682 + 1
	jsr $6c00
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
Lc66f
	jsr LTK_KernalCall 
	sta Lc8b9,y
	iny
	cpy #$10
	bcs Lc67f
	cmp #$0d
	bne Lc66f
	clc
Lc67f
	php
	tya
	pha
Lc682
	lda #$00
	ldx #$b9
	ldy #$c8
	jsr $6c03
	pla
	tay
	plp
	lda Lc8b9
	rts
	
Sc692
	sta Lc6ab
Lc695
	lda #$00
	tax
	ldy #$02
Lc69a
	sec
	adc #$00
	bne Lc69a
	inx
	bne Lc69a
	dey
	bne Lc69a
	dec Lc6ab
	bne Lc695
	rts
	
Lc6ab
	.byte $00
Lc6ac
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc6b4
	ldy #$00
	lda ($31),y
	bpl Lc6c1
	cmp #$ff
	bne Lc6ce
	jmp Lc2b1
	
Lc6c1
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc6b4
	inc $32
	bne Lc6b4
Lc6ce
	ldx #$0f
	jsr $6c00
	lda #$00
	sta Lc60c
	tay
	ldx $95e9
	jsr Sc8ae
	ldx #$e2
	ldy #$c9
	jsr LTK_Print 
	lda Lc9e2
	sta $1c2a
	lda Lc9e3
	sta $1c2b
	lda Lc75d
	jsr Sc75e
	ldx #$15
	jsr $6c00
	ldx #$16
	jsr $6c00
Lc702
	ldx #$11
	jsr Sc662
	bcs Lc702
	cmp #$59
	beq Lc714
	cmp #$4e
	bne Lc702
	jmp Lc2c7
	
Lc714
	bit Lc757
	bvc Lc750
	ldx #$20
	jsr $6c00
	lda #$01
	jsr Sc692
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc72b
	ldy #$00
	lda ($31),y
	bpl Lc743
	cmp #$ff
	beq Lc750
	jsr Sc4d1
	ldy #$1a
	lda ($33),y
	ora #$80
	sta ($33),y
	jsr Sc519
Lc743
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc72b
	inc $32
	bne Lc72b
Lc750
	ldx #$10
	ldy #$02
	jmp $95e3
	
Lc757
	.byte $00
Lc758
	.byte $00
Lc759
	.byte $00
Lc75a
	.byte $00
Lc75b
	.byte $00
Lc75c
	.byte $00
Lc75d
	.byte $00
Sc75e
	pha
	ldx #$10
	jsr $6c00
	lda #$41
	sta $1c2e
	lda #$4c
	sta $1c2f
	ldx #$12
	pla
	bmi Lc799
	tax
	lda #$00
	tay
	jsr Sc8ae
	lda #$20
	ldx $95e7
	beq Lc783
	lda #$2f
Lc783
	sta $1c2d
	lda Lc9e2
	sta $1c2e
	lda Lc9e3
	sta $1c2f
	ldx #$e2
	ldy #$c9
	jmp LTK_Print 
	
Lc799
	jmp $6c00
	
Lc79c
	ldy #$16
	jsr Sc8b3
	pha
	ldy #$10
	jsr Sc8b3
	tax
	iny
	jsr Sc8b3
	tay
	pla
	cmp #$0a
	bcc Lc7e4
	pha
	lda $95e6
	cmp #$38
	beq Lc7c7
	pla
	tya
	sec
	sbc #$01
	tay
	txa
	sbc #$00
	tax
	jmp Lc7e4
	
Lc7c7
	pla
	cmp #$0f
	bne Lc7d8
	tya
	clc
	adc #$04
	tay
	txa
	adc #$00
	tax
	jmp Lc7e4
	
Lc7d8
	txa
	beq Lc7e4
	tya
	sec
	sbc #$08
	tay
	txa
	sbc #$00
	tax
Lc7e4
	cpx #$00
	bcc Lc7f0
	bne Lc82a
Lc7ea
	cpy #$00
	bcc Lc7f0
	bne Lc82a
Lc7f0
	bit Lc757
	bpl Lc7fc
	ldy #$1a
	jsr Sc8b3
	bpl Lc82a
Lc7fc
	bit Lc75d
	bmi Lc80f
	ldy #$19
	jsr Sc8b3
	lsr a
	lsr a
	lsr a
	lsr a
	cmp Lc75d
	bne Lc82a
Lc80f
	ldy #$16
	jsr Sc8b3
	cmp #$01
	beq Lc82a
	cmp #$02
	beq Lc82a
	cmp #$03
	beq Lc82a
	ldx Lc892
	beq Lc82c
	cmp Lc892
	beq Lc82c
Lc82a
	sec
	rts
	
Lc82c
	lda #$00
	sta Lc891
	sta Lc88f
	sta Lc890
	tax
	tay
	lda Lc893
	bne Lc840
Lc83e
	clc
	rts
	
Lc840
	jsr Sc8b3
	sta Lc88e
	beq Lc82a
	lda Lc8b9,x
	cmp #$3f
	beq Lc881
	cmp #$2a
	bne Lc858
	sta Lc891
	beq Lc881
Lc858
	cmp Lc88e
	beq Lc871
	lda Lc891
	bne Lc887
	ldy Lc890
	ldx Lc88f
	beq Lc82a
	lda #$2a
	sta Lc891
	bne Lc887
Lc871
	lda Lc891
	beq Lc881
	stx Lc88f
	sty Lc890
	lda #$00
	sta Lc891
Lc881
	inx
	cpx Lc893
	bcs Lc83e
Lc887
	iny
	cpy #$10
	bne Lc840
	beq Lc82a
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
Sc894
	pha
	lda #$00
	tay
	jsr Sc8ae
	ldx #$e2
	ldy #$c9
	lda Lc9e2
	cmp #$30
	bne Lc8aa
	inx
	bne Lc8aa
	iny
Lc8aa
	pla
	jmp $6c03
	
Sc8ae
	clc
	jsr Sc94c
	rts
	
Sc8b3
	lda ($31),y
	rts
	
Sc8b6
	sta ($31),y
	rts
	
Lc8b9
	.byte $00
Lc8ba		     
    .byte $00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
Lc8ca
	.text " "
	.byte $00
Lc8cc
	.text ">"
	.byte $00
Sc8ce
	sta Lc8df + 1
	stx Lc8df + 2
	lda #$00
	sta Lc949
	sta Lc94a
	sta Lc94b
Lc8df
	lda Lc8df,y
	cmp #$30
	bcc Lc937
	cmp #$3a
	bcc Lc8fc
	ldx Lc907 + 1
	cpx #$0a
	beq Lc937
	cmp #$41
	bcc Lc937
	cmp #$47
	bcs Lc937
	sec
	sbc #$07
Lc8fc
	ldx Lc949
	beq Lc920
	pha
	tya
	pha
	lda #$00
	tax
Lc907
	ldy #$0a
Lc909
	clc
	adc Lc94b
	pha
	txa
	adc Lc94a
	tax
	pla
	dey
	bne Lc909
	sta Lc94b
	stx Lc94a
	pla
	tay
	pla
Lc920
	inc Lc949
	sec
	sbc #$30
	clc
	adc Lc94b
	sta Lc94b
	bcc Lc934
	inc Lc94a
	beq Lc941
Lc934
	iny
	bne Lc8df
Lc937
	cmp #$20
	beq Lc934
	clc
	ldx Lc949
	bne Lc942
Lc941
	sec
Lc942
	lda Lc94a
	ldx Lc94b
	rts
	
Lc949
	.byte $00
Lc94a
	.byte $00
Lc94b
	.byte $00
Sc94c
	stx Lc9de
	sty Lc9dd
	php
	pha
	lda #$30
	ldy #$04
Lc958
	sta Lc9df,y
	dey
	bpl Lc958
	pla
	beq Lc97c
	lda Lc9de
	jsr Sc9c8
	sta Lc9e2
	stx Lc9e3
	lda Lc9dd
	jsr Sc9c8
	sta Lc9e0
	stx Lc9e1
	jmp Lc9b1
	
Lc97c
	iny
Lc97d
	lda Lc9dd
	cmp Lc9e5,y
	bcc Lc9ac
	bne Lc98f
	lda Lc9de
	cmp Lc9ea,y
	bcc Lc9ac
Lc98f
	lda Lc9de
	sbc Lc9ea,y
	sta Lc9de
	lda Lc9dd
	sbc Lc9e5,y
	sta Lc9dd
	lda Lc9df,y
	clc
	adc #$01
	sta Lc9df,y
	bne Lc97d
Lc9ac
	iny
	cpy #$05
	bne Lc97d
Lc9b1
	plp
	bcc Lc9c7
	ldy #$00
Lc9b6
	lda Lc9df,y
	cmp #$30
	bne Lc9c7
	lda #$20
	sta Lc9df,y
	iny
	cpy #$04
	bne Lc9b6
Lc9c7
	rts
	
Sc9c8
	pha
	and #$0f
	jsr Sc9d4
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
Sc9d4
	cmp #$0a
	bcc Lc9da
	adc #$06
Lc9da
	adc #$30
	rts
	
Lc9dd
	.byte $ff 
Lc9de
	.byte $ff 
Lc9df
	.byte $00
Lc9e0
	.byte $00
Lc9e1
	.byte $00
Lc9e2
	.byte $00
Lc9e3
	.byte $00,$00 
Lc9e5
	.byte $27,$03,$00,$00,$00 
Lc9ea
	.byte $10,$e8,$64,$0a,$01 
Sc9ef
	lda LTK_BeepOnErrorFlag
	beq Lca2e
	ldy #$18
	lda #$00
Lc9f8
	sta SID_V1_FreqLo,y
	dey
	bpl Lc9f8
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lca0a
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Sca2f
	iny
	tya
	cmp #$10
	bne Lca0a
	ldx #$50
	jsr Sca2f
	ldy #$10
	sta SID_V1_Control
Lca22
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Sca2f
	tya
	bne Lca22
Lca2e
	rts
	
Sca2f
	dec Lca38
	bne Sca2f
	dex
	bne Sca2f
	rts
	
Lca38
	.byte $00
