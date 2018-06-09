;autodel.r.prg
	
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"

	*=$c000 ;$4000 for sysgen
	
Lc000
	lda LTK_Var_ActiveLU
	sta Lc639
	sta $c642
	lda LTK_Var_Active_User
	sta $c63a
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
	stx $c28e
	ldx #$3c
	stx $c306
	lda #$a0
	sta $c33c
	sta $c36b
	lsr a
	sta $c39b
	bne Lc045
Lc03c
	lda $01
	sta $c3fd
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
	sta $c63b
	ldx #$20
	lda #$ff
	ldy #$00
	sty $c63c
	sty $c63f
	sty $c4dc
Lc065
	sta ($31),y
	iny
	bne Lc065
	inc $32
	dex
	bne Lc065
	jsr Sc50b
	ldx #$17
	ldy #$c7
	jsr Sc177
	bcc Lc07e
Lc07b
	jmp Lc3f7
	
Lc07e
	cpx #$ff
	beq Lc07b
	stx $c642
Lc085
	ldx #$3b
	ldy #$c7
	jsr Sc190
	bcs Lc085
	stx $c640
	ldx #$53
	ldy #$c7
	jsr LTK_Print 
Lc098
	ldx #$da
	ldy #$c7
	jsr Sc51d
	bcs Lc0ce
	ldx #$00
	cpy #$01
	beq Lc0d8
	lda #$f1
	ldx #$c6
	ldy #$00
	jsr Sca93
	bcs Lc0ce
	cpx #$0b
	beq Lc0d8
	cpx #$0c
	beq Lc0d8
	cpx #$0d
	beq Lc0d8
	cpx #$0e
	beq Lc0d8
	cpx #$0f
	beq Lc0d8
	cpx #$04
	beq Lc0d8
	cpx #$05
	beq Lc0d8
Lc0ce
	ldx #$f9
	ldy #$c8
	jsr Sc1a6
	jmp Lc098
	
Lc0d8
	stx $c6e4
Lc0db
	ldx #$ef
	ldy #$c7
	jsr Sc51d
	lda #$00
	bcs Lc0db
	cpy #$01
	beq Lc0ec
	dey
	tya
Lc0ec
	sta $c6e5
	ldx #$f0
	lda $c642
	cmp #$0a
	beq Lc0fa
	ldx #$11
Lc0fa
	ldy #$00
	clc
	stx $c128
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc106
	lda $c63b
	beq Lc119
	ldy $c63c
Lc10e
	lda $9202,y
	bne Lc11c
	iny
	dec $c63b
	bne Lc10e
Lc119
	jmp Lc221
	
Lc11c
	iny
	tya
	sta $c63c
	ldy #$00
	dec $c63b
	clc
	adc #$00
	tax
	bcc Lc12d
	iny
Lc12d
	lda #$e0
	sta $31
	lda #$8f
	sta $32
	lda $c642
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
Lc13f
	lda $8ffc
	sta $c63e
	lda #$00
	sta $c63d
Lc14a
	ldy #$1d
	jsr Sc6eb
	bmi Lc167
	jsr Sc64e
	bcs Lc162
	lda $c63d
	jsr Sc212
	lda $c63c
	jsr Sc212
Lc162
	dec $c63e
	beq Lc106
Lc167
	inc $c63d
	clc
	lda $31
	adc #$20
	sta $31
	bcc Lc14a
	inc $32
	bne Lc14a
Sc177
	jsr Sc1f5
	bcs Lc18a
	cpx #$ff
	clc
	beq Lc1a5
	txa
	pha
	jsr LTK_SetLuActive 
	pla
	tax
	bcc Lc1a5
Lc18a
	ldx #$d9
	ldy #$c8
	bne Lc1a2
Sc190
	jsr Sc1f5
	bcs Lc19e
	cpx #$ff
	clc
	beq Lc1a5
	cpx #$10
	bcc Lc1a5
Lc19e
	ldx #$e7
	ldy #$c8
Lc1a2
	jsr Sc1a6
Lc1a5
	rts
	
Sc1a6
	php
	stx $c1c2
	sty $c1c4
	jsr Sc4f6
	txa
	pha
	tya
	pha
	lda #$00
	sta Lc4d6
	lda #$18
	sta $c4d7
	jsr Sc4f3
	ldx #$00
	ldy #$00
	jsr LTK_Print 
	jsr Scbb4
	lda #$03
	jsr Sc53b
	jsr Sc4f3
	ldy #$1d
	lda #$00
Lc1d7
	sta LTK_ErrMsgBuffer,y
	lda #$20
	dey
	bpl Lc1d7
	ldx #$e0
	ldy #$9e
	jsr LTK_Print 
	pla
	sta Lc4d6
	pla
	tax
	dex
	stx $c4d7
	jsr Sc4f3
	plp
	rts
	
Sc1f5
	jsr Sc51d
	bcs Lc211
	ldx #$ff
	cpy #$01
	beq Lc210
	lda #$f1
	ldx #$c6
	ldy #$00
	jsr Sca93
	bcs Lc211
	sec
	pha
	pla
	bne Lc211
Lc210
	clc
Lc211
	rts
	
Sc212
	ldy #$00
	sta ($33),y
	dey
	sty $c63f
	inc $33
	bne Lc220
	inc $34
Lc220
	rts
	
Lc221
	lda $c63f
	bne Lc229
	jmp Lc5bf
	
Lc229
	lda #$00
	sta $c63f
Lc22e
	lda #$00
	sta $c4da
	lda #$a0
	sta $c4d9
Lc238
	lda #$00
	sta $c4db
	sta $c4d8
	lda $c4d9
	sta $32
	lda $c4da
	sta $31
	jsr Sc50b
	ldx #$1c
	ldy #$c9
	jsr LTK_Print 
Lc254
	ldy $c4db
	jsr Sc6eb
	cmp #$ff
	beq Lc26b
	jsr Sc46f
	beq Lc26b
	inc $c4db
	inc $c4db
	bne Lc254
Lc26b
	lda #$00
	sta $c4db
	sta Lc4d6
	lda #$05
	sta $c4d7
Lc278
	jsr Sc4dd
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc280
	jsr LTK_KernalCall 
	tax
	beq Lc280
	cmp #$11
	bne Lc2c6
	ldx $c4db
	cpx #$27
	bcs Lc280
	inx
	txa
	asl a
	tay
	jsr Sc6eb
	cmp #$ff
	beq Lc280
	stx $c4db
	jsr Sc4e8
	lda $c4db
	cmp #$14
	beq Lc2b6
	cmp #$28
	beq Lc2b6
	cmp #$3c
	beq Lc2b6
	inc $c4d7
	bne Lc278
Lc2b6
	lda #$14
	clc
	adc Lc4d6
	sta Lc4d6
	lda #$05
	sta $c4d7
	bne Lc278
Lc2c6
	cmp #$91
	bne Lc2fb
	lda $c4db
	beq Lc280
	jsr Sc4e8
	ldx $c4db
	dex
	stx $c4db
	cpx #$13
	beq Lc2eb
	cpx #$27
	beq Lc2eb
	cpx #$3b
	beq Lc2eb
	dec $c4d7
Lc2e8
	jmp Lc278
	
Lc2eb
	lda Lc4d6
	sec
	sbc #$14
	sta Lc4d6
	lda #$18
	sta $c4d7
	bne Lc2e8
Lc2fb
	cmp #$1d
	bne Lc31a
	jsr Sc4e8
	lda Lc4d6
	cmp #$14
	bcs Lc2e8
	clc
	adc #$14
	sta Lc4d6
	lda $c4db
	clc
	adc #$14
	sta $c4db
	bne Lc2e8
Lc31a
	cmp #$9d
	bne Lc337
	jsr Sc4e8
	lda Lc4d6
	beq Lc2e8
	sec
	sbc #$14
	sta Lc4d6
	lda $c4db
	sec
	sbc #$14
	sta $c4db
	bne Lc2e8
Lc337
	cmp #$4e
	bne Lc354
	ldy #$50
	jsr Sc6eb
	cmp #$ff
	beq Lc391
	tya
	clc
	adc $c4da
	sta $c4da
	bcc Lc351
	inc $c4d9
Lc351
	jmp Lc238
	
Lc354
	cmp #$50
	bne Lc37a
	lda $c4d9
	cmp #$a0
	bne Lc366
	lda $c4da
	cmp #$00
	beq Lc391
Lc366
	lda $c4da
	sec
	sbc #$50
	sta $c4da
	lda $c4d9
	sbc #$00
	sta $c4d9
	jmp Lc238
	
Lc37a
	cmp #$20
	bne Lc394
	jsr Sc4f3
	lda $c4db
	asl a
	tay
	jsr Sc6eb
	eor #$80
	jsr Sc6ee
	jsr Sc4be
Lc391
	jmp Lc278
	
Lc394
	cmp #$54
	bne Lc3b3
	ldy #$00
	ldx #$28
Lc39c
	jsr Sc6eb
	cmp #$ff
	beq Lc3ad
	eor #$80
	jsr Sc6ee
	iny
	iny
	dex
	bne Lc39c
Lc3ad
	jmp Lc238
	
Lc3b0
	jmp Lc22e
	
Lc3b3
	cmp #$44
	bne Lc3ba
	jmp Lc555
	
Lc3ba
	cmp #$45
	bne Lc3e1
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc3c6
	ldy #$00
	jsr Sc6eb
	cmp #$ff
	beq Lc3b0
	eor #$80
	jsr Sc6ee
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc3c6
	inc $32
	bne Lc3c6
Lc3e1
	cmp #$13
	beq Lc3b0
	cmp #$51
	bne Lc391
Lc3e9
	lda #$ff
	sta LTK_Var_SAndRData
	sta $8026
	sta $8027
	jmp Lc045
	
Lc3f7
	lda LTK_Var_CPUMode
	bne Lc400
	lda #$00
	sta $01
Lc400
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	lda $c642
	sta LTK_Var_ActiveLU
	lda #$02
	clc
	jsr $9f00
	lda Lc639
	sta LTK_Var_ActiveLU
	lda $c63a
	sta LTK_Var_Active_User
	jmp LTK_MemSwapOut 
	
Sc427
	ldy $c4db
	iny
	jsr Sc6eb
	bit $c4dc
	bpl Lc438
	cmp $c63c
	beq Lc454
Lc438
	sta $c63c
	ldy #$00
	clc
	adc $c128
	tax
	bcc Lc445
	iny
Lc445
	lda $c642
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
Lc44f
	lda #$ff
	sta $c4dc
Lc454
	ldy $c4db
	jsr Sc6eb
	and #$7f
	ldy #$8f
	ldx #$05
Lc460
	asl a
	bcc Lc464
	iny
Lc464
	dex
	bne Lc460
	clc
	adc #$e0
	tax
	bcc Lc46e
	iny
Lc46e
	rts
	
Sc46f
	jsr Sc4f3
	ldy $c4db
	jsr Sc6eb
	jsr Sc4be
	jsr Sc4ce
	jsr Sc427
	jsr LTK_Print 
	jsr Sc4ce
	inc $c4d7
	inc $c4d8
	lda #$14
	cmp $c4d8
	beq Lc4b5
	lda #$28
	ldx LTK_Var_CPUMode
	beq Lc49f
	ldx $d7
	bne Lc4a3
Lc49f
	cmp $c4d8
	rts
	
Lc4a3
	cmp $c4d8
	beq Lc4b5
	lda #$3c
	cmp $c4d8
	beq Lc4b5
	lda #$50
	cmp $c4d8
	rts
	
Lc4b5
	sta Lc4d6
	lda #$05
	sta $c4d7
	rts
	
Sc4be
	pha
	ldx #$0b
	ldy #$c9
	pla
	bmi Lc4ca
	ldx #$0e
	ldy #$c9
Lc4ca
	jsr LTK_Print 
	rts
	
Sc4ce
	ldx #$11
	ldy #$c9
	jsr LTK_Print 
	rts
	
Lc4d6
	.byte $00,$02,$00,$00,$00,$00,$00 
Sc4dd
	jsr Sc4f3
	ldx #$14
	ldy #$c9
	jsr LTK_Print 
	rts
	
Sc4e8
	jsr Sc4f3
	ldx #$0f
	ldy #$c9
	jsr LTK_Print 
	rts
	
Sc4f3
	clc
	bcc Lc4f7
Sc4f6
	sec
Lc4f7
	php
	sec
	ldx #$f0
	ldy #$ff
	jsr LTK_KernalTrapSetup
	plp
	ldx $c4d7
	ldy Lc4d6
	jsr LTK_KernalCall 
	rts
	
Sc50b
	ldx #$02
	ldy #$c7
	jsr LTK_Print 
	lda #$00
	sta Lc4d6
	lda #$05
	sta $c4d7
	rts
	
Sc51d
	jsr LTK_Print 
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
Lc527
	jsr LTK_KernalCall 
	sta Lc6f1,y
	iny
	cpy #$10
	bcs Lc537
	cmp #$0d
	bne Lc527
	clc
Lc537
	lda Lc6f1
	rts
	
Sc53b
	sta $c554
Lc53e
	lda #$00
	tax
	ldy #$02
Lc543
	sec
	adc #$00
	bne Lc543
	inx
	bne Lc543
	dey
	bne Lc543
	dec $c554
	bne Lc53e
	rts
	
	.byte $00
Lc555
	lda #$a0
	sta $32
	lda #$00
	sta $31
	lda #$00
	sta $c4db
	sta $c4dc
	ldx #$06
	ldy #$c8
	jsr LTK_Print 
	lda #$00
	tay
	ldx $c642
	jsr Sc6e6
	ldx #$a7
	ldy #$cb
	jsr LTK_Print 
	lda $c640
	jsr Sc61b
Lc582
	ldx #$73
	ldy #$c8
	jsr Sc51d
	bcs Lc582
	cmp #$59
	beq Lc596
	cmp #$4e
	bne Lc582
	jmp Lc22e
	
Lc596
	lda $c642
	sta LTK_Var_ActiveLU
	lda #$02
	sec
	jsr $9f00
	bcc Lc5ac
	ldy #$05
	jsr LTK_ErrorHandler 
	jmp Lc5bf
	
Lc5ac
	ldx #$88
	ldy #$c8
	jsr LTK_Print 
Lc5b3
	ldy $c4db
	jsr Sc6eb
	bpl Lc60e
	cmp #$ff
	bne Lc5d8
Lc5bf
	ldx #$9b
	ldy #$c8
	lda $c63f
	bne Lc5cc
	ldx #$b8
	ldy #$c8
Lc5cc
	jsr LTK_Print 
Lc5cf
	jsr Sc645
	tax
	beq Lc5cf
	jmp Lc3e9
	
Lc5d8
	jsr Sc427
	stx $33
	sty $34
	jsr LTK_ClearHeaderBlock 
	ldy #$00
Lc5e4
	lda ($33),y
	sta LTK_FileHeaderBlock ,y
	sta Lc6f1,y
	iny
	cpy #$10
	bne Lc5e4
	ldy #$19
	lda ($33),y
	lsr a
	lsr a
	lsr a
	lsr a
	sta $c644
	jsr Sc9a3
	lda #$ff
	sta $c63f
	jsr Sc645
	cmp #$03
	bne Lc60e
	jmp Lc3e9
	
Lc60e
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc5b3
	inc $32
	bne Lc5b3
Sc61b
	pha
	ldx #$68
	ldy #$c8
	jsr LTK_Print 
	ldx #$16
	ldy #$c9
	pla
	bmi Lc635
	tax
	lda #$00
	tay
	jsr Sc6e6
	ldx #$a7
	ldy #$cb
Lc635
	jsr LTK_Print 
	rts
	
Lc639
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
Sc645
	ldy #$10
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall 
	rts
	
Sc64e
	lda $c640
	bmi Lc661
	ldy #$19
	jsr Sc6eb
	lsr a
	lsr a
	lsr a
	lsr a
	cmp $c640
	bne Lc67c
Lc661
	ldy #$16
	jsr Sc6eb
	cmp #$01
	beq Lc67c
	cmp #$02
	beq Lc67c
	cmp #$03
	beq Lc67c
	ldx $c6e4
	beq Lc67e
	cmp $c6e4
	beq Lc67e
Lc67c
	sec
	rts
	
Lc67e
	lda #$00
	sta $c6e3
	sta $c6e1
	sta $c6e2
	tax
	tay
	lda $c6e5
	bne Lc692
Lc690
	clc
	rts
	
Lc692
	jsr Sc6eb
	sta Lc6e0
	beq Lc67c
	lda Lc6f1,x
	cmp #$3f
	beq Lc6d3
	cmp #$2a
	bne Lc6aa
	sta $c6e3
	beq Lc6d3
Lc6aa
	cmp Lc6e0
	beq Lc6c3
	lda $c6e3
	bne Lc6d9
	ldy $c6e2
	ldx $c6e1
	beq Lc67c
	lda #$2a
	sta $c6e3
	bne Lc6d9
Lc6c3
	lda $c6e3
	beq Lc6d3
	stx $c6e1
	sty $c6e2
	lda #$00
	sta $c6e3
Lc6d3
	inx
	cpx $c6e5
	bcs Lc690
Lc6d9
	iny
	cpy #$10
	bne Lc692
	beq Lc67c
Lc6e0
	.byte $00,$00,$00,$00,$00,$00 
Sc6e6
	clc
	jsr Scb11
	rts
	
Sc6eb
	lda ($31),y
	rts
	
Sc6ee
	sta ($31),y
	rts
	
Lc6f1
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00 
Lc702
	.text "{return}{clr}{rvs on}auto file delete{return}"
	.byte $00
Lc717
	.text "{return}enter desired lu(0-10 or cr=exit) "
	.byte $00
Lc73b
	.text "{return}desired user (cr=all) "
	.byte $00
Lc753
	.text "{return}{return}key files = 4{return}contiguous data files = 5{return}basic files = 11{return}m.l. files = 12{return}sequential files = 13{return}user files = 14{return}relative files = 15{return}{return}"
	.byte $00
Lc7da
	.text "{return}file type (cr=all) "
	.byte $00
Lc7ef
	.text "{return}pattern match (cr=*) "
	.byte $00
Lc806
	.text "{clr}files marked with an asterik(*) will{return}be deleted from the selected lu/user{return}{return}{return}the selected lu is {rvs on}"
	.byte $00
Lc868
	.text "{rvs off}   user {rvs on}"
	.byte $00
Lc873
	.text "{return}{return}{return}proceed(y/n) ? y{left}"
	.byte $00
Lc888
	.text "{clr}{rvs on}deleting files{return}{return}"
	.byte $00
Lc89b
	.text "{return}{return}files deleted hit any key{return}"
	.byte $00
Lc8b8
	.text "{return}{return}no files selected hit any key{return}"
	.byte $00
Lc8d9
	.text "{rvs on}invalid lu!{rvs off}"
	.byte $00
Lc8e7
	.text "{rvs on}invalid user !!{rvs off}"
	.byte $00
Lc8f9
	.text "{rvs on}invalid type !!{rvs off}"
	.byte $00
Lc90b
	.text " *"
	.byte $00
Lc90e
	.text "  "
	.byte $00
Lc911
	.text "{$22}{del}"
	.byte $00
Lc914
	.text ">"
	.byte $00
Lc916
	.text "all"
	.byte $00
Lc91a
	.text "{return}"
	.byte $00
Lc91c
	.text "{rvs on}home{rvs off}=1st page {rvs on}n{rvs off}ext page {rvs on}p{rvs off}rev.page {rvs on}q{rvs off}uit{return}{rvs on}crsr keys{rvs off}=> {rvs on}spc{rvs off}=toggle tag {rvs on}d{rvs off}elete files{return}{rvs on}t{rvs off}his page toggle   {rvs on}e{rvs off}very page toggle{return}"
	.byte $00
Sc9a3
	lda #$00
	sta $c63c
	lda $c642
	sta LTK_Var_ActiveLU
	lda $c644
	sta LTK_Var_Active_User
	jsr LTK_FindFile 
	bcc Lc9bc
	jmp Lca62
	
Lc9bc
	sta $ca6b
	stx $c9d0
	stx $c9d3
	sty $c9d1
	sty $c9d4
	lda #$80
	ldy #$1d
	ora $c9cf,y
	sta $c9d2,y
	ldx #$00
	dec $8ffc
	bne Lc9dd
	dex
Lc9dd
	stx Lca6a
	ldy #$00
	sec
	lda $ca6b
	adc $c128
	tax
	bcc Lc9ed
	iny
Lc9ed
	lda $c642
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
Lc9f7
	lda Lca6a
	beq Lca1e
	lda $c642
	ldx $c128
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
Lca0b
	pha
	ldy $ca6b
	lda #$00
	sta $9002,y
	pla
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
Lca1e
	lda $91f8
	cmp #$0a
	bcs Lca2d
	jsr LTK_DeallocContigBlks 
	bcc Lca35
	jsr LTK_FatalError 
Lca2d
	jsr LTK_DeallocateRndmBlks 
	bcc Lca35
	jsr LTK_FatalError 
Lca35
	ldx #$1a
	ldy #$c9
	jsr LTK_Print 
	jsr Sc4ce
	lda #$00
	sta $91f0
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	jsr Sc4ce
	jsr Sc4f6
	ldy #$14
	stx $c4d7
	sty Lc4d6
	jsr Sc4f3
	ldx #$84
	ldy #$ca
	bne Lca66
Lca62
	ldx #$6c
	ldy #$ca
Lca66
	jsr LTK_Print 
	rts
	
Lca6a
	.byte $00,$00 
Lca6c
	.text "file does not exist !!{return}"
	.byte $00
Lca84
	.text "  file deleted"
	.byte $00
Sca93
	sta Lcaa4 + 1
	stx Lcaa4 + 2
	lda #$00
	sta Lcb0e
	sta $cb0f
	sta $cb10
Lcaa4
	lda Lcaa4,y
	cmp #$30
	bcc Lcafc
	cmp #$3a
	bcc Lcac1
	ldx $cacd
	cpx #$0a
	beq Lcafc
	cmp #$41
	bcc Lcafc
	cmp #$47
	bcs Lcafc
	sec
	sbc #$07
Lcac1
	ldx Lcb0e
	beq Lcae5
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
Lcace
	clc
	adc $cb10
	pha
	txa
	adc $cb0f
	tax
	pla
	dey
	bne Lcace
	sta $cb10
	stx $cb0f
	pla
	tay
	pla
Lcae5
	inc Lcb0e
	sec
	sbc #$30
	clc
	adc $cb10
	sta $cb10
	bcc Lcaf9
	inc $cb0f
	beq Lcb06
Lcaf9
	iny
	bne Lcaa4
Lcafc
	cmp #$20
	beq Lcaf9
	clc
	ldx Lcb0e
	bne Lcb07
Lcb06
	sec
Lcb07
	lda $cb0f
	ldx $cb10
	rts
	
Lcb0e
	.byte $00,$00,$00 
Scb11
	stx $cba3
	sty Lcba2
	php
	pha
	lda #$30
	ldy #$04
Lcb1d
	sta $cba4,y
	dey
	bpl Lcb1d
	pla
	beq Lcb41
	lda $cba3
	jsr Scb8d
	sta $cba7
	stx $cba8
	lda Lcba2
	jsr Scb8d
	sta $cba5
	stx $cba6
	jmp Lcb76
	
Lcb41
	iny
Lcb42
	lda Lcba2
	cmp $cbaa,y
	bcc Lcb71
	bne Lcb54
	lda $cba3
	cmp $cbaf,y
	bcc Lcb71
Lcb54
	lda $cba3
	sbc $cbaf,y
	sta $cba3
	lda Lcba2
	sbc $cbaa,y
	sta Lcba2
	lda $cba4,y
	clc
	adc #$01
	sta $cba4,y
	bne Lcb42
Lcb71
	iny
	cpy #$05
	bne Lcb42
Lcb76
	plp
	bcc Lcb8c
	ldy #$00
Lcb7b
	lda $cba4,y
	cmp #$30
	bne Lcb8c
	lda #$20
	sta $cba4,y
	iny
	cpy #$04
	bne Lcb7b
Lcb8c
	rts
	
Scb8d
	pha
	and #$0f
	jsr Scb99
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
Scb99
	cmp #$0a
	bcc Lcb9f
	adc #$06
Lcb9f
	adc #$30
	rts
	
Lcba2	 
	.byte $ff,$ff,$00,$00,$00,$00,$00,$00,$27,$03,$00,$00,$00,$10,$e8,$64,$0a,$01 
Scbb4
	lda LTK_BeepOnErrorFlag
	beq Lcbf3
	ldy #$18
	lda #$00
Lcbbd
	sta SID_V1_FreqLo,y
	dey
	bpl Lcbbd
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lcbcf
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scbf4
	iny
	tya
	cmp #$10
	bne Lcbcf
	ldx #$50
	jsr Scbf4
	ldy #$10
	sta SID_V1_Control
Lcbe7
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scbf4
	tya
	bne Lcbe7
Lcbf3
	rts
	
Scbf4
	dec Lcbfd
	bne Scbf4
	dex
	bne Scbf4
	rts
	
Lcbfd
	.byte $00
