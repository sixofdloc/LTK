;autocopy.r.prg
 	
 	.include "../../include/ltk_dos_addresses.asm"
 	.include "../../include/ltk_equates.asm"
 	.include "../../include/sid_regs.asm"
	
	*=$c000 ; $4000 for sysgen
	
Lc000
	lda LTK_Var_ActiveLU
	sta Lc690
	sta $c69a
	lda LTK_Var_Active_User
	sta $c691
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
	stx $c2c8
	ldx #$3c
	stx $c340
	lda #$a0
	sta $c376
	sta $c3a5
	lsr a
	sta $c3d5
	bne Lc045
Lc03c
	lda $01
	sta $c437
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
	sta $c692
	ldx #$20
	lda #$ff
	ldy #$00
	sty $c693
	sty $c696
	sty $c516
Lc065
	sta ($31),y
	iny
	bne Lc065
	inc $32
	dex
	bne Lc065
Lc06f
	jsr Sc545
	ldx #$6c
	ldy #$c7
	jsr Sc1b1
	bcc Lc07e
Lc07b
	jmp Lc431
	
Lc07e
	stx $c699
	cpx #$ff
	beq Lc07b
Lc085
	ldx #$8f
	ldy #$c7
	jsr Sc1ca
	bcs Lc085
	stx $c697
Lc091
	ldx #$a6
	ldy #$c7
	jsr Sc1b1
	bcs Lc091
	cpx #$ff
	bne Lc0a1
	ldx $c699
Lc0a1
	stx $c69a
Lc0a4
	ldx #$c3
	ldy #$c7
	jsr Sc1ca
	bcs Lc0a4
	cpx #$ff
	bne Lc0b4
	ldx $c697
Lc0b4
	stx $c698
	lda $c699
	cmp $c69a
	bne Lc0cb
	lda $c697
	cmp $c698
	beq Lc06f
	cmp #$ff
	beq Lc06f
Lc0cb
	ldx #$e2
	ldy #$c7
	jsr LTK_Print 
Lc0d2
	ldx #$69
	ldy #$c8
	jsr Sc557
	bcs Lc108
	ldx #$00
	cpy #$01
	beq Lc112
	lda #$48
	ldx #$c7
	ldy #$00
	jsr Sce90
	bcs Lc108
	cpx #$0b
	beq Lc112
	cpx #$0c
	beq Lc112
	cpx #$0d
	beq Lc112
	cpx #$0e
	beq Lc112
	cpx #$0f
	beq Lc112
	cpx #$04
	beq Lc112
	cpx #$05
	beq Lc112
Lc108
	ldx #$c6
	ldy #$c9
	jsr Sc1e0
	jmp Lc0d2
	
Lc112
	stx $c73b
Lc115
	ldx #$7e
	ldy #$c8
	jsr Sc557
	lda #$00
	bcs Lc115
	cpy #$01
	beq Lc126
	dey
	tya
Lc126
	sta $c73c
	ldx #$f0
	lda $c699
	cmp #$0a
	beq Lc134
	ldx #$11
Lc134
	ldy #$00
	clc
	stx $c162
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc140
	lda $c692
	beq Lc153
	ldy $c693
Lc148
	lda $9202,y
	bne Lc156
	iny
	dec $c692
	bne Lc148
Lc153
	jmp Lc25b
	
Lc156
	iny
	tya
	sta $c693
	ldy #$00
	dec $c692
	clc
	adc #$00
	tax
	bcc Lc167
	iny
Lc167
	lda #$e0
	sta $31
	lda #$8f
	sta $32
	lda $c699
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
Lc179
	lda $8ffc
	sta $c695
	lda #$00
	sta $c694
Lc184
	ldy #$1d
	jsr Sc742
	bmi Lc1a1
	jsr Sc6a5
	bcs Lc19c
	lda $c694
	jsr Sc24c
	lda $c693
	jsr Sc24c
Lc19c
	dec $c695
	beq Lc140
Lc1a1
	inc $c694
	clc
	lda $31
	adc #$20
	sta $31
	bcc Lc184
	inc $32
	bne Lc184
Sc1b1
	jsr Sc22f
	bcs Lc1c4
	cpx #$ff
	clc
	beq Lc1df
	txa
	pha
	jsr LTK_SetLuActive 
	pla
	tax
	bcc Lc1df
Lc1c4
	ldx #$9a
	ldy #$c9
	bne Lc1dc
Sc1ca
	jsr Sc22f
	bcs Lc1d8
	cpx #$ff
	clc
	beq Lc1df
	cpx #$10
	bcc Lc1df
Lc1d8
	ldx #$b4
	ldy #$c9
Lc1dc
	jsr Sc1e0
Lc1df
	rts
	
Sc1e0
	php
	stx $c1fc
	sty $c1fe
	jsr Sc530
	txa
	pha
	tya
	pha
	lda #$00
	sta Lc510
	lda #$18
	sta $c511
	jsr Sc52d
	ldx #$00
	ldy #$00
	jsr LTK_Print 
	jsr Scfb1
	lda #$03
	jsr Sc575
	jsr Sc52d
	ldy #$1d
	lda #$00
Lc211
	sta LTK_ErrMsgBuffer,y
	lda #$20
	dey
	bpl Lc211
	ldx #$e0
	ldy #$9e
	jsr LTK_Print 
	pla
	sta Lc510
	pla
	tax
	dex
	stx $c511
	jsr Sc52d
	plp
	rts
	
Sc22f
	jsr Sc557
	bcs Lc24b
	ldx #$ff
	cpy #$01
	beq Lc24a
	lda #$48
	ldx #$c7
	ldy #$00
	jsr Sce90
	bcs Lc24b
	sec
	pha
	pla
	bne Lc24b
Lc24a
	clc
Lc24b
	rts
	
Sc24c
	ldy #$00
	sta ($33),y
	dey
	sty $c696
	inc $33
	bne Lc25a
	inc $34
Lc25a
	rts
	
Lc25b
	lda $c696
	bne Lc263
	jmp Lc616
	
Lc263
	lda #$00
	sta $c696
Lc268
	lda #$00
	sta $c514
	lda #$a0
	sta $c513
Lc272
	lda #$00
	sta $c515
	sta $c512
	lda $c513
	sta $32
	lda $c514
	sta $31
	jsr Sc545
	ldx #$e9
	ldy #$c9
	jsr LTK_Print 
Lc28e
	ldy $c515
	jsr Sc742
	cmp #$ff
	beq Lc2a5
	jsr Sc4a9
	beq Lc2a5
	inc $c515
	inc $c515
	bne Lc28e
Lc2a5
	lda #$00
	sta $c515
	sta Lc510
	lda #$05
	sta $c511
Lc2b2
	jsr Sc517
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc2ba
	jsr LTK_KernalCall 
	tax
	beq Lc2ba
	cmp #$11
	bne Lc300
	ldx $c515
	cpx #$27
	bcs Lc2ba
	inx
	txa
	asl a
	tay
	jsr Sc742
	cmp #$ff
	beq Lc2ba
	stx $c515
	jsr Sc522
	lda $c515
	cmp #$14
	beq Lc2f0
	cmp #$28
	beq Lc2f0
	cmp #$3c
	beq Lc2f0
	inc $c511
	bne Lc2b2
Lc2f0
	lda #$14
	clc
	adc Lc510
	sta Lc510
	lda #$05
	sta $c511
	bne Lc2b2
Lc300
	cmp #$91
	bne Lc335
	lda $c515
	beq Lc2ba
	jsr Sc522
	ldx $c515
	dex
	stx $c515
	cpx #$13
	beq Lc325
	cpx #$27
	beq Lc325
	cpx #$3b
	beq Lc325
	dec $c511
Lc322
	jmp Lc2b2
	
Lc325
	lda Lc510
	sec
	sbc #$14
	sta Lc510
	lda #$18
	sta $c511
	bne Lc322
Lc335
	cmp #$1d
	bne Lc354
	jsr Sc522
	lda Lc510
	cmp #$14
	bcs Lc322
	clc
	adc #$14
	sta Lc510
	lda $c515
	clc
	adc #$14
	sta $c515
	bne Lc322
Lc354
	cmp #$9d
	bne Lc371
	jsr Sc522
	lda Lc510
	beq Lc322
	sec
	sbc #$14
	sta Lc510
	lda $c515
	sec
	sbc #$14
	sta $c515
	bne Lc322
Lc371
	cmp #$4e
	bne Lc38e
	ldy #$50
	jsr Sc742
	cmp #$ff
	beq Lc3cb
	tya
	clc
	adc $c514
	sta $c514
	bcc Lc38b
	inc $c513
Lc38b
	jmp Lc272
	
Lc38e
	cmp #$50
	bne Lc3b4
	lda $c513
	cmp #$a0
	bne Lc3a0
	lda $c514
	cmp #$00
	beq Lc3cb
Lc3a0
	lda $c514
	sec
	sbc #$50
	sta $c514
	lda $c513
	sbc #$00
	sta $c513
	jmp Lc272
	
Lc3b4
	cmp #$20
	bne Lc3ce
	jsr Sc52d
	lda $c515
	asl a
	tay
	jsr Sc742
	eor #$80
	jsr Sc745
	jsr Sc4f8
Lc3cb
	jmp Lc2b2
	
Lc3ce
	cmp #$54
	bne Lc3ed
	ldy #$00
	ldx #$28
Lc3d6
	jsr Sc742
	cmp #$ff
	beq Lc3e7
	eor #$80
	jsr Sc745
	iny
	iny
	dex
	bne Lc3d6
Lc3e7
	jmp Lc272
	
Lc3ea
	jmp Lc268
	
Lc3ed
	cmp #$43
	bne Lc3f4
	jmp Lc58f
	
Lc3f4
	cmp #$45
	bne Lc41b
	lda #$00
	sta $31
	lda #$a0
	sta $32
Lc400
	ldy #$00
	jsr Sc742
	cmp #$ff
	beq Lc3ea
	eor #$80
	jsr Sc745
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc400
	inc $32
	bne Lc400
Lc41b
	cmp #$13
	beq Lc3ea
	cmp #$51
	bne Lc3cb
Lc423
	lda #$ff
	sta LTK_Var_SAndRData
	sta $8026
	sta $8027
	jmp Lc045
	
Lc431
	lda LTK_Var_CPUMode
	bne Lc43a
	lda #$00
	sta $01
Lc43a
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	lda $c69a
	sta LTK_Var_ActiveLU
	lda #$02
	clc
	jsr $9f00
	lda Lc690
	sta LTK_Var_ActiveLU
	lda $c691
	sta LTK_Var_Active_User
	jmp LTK_MemSwapOut 
	
Sc461
	ldy $c515
	iny
	jsr Sc742
	bit $c516
	bpl Lc472
	cmp $c693
	beq Lc48e
Lc472
	sta $c693
	ldy #$00
	clc
	adc $c162
	tax
	bcc Lc47f
	iny
Lc47f
	lda $c699
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
Lc489
	lda #$ff
	sta $c516
Lc48e
	ldy $c515
	jsr Sc742
	and #$7f
	ldy #$8f
	ldx #$05
Lc49a
	asl a
	bcc Lc49e
	iny
Lc49e
	dex
	bne Lc49a
	clc
	adc #$e0
	tax
	bcc Lc4a8
	iny
Lc4a8
	rts
	
Sc4a9
	jsr Sc52d
	ldy $c515
	jsr Sc742
	jsr Sc4f8
	jsr Sc508
	jsr Sc461
	jsr LTK_Print 
	jsr Sc508
	inc $c511
	inc $c512
	lda #$14
	cmp $c512
	beq Lc4ef
	lda #$28
	ldx LTK_Var_CPUMode
	beq Lc4d9
	ldx $d7
	bne Lc4dd
Lc4d9
	cmp $c512
	rts
	
Lc4dd
	cmp $c512
	beq Lc4ef
	lda #$3c
	cmp $c512
	beq Lc4ef
	lda #$50
	cmp $c512
	rts
	
Lc4ef
	sta Lc510
	lda #$05
	sta $c511
	rts
	
Sc4f8
	pha
	ldx #$d8
	ldy #$c9
	pla
	bmi Lc504
	ldx #$db
	ldy #$c9
Lc504
	jsr LTK_Print 
	rts
	
Sc508
	ldx #$de
	ldy #$c9
	jsr LTK_Print 
	rts
	
Lc510
	.byte $00,$02,$00,$00,$00,$00,$00 
Sc517
	jsr Sc52d
	ldx #$e1
	ldy #$c9
	jsr LTK_Print 
	rts
	
Sc522
	jsr Sc52d
	ldx #$dc
	ldy #$c9
	jsr LTK_Print 
	rts
	
Sc52d
	clc
	bcc Lc531
Sc530
	sec
Lc531
	php
	sec
	ldx #$f0
	ldy #$ff
	jsr LTK_KernalTrapSetup
	plp
	ldx $c511
	ldy Lc510
	jsr LTK_KernalCall 
	rts
	
Sc545
	ldx #$59
	ldy #$c7
	jsr LTK_Print 
	lda #$00
	sta Lc510
	lda #$05
	sta $c511
	rts
	
Sc557
	jsr LTK_Print 
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
Lc561
	jsr LTK_KernalCall 
	sta Lc748,y
	iny
	cpy #$10
	bcs Lc571
	cmp #$0d
	bne Lc561
	clc
Lc571
	lda Lc748
	rts
	
Sc575
	sta Lc58e
Lc578
	lda #$00
	tax
	ldy #$02
Lc57d
	sec
	adc #$00
	bne Lc57d
	inx
	bne Lc57d
	dey
	bne Lc57d
	dec Lc58e
	bne Lc578
	rts
	
Lc58e
	.byte $00
Lc58f
	lda #$a0
	sta $32
	lda #$00
	sta $31
	lda #$00
	sta $c515
	sta $c516
	ldx #$95
	ldy #$c8
	jsr LTK_Print 
	lda #$00
	tay
	ldx $c699
	jsr Sc73d
	ldx #$a4
	ldy #$cf
	jsr LTK_Print 
	lda $c697
	jsr Sc672
	ldx #$84
	ldy #$c9
	jsr LTK_Print 
	ldx $c69a
	lda #$00
	tay
	jsr Sc73d
	ldx #$a4
	ldy #$cf
	jsr LTK_Print 
	lda $c698
	jsr Sc672
Lc5d9
	ldx #$19
	ldy #$c9
	jsr Sc557
	bcs Lc5d9
	cmp #$59
	beq Lc5ed
	cmp #$4e
	bne Lc5d9
	jmp Lc268
	
Lc5ed
	lda $c69a
	sta LTK_Var_ActiveLU
	lda #$02
	sec
	jsr $9f00
	bcc Lc603
	ldy #$05
	jsr LTK_ErrorHandler 
	jmp Lc616
	
Lc603
	ldx #$35
	ldy #$c9
	jsr LTK_Print 
Lc60a
	ldy $c515
	jsr Sc742
	bpl Lc665
	cmp #$ff
	bne Lc62f
Lc616
	ldx #$47
	ldy #$c9
	lda $c696
	bne Lc623
	ldx #$63
	ldy #$c9
Lc623
	jsr LTK_Print 
Lc626
	jsr Sc69c
	tax
	beq Lc626
	jmp Lc423
	
Lc62f
	jsr Sc461
	stx $33
	sty $34
	jsr LTK_ClearHeaderBlock 
	ldy #$00
Lc63b
	lda ($33),y
	sta LTK_FileHeaderBlock ,y
	sta Lc748,y
	iny
	cpy #$10
	bne Lc63b
	ldy #$19
	lda ($33),y
	lsr a
	lsr a
	lsr a
	lsr a
	sta $c69b
	jsr Sca70
	lda #$ff
	sta $c696
	jsr Sc69c
	cmp #$03
	bne Lc665
	jmp Lc423
	
Lc665
	lda $31
	clc
	adc #$02
	sta $31
	bcc Lc60a
	inc $32
	bne Lc60a
Sc672
	pha
	ldx #$0e
	ldy #$c9
	jsr LTK_Print 
	ldx #$e3
	ldy #$c9
	pla
	bmi Lc68c
	tax
	lda #$00
	tay
	jsr Sc73d
	ldx #$a4
	ldy #$cf
Lc68c
	jsr LTK_Print 
	rts
	
Lc690
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
Sc69c
	ldy #$10
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall 
	rts
	
Sc6a5
	lda $c697
	bmi Lc6b8
	ldy #$19
	jsr Sc742
	lsr a
	lsr a
	lsr a
	lsr a
	cmp $c697
	bne Lc6d3
Lc6b8
	ldy #$16
	jsr Sc742
	cmp #$01
	beq Lc6d3
	cmp #$02
	beq Lc6d3
	cmp #$03
	beq Lc6d3
	ldx $c73b
	beq Lc6d5
	cmp $c73b
	beq Lc6d5
Lc6d3
	sec
	rts
	
Lc6d5
	lda #$00
	sta $c73a
	sta Lc738
	sta $c739
	tax
	tay
	lda $c73c
	bne Lc6e9
Lc6e7
	clc
	rts
	
Lc6e9
	jsr Sc742
	sta $c737
	beq Lc6d3
	lda Lc748,x
	cmp #$3f
	beq Lc72a
	cmp #$2a
	bne Lc701
	sta $c73a
	beq Lc72a
Lc701
	cmp $c737
	beq Lc71a
	lda $c73a
	bne Lc730
	ldy $c739
	ldx Lc738
	beq Lc6d3
	lda #$2a
	sta $c73a
	bne Lc730
Lc71a
	lda $c73a
	beq Lc72a
	stx Lc738
	sty $c739
	lda #$00
	sta $c73a
Lc72a
	inx
	cpx $c73c
	bcs Lc6e7
Lc730
	iny
	cpy #$10
	bne Lc6e9
	beq Lc6d3
	brk
	
Lc738
	.byte $00,$00,$00,$00,$00 
Sc73d
	clc
	jsr Scf0e
	rts
	
Sc742
	lda ($31),y
	rts
	
Sc745
	sta ($31),y
	rts
	
Lc748	
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00 
Lc759
	.text "{return}{clr}{rvs on}auto file copy{return}"
	.byte $00
Lc76c
	.text "{return}enter source lu(0-10 or cr=exit) "
	.byte $00
Lc78f
	.text "{return}source user (cr=all) "
	.byte $00
Lc7a6
	.text "{return}destination lu (cr=source) "
	.byte $00
Lc7c3
	.text "{return}destination user (cr=source) "
	.byte $00
Lc7e2
	.text "{return}{return}key files = 4{return}contiguous data files = 5{return}basic files = 11{return}m.l. files = 12{return}sequential files = 13{return}user files = 14{return}relative files = 15{return}{return}"
	.byte $00
Lc869
	.text "{return}file type (cr=all) "
	.byte $00
Lc87e
	.text "{return}pattern match (cr=*) "
	.byte $00
Lc895
	.text "{clr}all files marked with an asterik(*){return}will be copied from the source lu/user{return}to the destination lu/user.{return}{return}{return}source lu is {rvs on}"
	.byte $00
Lc90e
	.text "{rvs off}   user {rvs on}"
	.byte $00
Lc919
	.text "{return}{return}{return}ok to proceed (y/n) ? y{left}"
	.byte $00
Lc935
	.text "{clr}{rvs on}copying files{return}{return}"
	.byte $00
Lc947
	.text "{return}{return}files copied hit any key{return}"
	.byte $00
Lc963
	.text "{return}{return}no files selected hit any key{return}"
	.byte $00
Lc984
	.text "{return}{return}destination lu is {rvs on}"
	.byte $00
Lc99a
	.text "{rvs on}invalid logical unit !!{rvs off}"
	.byte $00
Lc9b4
	.text "{rvs on}invalid user !!{rvs off}"
	.byte $00
Lc9c6
	.text "{rvs on}invalid type !!{rvs off}"
	.byte $00
Lc9d8
	.text " *"
	.byte $00
Lc9db
	.text "  "
	.byte $00
Lc9de
	.text "{$22}{Del}"
	.byte $00
Lc9e1
	.text ">"
	.byte $00
Lc9e3
	.text "all"
	.byte $00
Lc9e7
	.text "{Return}"
	.byte $00
Lc9e9
	.text "{rvs on}home{rvs off}=1st page {rvs on}n{rvs off}ext page {rvs on}p{rvs off}rev.page {rvs on}q{rvs off}uit{return}{rvs on}crsr keys{rvs off}=> {rvs on}space{rvs off}=toggle tag {rvs on}c{rvs off}opy files{return}{rvs on}t{rvs off}his page toggle   {rvs on}e{rvs off}very page toggle{return}"
	.byte $00
Sca70
	lda #$00
	sta Lce00
	sta $ce02
	sta $ce01
	sta $ce03
	sta $c693
	lda $c699
	sta LTK_Var_ActiveLU
	lda $c69b
	sta LTK_Var_Active_User
	jsr LTK_FindFile 
	sta $ce0e
	bcc Lca98
	jmp Lccd6
	
Lca98
	lda $91f8
	cmp #$0a
	bcs Lcaa2
	dec $ce02
Lcaa2
	lda $9200
	sta $ce0c
	lda $9201
	sta $ce0d
	jsr LTK_ClearHeaderBlock 
	ldy #$0f
Lcab3
	lda Lc748,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl Lcab3
	lda $c698
	bmi Lcac4
	sta LTK_Var_Active_User
Lcac4
	lda $c69a
	sta LTK_Var_ActiveLU
	jsr LTK_FindFile 
	sta $ce09
	stx $ce10
	sty $ce0f
	bcs Lcb25
	dec $ce01
	jsr Sccdc
	ldy #$0a
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall 
	cmp #$51
	bne Lcaef
	pla
	pla
	jmp Lc423
	
Lcaef
	cmp #$59
Lcaf1
	beq Lcafd
	ldx #$e7
	ldy #$c9
	jsr LTK_Print 
	jmp Lccf5
	
Lcafd
	lda $c69a
	sta LTK_Var_ActiveLU
	lda $91f8
	cmp #$0a
	bcs Lcb12
	jsr LTK_DeallocContigBlks 
	bcc Lcb17
Lcb0f
	jsr LTK_FatalError 
Lcb12
	jsr LTK_DeallocateRndmBlks 
	bcs Lcb0f
Lcb17
	jsr LTK_ClearHeaderBlock 
	ldy #$0f
Lcb1c
	lda Lc748,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl Lcb1c
Lcb25
	ldy $ce0c
	ldx $ce0d
	lda $c699
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
Lcb35
	ldy #$10
Lcb37
	lda LTK_MiscWorkspace,y
	sta LTK_FileHeaderBlock ,y
	iny
	lda $ce02
	beq Lcb49
	cpy #$00
	beq Lcb4d
	bne Lcb37
Lcb49
	cpy #$20
	bne Lcb37
Lcb4d
	lda $ce02
	bne Lcba0
	ldx $91f0
	lda $91f1
	cpx #$00
	bne Lcb60
	cmp #$f1
	bcc Lcba0
Lcb60
	dec Lce00
	sec
	sbc #$01
	bcs Lcb69
	dex
Lcb69
	tay
	lda #$00
Lcb6c
	cpx #$01
	bcc Lcb83
	bne Lcb76
	cpy #$01
	bcc Lcb83
Lcb76
	adc #$00
	dey
	cpy #$ff
	bne Lcb80
	dex
	beq Lcb83
Lcb80
	dex
	bne Lcb6c
Lcb83
	cpx #$00
	bne Lcb8b
	cpy #$00
	beq Lcb8e
Lcb8b
	clc
	adc #$01
Lcb8e
	sta $ce03
	lda $91f1
	sec
	sbc $ce03
	sta $91f1
	bcs Lcba0
	dec $91f0
Lcba0
	lda $c69a
	sta LTK_Var_ActiveLU
	lda $ce02
	beq Lcbb2
	jsr LTK_AllocContigBlks 
	bcc Lcbba
	bcs Lcbb7
Lcbb2
	jsr LTK_AllocateRandomBlks 
	bcc Lcbba
Lcbb7
	jmp Lcce5
	
Lcbba
	ldx #$00
	stx $ce0a
	stx $ce0b
	lda #$ff
	sta LTK_ReadChanFPTPtr
	sta LTK_WriteChanFPTPtr
	lda $c698
	bpl Lcbd2
	lda $c69b
Lcbd2
	sta LTK_Var_Active_User
	lda $ce09
	pha
	ldx $ce10
	ldy $ce0f
	lda #$24
	jsr LTK_ExeExtMiniSub 
	ldy $ce0c
	ldx $ce0d
	lda $c699
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
Lcbf4
	lda $91f1
	ldx $91f0
	sec
	sbc $ce03
	bcs Lcc01
	dex
Lcc01
	sta $ccbe
	stx $ccbd
	lda $c69a
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lcc17
	inc $ce0b
	lda $ccbd
	bne Lcc2a
	lda $ccbe
	cmp $ce0b
	bne Lcc2a
	jmp Lccc1
	
Lcc2a
	jsr Scc77
	lda $ce0a
	pha
	lda $ce0b
	pha
Lcc35
	jsr Scd1e
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$00,$01 
Lcc3f
	jsr Scc8d
	bne Lcc35
	pla
	sta $ce0b
	pla
	sta $ce0a
	lda $ce02
	bne Lcc59
	lda $ce08
	beq Lcc59
	sta $ce07
Lcc59
	jsr Scc77
Lcc5c
	jsr Scd49
	sec
	jsr LTK_HDDiscDriver 
	.byte $00,$00,$01 
Lcc66
	jsr Scc8d
	bcs Lccc1
	bne Lcc5c
	ldx #$11
	ldy #$ce
	jsr LTK_Print 
	jmp Lcc2a
	
Scc77
	lda #$1e
	sta $cc3d
	sta $cc64
	lda #$00
	sta $cc3c
	sta $cc63
	lda #$00
	sta Lccbc
	rts
	
Scc8d
	inc $cc3d
	inc $cc3d
	inc $cc64
	inc $cc64
	inc Lccbc
	inc $ce0b
	bne Lcca4
	inc $ce0a
Lcca4
	lda $ce0a
	cmp $ccbd
	bne Lccb5
	lda $ce0b
	cmp $ccbe
	sec
	beq Lccbb
Lccb5
	lda Lccbc
	cmp #$31
	clc
Lccbb
	rts
	
Lccbc
	.byte $00,$00,$00,$00,$00 
Lccc1
	lda $91f8
	cmp #$04
	bne Lcccd
	lda #$1f
	jsr LTK_ExeExtMiniSub 
Lcccd
	jsr Sccf6
	ldx #$66
	ldy #$ce
	bne Lccf2
Lccd6
	ldx #$13
	ldy #$ce
	bne Lccf2
Sccdc
	jsr Sccf6
	ldx #$28
	ldy #$ce
	bne Lccf2
Lcce5
	ldx #$58
	ldy #$ce
	lda $ce02
	beq Lccf2
	ldx #$72
	ldy #$ce
Lccf2
	jsr LTK_Print 
Lccf5
	rts
	
Sccf6
	ldx #$e7
	ldy #$c9
	jsr LTK_Print 
	jsr Sc508
	ldx #$e0
	ldy #$91
	lda #$00
	sta $91f0
	jsr LTK_Print 
	jsr Sc508
	jsr Sc530
	ldy #$14
	stx $c511
	sty Lc510
	jsr Sc52d
	rts
	
Scd1e
	lda $ce02
	beq Lcd36
	lda $9001
	clc
	adc $ce0b
	tax
	lda $9000
	adc $ce0a
	tay
	lda $c699
	rts
	
Lcd36
	lda #$02
	sta Lcda0 + 1
	lda $c699
	sta $cdc9
	lda #$90
	ldx #$e0
	ldy #$9b
	bne Lcd72
Scd49
	lda $ce02
	beq Lcd61
	lda $9201
	clc
	adc $ce0b
	tax
	lda $9200
	adc $ce0a
	tay
	lda $c69a
	rts
	
Lcd61
	lda #$02
	sta Lcda0 + 1
	lda $c69a
	sta $cdc9
	lda #$92
	ldx #$e0
	ldy #$8d
Lcd72
	sta $cda3
	stx $cdce
	sty $cdcf
	lda #$00
	sta $ce08
	ldx $ce0a
	lda $ce0b
	sec
	sbc #$01
	bcs Lcd8c
	dex
Lcd8c
	stx $ce04
	sta $ce05
	sta $ce06
	tay
	bne Lcda0
	txa
	bne Lcda0
	lda #$ff
	sta $ce07
Lcda0
	lda #$00
	ldx #$00
	jsr Scde4
	lda Lce00
	beq Lcdda
	ldy #$08
Lcdae
	lsr $ce04
	ror $ce05
	dey
	bne Lcdae
	lda $ce05
	cmp $ce07
	beq Lcdd1
	sta $ce07
	dec $ce08
	jsr Scdeb
	lda #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$00,$01 
Lcdd1
	lda $cdce
	ldx $cdcf
	jsr Scde4
Lcdda
	lda $ce06
	jsr Scdeb
	lda $cdc9
	rts
	
Scde4
	sta Scdfb + 1
	stx Scdfb + 2
	rts
	
Scdeb
	asl a
	tax
	bcc Lcdf2
	inc Scdfb + 2
Lcdf2
	jsr Scdfb
	tay
	jsr Scdfb
	tax
	rts
	
Scdfb
	lda Scdfb,x
	inx
	rts
	
Lce00
	.byte $00,$00,$00,$00,$00,$00,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$2e,$00 
Lce13
	.text "file does not exist{return}"
	.byte $00
Lce28
	.text "file exists{return}{return}replace it (y/n) or q to quit ? n{left}"
	.byte $00
Lce58
	.text "disk is full{return}"
	.byte $00
Lce66
	.text "file copied"
	.byte $00
Lce72
	.text "not enough contiguous blocks{return}"
	.byte $00
Sce90
	sta Lcea1 + 1
	stx Lcea1 + 2
	lda #$00
	sta $cf0b
	sta $cf0c
	sta $cf0d
Lcea1
	lda Lcea1,y
	cmp #$30
	bcc Lcef9
	cmp #$3a
	bcc Lcebe
	ldx $ceca
	cpx #$0a
	beq Lcef9
	cmp #$41
	bcc Lcef9
	cmp #$47
	bcs Lcef9
	sec
	sbc #$07
Lcebe
	ldx $cf0b
	beq Lcee2
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
Lcecb
	clc
	adc $cf0d
	pha
	txa
	adc $cf0c
	tax
	pla
	dey
	bne Lcecb
	sta $cf0d
	stx $cf0c
	pla
	tay
	pla
Lcee2
	inc $cf0b
	sec
	sbc #$30
	clc
	adc $cf0d
	sta $cf0d
	bcc Lcef6
	inc $cf0c
	beq Lcf03
Lcef6
	iny
	bne Lcea1
Lcef9
	cmp #$20
	beq Lcef6
	clc
	ldx $cf0b
	bne Lcf04
Lcf03
	sec
Lcf04
	lda $cf0c
	ldx $cf0d
	rts
	
	.byte $00,$00,$00 
Scf0e
	stx $cfa0
	sty $cf9f
	php
	pha
	lda #$30
	ldy #$04
Lcf1a
	sta $cfa1,y
	dey
	bpl Lcf1a
	pla
	beq Lcf3e
	lda $cfa0
	jsr Scf8a
	sta $cfa4
	stx $cfa5
	lda $cf9f
	jsr Scf8a
	sta $cfa2
	stx $cfa3
	jmp Lcf73
	
Lcf3e
	iny
Lcf3f
	lda $cf9f
	cmp $cfa7,y
	bcc Lcf6e
	bne Lcf51
	lda $cfa0
	cmp $cfac,y
	bcc Lcf6e
Lcf51
	lda $cfa0
	sbc $cfac,y
	sta $cfa0
	lda $cf9f
	sbc $cfa7,y
	sta $cf9f
	lda $cfa1,y
	clc
	adc #$01
	sta $cfa1,y
	bne Lcf3f
Lcf6e
	iny
	cpy #$05
	bne Lcf3f
Lcf73
	plp
	bcc Lcf89
	ldy #$00
Lcf78
	lda $cfa1,y
	cmp #$30
	bne Lcf89
	lda #$20
	sta $cfa1,y
	iny
	cpy #$04
	bne Lcf78
Lcf89
	rts
	
Scf8a
	pha
	and #$0f
	jsr Scf96
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
Scf96
	cmp #$0a
	bcc Lcf9c
	adc #$06
Lcf9c
	adc #$30
	rts
	
	.byte $ff,$ff,$00,$00,$00,$00,$00,$00,$27,$03,$00,$00,$00,$10,$e8,$64,$0a 
	.byte $01 
Scfb1
	lda LTK_BeepOnErrorFlag
	beq Lcff0
	ldy #$18
	lda #$00
Lcfba
	sta SID_V1_FreqLo,y
	dey
	bpl Lcfba
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lcfcc
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scff1
	iny
	tya
	cmp #$10
	bne Lcfcc
	ldx #$50
	jsr Scff1
	ldy #$10
	sta SID_V1_Control
Lcfe4
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scff1
	tya
	bne Lcfe4
Lcff0
	rts
	
Scff1
	dec $cffa
	bne Scff1
	dex
	bne Scff1
	rts
	
	.byte $00
