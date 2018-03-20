;automove.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"
	
	*=$c000 ;$4000 for sysgen
	
Lc000
	lda LTK_Var_ActiveLU
	sta Lc64b
	sta Lc654
	lda LTK_Var_Active_User
	sta Lc64c
	lda $31
	pha
	lda $32
	pha
	lda $33
	pha
	lda $34
	pha
	lda LTK_Var_CPUMode
	beq Lc03c
	lda $d7
	beq Lc045
	ldx #$4f
	stx $c2aa
	ldx #$3c
	stx $c322
	lda #$a0
	sta $c358
	sta $c387
	lsr a
	sta $c3b7
	bne Lc045
Lc03c
	lda $01
	sta $c40e
	and #$fe
	sta $01
Lc045
	lda #$00
	sta $31
	sta $33
	lda #$a0
	sta $32
	sta $34
	lda #$fe
	sta Lc64d
	ldx #$20
	lda #$ff
	sta LTK_ReadChanFPTPtr
	ldy #$00
	sty Lc64e
	sty Lc651
	sty Lc4f3
Lc068
	sta ($31),y
	iny
	bne Lc068
	inc $32
	dex
	bne Lc068
Lc072
	jsr Sc524
	ldx #$25
	ldy #$c7
	jsr Sc193
	bcc Lc081
Lc07e
	jmp Lc408
	
Lc081
	cpx #$ff
	beq Lc07e
	stx Lc654
Lc088
	ldx #$41
	ldy #$c7
	jsr Sc1ac
	bcs Lc088
	stx Lc652
	cpx #$ff
	beq Lc072
Lc098
	ldx #$58
	ldy #$c7
	jsr Sc1ac
	bcs Lc098
	stx Lc653
	cpx #$ff
	beq Lc072
	cpx Lc652
	beq Lc072
	ldx #$74
	ldy #$c7
	jsr LTK_Print 
Lc0b4
	ldx #$fb
	ldy #$c7
	jsr Sc536
	bcs Lc0ea
	ldx #$00
	cpy #$01
	beq Lc0f4
	lda #$01
	ldx #$c7
	ldy #$00
	jsr Scba8
	bcs Lc0ea
	cpx #$0b
	beq Lc0f4
	cpx #$0c
	beq Lc0f4
	cpx #$0d
	beq Lc0f4
	cpx #$0e
	beq Lc0f4
	cpx #$0f
	beq Lc0f4
	cpx #$04
	beq Lc0f4
	cpx #$05
	beq Lc0f4
Lc0ea
	ldx #$47
	ldy #$c9
	jsr Sc1c2
	jmp Lc0b4
	
Lc0f4
	stx Lc6f4
Lc0f7
	ldx #$10
	ldy #$c8
	jsr Sc536
	lda #$00
	bcs Lc0f7
	cpy #$01
	beq Lc108
	dey
	tya
Lc108
	sta Lc6f5
	ldx #$f0
	lda Lc654
	cmp #$0a
	beq Lc116
	ldx #$11
Lc116
	ldy #$00
	clc
	stx $c144
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc122
	lda Lc64d
	beq Lc135
	ldy Lc64e
Lc12a
	lda $9202,y
	bne Lc138
	iny
	dec Lc64d
	bne Lc12a
Lc135
	jmp Lc23d
	
Lc138
	iny
	tya
	sta Lc64e
	ldy #$00
	dec Lc64d
	clc
	adc #$00
	tax
	bcc Lc149
	iny
Lc149
	lda #$e0
	sta $31
	lda #$8f
	sta $32
	lda Lc654
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lc15b
	lda $8ffc
	sta Lc650
	lda #$00
	sta Lc64f
Lc166
	ldy #$1d
	jsr Sc6fb
	bmi Lc183
	jsr Sc65e
	bcs Lc17e
	lda Lc64f
	jsr Sc22e
	lda Lc64e
	jsr Sc22e
Lc17e
	dec Lc650
	beq Lc122
Lc183
	inc Lc64f
	clc
	lda $31
	adc #$20
	sta $31
	bcc Lc166
	inc $32
	bne Lc166
Sc193
	jsr Sc211
	bcs Lc1a6
	cpx #$ff
	clc
	beq Lc1c1
	txa
	pha
	jsr LTK_SetLuActive 
	pla
	tax
	bcc Lc1c1
Lc1a6
	ldx #$1b
	ldy #$c9
	bne Lc1be
Sc1ac
	jsr Sc211
	bcs Lc1ba
	cpx #$ff
	clc
	beq Lc1c1
	cpx #$10
	bcc Lc1c1
Lc1ba
	ldx #$35
	ldy #$c9
Lc1be
	jsr Sc1c2
Lc1c1
	rts
	
Sc1c2
	php
	stx $c1de
	sty $c1e0
	jsr Sc50f
	txa
	pha
	tya
	pha
	lda #$00
	sta Lc4ed
	lda #$18
	sta Lc4ee
	jsr Sc50c
	ldx #$00
	ldy #$00
	jsr LTK_Print 
	jsr Sccc9
	lda #$03
	jsr Sc554
	jsr Sc50c
	ldy #$1d
	lda #$00
Lc1f3
	sta LTK_ErrMsgBuffer,y
	lda #$20
	dey
	bpl Lc1f3
	ldx #$e0
	ldy #$9e
	jsr LTK_Print 
	pla
	sta Lc4ed
	pla
	tax
	dex
	stx Lc4ee
	jsr Sc50c
	plp
	rts
	
Sc211
	jsr Sc536
	bcs Lc22d
	ldx #$ff
	cpy #$01
	beq Lc22c
	lda #$01
	ldx #$c7
	ldy #$00
	jsr Scba8
	bcs Lc22d
	sec
	pha
	pla
	bne Lc22d
Lc22c
	clc
Lc22d
	rts
	
Sc22e
	ldy #$00
	sta ($33),y
	dey
	sty Lc651
	inc $33
	bne Lc23c
	inc $34
Lc23c
	rts
	
Lc23d
	lda Lc651
	bne Lc245
	jmp Lc5e5
	
Lc245
	lda #$00
	sta Lc651
Lc24a
	lda #$00
	sta Lc4f1
	lda #$a0
	sta Lc4f0
Lc254
	lda #$00
	sta Lc4f2
	sta Lc4ef
	lda Lc4f0
	sta $32
	lda Lc4f1
	sta $31
	jsr Sc524
	ldx #$66
	ldy #$c9
	jsr LTK_Print 
Lc270
	ldy Lc4f2
	jsr Sc6fb
	cmp #$ff
	beq Lc287
	jsr Sc486
	beq Lc287
	inc Lc4f2
	inc Lc4f2
	bne Lc270
Lc287
	lda #$00
	sta Lc4f2
	sta Lc4ed
	lda #$05
	sta Lc4ee
Lc294
	jsr Sc4f6
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc29c
	jsr LTK_KernalCall 
	tax
	beq Lc29c
	cmp #$11
	bne Lc2e2
	ldx Lc4f2
	cpx #$27
	bcs Lc29c
	inx
	txa
	asl a
	tay
	jsr Sc6fb
	cmp #$ff
	beq Lc29c
	stx Lc4f2
	jsr Sc501
	lda Lc4f2
	cmp #$14
	beq Lc2d2
	cmp #$28
	beq Lc2d2
	cmp #$3c
	beq Lc2d2
	inc Lc4ee
	bne Lc294
Lc2d2
	lda #$14
	clc
	adc Lc4ed
	sta Lc4ed
	lda #$05
	sta Lc4ee
	bne Lc294
Lc2e2
	cmp #$91
	bne Lc317
	lda Lc4f2
	beq Lc29c
	jsr Sc501
	ldx Lc4f2
	dex
	stx Lc4f2
	cpx #$13
	beq Lc307
	cpx #$27
	beq Lc307
	cpx #$3b
	beq Lc307
	dec Lc4ee
Lc304
	jmp Lc294
	
Lc307
	lda Lc4ed
	sec
	sbc #$14
	sta Lc4ed
	lda #$18
	sta Lc4ee
	bne Lc304
Lc317
	cmp #$1d
	bne Lc336
	jsr Sc501
	lda Lc4ed
	cmp #$14
	bcs Lc304
	clc
	adc #$14
	sta Lc4ed
	lda Lc4f2
	clc
	adc #$14
	sta Lc4f2
	bne Lc304
Lc336
	cmp #$9d
	bne Lc353
	jsr Sc501
	lda Lc4ed
	beq Lc304
	sec
	sbc #$14
	sta Lc4ed
	lda Lc4f2
	sec
	sbc #$14
	sta Lc4f2
	bne Lc304
Lc353
	cmp #$4e
	bne Lc370
	ldy #$50
	jsr Sc6fb
	cmp #$ff
	beq Lc3ad
	tya
	clc
	adc Lc4f1
	sta Lc4f1
	bcc Lc36d
	inc Lc4f0
Lc36d
	jmp Lc254
	
Lc370
	cmp #$50
	bne Lc396
	lda Lc4f0
	cmp #$a0
	bne Lc382
	lda Lc4f1
	cmp #$00
	beq Lc3ad
Lc382
	lda Lc4f1
	sec
	sbc #$50
	sta Lc4f1
	lda Lc4f0
	sbc #$00
	sta Lc4f0
	jmp Lc254
	
Lc396
	cmp #$20
	bne Lc3b0
	jsr Sc50c
	lda Lc4f2
	asl a
	tay
	jsr Sc6fb
	eor #$80
	jsr Sc6fe
	jsr Sc4d5
Lc3ad
	jmp Lc294
	
Lc3b0
	cmp #$54
	bne Lc3cf
	ldy #$00
	ldx #$28
Lc3b8
	jsr Sc6fb
	cmp #$ff
	beq Lc3c9
	eor #$80
	jsr Sc6fe
	iny
	iny
	dex
	bne Lc3b8
Lc3c9
	jmp Lc254
	
Lc3cc
	jmp Lc24a
	
Lc3cf
	cmp #$4d
	bne Lc3d6
	jmp Lc56e
	
Lc3d6
	cmp #$45
	bne Lc3fd
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc3e2
	ldy #$00
	jsr Sc6fb
	cmp #$ff
	beq Lc3cc
	eor #$80
	jsr Sc6fe
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc3e2
	inc $32
	bne Lc3e2
Lc3fd
	cmp #$13
	beq Lc3cc
	cmp #$51
	bne Lc3ad
Lc405
	jmp Lc045
	
Lc408
	lda LTK_Var_CPUMode
	bne Lc411
	lda #$00
	sta $01
Lc411
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	lda Lc654
	sta LTK_Var_ActiveLU
	lda #$02
	clc
	jsr $9f00
	lda Lc64b
	sta LTK_Var_ActiveLU
	lda Lc64c
	sta LTK_Var_Active_User
	jmp LTK_MemSwapOut 
	
Sc438
	ldy Lc4f2
	iny
	jsr Sc6fb
	bit Lc4f3
	bpl Lc449
	cmp Lc64e
	beq Lc46b
Lc449
	sta Lc64e
	ldy #$00
	clc
	adc $c144
	tax
	bcc Lc456
	iny
Lc456
	lda Lc654
	clc
	stx Lc4f5
	sty Lc4f4
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
Lc466
	lda #$ff
	sta Lc4f3
Lc46b
	ldy Lc4f2
	jsr Sc6fb
	and #$7f
	ldy #$9b
	ldx #$05
Lc477
	asl a
	bcc Lc47b
	iny
Lc47b
	dex
	bne Lc477
	clc
	adc #$e0
	tax
	bcc Lc485
	iny
Lc485
	rts
	
Sc486
	jsr Sc50c
	ldy Lc4f2
	jsr Sc6fb
	jsr Sc4d5
	jsr Sc4e5
	jsr Sc438
	jsr LTK_Print 
	jsr Sc4e5
	inc Lc4ee
	inc Lc4ef
	lda #$14
	cmp Lc4ef
	beq Lc4cc
	lda #$28
	ldx LTK_Var_CPUMode
	beq Lc4b6
	ldx $d7
	bne Lc4ba
Lc4b6
	cmp Lc4ef
	rts
	
Lc4ba
	cmp Lc4ef
	beq Lc4cc
	lda #$3c
	cmp Lc4ef
	beq Lc4cc
	lda #$50
	cmp Lc4ef
	rts
	
Lc4cc
	sta Lc4ed
	lda #$05
	sta Lc4ee
	rts
	
Sc4d5
	pha
	ldx #$59
	ldy #$c9
	pla
	bmi Lc4e1
	ldx #$5c
	ldy #$c9
Lc4e1
	jsr LTK_Print 
	rts
	
Sc4e5
	ldx #$5f
	ldy #$c9
	jsr LTK_Print 
	rts
	
Lc4ed
	.byte $00
Lc4ee
	.byte $02 
Lc4ef
	.byte $00
Lc4f0
	.byte $00
Lc4f1
	.byte $00
Lc4f2
	.byte $00
Lc4f3
	.byte $00
Lc4f4
	.byte $00
Lc4f5
	.byte $00
Sc4f6
	jsr Sc50c
	ldx #$62
	ldy #$c9
	jsr LTK_Print 
	rts
	
Sc501
	jsr Sc50c
	ldx #$5d
	ldy #$c9
	jsr LTK_Print 
	rts
	
Sc50c
	clc
	bcc Lc510
Sc50f
	sec
Lc510
	php
	sec
	ldx #$f0
	ldy #$ff
	jsr LTK_KernalTrapSetup
	plp
	ldx Lc4ee
	ldy Lc4ed
	jsr LTK_KernalCall 
	rts
	
Sc524
	ldx #$12
	ldy #$c7
	jsr LTK_Print 
	lda #$00
	sta Lc4ed
	lda #$05
	sta Lc4ee
	rts
	
Sc536
	jsr LTK_Print 
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
Lc540
	jsr LTK_KernalCall 
	sta Lc701,y
	iny
	cpy #$10
	bcs Lc550
	cmp #$0d
	bne Lc540
	clc
Lc550
	lda Lc701
	rts
	
Sc554
	sta $c56d
Lc557
	lda #$00
	tax
	ldy #$02
Lc55c
	sec
	adc #$00
	bne Lc55c
	inx
	bne Lc55c
	dey
	bne Lc55c
	dec $c56d
	bne Lc557
	rts
	
	.byte $00
Lc56e
	lda #$a0
	sta $32
	lda #$00
	sta $31
	lda #$00
	sta Lc4f2
	sta Lc4f3
	ldx #$27
	ldy #$c8
	jsr LTK_Print 
	lda #$00
	tay
	ldx Lc654
	jsr Sc6f6
	ldx #$bc
	ldy #$cc
	jsr LTK_Print 
	lda Lc652
	jsr Sc633
	ldx #$0d
	ldy #$c9
	jsr LTK_Print 
	lda Lc653
	jsr Sc633
Lc5a8
	ldx #$a4
	ldy #$c8
	jsr Sc536
	bcs Lc5a8
	cmp #$59
	beq Lc5bc
	cmp #$4e
	bne Lc5a8
	jmp Lc24a
	
Lc5bc
	lda Lc654
	sta LTK_Var_ActiveLU
	lda #$02
	sec
	jsr $9f00
	bcc Lc5d2
	ldy #$05
	jsr LTK_ErrorHandler 
	jmp Lc5e5
	
Lc5d2
	ldx #$c0
	ldy #$c8
	jsr LTK_Print 
Lc5d9
	ldy Lc4f2
	jsr Sc6fb
	bpl Lc626
	cmp #$ff
	bne Lc5fe
Lc5e5
	ldx #$d1
	ldy #$c8
	lda Lc651
	bne Lc5f2
	ldx #$ec
	ldy #$c8
Lc5f2
	jsr LTK_Print 
Lc5f5
	jsr Sc655
	tax
	beq Lc5f5
	jmp Lc405
	
Lc5fe
	jsr Sc438
	stx $33
	sty $34
	jsr LTK_ClearHeaderBlock 
	ldy #$00
Lc60a
	lda ($33),y
	sta LTK_FileHeaderBlock ,y
	iny
	cpy #$10
	bne Lc60a
	jsr Sc9ed
	lda #$ff
	sta Lc651
	jsr Sc655
	cmp #$03
	bne Lc626
	jmp Lc405
	
Lc626
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc5d9
	inc $32
	bne Lc5d9
Sc633
	pha
	ldx #$99
	ldy #$c8
	jsr LTK_Print 
	pla
	tax
	lda #$00
	tay
	jsr Sc6f6
	ldx #$bc
	ldy #$cc
	jsr LTK_Print 
	rts
	
Lc64b
	.byte $00
Lc64c
	.byte $00
Lc64d
	.byte $00
Lc64e
	.byte $00
Lc64f
	.byte $00
Lc650
	.byte $00
Lc651
	.byte $00
Lc652
	.byte $00
Lc653
	.byte $00
Lc654
	.byte $00
Sc655
	ldy #$10
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall 
	rts
	
Sc65e
	lda Lc652
	bmi Lc671
	ldy #$19
	jsr Sc6fb
	lsr a
	lsr a
	lsr a
	lsr a
	cmp Lc652
	bne Lc68c
Lc671
	ldy #$16
	jsr Sc6fb
	cmp #$01
	beq Lc68c
	cmp #$02
	beq Lc68c
	cmp #$03
	beq Lc68c
	ldx Lc6f4
	beq Lc68e
	cmp Lc6f4
	beq Lc68e
Lc68c
	sec
	rts
	
Lc68e
	lda #$00
	sta Lc6f3
	sta Lc6f1
	sta Lc6f2
	tax
	tay
	lda Lc6f5
	bne Lc6a2
Lc6a0
	clc
	rts
	
Lc6a2
	jsr Sc6fb
	sta Lc6f0
	beq Lc68c
	lda Lc701,x
	cmp #$3f
	beq Lc6e3
	cmp #$2a
	bne Lc6ba
	sta Lc6f3
	beq Lc6e3
Lc6ba
	cmp Lc6f0
	beq Lc6d3
	lda Lc6f3
	bne Lc6e9
	ldy Lc6f2
	ldx Lc6f1
	beq Lc68c
	lda #$2a
	sta Lc6f3
	bne Lc6e9
Lc6d3
	lda Lc6f3
	beq Lc6e3
	stx Lc6f1
	sty Lc6f2
	lda #$00
	sta Lc6f3
Lc6e3
	inx
	cpx Lc6f5
	bcs Lc6a0
Lc6e9
	iny
	cpy #$10
	bne Lc6a2
	beq Lc68c
Lc6f0
	.byte $00
	
Lc6f1
	.byte $00
Lc6f2
	.byte $00
Lc6f3
	.byte $00
Lc6f4
	.byte $00
Lc6f5
	.byte $00
Sc6f6
	clc
	jsr Scc26
	rts
	
Sc6fb
	lda ($31),y
	rts
	
Sc6fe
	sta ($31),y
	rts
	
Lc701
	.byte $00
Lc702
	.byte $00
Lc703
	.byte $00
Lc704L  
	.byte $00 
Lc705
	.byte $00
Lc706
	.byte $00
Lc707
	.byte $00
Lc708
	.byte $00
Lc709
	.byte $00
Lc70a
	.byte $00
Lc70b
	.byte $00
Lc70c
	.byte $00
Lc70d
	.byte $00
Lc70e
	.byte $00
Lc70f
	.byte $00
Lc710
	.byte $00
Lc711
	.byte $00
Lc712
	.text "{return}{clr}{rvs on}auto file move{return}"
	.byte $00
Lc725
	.text "{return}enter lu(0-10 or cr=exit) "
	.byte $00
Lc741
	.text "{return}source user (0-15) ? "
	.byte $00
Lc758
	.text "{return}destination user (0-15) ? "
	.byte $00
Lc774
	.text "{return}{return}key files = 4{return}contiguous data files = 5{return}basic files = 11{return}m.l. files = 12{return}sequential files = 13{return}user files = 14{return}relative files = 15{return}{return}"
	.byte $00
Lc7fb
	.text "{return}file type (cr=all) "
	.byte $00 
Lc810
	.text "{return}pattern match (cr=*) "
	.byte $00
Lc827
	.text "{clr}all files marked with an asterik(*){return}will be moved from the source user{return}to the destination user.{return}{return}{return}source lu is {rvs on}"
	.byte $00
Lc899
	.text "{rvs off}   user {rvs on}"
	.byte $00
Lc8a4
	.text "{return}{return}{return}ok to proceed (y/n) ? y{left}"
	.byte $00 
Lc8c0
	.text "{clr}{rvs on}moving files{return}{return}"
	.byte $00
Lc8d1
	.text "{return}{return}files moved hit any key{return}"
	.byte $00
Lc8ec
	.text "{return}{return}no files selected hit any key{return}"
	.byte $00
Lc90d
	.text "{return}{return}destination"
	.byte $00
Lc91b
	.text "{rvs on}invalid logical unit !!{rvs off}"
	.byte $00
Lc935
	.text "{rvs on}invalid user !!{rvs off}"
	.byte $00
Lc947
	.text "{rvs on}invalid type !!{rvs off}"
	.byte $00
Lc959
	.text " *"
	.byte $00
Lc95c
	.text "  "
	.byte $00
Lc95f
	.text "{$22}{Del}"
	.byte $00
Lc962
	.text ">"
	.byte $00
Lc964
	.text "{Return}"
	.byte $00
Lc966
	.text "{rvs on}home{rvs off}=1st page {rvs on}n{rvs off}ext page {rvs on}p{rvs off}rev.page {rvs on}q{rvs off}uit{return}{rvs on}crsr keys{rvs off}=> {rvs on}space{rvs off}=toggle tag {rvs on}m{rvs off}ove files{return}{rvs on}t{rvs off}his page toggle   {rvs on}e{rvs off}very page toggle{return}"
	.byte $00
Sc9ed
	lda Lc653
	sta LTK_Var_Active_User
	jsr LTK_FindFile 
	sta Lcb53
	stx $ca56
	stx $ca59
	sty $ca57
	sty $ca5a
	bcs Lca1b
	jsr Scac8
	ldy #$0a
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall 
	cmp #$51
	bne Lca21
	pla
	pla
	jmp Lc405
	
Lca1b
	jsr Scb05
	jmp Lcab9
	
Lca21
	cmp #$59
	beq Lca2f
	ldx #$64
	ldy #$c9
	jsr LTK_Print 
	jmp Lcad2
	
Lca2f
	jsr Scb05
	ldy #$00
	sty Lc4f3
	lda Lcb53
	sec
	adc $c144
	tax
	bcc Lca42
	iny
Lca42
	lda Lc654
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lca4c
	pha
	txa
	pha
	tya
	pha
	lda #$80
	ldy #$1d
	ora $ca55,y
	sta $ca58,y
	ldx #$00
	dec $8ffc
	bne Lca63
	dex
Lca63
	stx Lcb57
	pla
	tay
	pla
	tax
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lca72
	lda Lcb57
	beq Lca9b
	lda LTK_Var_ActiveLU
	ldx $c144
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lca86
	pha
	tya
	pha
	ldy Lcb53
	lda #$00
	sta $9002,y
	pla
	tay
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lca9b
	lda $91f8
	cmp #$0a
	bcs Lcaa9
	jsr LTK_DeallocContigBlks 
	bcc Lcab9
	bcs Lcaae
Lcaa9
	jsr LTK_DeallocateRndmBlks 
	bcc Lcab9
Lcaae
	cpx #$80
	bne Lcab6
	tax
	jmp Lcad3
	
Lcab6
	jsr LTK_FatalError 
Lcab9
	jsr Scadd
	ldx #$9d
	ldy #$cb
	bne Lcacf
	ldx #$58
	ldy #$cb
	bne Lcacf
Scac8
	jsr Scadd
	ldx #$6d
	ldy #$cb
Lcacf
	jsr LTK_Print 
Lcad2
	rts
	
Lcad3
	ldy #$04
	jsr LTK_ErrorHandler 
	pla
	pla
	jmp Lc405
	
Scadd
	ldx #$64
	ldy #$c9
	jsr LTK_Print 
	jsr Sc4e5
	ldx #$e0
	ldy #$91
	lda #$00
	sta $91f0
	jsr LTK_Print 
	jsr Sc4e5
	jsr Sc50f
	ldy #$14
	stx Lc4ee
	sty Lc4ed
	jsr Sc50c
	rts
	
Scb05
	ldy #$19
	lda ($33),y
	and #$0f
	sta ($33),y
	lda Lc653
	asl a
	asl a
	asl a
	asl a
	ora ($33),y
	sta ($33),y
	pha
	ldy #$1a
	lda ($33),y
	ora #$80
	sta ($33),y
	lda Lc654
	ldx Lc4f5
	ldy Lc4f4
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0
Lcb31
	ldy #$1f
	lda ($33),y
	tax
	dey
	lda ($33),y
	tay
	lda Lc654
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lcb44
	pla
	sta $8ffd
	lda Lc654
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lcb52
	rts
	
Lcb53
	.byte $00
	
Lcb54
	.byte $00
Lcb55
	.byte $00
Lcb56
	.byte $00
Lcb57
	.byte $00
Lcb58
	.text "file does not exist{return}"
	.byte $00
Lcb6d
	.text "file exists{return}{return}replace it (y/n) or q to quit ? n{left}"
	.byte $00
Lcb9d
	.text "file moved"
	.byte $00
Scba8
	sta Lcbb9 + 1
	stx Lcbb9 + 2
	lda #$00
	sta Lcc23
	sta Lcc24
	sta Lcc25
Lcbb9
	lda Lcbb9,y
	cmp #$30
	bcc Lcc11
	cmp #$3a
	bcc Lcbd6
	ldx $cbe2
	cpx #$0a
	beq Lcc11
	cmp #$41
	bcc Lcc11
	cmp #$47
	bcs Lcc11
	sec
	sbc #$07
Lcbd6
	ldx Lcc23
	beq Lcbfa
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
Lcbe3
	clc
	adc Lcc25
	pha
	txa
	adc Lcc24
	tax
	pla
	dey
	bne Lcbe3
	sta Lcc25
	stx Lcc24
	pla
	tay
	pla
Lcbfa
	inc Lcc23
	sec
	sbc #$30
	clc
	adc Lcc25
	sta Lcc25
	bcc Lcc0e
	inc Lcc24
	beq Lcc1b
Lcc0e
	iny
	bne Lcbb9
Lcc11
	cmp #$20
	beq Lcc0e
	clc
	ldx Lcc23
	bne Lcc1c
Lcc1b
	sec
Lcc1c
	lda Lcc24
	ldx Lcc25
	rts
	
Lcc23
	.byte $00
Lcc24
	.byte $00
Lcc25
	.byte $00
Scc26
	stx Lccb8
	sty Lccb7
	php
	pha
	lda #$30
	ldy #$04
Lcc32
	sta Lccb9,y
	dey
	bpl Lcc32
	pla
	beq Lcc56
	lda Lccb8
	jsr Scca2
	sta Lccbc
	stx Lccbd
	lda Lccb7
	jsr Scca2
	sta Lccba
	stx Lccbb
	jmp Lcc8b
	
Lcc56
	iny
Lcc57
	lda Lccb7
	cmp Lccbf,y
	bcc Lcc86
	bne Lcc69
	lda Lccb8
	cmp Lccc4,y
	bcc Lcc86
Lcc69
	lda Lccb8
	sbc Lccc4,y
	sta Lccb8
	lda Lccb7
	sbc Lccbf,y
	sta Lccb7
	lda Lccb9,y
	clc
	adc #$01
	sta Lccb9,y
	bne Lcc57
Lcc86
	iny
	cpy #$05
	bne Lcc57
Lcc8b
	plp
	bcc Lcca1
	ldy #$00
Lcc90
	lda Lccb9,y
	cmp #$30
	bne Lcca1
	lda #$20
	sta Lccb9,y
	iny
	cpy #$04
	bne Lcc90
Lcca1
	rts
	
Scca2
	pha
	and #$0f
	jsr Sccae
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
Sccae
	cmp #$0a
	bcc Lccb4
	adc #$06
Lccb4
	adc #$30
	rts
	
Lccb7
	.byte $ff 
Lccb8
	.byte $ff 
Lccb9
	.byte $00
Lccba
	.byte $00
Lccbb
	.byte $00
Lccbc
	.byte $00
Lccbd
	.byte $00
Lccbe
	.byte $00
Lccbf
	.byte $27 
Lccc0
	.byte $03 
Lccc1
	.byte $00
Lccc2
	.byte $00
Lccc3
	.byte $00
Lccc4
	.byte $10 
Lccc5
	.byte $e8 
Lccc6
	.byte $64 
Lccc7
	.byte $0a 
Lccc8
	.byte $01 
Sccc9
	lda LTK_BeepOnErrorFlag
	beq Lcd08
	ldy #$18
	lda #$00
Lccd2
	sta SID_V1_FreqLo,y
	dey
	bpl Lccd2
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lcce4
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scd09
	iny
	tya
	cmp #$10
	bne Lcce4
	ldx #$50
	jsr Scd09
	ldy #$10
	sta SID_V1_Control
Lccfc
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scd09
	tya
	bne Lccfc
Lcd08
	rts
	
Scd09
	dec Lcd12
	bne Scd09
	dex
	bne Scd09
	rts
	
Lcd12
	.byte $00
