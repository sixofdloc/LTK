;renum.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	.include "../../include/basic.asm"

	*=$c000 
Lc000
	ldx LTK_Var_CPUMode
	beq Lc00f
	ldx #$12
	ldy #$cb
	jsr LTK_Print 
	jmp Lcb0e
	
Lc00f
	jsr LTK_Krn_BankIn
	ldx $c8
	jmp Lc06f
	
Lc017
	.byte $17 
Lc018
	.text "00010,00010,00000-63999"
Sc02f
	tay
	iny
	lda #$00
	sta Lc05a + 1
	lda #$02
	sta Lc05a + 2
	stx Lc017
	cpy Lc017
	bcs Lc069
	dey
	iny
	sty $c05e
	lda #$18
	sec
	sbc $c05e
	sta $c05e
	lda #$c0
	sbc #$00
	sta $c05f
	ldx #$00
Lc05a
	lda Lc05a,y
	sta $c05d,y
	cpy Lc017
	beq Lc06b
	inx
	iny
	bne Lc05a
Lc069
	ldx #$17
Lc06b
	stx Lc017
	rts
	
Lc06f
	jsr Sc02f
	lda #$18
	sta Lc081 + 1
	lda #$c0
	sta Lc081 + 2
	ldx Lc017
	ldy #$00
Lc081
	lda Lc081,y
	iny
	dex
	cmp #$2c
	beq Lc09b
	cmp #$2d
	beq Lc0a0
	cmp #$30
	bcc Lc0ac
	cmp #$3a
	bcs Lc0ac
	txa
	bne Lc081
	beq Lc0fe
Lc09b
	inc Lc0fd
	bne Lc081
Lc0a0
	lda Lc0fd
	cmp #$02
	bne Lc0ac
	txa
	beq Lc0fe
	bne Lc081
Lc0ac
	ldx #$73
	ldy #$c4
	jsr Sc0b6
	jmp Lcb0b
	
Sc0b6
	stx Lc0be + 1
	sty Lc0be + 2
	ldy #$00
Lc0be
	lda Lc0be,y
	beq Lc0c9
	jsr CHROUT
	iny
	bne Lc0be
Lc0c9
	rts
	
Lc0ca
	.text "{return}increment must be within{return}the  range of  1 - 63999"
	.byte $00
Lc0fd
	.byte $00
Lc0fe
	lda #$18
	sta Lc10d + 1
	lda #$c0
	sta Lc10d + 2
	ldy #$00
	ldx Lc017
Lc10d
	lda Lc10d,y
	iny
	dex
	cmp #$2c
	beq Lc120
	cmp #$2d
	beq Lc120
	jsr Sc154
	txa
	bne Lc10d
Lc120
	sty Lc153
	ldy Lc152
	lda Lc195
	sta Lc14a,y
	iny
	lda Lc196
	sta Lc14a,y
	iny
	sty Lc152
	ldy Lc153
	txa
	beq Lc147
	lda #$00
	sta Lc195
	sta Lc196
	beq Lc10d
Lc147
	jmp Lc1ba
	
Lc14a
	.byte $0a 
Lc14b
	.byte $00
Lc14c
	.byte $0a 
Lc14d
	.byte $00
Lc14e
	.byte $00
Lc14f
	.byte $00
Lc150
	.byte $ff 
Lc151
	.byte $ff 
Lc152
	.byte $00
Lc153
	.byte $00
Sc154
	clc
	sbc #$2f
	sta Lc193
	lda Lc196
	sta Lc194
	cmp #$19
	bcs Lc197
	lda Lc195
	asl a
	rol Lc194
	asl a
	rol Lc194
	adc Lc195
	sta Lc195
	lda Lc194
	adc Lc196
	sta Lc196
	asl Lc195
	rol Lc196
	lda Lc195
	adc Lc193
	sta Lc195
	bcc Lc192
	inc Lc196
Lc192
	rts
	
Lc193
	.byte $00
Lc194
	.byte $00
Lc195
	.byte $00
Lc196
	.byte $00
Lc197
	pla
	pla
	ldx #$a3
	ldy #$c1
	jsr Sc0b6
	jmp Lcb0b
	
Lc1a3
	.text "{return}parameter too large{return}{$07}"
	.byte $00
Lc1ba
	lda Lc151
	cmp Lc14f
	bcc Lc1cc
	bne Lc1e1
	lda Lc150
	cmp Lc14e
	bcs Lc1e1
Lc1cc
	ldx #$d6
	ldy #$c1
	jsr Sc0b6
	jmp Lcb0b
	
Lc1d6
	.text "{return}bad range"
	.byte $00
Lc1e1
	lda Lc14a
	ora Lc14b
	bne Lc1f3
	ldx #$ca
	ldy #$c0
	jsr Sc0b6
	jmp Lcb0b
	
Lc1f3
	jsr Sc2aa
	lda Lc38b
	ora Lc38c
	bne Lc218
	ldx #$08
	ldy #$c2
	jsr Sc0b6
	jmp Lcb0b
	
Lc208
	.text "{return}no lines found"
	.byte $00
Lc218
	lda Lc38b
	sec
	sbc #$01
	sta Lc381
	lda Lc38c
	sbc #$00
	sta Lc382
	lda Lc14a
	sta Lc385
	lda Lc14b
	sta Lc386
	jsr Sc32c
	lda Lc389
	bne Lc260
	lda #$f9
	cmp Lc388
	bcc Lc260
	clc
	lda Lc14c
	adc Lc387
	sta Lc387
	lda Lc14d
	adc Lc388
	sta Lc388
	bcs Lc260
	lda #$f9
	cmp Lc388
	bcs Lc2a7
Lc260
	ldx #$6a
	ldy #$c2
	jsr Sc0b6
	jmp Lcb0b
	
Lc26a
	.text "{return}increment  or  starting  line{return}too large for renumber range."
	.byte $00
Lc2a7
	jmp Lc38d
	
Sc2aa
	lda #$00
	sta Lc38b
	sta Lc38c
	lda $2b
	sta $22
	lda $2c
	sta $23
	clc
Lc2bb
	php
	ldy #$01
	lda ($22),y
	beq Lc300
	clc
	lda Lcf8f
	adc #$04
	sta Lcf8f
	lda Lcf90
	adc #$00
	sta Lcf90
	jsr Sc302
	bcc Lc2e0
	inc Lc38b
	bne Lc2e0
	inc Lc38c
Lc2e0
	plp
	ldy #$04
Lc2e3
	iny
	lda ($22),y
	bne Lc2e3
	iny
	tya
	adc $22
	tax
	ldy #$00
	sta ($22),y
	lda $23
	adc #$00
	iny
	sta ($22),y
	stx $22
	sta $23
	bcc Lc2bb
	bcs Lc301
Lc300
	plp
Lc301
	rts
	
Sc302
	ldy #$03
	lda ($22),y
	cmp Lc14f
	bcc Lc32a
	bne Lc316
	dey
	lda ($22),y
	iny
	cmp Lc14e
	bcc Lc32a
Lc316
	lda Lc151
	cmp ($22),y
	bcc Lc32a
	bne Lc327
	dey
	lda Lc150
	cmp ($22),y
	bcc Lc32a
Lc327
	sec
	bcs Lc32b
Lc32a
	clc
Lc32b
	rts
	
Sc32c
	lda #$00
	sta Lc387
	sta Lc388
	sta Lc389
	sta Lc38a
	sta Lc383
	sta Lc384
	ldx #$10
Lc342
	clc
	lsr Lc386
	ror Lc385
	bcc Lc370
	clc
	lda Lc387
	adc Lc381
	sta Lc387
	lda Lc388
	adc Lc382
	sta Lc388
	lda Lc389
	adc Lc383
	sta Lc389
	lda Lc38a
	adc Lc384
	sta Lc38a
Lc370
	clc
	rol Lc381
	rol Lc382
	rol Lc383
	rol Lc384
	dex
	bne Lc342
	rts
	
Lc381
	.byte $00
Lc382
	.byte $00
Lc383
	.byte $00
Lc384
	.byte $00
Lc385
	.byte $00
Lc386
	.byte $00
Lc387
	.byte $00
Lc388
	.byte $00
Lc389
	.byte $00
Lc38a
	.byte $00
Lc38b
	.byte $00
Lc38c
	.byte $00
Lc38d
	lda $01
	and #$fe
	sta $01
	lda $f7
	sta Lc4e2
	lda $f8
	sta Lc4e3
	lda $f9
	sta Lc4e4
	lda $fa
	sta Lc4e5
	lda $fb
	sta Lc4e6
	lda $fc
	sta Lc4e7
	lda #$01
	sta $f7
	sta Lcf93
	lda #$08
	sta $f8
	sta Lcf94
	lda Lcf8f
	sta Lcf9b
	lda Lcf90
	sta Lcf9c
	lda #$00
	sta $22
	lda #$a0
	sta $23
	ldy #$00
	sty Lcfa3
	lda Lc14c
	sec
	sbc Lc14a
	sta Lcf86
	lda Lc14d
	sbc Lc14b
	sta Lcf87
	sty Lcf91
	sty Lcf92
	sty Lcf8a
	sty Lcf8b
	sty Lcf8c
	sty Lcf8d
	sty Lcf95
	sty Lcf96
	sty Lcf85
	sty Lcfa1
	sty Lcfa2
	sty Lcfa6
Lc40f
	jsr Scdce
	lda ($f7),y
	iny
	ora ($f7),y
	dey
	ora #$00
	bne Lc41f
	jmp Lc4e8
	
Lc41f
	lda ($f7),y
	sta Lcf88
	iny
	lda ($f7),y
	sta Lcf89
	iny
	lda ($f7),y
	sta Lcf9f
	iny
	lda ($f7),y
	sta Lcfa0
	iny
Lc437
	jsr Scc30
	bcs Lc482
	jsr Scc80
	bcs Lc482
	jsr Sccc9
	bcs Lc482
	lda ($f7),y
	beq Lc44d
	iny
	bne Lc437
Lc44d
	iny
	lda $f7
	sta Lcf93
	lda $f8
	sta Lcf94
	lda Lcf88
	sta $f7
	lda Lcf89
	sta $f8
	ldy #$00
	jmp Lc40f
	
Lc467
	.text "  in 00000{return}"
	.byte $00
Lc473
	.text "{return}?syntax error"
	.byte $00
Lc482
	ldx #$73
	ldy #$c4
Lc486
	lda $01
	ora #$01
	sta $01
	jsr Sc0b6
	lda #$6c
	sta $f9
	lda #$c4
	sta $fa
	lda Lcf9f
	sta Lcf9d
	lda Lcfa0
	sta Lcf9e
	ldx #$05
	ldy #$00
	jsr Sc633
	ldx #$67
	ldy #$c4
	jsr Sc0b6
	jsr Sca96
	lda #$ff
	sta Lcfa3
	jsr Sc808
	jsr Sc4c3
	clc
	jmp Lcb0b
	
Sc4c3
	lda Lc4e2
	sta $f7
	lda Lc4e3
	sta $f8
	lda Lc4e4
	sta $f9
	lda Lc4e5
	sta $fa
	lda Lc4e6
	sta $fb
	lda Lc4e7
	sta $fc
	rts
	
Lc4e2
	.byte $00
Lc4e3
	.byte $00
Lc4e4
	.byte $00
Lc4e5
	.byte $00
Lc4e6
	.byte $00
Lc4e7
	.byte $00
Lc4e8
	lda Lcf8a
	ora Lcf8b
	bne Lc4f6
	jsr Sc808
	jmp Lc74c
	
Lc4f6
	sec
	lda Lcf91
	sbc #$01
	sta Lcf91
	lda Lcf92
	sbc #$00
	sta Lcf92
	inc Lcf85
	jsr Scb2c
	bcc Lc543
Lc50f
	ldx #$23
	ldy #$c5
	jsr Sc0b6
	lda $01
	ora #$01
	sta $01
	jsr Sc4c3
	clc
	jmp Lcb0b
	
Lc523
	.text "{return}program too large to renumber{return}"
	.byte $00
Lc543
	lda $f9
	sec
	sbc $f7
	sta Lcf9d
	lda $fa
	sbc $f8
	sta Lcf9e
	inc $f7
	jsr Sc7dd
	ldy #$00
Lc559
	lda ($f9),y
	sta ($f7),y
	iny
	bne Lc559
	inc $fa
	inc $f8
	lda $fa
	cmp #$a0
	bne Lc559
	tya
	clc
	adc $f7
	sta Lcfa1
	lda #$00
	adc $f8
	sta Lcfa2
	lda Lcfa1
	sec
	sbc #$01
	sta Lcfa1
	lda Lcfa2
	sbc #$00
	sta Lcfa2
	jsr Sc9b0
	lda #$01
	sta $2b
	lda #$08
	sta $2c
	lda Lcf8f
	sta $f7
	lda Lcf90
	sta $f8
	ldy #$00
	lda Lcf8a
	sta Lcf93
	lda Lcf8b
	sta Lcf94
Lc5ac
	sec
	lda ($f7),y
	sbc Lcf9d
	sta ($f7),y
	iny
	lda ($f7),y
	sbc Lcf9e
	sta ($f7),y
	lda #$05
	jsr Sc7d1
	dey
	dec Lcf93
	lda Lcf93
	ora Lcf94
	beq Lc5da
	lda Lcf93
	cmp #$ff
	bne Lc5ac
	dec Lcf94
	jmp Lc5ac
	
Lc5da
	jsr Sce64
	bcc Lc5e7
	lda #$ff
	sta Lcfa3
	jmp Lc6df
	
Lc5e7
	lda Lcf8f
	sta $f7
	lda Lcf90
	sta $f8
	lda Lcf8a
	sta $22
	lda Lcf8b
	sta $23
Lc5fb
	ldy #$00
	lda ($f7),y
	sta $f9
	iny
	lda ($f7),y
	sta $fa
	iny
	lda ($f7),y
	tax
	iny
	lda ($f7),y
	sta Lcf9d
	iny
	lda ($f7),y
	sta Lcf9e
	ldy #$00
	txa
	sec
	sbc Lcf8e
	beq Lc62a
	bcc Lc62a
	tax
	lda #$30
Lc624
	sta ($f9),y
	iny
	dex
	bne Lc624
Lc62a
	ldx Lcf8e
	jsr Sc633
	jmp Lc688
	
Sc633
	cpx #$05
	beq Lc63e
	cpx #$04
	beq Lc649
	jmp Lc654
	
Lc63e
	lda #$10
	sta $fb
	lda #$27
	sta $fc
	jsr Sc697
Lc649
	lda #$e8
	sta $fb
	lda #$03
	sta $fc
	jsr Sc697
Lc654
	lda #$64
	sta $fb
	lda #$00
	sta $fc
	lda #$30
	sta ($f9),y
	lda Lcf9e
	iny
	cmp #$00
	bne Lc66f
	lda Lcf9d
	cmp #$64
	bcc Lc679
Lc66f
	dey
	jsr Sc697
	jmp Lc679
	
Lc676
	jsr Lc6a6
Lc679
	lda #$0a
	sta $fb
	lda #$00
	sta $fc
	jsr Sc697
	jsr Sc6d3
	rts
	
Lc688
	jsr Sc7ef
	ora $22
	beq Lc6dc
	lda #$05
	jsr Sc7d1
	jmp Lc5fb
	
Sc697
	lda #$30
	sta ($f9),y
	lda Lcf9e
	iny
	cmp $fc
	bcc Lc6d2
	dey
	bcs Lc6ad
Lc6a6
	lda #$01
	clc
	adc ($f9),y
	sta ($f9),y
Lc6ad
	sec
	lda Lcf9d
	sbc $fb
	sta Lcf9d
	lda Lcf9e
	sbc $fc
	sta Lcf9e
	bcs Lc6a6
	iny
	clc
	lda $fb
	adc Lcf9d
	sta Lcf9d
	lda $fc
	adc Lcf9e
	sta Lcf9e
Lc6d2
	rts
	
Sc6d3
	lda #$30
	clc
	adc Lcf9d
	sta ($f9),y
	rts
	
Lc6dc
	jmp Lc6e4
	
Lc6df
	lda #$ff
	sta Lcfa6
Lc6e4
	lda #$01
	sta $f7
	sta $f9
	lda #$08
	sta $f8
	sta $fa
	lda Lcf8f
	sta $fb
	lda Lcf90
	sta $fc
Lc6fa
	ldy #$00
	lda ($fb),y
	tax
	lda ($f7),y
	sta ($f9),y
	cpx $f7
	bne Lc72f
	iny
	lda ($fb),y
	dey
	cmp $f8
	bne Lc72f
	lda #$05
	clc
	adc $fb
	sta $fb
	lda $fc
	adc #$00
	sta $fc
	lda ($f7),y
	cmp #$30
	bne Lc72f
Lc722
	iny
	lda ($f7),y
	cmp #$30
	beq Lc722
	tya
	jsr Sc7d1
	bne Lc6fa
Lc72f
	jsr Sc7cb
	cmp Lcfa2
	beq Lc73a
	jmp Lc7c5
	
Lc73a
	lda $f7
	cmp Lcfa1
	beq Lc744
	jmp Lc7c5
	
Lc744
	jsr Sc808
	lda Lcfa3
	bne Lc7a6
Lc74c
	lda #$01
	sta $22
	lda #$08
	sta $23
	lda Lc14c
	sec
	sbc Lc14a
	sta Lcf9f
	lda Lc14d
	sbc Lc14b
	sta Lcfa0
Lc767
	ldy #$00
	lda ($22),y
	sta $f9
	iny
	lda ($22),y
	sta $fa
	ldy #$03
	jsr Sc302
	bcc Lc796
	lda Lc14a
	clc
	adc Lcf9f
	sta Lcf9f
	lda Lc14b
	adc Lcfa0
	sta Lcfa0
	ldy #$03
	sta ($22),y
	dey
	lda Lcf9f
	sta ($22),y
Lc796
	lda $f9
	ora $fa
	beq Lc7a6
	lda $f9
	sta $22
	lda $fa
	sta $23
	bne Lc767
Lc7a6
	lda Lcfa6
	beq Lc7c1
	ldx #$b2
	ldy #$c7
	jmp Lc486
	
Lc7b2
	.text "{return}?unknown line"
	.byte $00
Lc7c1
	clc
	jmp Lc831
	
Lc7c5
	jsr Sc7dd
	jmp Lc6fa
	
Sc7cb
	lda #$01
	jsr Sc7d1
	rts
	
Sc7d1
	clc
	adc $f7
	sta $f7
	lda $f8
	adc #$00
	sta $f8
	rts
	
Sc7dd
	lda #$01
	jsr Sc7e3
	rts
	
Sc7e3
	clc
	adc $f9
	sta $f9
	lda $fa
	adc #$00
	sta $fa
	rts
	
Sc7ef
	lda $22
	sec
	sbc #$01
	sta $22
	lda $23
	sbc #$00
	sta $23
	rts
	
Lc7fd
	.text "list00000{return}"
	.byte $00
Sc808
	lda #$01
	sta $2b
	lda #$08
	sta $2c
	jsr Sc9b0
	lda #$01
	sta $2b
	lda #$08
	sta $2c
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
	rts
	
Lc831
	lda $01
	ora #$01
	sta $01
	lda #$00
	sta Lca15
	sta Lca16
	sta Lca19
	lda #$01
	sta $2b
	lda #$08
	sta $2c
	jsr Sc9b0
	lda #$01
	sta $2b
	lda #$08
	sta $2c
	lda Lca19
	bne Lc881
	jsr Sc808
	jsr Sc4c3
	clc
	jmp Lcb0b
	
Lc864
	.text "{return}re-ordering displaced lines"
	.byte $00
Lc881
	ldx #$64
	ldy #$c8
	jsr Sc0b6
	lda $22
	clc
	adc #$02
	sta $f7
	lda $23
	adc #$00
	sta $f8
	lda #$00
	sec
	sbc #$01
	sta $f9
	lda #$a0
	sbc #$00
	sta $fa
	ldy #$00
Lc8a4
	lda ($f7),y
	sta ($f9),y
	jsr Scd5c
	jsr Scd4a
	lda $f8
	cmp #$07
	bne Lc8a4
	jsr Sc7dd
	jsr Sc7dd
	lda $f9
	sta $f7
	lda $fa
	sta $f8
	lda #$03
	sta $2d
	sta $2f
	sta $31
	lda #$08
	sta $2e
	sta $30
	sta $32
	lda #$00
	sta $0801
	sta $0802
Lc8da
	jsr Sca42
	ldx #$ff
	ldy #$01
	stx $7a
	sty $7b
	ldx #$ff
	stx $3a
	jsr Sca1a
	jsr bFNDLIN
	bcc Lc935
	ldy #$01
	lda ($5f),y
	sta $23
	lda $2d
	sta $22
	lda $60
	sta $25
	lda $5f
	dey
	sbc ($5f),y
	clc
	adc $2d
	sta $2d
	sta $24
	lda $2e
	adc #$ff
	sta $2e
	sbc $60
	tax
	sec
	lda $5f
	sbc $2d
	tay
	bcs Lc91f
	inx
	dec $25
Lc91f
	clc
	adc $22
	bcc Lc927
	dec $23
	clc
Lc927
	lda ($22),y
	sta ($24),y
	iny
	bne Lc927
	inc $23
	inc $25
	dex
	bne Lc927
Lc935
	jsr Sc98b
	jsr Sc9b0
	lda Lca41
	beq Lc948
	lda #$01
	sta $2b
	lda #$08
	sta $2c
Lc948
	lda LTK_Command_Buffer
	bne Lc950
	jmp Lc8da
	
Lc950
	clc
	lda $2d
	sta $5a
	adc $0b
	sta $58
	ldy $2e
	sty $5b
	bcc Lc960
	iny
Lc960
	sty $59
	jsr bBLTU
	lda $14
	ldy $15
	sta $01fe
	sty $01ff
	lda $31
	ldy $32
	sta $2d
	sty $2e
	ldy $0b
	dey
Lc97a
	lda $01fc,y
	sta ($5f),y
	dey
	bpl Lc97a
	jsr Sc98b
	jsr Sc9b0
	jmp Lc8da
	
Sc98b
	jsr bSTXPT
	lda $37
	ldy $38
	sta $33
	sty $34
	lda $2d
	ldy $2e
	sta $2f
	sty $30
	sta $31
	sty $32
	jsr bRESTOR
	ldx #$19
	stx $16
	lda #$00
	sta $3e
	sta $10
	rts
	
Sc9b0
	lda $2b
	ldy $2c
	sta $22
	sty $23
	clc
Lc9b9
	ldy #$01
	lda $22
	sta $2b
	lda $23
	sta $2c
	lda ($22),y
	beq Lca14
	lda Lca15
	sta Lca17
	lda Lca16
	sta Lca18
	ldy #$02
	lda ($22),y
	sta Lca15
	iny
	lda ($22),y
	php
	sta Lca16
	cmp Lca18
	bcc Lc9f2
	bne Lc9f7
	lda Lca15
	cmp Lca17
	bcc Lc9f2
	bne Lc9f7
Lc9f2
	lda #$ff
	sta Lca19
Lc9f7
	plp
	iny
Lc9f9
	iny
	lda ($22),y
	bne Lc9f9
	iny
	tya
	adc $22
	tax
	ldy #$00
	sta ($22),y
	lda $23
	adc #$00
	iny
	sta ($22),y
	stx $22
	sta $23
	bcc Lc9b9
Lca14
	rts
	
Lca15
	.byte $00
Lca16
	.byte $00
Lca17
	.byte $00
Lca18
	.byte $00
Lca19
	.byte $00
Sca1a
	php
	pha
	lda #$00
	sta Lca41
	lda $15
	cmp Lca16
	bcc Lca33
	bne Lca3e
	lda $14
	cmp Lca15
	bcc Lca33
	bne Lca3e
Lca33
	lda #$01
	sta $2b
	lda #$08
	sta $2c
	sta Lca41
Lca3e
	pla
	plp
	rts
	
Lca41
	.byte $00
Sca42
	ldy #$01
	lda ($f7),y
	beq Lca77
	sty $fa
	lda #$fc
	sta $f9
	iny
	lda ($f7),y
	sta $14
	iny
	lda ($f7),y
	sta $15
	iny
Lca59
	lda ($f7),y
	sta ($f9),y
	beq Lca62
	iny
	bne Lca59
Lca62
	iny
	tya
	clc
	adc $f7
	sta $f7
	lda $f8
	adc #$00
	sta $f8
	sty $0b
	lda #$2e
	jsr CHROUT
	rts
	
Lca77
	pla
	pla
	lda #$01
	sta $2b
	lda #$08
	sta $2c
	lda #$ff
	sta $7a
	lda #$01
	sta $7b
	lda #$00
	sta LTK_Command_Buffer
	sta $0b
	jsr Sc4c3
	jmp Lcb0b
	
Sca96
	lda #$0d
	jsr CHROUT
	lda Lcf9f
	sta $14
	lda Lcfa0
	sta $15
	jsr bFNDLIN
	ldx $14
	lda $15
	jsr $bdcd
	lda #$20
	jsr CHROUT
	ldy #$04
Lcab6
	lda ($5f),y
	beq Lcac0
	jsr Scac6
	iny
	bne Lcab6
Lcac0
	lda #$0d
	jsr CHROUT
	rts
	
Scac6
	sty Lcf9d
	cmp #$22
	bne Lcad7
	pha
	lda $0f
	eor #$ff
	sta $0f
	pla
	bne Lcadf
Lcad7
	ora #$00
	bmi Lcae6
	bpl Lcadf
Lcadd
	and #$7f
Lcadf
	jsr CHROUT
	ldy Lcf9d
	rts
	
Lcae6
	cmp #$ff
	beq Lcadf
	bit $0f
	bmi Lcadf
	sec
	sbc #$7f
	tax
	ldy #$ff
Lcaf4
	dex
	beq Lcaff
Lcaf7
	iny
	lda bRESLST,y
	bpl Lcaf7
	bmi Lcaf4
Lcaff
	iny
	lda bRESLST,y
	bmi Lcadd
	jsr CHROUT
	jmp Lcaff
	
Lcb0b
	jsr LTK_Krn_BankOut
Lcb0e
	clc
	jmp LTK_MemSwapOut 
	
Lcb12
	.text "{return}{rvs on}not needed in c128 mode"
	.byte $00
Scb2c
	lda #$05
	sta Lcf8e
	tay
	tax
	lda Lcf8b
Lcb36
	dey
	beq Lcb40
	clc
	adc Lcf8b
	jmp Lcb36
	
Lcb40
	sta Lcf96
	txa
	tay
	lda Lcf8a
Lcb48
	dey
	beq Lcb56
	clc
	adc Lcf8a
	bcc Lcb48
	inc Lcf96
	bne Lcb48
Lcb56
	sta Lcf95
	lda #$a0
	sec
	sbc Lcf89
	sta Lcf98
	sec
	lda #$00
	sbc Lcf88
	sta Lcf97
	bcs Lcb70
	dec Lcf98
Lcb70
	lda Lcf97
	clc
	adc Lcf8c
	sta Lcf99
	lda Lcf98
	adc Lcf8d
	sta Lcf9a
	lda Lcf9a
	sec
	sbc Lcf96
	bcs Lcb9c
	beq Lcb93
Lcb8e
	sec
	rts
	
	.byte $18,$90,$fc 
Lcb93
	lda Lcf99
	sec
	sbc Lcf95
	bcc Lcb8e
Lcb9c
	jsr Sc7cb
	lda #$ff
	sta $f9
	lda #$9f
	sta $fa
	lda Lcf9b
	sec
	sbc #$05
	sta $fb
	lda Lcf9c
	sbc #$00
	sta $fc
Lcbb6
	ldy #$00
	lda ($f7),y
	sta ($f9),y
	lda $f7
	cmp ($fb),y
	bne Lcc21
	lda $f8
	iny
	cmp ($fb),y
	bne Lcc21
	iny
	lda ($fb),y
	ldy #$00
	tax
	beq Lcbdb
Lcbd1
	jsr Scd43
	lda ($f7),y
	sta ($f9),y
	dex
	bne Lcbd1
Lcbdb
	ldy #$02
	lda Lcf8e
	sec
	sbc ($fb),y
	beq Lcbf4
	bcc Lcbf4
	tax
	lda #$30
	ldy #$00
Lcbec
	jsr Scd4a
	sta ($f9),y
	dex
	bne Lcbec
Lcbf4
	ldy #$02
	lda ($fb),y
	tay
	jsr Scd6e
	ldy #$03
	lda Lcf9f
	sta ($fb),y
	iny
	lda Lcfa0
	sta ($fb),y
	ldy #$00
	lda $f9
	sta ($fb),y
	lda $fa
	iny
	sta ($fb),y
	sec
	lda $fb
	sbc #$05
	sta $fb
	lda $fc
	sbc #$00
	sta $fc
Lcc21
	jsr Scd43
	lda $f7
	bne Lcbb6
	lda $f8
	cmp #$08
	bne Lcbb6
	clc
	rts
	
Scc30
	lda ($f7),y
	cmp #$a7
	bne Lcc52
	jsr Sccdc
	ora #$00
	bmi Lcc50
	jsr Sccd0
	bcs Lcc52
	jsr Scce4
Lcc45
	iny
	jsr Scc54
	jsr Sccd0
	bcs Lcc50
	bcc Lcc45
Lcc50
	lda #$00
Lcc52
	clc
	rts
	
Scc54
	php
	pha
	tya
	pha
	ldy #$02
	inc Lcf8c
	bne Lcc62
	inc Lcf8d
Lcc62
	lda #$01
	clc
	adc ($f9),y
	sta ($f9),y
	dey
	dey
	lda #$01
	adc ($f9),y
	sta ($f9),y
	bne Lcc7b
	iny
	lda #$01
	clc
	adc ($f9),y
	sta ($f9),y
Lcc7b
	pla
	tay
	pla
	plp
	rts
	
Scc80
	lda #$89
	sta $cc88
Lcc85
	lda ($f7),y
	cmp #$89
	bne Lccc5
	jsr Sccdc
	ora #$00
	bne Lcc97
Lcc92
	jsr Scce4
	bne Lccc5
Lcc97
	cmp #$3a
	beq Lcc92
	jsr Sccd0
	bcs Lccc2
	jsr Scce4
Lcca3
	jsr Scc54
	iny
Lcca7
	jsr Sccd0
	bcc Lcca3
	ora #$00
	beq Lccc5
	cmp #$3a
	beq Lccc5
	cmp #$20
	beq Lcca3
	cmp #$2c
	bne Lccc2
	iny
	jsr Scce4
	bne Lcca7
Lccc2
	sec
	bcs Lccc8
Lccc5
	lda #$00
	clc
Lccc8
	rts
	
Sccc9
	lda #$8d
	sta $cc88
	bne Lcc85
Sccd0
	lda ($f7),y
	cmp #$30
	bcc Lccda
	cmp #$3a
	bcc Lccdb
Lccda
	sec
Lccdb
	rts
	
Sccdc
	iny
	lda ($f7),y
	cmp #$20
	beq Sccdc
	rts
	
Scce4
	lda Lcf85
	bne Lcd3a
	lda Lcf9b
	sta $f9
	lda Lcf9c
	sta $fa
	lda #$05
	clc
	adc Lcf9b
	sta Lcf9b
	lda #$00
	adc Lcf9c
	sta Lcf9c
	lda Lcf9c
	cmp #$c4
	bcc Lcd16
	bne Lcd3b
	lda Lcf9b
	cmp #$0f
	bcc Lcd16
	bne Lcd3b
Lcd16
	tya
	pha
	tya
	clc
	adc $f7
	sta Lcf9d
	lda #$00
	ldy #$02
	sta ($f9),y
	adc $f8
	dey
	sta ($f9),y
	dey
	lda Lcf9d
	sta ($f9),y
	inc Lcf8a
	bne Lcd38
	inc Lcf8b
Lcd38
	pla
	tay
Lcd3a
	rts
	
Lcd3b
	pla
	pla
	pla
	pla
	pla
	jmp Lc50f
	
Scd43
	jsr Scd4a
	jsr Scd5c
	rts
	
Scd4a
	php
	pha
	sec
	lda $f9
	sbc #$01
	sta $f9
	lda $fa
	sbc #$00
	sta $fa
	pla
	plp
	rts
	
Scd5c
	php
	pha
	sec
	lda $f7
	sbc #$01
	sta $f7
	lda $f8
	sbc #$00
	sta $f8
	pla
	plp
	rts
	
Scd6e
	tya
	cmp Lcf8e
	bpl Lcd77
	ldy Lcf8e
Lcd77
	sty Lc153
	sec
	lda #$cd
	sbc Lc153
	sta $2d
	lda #$cd
	sbc #$00
	sta $2e
	lda #$00
	sta Lcf9f
	sta Lcfa0
Lcd90
	dey
	bmi Lcdc1
	lda ($f9),y
	sec
	sbc #$30
	tax
	beq Lcdb1
Lcd9b
	lda ($2d),y
	clc
	adc Lcf9f
	sta Lcf9f
	iny
	lda ($2d),y
	adc Lcfa0
	sta Lcfa0
	dey
	dex
	bne Lcd9b
Lcdb1
	lda $2d
	sec
	sbc #$01
	sta $2d
	lda $2e
	sbc #$00
	sta $2e
	jmp Lcd90
	
Lcdc1
	rts
	
Lcdc2
	.byte $00
Lcdc3
	.byte $00
Lcdc4
	.byte $10 
Lcdc5
	.byte $27 
Lcdc6
	.byte $e8 
Lcdc7
	.byte $03 
Lcdc8
	.byte $64 
Lcdc9
	.byte $00
Lcdca
	.byte $0a 
Lcdcb
	.byte $00
Lcdcc
	.byte $01 
Lcdcd
	.byte $00
Scdce
	php
	pha
	txa
	pha
	tya
	pha
	lda $f7
	sta Lcfa4
	lda $f8
	sta Lcfa5
	ldy #$02
	lda ($f7),y
	tax
	iny
	lda ($f7),y
	ldy #$01
	sta ($22),y
	sta Lce63
	dey
	txa
	sta ($22),y
	sta Lce62
	iny
	lda $22
	sta Lce5f
	lda $23
	sta Lce60
	lda $f7
	sta $22
	lda $f8
	sta $23
	sty Lce61
	ldy #$03
	jsr Sc302
	ldy Lce61
	lda Lce5f
	sta $22
	lda Lce60
	sta $23
	lda Lce62
	iny
	sta ($22),y
	iny
	lda Lce63
	sta ($22),y
	dey
	bcc Lce43
	lda Lc14a
	clc
	adc Lcf86
	sta Lcf86
	sta ($22),y
	lda Lc14b
	adc Lcf87
	iny
	sta ($22),y
	sta Lcf87
Lce43
	inc Lcf91
	bne Lce4b
	inc Lcf92
Lce4b
	lda #$04
	clc
	adc $22
	sta $22
	lda #$00
	adc $23
	sta $23
	pla
	tay
	pla
	tax
	pla
	plp
	rts
	
Lce5f
	.byte $00
Lce60
	.byte $00
Lce61
	.byte $00
Lce62
	.byte $00
Lce63
	.byte $00
Sce64
	lda Lcf8f
	sta $f9
	lda Lcf90
	sta $fa
	lda Lcf8a
	sta $22
	lda Lcf8b
	sta $23
Lce78
	ldy #$03
	lda ($f9),y
	sta Lcf9d
	iny
	lda ($f9),y
	sta Lcf9e
	ldx #$10
	lda Lcf91
	and #$fe
	clc
	rol a
	sta $fb
	lda Lcf92
	rol a
	sta $fc
	lda #$00
	sta $f7
	lda #$a0
	sta $f8
	lda $fb
	clc
	adc $f7
	sta $f7
	lda $fc
	adc $f8
	sta $f8
Lceab
	ldy #$01
	lda ($f7),y
	cmp Lcf9e
	beq Lcebc
	bcc Lceb9
	jmp Lcf59
	
Lceb9
	jmp Lcf43
	
Lcebc
	ldy #$00
	lda ($f7),y
	cmp Lcf9d
	beq Lceca
	bcc Lcf43
	jmp Lcf59
	
Lceca
	ldy #$02
	lda ($f7),y
	iny
	sta ($f9),y
	lda ($f7),y
	iny
	sta ($f9),y
	lda #$05
	clc
	adc $f9
	sta $f9
	lda #$00
	adc $fa
	sta $fa
	lda $22
	sec
	sbc #$01
	sta $22
	lda $23
	sbc #$00
	sta $23
	ora $22
	beq Lcef7
	jmp Lce78
	
Lcef7
	clc
	bcc Lcf42
Lcefa
	ldy #$00
	lda ($f9),y
	sta $f7
	iny
	lda ($f9),y
	sta $f8
	dey
Lcf06
	jsr Scd5c
	lda ($f7),y
	bne Lcf06
	lda $f7
	sta $f9
	lda $f8
	sta $fa
	jsr Scd5c
	jsr Scd5c
	jsr Scd5c
	jsr Scd5c
	lda ($f7),y
	beq Lcf2c
	jsr Sc7cb
	lda ($f7),y
	bne Lcf34
Lcf2c
	lda $f7
	sta $f9
	lda $f8
	sta $fa
Lcf34
	ldy #$03
	lda ($f9),y
	sta Lcf9f
	iny
	lda ($f9),y
	sta Lcfa0
	sec
Lcf42
	rts
	
Lcf43
	jsr Scf6f
	clc
	lda $fb
	adc $f7
	sta $f7
	lda $fc
	adc $f8
	sta $f8
	dex
	beq Lcefa
	jmp Lceab
	
Lcf59
	jsr Scf6f
	sec
	lda $f7
	sbc $fb
	sta $f7
	lda $f8
	sbc $fc
	sta $f8
	dex
	beq Lcefa
	jmp Lceab
	
Scf6f
	lda $fc
	clc
	ror a
	sta $fc
	lda $fb
	ror a
	and #$fc
	sta $fb
	ora $fc
	bne Lcf84
	lda #$04
	sta $fb
Lcf84
	rts
	
Lcf85
	.byte $00
Lcf86
	.byte $00
Lcf87
	.byte $00
Lcf88
	.byte $00
Lcf89
	.byte $00
Lcf8a
	.byte $00
Lcf8b
	.byte $00
Lcf8c
	.byte $00
Lcf8d
	.byte $00
Lcf8e
	.byte $00
Lcf8f
	.byte $10 
Lcf90
	.byte $a0 
Lcf91
	.byte $00
Lcf92
	.byte $00
Lcf93
	.byte $00
Lcf94
	.byte $00
Lcf95
	.byte $00
Lcf96
	.byte $00
Lcf97
	.byte $00
Lcf98
	.byte $00
Lcf99
	.byte $00
Lcf9a
	.byte $00
Lcf9b
	.byte $00
Lcf9c
	.byte $00
Lcf9d
	.byte $00
Lcf9e
	.byte $00
Lcf9f
	.byte $00
Lcfa0
	.byte $00
Lcfa1
	.byte $00
Lcfa2
	.byte $00
Lcfa3
	.byte $00
Lcfa4
	.byte $00
Lcfa5
	.byte $00
Lcfa6
	.byte $00
