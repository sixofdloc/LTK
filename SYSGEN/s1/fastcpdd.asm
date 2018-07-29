;fastcpdd.r.prg
 
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
	stx Lc74f
	lda $95e6
	sta Lc7d0
Lc015
	ldx #$48
	jsr Sc753
	ldx #$00
	cmp #$4e
	beq Lc02c
	dex
	cmp #$59
	beq Lc02c
	cmp #$51
	bne Lc015
	jmp Lc52d
	
Lc02c
	stx Lc752
	ldx #$43
	jsr Sc753
	dey
	sty Lc749
	jsr LTK_ClearHeaderBlock 
	ldy #$00
	sty Lc74a
	cpy Lc749
	bcc Lc048
	jmp Lc52d
	
Lc048
	lda LTK_MiscWorkspace,y
	cmp #$22
	bne Lc050
	iny
Lc050
	ldx Lc749
	lda $8fdf,x
	cmp #$22
	bne Lc05d
	dec Lc749
Lc05d
	cpy Lc749
	bcc Lc065
	jmp Lc52d
	
Lc065
	sty Lc74a
	jsr Sc792
	bcc Lc073
	cmp #$3a
	beq Lc080
	bne Lc09d
Lc073
	txa
	jsr LTK_SetLuActive 
	bcc Lc080
	jsr Sc7c4
	ldx #$0a
	bne Lc08e
Lc080
	jsr Sc792
	bcs Lc09d
	cpx #$10
	bcc Lc09a
	jsr Sc7c4
	ldx #$0b
Lc08e
	jsr $6c00
	jsr Sc92e
	jsr Sc5bc
	jmp Lc015
	
Lc09a
	stx LTK_Var_Active_User
Lc09d
	ldy Lc74a
	ldx #$00
Lc0a2
	cpy Lc749
	bcs Lc0b1
	lda LTK_MiscWorkspace,y
	sta LTK_FileHeaderBlock ,x
	inx
	iny
	bne Lc0a2
Lc0b1
	jsr LTK_FindFile 
	bcc Lc0b9
	jmp Lc1a2
	
Lc0b9
	lda $9201
	ldy $9200
	clc
	adc #$02
	bcc Lc0c5
	iny
Lc0c5
	sta Lc748
	sty Lc747
	ldy #$00
	lda $91f0
	cmp #$02
	bne Lc0dc
	lda $91f1
	cmp #$ad
	bne Lc0dc
	dey
Lc0dc
	sty $1c9c
	jsr Sc52e
	cpy $91f0
	bne Lc0ec
	cpx $91f1
	beq Lc0fd
Lc0ec
	jsr $1c98
	jsr Sc7c4
	jsr Sc92e
	ldx #$46
	jsr Sc783
	jmp Lc015
	
Lc0fd
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	inx
	bne Lc10a
	iny
Lc10a
	clc
	jsr LTK_HDDiscDriver 
    .byte $00,$68,$01 
Lc111
	ldx #$52
	jsr $6c00
	lda $6800
	beq Lc14c
	ldx #$00
	ldy #$68
	jsr LTK_Print 
	ldx #$d4
	ldy #$c7
	jsr LTK_Print 
	ldx #$20
	ldy #$68
	jsr LTK_Print 
	ldx #$e7
	ldy #$c7
	jsr LTK_Print 
	ldx #$40
	ldy #$68
	jsr LTK_Print 
	ldx #$fa
	ldy #$c7
	jsr LTK_Print 
	ldx #$60
	ldy #$68
	jsr LTK_Print 
Lc14c
	ldx #$47
	jsr Sc783
	cmp #$51
	bne Lc158
Lc155
	jmp Lc015
	
Lc158
	cmp #$44
	bne Lc15f
	jmp Lc3d9
	
Lc15f
	cmp #$53
	bne Lc0fd
	ldx #$45
	jsr Sc783
Lc168
	jsr $1c95
	jsr $1c62
	bcc Lc18f
Lc170
	jsr Sc7be
	jsr Sc92e
	jsr $1c98
	ldx #$2e
	jsr Sc783
	cmp #$51
	beq Lc155
	cmp #$52
	bne Lc170
	jsr $1c95
	jsr Sc67d
	jmp Lc168
	
Lc18f
	jsr Sc52e
	cpy $91f0
	bne Lc19f
	cpx $91f1
	bne Lc19f
	jmp Lc24a
	
Lc19f
	jmp Lc0ec
	
Lc1a2
	sta Lc74b
	stx Lc74d
	sty Lc74c
Lc1ab
	ldx #$44
	jsr Sc753
	cmp #$4e
	bne Lc1b7
Lc1b4
	jmp Lc015
	
Lc1b7
	cmp #$59
	bne Lc1ab
	ldx #$45
	jsr Sc783
Lc1c0
	jsr $1c95
	jsr $1c62
	bcc Lc1e7
Lc1c8
	jsr Sc7be
	jsr Sc92e
	jsr $1c98
	ldx #$2e
	jsr Sc783
	cmp #$51
	beq Lc1b4
	cmp #$52
	bne Lc1c8
	jsr $1c95
	jsr Sc67d
	jmp Lc1c0
	
Lc1e7
	jsr Sc52e
	stx $91f1
	sty $91f0
	lda #$05
	sta $91f8
	jsr LTK_AllocContigBlks 
	bcc Lc205
	jsr $1c98
	ldx #$41
	jsr Sc783
	jmp Lc015
	
Lc205
	lda $9201
	ldy $9200
	clc
	adc #$02
	bcc Lc211
	iny
Lc211
	sty Lc745
	sta Lc746
	sta Lc748
	sty Lc747
	lda Lc74b
	pha
	ldx Lc74d
	ldy Lc74c
	lda #$24
	jsr LTK_ExeExtMiniSub 
	jsr Sc6a1
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
    jsr LTK_HDDiscDriver
	.byte $e0,$91,$01 
Lc23f               
    inx
    bne Lc243
    iny
Lc243
    sec
	jsr LTK_HDDiscDriver 
	.byte $00,$68,$01 
Lc24a
	lda #$8c
	sta Sc50c + 1
	lda #$1c
	sta Sc50c + 2
	lda #$38
	sta Lc51d
	lda #$00
	sta $1c56
	sta $1c57
	sta Lc743
	sta Lc744
	lda Lc748
	sta Lc746
	lda Lc747
	sta Lc745
	jsr $1c95
	jsr Sc5e8
	jsr Sc6a1
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	inx
	bne Lc289
	iny
Lc289
	sec
	jsr LTK_HDDiscDriver 
	.byte $00,$68,$01 
Lc290
	jsr Sc575
	bne Lc298
	jmp Lc353
	
Lc298
	lda #$02
	sta Lc511
	lda #$65
	sta Lc512
	lda $1c56
	sta Lc6c0
	sta Lc50f
	lda $1c57
	sta Lc6c1
	sta Lc510
	lda #$ff
	sta Lc6e3
	jsr Sc50c
	bcc Lc2c8
	jsr Sc616
	php
	jsr Sc5e8
	plp
	bcc Lc298
Lc2c8
	lda $6600
	sta $6500
	lda $6601
	sta $6501
	jsr Sc575
	beq Lc336
Lc2d9
	lda #$02
	sta Lc511
	lda #$66
	sta Lc512
	lda $1c56
	sta Lc6e3
	lda $1c57
	sta Lc6e4
	jsr Sc50c
	bcc Lc2fe
	jsr Sc616
	php
	jsr Sc5e8
	plp
	bcc Lc2d9
Lc2fe
	lda $6700
	sta $6600
	lda $6701
	sta $6601
	jsr Sc514
	bit Lc752
	bmi Lc315
Lc312
	jmp Lc290
	
Lc315
	jsr Sc6b1
	bcc Lc312
	jsr Sc612
	php
	jsr Sc5e8
	plp
	bcs Lc312
	jsr Sc599
	lda Lc6c0
	sta $1c56
	lda Lc6c1
	sta $1c57
	jmp Lc298
	
Lc336
	jsr Sc514
	bit Lc752
	bpl Lc353
	jsr Sc6b1
	bcc Lc353
	jsr Sc612
	php
	jsr Sc5e8
	plp
	bcs Lc353
	jsr Sc599
	jmp Lc298
	
Lc353
	lda $1c4c
	ldy $1c4d
	clc
	adc #$04
	bcc Lc35f
	iny
Lc35f
	ldx $95e6
	cpx #$38
	beq Lc36c
	clc
	adc #$8c
	bcc Lc36c
	iny
Lc36c
	sta Lc377 + 1
	sty Lc377 + 2
	jsr Sc6a1
	ldy #$0f
Lc377
	lda Lc377,y
	sta $6800,y
	dey
	bpl Lc377
	jsr Sc7be
	jsr $1c98
	jsr Sc92e
Lc389
	ldx #$53
	jsr Sc753
	bcs Lc389
	cpy #$0a
	bcs Lc389
	ldy #$00
Lc396
	lda LTK_MiscWorkspace,y
	cmp #$0d
	beq Lc3a3
	sta $6820,y
	iny
	bne Lc396
Lc3a3
	ldx #$54
	jsr Sc753
	bcs Lc3a3
	ldy #$00
Lc3ac
	lda LTK_MiscWorkspace,y
	cmp #$0d
	beq Lc3b9
	sta $6840,y
	iny
	bne Lc3ac
Lc3b9
	lda #$59
	bit Lc752
	bmi Lc3c2
	lda #$4e
Lc3c2
	sta $6860
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	inx
	bne Lc3d2
	iny
Lc3d2
	sec
	jsr LTK_HDDiscDriver 
	.byte $00,$68,$01 
Lc3d9
	jsr $1c98
	jsr Sc92e
	ldx #$23
	jsr Sc783
	cmp #$52
	beq Lc3ee
	cmp #$51
	bne Lc3d9
	beq Lc419
Lc3ee
	jsr $1c95
	jsr Sc5dd
	bit Lc74f
	bpl Lc3fe
	ldx #$29
	jsr $6c00
Lc3fe
	jsr $1c6b
	bcc Lc41c
	jsr Sc7be
	jsr $1c98
Lc409
	jsr Sc92e
	ldx #$22
	jsr Sc783
	cmp #$52
	beq Lc3ee
	cmp #$51
	bne Lc409
Lc419
	jmp Lc015
	
Lc41c
	lda Lc748
	sta Lc746
	lda Lc747
	sta Lc745
	lda #$8f
	sta Sc50c + 1
	lda #$1c
	sta Sc50c + 2
	lda #$18
	sta Lc51d
	lda #$00
	sta $1c56
	sta $1c57
	sta Lc743
	sta Lc744
	jsr Sc5fe
Lc448
	jsr Sc575
	bne Lc450
	jmp Lc4f0
	
Lc450
	jsr Sc514
Lc453
	lda #$00
	sta Lc511
	lda #$65
	sta Lc512
	lda $1c56
	sta Lc6c0
	sta Lc50f
	lda $1c57
	sta Lc6c1
	sta Lc510
	lda #$ff
	sta Lc6e3
	jsr Sc50c
	bcc Lc483
	jsr Sc619
	php
	jsr Sc5fe
	plp
	bcc Lc453
Lc483
	jsr Sc575
	beq Lc4d6
Lc488
	lda #$00
	sta Lc511
	lda #$66
	sta Lc512
	lda $1c56
	sta Lc6e3
	lda $1c57
	sta Lc6e4
	jsr Sc50c
	bcs Lc4c9
	bit Lc752
	bpl Lc448
	jsr Sc6b1
	bcc Lc448
	jsr Sc612
	php
	jsr Sc5fe
	plp
	bcs Lc448
	jsr Sc599
	lda Lc6c0
	sta $1c56
	lda Lc6c1
	sta $1c57
	jmp Lc450
	
Lc4c9
	jsr Sc619
	php
	jsr Sc5fe
	plp
	bcc Lc488
	jmp Lc448
	
Lc4d6
	bit Lc752
	bpl Lc4f0
	jsr Sc6b1
	bcc Lc4f0
	jsr Sc612
	php
	jsr Sc5fe
	plp
	bcs Lc4f0
	jsr Sc599
	jmp Lc450
	
Lc4f0
	jsr Sc7be
	jsr $1c98
	jsr Sc92e
	ldx #$51
	jsr Sc753
	cmp #$59
	bne Lc505
	jmp Lc3d9
	
Lc505
	cmp #$4e
	bne Lc4f0
	jmp Lc015
	
Sc50c
	jsr Sc50c
Lc50f
	.byte $00
	
Lc510
	.byte $00
Lc511
	.byte $00
Lc512
	.byte $00,$60 
Sc514
	lda LTK_Var_ActiveLU
	ldx Lc746
	ldy Lc745
Lc51d
	nop
	jsr LTK_HDDiscDriver 
	.byte $00,$65,$01 
Lc524
	inc Lc746
	bne Lc52c
	inc Lc745
Lc52c
	rts
	
Lc52d
	rts
	
Sc52e
	lda $95e6
	ldx #$ac
	ldy #$02
	cmp #$34
	beq Lc550
	cmp #$37
	bne Lc548
	lda $1c9c
	beq Lc550
	ldx #$57
	ldy #$05
	bne Lc550
Lc548
	cmp #$38
Lc54a
	bne Lc54a
	ldx #$81
	ldy #$0c
Lc550
	stx Lc596 + 1
	sty Lc58f + 1
	lda $95e6
	ldx #$58
	ldy #$01
	cmp #$34
	beq Lc574
	cmp #$37
	bne Lc570
	lda $1c9c
	beq Lc574
	ldx #$ad
	ldy #$02
	bne Lc574
Lc570
	ldx #$42
	ldy #$06
Lc574
	rts
	
Sc575
	jsr $1c92
	lda $1c56
	sta Lc50f
	lda $1c57
	sta Lc510
	inc Lc744
	bne Lc58c
	inc Lc743
Lc58c
	lda Lc743
Lc58f
	cmp #$00
	bne Lc598
	lda Lc744
Lc596
	cmp #$00
Lc598
	rts
	
Sc599
	lda Lc744
	sec
	sbc #$01
	sta Lc744
	lda Lc743
	sbc #$00
	sta Lc743
	lda Lc746
	sec
	sbc #$01
	sta Lc746
	lda Lc745
	sbc #$00
	sta Lc745
	rts
	
Sc5bc
	lda #$02
	bit Lc74f
	bpl Lc5c4
	asl a
Lc5c4
	sta Lc74e
Lc5c7
	lda #$00
	tax
	ldy #$02
Lc5cc
	sec
	adc #$00
	bne Lc5cc
	inx
	bne Lc5cc
	dey
	bne Lc5cc
	dec Lc74e
	bne Lc5c7
	rts
	
Sc5dd
	bit Lc74f
	bpl Lc5e7
	ldx #$2d
	jsr $6c00
Lc5e7
	rts
	
Sc5e8
	bit Lc74f
	bpl Lc5fd
	jsr Sc5dd
	ldx #$49
	jsr $6c00
	jsr Sc7b8
	ldx #$4a
	jsr $6c00
Lc5fd
	rts
	
Sc5fe
	bit Lc74f
	bpl Lc611
	jsr Sc5dd
	ldx #$50
	jsr $6c00
	jsr Sc7b8
	jsr Sc7c4
Lc611
	rts
	
Sc612
	lda #$55
	bne Lc627
Sc616
	lda #$4b
	.byte $2c 
Sc619
	lda #$4c
	ldx $1c56
	ldy $1c57
	stx Lc750
	sty Lc751
Lc627
	sta Lc630 + 1
Lc62a
	jsr Sc7be
	jsr $1c98
Lc630
	ldx #$00
	jsr $6c00
	jsr Sc65c
	jsr Sc92e
	ldx #$4f
	jsr Sc783
	cmp #$51
	bne Lc649
	pla
	pla
	jmp Lc015
	
Lc649
	cmp #$52
	beq Lc651
	cmp #$53
	bne Lc62a
Lc651
	pha
	jsr $1c95
	jsr Sc67d
	pla
	cmp #$53
	rts
	
Sc65c
	ldx #$4d
	jsr $6c00
	ldx Lc750
	jsr Sc66f
	ldx #$4e
	jsr $6c00
	ldx Lc751
Sc66f
	lda #$00
	tay
	clc
	jsr Sc88b
	ldx #$21
	ldy #$c9
	jmp LTK_Print 
	
Sc67d
	ldx #$01
	lda $1c57
	pha
	lda $1c56
	pha
	beq Lc68e
	cmp #$01
	bne Lc68e
	inx
Lc68e
	stx Lc694
	jsr $1c8c
Lc694
	.byte $00,$00,$00,$67,$68 
Lc699
	sta $1c56
	pla
Lc69d
	sta $1c57
	rts
	
Sc6a1
	lda #$00
	tay
Lc6a4
	sta $6800,y
	iny
	bne Lc6a4
Lc6aa
	sta $6900,y
	iny
	bne Lc6aa
	rts
	
Sc6b1
	lda Lc6c0
	sta Lc750
	lda Lc6c1
	sta Lc751
	jsr $1c8c
Lc6c0
	.byte $00
	
Lc6c1
	.byte $00,$02,$69,$b0,$7b 
Lc6c6
	lda $6a00
	sta $6900
	lda $6a01
	sta $6901
	lda Lc6e3
	bmi Lc6f5
	sta Lc750
	lda Lc6e4
	sta Lc751
	jsr $1c8c
Lc6e3
	.byte $00
	
Lc6e4
	.byte $00,$02,$6a,$b0,$58 
Lc6e9
	lda $6b00
	sta $6a00
	lda $6b01
	sta $6a01
Lc6f5
	lda Lc746
	sec
	sbc #$01
	tax
	lda Lc745
	sbc #$00
	tay
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$67,$01 
Lc70c
	lda Lc6c0
	sta Lc750
	lda Lc6c1
	sta Lc751
	ldy #$00
Lc71a
	lda $6700,y
	cmp $6900,y
	bne Lc741
	iny
	bne Lc71a
	lda Lc6e3
	bmi Lc73e
	sta Lc750
	lda Lc6e4
	sta Lc751
Lc733
	lda $6800,y
	cmp $6a00,y
	bne Lc741
	iny
	bne Lc733
Lc73e
	clc
	bcc Lc742
Lc741
	sec
Lc742
	rts
	
Lc743
	.byte $00
Lc744
	.byte $00
Lc745
	.byte $00
Lc746
	.byte $00
Lc747
	.byte $00
Lc748
	.byte $00
Lc749
	.byte $00
Lc74a
	.byte $00
Lc74b
	.byte $00
Lc74c
	.byte $00
Lc74d
	.byte $00
Lc74e
	.byte $00
Lc74f
	.byte $00
Lc750
	.byte $00
Lc751
	.byte $00
Lc752
	.byte $00
Sc753
	stx Lc773 + 1
	jsr $6c00
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
Lc760
	jsr LTK_KernalCall 
	sta LTK_MiscWorkspace,y
	iny
	cpy #$16
	bcs Lc770
	cmp #$0d
	bne Lc760
	clc
Lc770
	php
	tya
	pha
Lc773
	lda #$00
	ldx #$e0
	ldy #$8f
	jsr $6c03
	pla
	tay
	plp
	lda LTK_MiscWorkspace
	rts
	
Sc783
	jsr $6c00
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc78b
	jsr LTK_KernalCall 
	tax
	beq Lc78b
	rts
	
Sc792
	ldy Lc74a
	lda #$e0
	ldx #$8f
	cpy Lc749
	bcs Lc7b6
	jsr Sc80d
	php
	bcs Lc7a8
	pha
	pla
	bne Lc7b5
Lc7a8
	lda LTK_MiscWorkspace,y
	cmp #$3a
	bne Lc7b5
	iny
	sty Lc74a
	plp
	rts
	
Lc7b5
	plp
Lc7b6
	sec
	rts
	
Sc7b8
	ldx #$d0
	ldy #$c7
	bne Lc7c8
Sc7be
	ldx #$ce
	ldy #$c7
	bne Lc7c8
Sc7c4
	ldx #$cb
	ldy #$c7
Lc7c8
	jmp LTK_Print 
	
Lc7cb
	.text "{return}{return}"
	.byte $00
Lc7ce
	.text "{clr}"
	.byte $00
Lc7d0
	.byte $00
Lc7d1
	.text "1 "
	.byte $00
Lc7d4
	.text "{return}{return}creation date: {rvs on}"
	.byte $00
Lc7e7
	.text "{return}{return}descriptor   : {rvs on}"
	.byte $00
Lc7fa
	.text "{return}{return}verified file: {rvs on}"
	.byte $00
Sc80d
	sta Lc81e + 1
	stx Lc81e + 2
	lda #$00
	sta Lc888
	sta Lc889
	sta Lc88a
Lc81e
	lda Lc81e,y
	cmp #$30
	bcc Lc876
	cmp #$3a
	bcc Lc83b
	ldx Lc846 + 1
	cpx #$0a
	beq Lc876
	cmp #$41
	bcc Lc876
	cmp #$47
	bcs Lc876
	sec
	sbc #$07
Lc83b
	ldx Lc888
	beq Lc85f
	pha
	tya
	pha
	lda #$00
	tax
Lc846
	ldy #$0a
Lc848
	clc
	adc Lc88a
	pha
	txa
	adc Lc889
	tax
	pla
	dey
	bne Lc848
	sta Lc88a
	stx Lc889
	pla
	tay
	pla
Lc85f
	inc Lc888
	sec
	sbc #$30
	clc
	adc Lc88a
	sta Lc88a
	bcc Lc873
	inc Lc889
	beq Lc880
Lc873
	iny
	bne Lc81e
Lc876
	cmp #$20
	beq Lc873
	clc
	ldx Lc888
	bne Lc881
Lc880
	sec
Lc881
	lda Lc889
	ldx Lc88a
	rts
	
Lc888
	.byte $00
Lc889
	.byte $00
Lc88a
	.byte $00
Sc88b
	stx Lc91d
	sty Lc91c
	php
	pha
	lda #$30
	ldy #$04
Lc897
	sta Lc91e,y
	dey
	bpl Lc897
	pla
	beq Lc8bb
	lda Lc91d
	jsr Sc907
	sta Lc921
	stx Lc922
	lda Lc91c
	jsr Sc907
	sta Lc91f
	stx Lc920
	jmp Lc8f0
	
Lc8bb
	iny
Lc8bc
	lda Lc91c
	cmp Lc924,y
	bcc Lc8eb
	bne Lc8ce
	lda Lc91d
	cmp Lc929,y
	bcc Lc8eb
Lc8ce
	lda Lc91d
	sbc Lc929,y
	sta Lc91d
	lda Lc91c
	sbc Lc924,y
	sta Lc91c
	lda Lc91e,y
	clc
	adc #$01
	sta Lc91e,y
	bne Lc8bc
Lc8eb
	iny
	cpy #$05
	bne Lc8bc
Lc8f0
	plp
	bcc Lc906
	ldy #$00
Lc8f5
	lda Lc91e,y
	cmp #$30
	bne Lc906
	lda #$20
	sta Lc91e,y
	iny
	cpy #$04
	bne Lc8f5
Lc906
	rts
	
Sc907
	pha
	and #$0f
	jsr Sc913
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
Sc913
	cmp #$0a
	bcc Lc919
	adc #$06
Lc919
	adc #$30
	rts
	
Lc91c
	.byte $ff 
Lc91d
	.byte $ff 
Lc91e
	.byte $00
Lc91f
	.byte $00
Lc920
	.byte $00
Lc921
	.byte $00
Lc922
	.byte $00,$00 
Lc924
	.byte $27,$03,$00,$00,$00 
Lc929
	.byte $10,$e8,$64,$0a,$01 
Sc92e
	lda LTK_BeepOnErrorFlag
	beq Lc96d
	ldy #$18
	lda #$00
Lc937
	sta SID_V1_FreqLo,y
	dey
	bpl Lc937
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lc949
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Sc96e
	iny
	tya
	cmp #$10
	bne Lc949
	ldx #$50
	jsr Sc96e
	ldy #$10
	sta SID_V1_Control
Lc961
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Sc96e
	tya
	bne Lc961
Lc96d
	rts
	
Sc96e
	dec Lc977
	bne Sc96e
	dex
	bne Sc96e
	rts
	
Lc977
	.byte $00

