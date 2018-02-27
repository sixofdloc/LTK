;configlu.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/vic_regs.asm"
	.include "../../include/sid_regs.asm"
	
	*=$c000 ; $4000 for sysgen
Lc000
	jsr $9f03
	beq Lc017
	ldx #<str_OnlyPort0
	ldy #>str_OnlyPort0 ;$cb12
	jsr LTK_Print
	jsr Sccc1
	lda #$04
	jsr Sc4a3
	jmp Lc176
	
Lc017
	lda #$0a
	ldx #$00
	ldy #$00
	stx LTK_BLKAddr_MiniSub
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; $91e0 
Lc027
	ldx #$1a
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
Lc030
	ldx #$9e
	ldy #$02
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ; $9be0 
Lc03b
	lda #$ff
	sta LTK_ReadChanFPTPtr
Lc040
	lda #$00
	sta $c49e
	ldx #<str_PhysController ;$cab2
	ldy #>str_PhysController ;$cab2
	jsr Sc356
	bcs Lc040
	dey
	beq Lc040
	jsr Sc383
	tay
	bne Lc040
	cpx #$08
	bcs Lc040
	txa
	sta $c49a
	beq Lc092
	dex
	txa
	asl a
	asl a
	asl a
	tay
	lda $92e3,y
	bpl Lc07e
	ldx #<str_InvalidParams
	ldy #>str_InvalidParams ;$cad0
	jsr LTK_Print
	jsr Sccc1
	lda #$03
	jsr Sc4a3
Lc07b
	jmp Lc040
	
Lc07e
	lda $92e2,y
	pha
	lda $92e5,y
	pha
	lda $92e4,y
	tax
	lda $92e3,y
	tay
	pla
	jmp Lc09f
	
Lc092
	lda $91f4
	pha
	lda $91f7
	ldx $91f6
	ldy $91f9
Lc09f
	sec
	sbc #$10
	bcs Lc0a5
	dex
Lc0a5
	sta $c769
	stx $c768
	sty $c49f
	pla
	sta Lc492
	ldx #<str_PhysDrive 
	ldy #>str_PhysDrive ;$cafa
	jsr Sc356
	bcs Lc07b
	dey
	beq Lc07b
	jsr Sc383
	tay
	bne Lc07b
	cpx #$04
	bcs Lc07b
	stx $c49b
	txa
	bne Lc0d9
	lda $c49a
	bne Lc0d9
	lda $9216
	sta $c49e
Lc0d9
	jsr Sc53b
	ldx #<str_ManagePrompt 
	ldy #>str_ManagePrompt ;$c7b6
	jsr LTK_Print
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc0e8
	jsr LTK_KernalCall
	tax
	beq Lc0e8
	cmp #$41
	bne Lc0f5
	jmp Lc177
	
Lc0f5
	cmp #$44
	bne Lc0fc
	jmp Lc269
	
Lc0fc
	cmp #$55
	bne Lc103
	jmp Lc4bd
	
Lc103
	cmp #$53
	bne Lc10a
	jmp Lc2c7
	
Lc10a
	cmp #$0d
	bne Lc111
	jmp Lc040
	
Lc111
	cmp #$45
	bne Lc0e8
	dec $c4a0
	ldx #<str_Hardcopy
	ldy #>str_Hardcopy ;$c96a
	jsr LTK_Print
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc124
	jsr LTK_KernalCall
	tax
	beq Lc124
	cmp #$50
	beq Lc14a
	cmp #$53
	bne Lc124
	jsr Sc53b
	ldx #<str_AnyKey
	ldy #>str_AnyKey ;$ca94
	jsr LTK_Print
	ldy #$10
	jsr LTK_KernalTrapRemove
Lc141
	jsr LTK_KernalCall
	tax
	beq Lc141
	jmp Lc176
	
Lc14a
	ldx $9bf0
	ldy $9bf2
	bit LTK_Var_CPUMode
	bpl Lc15b
	ldx $9bf1
	ldy $9bf3
Lc15b
	stx $c4a1
	sty $c4a2
	jsr Sc6d4
	bcs Lc16b
	lda #$0d
	sta str_Header ;$c778
Lc16b
	jsr Sc53b
	lda #$93
	sta str_Header ;$c778
	jsr Sc73d
Lc176
	rts
	
Lc177
	lda $c775
	bne Lc19c
	lda $c776
	cmp #$10
	bcs Lc19c
	ldx #<str_NotEnufCyl
	ldy #>str_NotEnufCyl ;$c889
	jsr LTK_Print
	ldx #<str_AtLeast16 
	ldy #>str_AtLeast16 ;$c8a7
	jsr LTK_Print
	jsr Sccc1
	lda #$05
	jsr Sc4a3
Lc199
	jmp Lc0d9
	
Lc19c
	ldx #<str_AddLU 
	ldy #>str_AddLU ;$c7e9
	jsr Sc356
	bcs Lc177
	cpy #$01
	beq Lc199
	jsr Sc383
	tay
	bne Lc177
	cpx #$0a
	bcs Lc177
	txa
	jsr Sc371
	bne Lc177
Lc1b9
	ldx #<str_EnterStartCyl 
	ldy #>str_EnterStartCyl ;$c810
	jsr Sc356
	bcs Lc1b9
	cpy #$01
	bne Lc1cc
	jsr Sc25a
	jmp Lc177
	
Lc1cc
	jsr Sc383
	ldy $c772
	and #$03
	sta $c49d
	txa
	sta LTK_MiniSubExeArea+$05,y
	lda $c49b
	asl a
	asl a
	asl a
	asl a
	asl a
	ora $c49d
	sta LTK_MiniSubExeArea+$04,y
	lda $c49a
	asl a
	asl a
	ora LTK_MiniSubExeArea+$04,y
	sta LTK_MiniSubExeArea+$04,y
Lc1f4
	ldx #<str_EnterNumCyl 
	ldy #>str_EnterNumCyl ;$c82d
	jsr Sc356
	bcs Lc1f4
	cpy #$01
	beq Lc1b9
	jsr Sc383
	tay
	bne Lc218
	cpx #$10
	bcs Lc218
	ldx #<str_AtLeast16 
	ldy #>str_AtLeast16 ;$c8a7
	jsr LTK_Print
	jsr Sccc1
	jmp Lc1f4
	
Lc218
	cmp $c775
	bcc Lc230
	bne Lc226
	cpx $c776
	bcc Lc230
	beq Lc230
Lc226
	ldx #<str_NotEnufCyl 
	ldy #>str_NotEnufCyl ;$c889
	jsr LTK_Print
	jmp Lc1f4
	
Lc230
	ldy $c772
	and #$07
	sta $c49c
	lda $c49f
	asl a
	asl a
	asl a
	asl a
	ora $c49c
	sta LTK_MiniSubExeArea+$06,y
	txa
	sta LTK_MiniSubExeArea+$07,y
	lda Lc492
	sta LTK_MiniSubExeArea+$08,y
	jsr Sc38d
	bcc Lc257
	jsr Sc25a
Lc257
	jmp Lc177
	
Sc25a
	ldy $c772
	ldx #$05
	lda #$ff
Lc261
	sta LTK_MiniSubExeArea+$04,y
	iny
	dex
	bne Lc261
	rts
	
Lc269
	ldx #<str_DeleteLU 
	ldy #>str_DeleteLU ;$c8c1
	jsr LTK_Print
	ldx #<str_EnterLU 
	ldy #>str_EnterLU ;$c7f4
	jsr Sc356
	bcs Lc269
	cpy #$01
	beq Lc29c
	jsr Sc383
	tay
	bne Lc269
	cpx #$0a
	bcs Lc269
	txa
	jsr Sc371
	bne Lc29f
	ldx #<str_LU_Nonexist 
	ldy #>str_LU_Nonexist ;$c8d0
	jsr LTK_Print
	jsr Sccc1
	lda #$05
	jsr Sc4a3
Lc29c
	jmp Lc0d9
	
Lc29f
	ldx #<str_LU_DelWarn 
	ldy #>str_LU_DelWarn ;$c8ea
	jsr LTK_Print
	jsr Sccc1
	ldx #<str_OKPrompt 
	ldy #>str_OKPrompt ;$c924
	jsr Sc356
	bcs Lc29f
	cpy #$01
	beq Lc269
	cpy #$02
	bne Lc269
	lda $cb94
	cmp #$59
	bne Lc269
	jsr Sc25a
	jmp Lc269
	
Lc2c7
	ldx #<str_SetLUType
	ldy #>str_SetLUType ;$cb3e
	jsr LTK_Print
	ldx #<str_EnterLU 
	ldy #>str_EnterLU ;$c7f4
	jsr Sc356
	bcs Lc2c7
	cpy #$01
	beq Lc29c
	jsr Sc383
	tay
	bne Lc2c7
	cpx #$0a
	bcs Lc2c7
	txa
	jsr Sc371
	bne Lc2fd
	ldx #<str_LU_Nonexist 
	ldy #>str_LU_Nonexist ;$c8d0
	jsr LTK_Print
	jsr Sccc1
	lda #$05
	jsr Sc4a3
	jmp Lc2c7
	
Lc2fd
	ldx #<str_Header2
	ldy #>str_Header2 ;$cb4f
	jsr Sc356
	bcs Lc2c7
	cpy #$01
	beq Lc2c7
	lda $cb94
	cmp #$52
	beq Lc315
	cmp #$43
	bne Lc2fd
Lc315
	ldy $c772
	lda LTK_MiniSubExeArea+$04,y
	ldx $cb94
	cpx #$52
	beq Lc326
	ora #$80
	bne Lc328
Lc326
	and #$7f
Lc328
	sta LTK_MiniSubExeArea+$04,y
	jmp Lc2c7
	
Sc32e
	sec
	bcs Lc332
Sc331
	clc
Lc332
	lda #$00
	jsr Scba0
	rts
	
Sc338
	sta $c34b
	stx $c34d
Lc33e
	ldx #<printTemp 
	ldy #>printTemp ;$c34b
	jsr LTK_Print
	dec $c34d
	bne Lc33e
	rts
printTemp ;$c34b	
	.byte $00,$00,$00 
Sc34e
	ldx #<str_Return 
	ldy #>str_Return ;$cb9e
	jsr LTK_Print
	rts
	
Sc356
	jsr LTK_Print
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
Lc360
	jsr LTK_KernalCall
	sta $cb94,y
	iny
	cpy #$06
	bcs Lc370
	cmp #$0d
	bne Lc360
	clc
Lc370
	rts
	
Sc371
	sta $c378
	asl a
	asl a
	clc
	adc #$00
	tay
	sta $c772
	lda LTK_MiniSubExeArea+$04,y
	cmp #$ff
	rts
	
Sc383
	ldy #$00
	lda #$94
	ldx #$cb
	jsr Scc43
	rts
	
Sc38d
	lda LTK_MiniSubExeArea+$05,y
	clc
	adc LTK_MiniSubExeArea+$07,y
	sta $c494
	lda LTK_MiniSubExeArea+$06,y
	and #$07
	sta $c49c
	lda LTK_MiniSubExeArea+$04,y
	and #$03
	adc $c49c
	sta $c493
	ldy $c772
	lda LTK_MiniSubExeArea+$04,y
	and #$03
	cmp #$00
	bcc Lc3d2
	bne Lc3c0
	lda LTK_MiniSubExeArea+$05,y
	cmp $c49e
	bcc Lc3d2
Lc3c0
	lda $c768
	cmp $c493
	bcc Lc3d2
	bne Lc3d4
	lda $c769
	cmp $c494
	bcs Lc3d4
Lc3d2
	sec
	rts
	
Lc3d4
	lda #$0a
	sta $c771
	lda #$00
	sta $c499
Lc3de
	ldy $c499
	cpy $c772
	beq Lc42d
	lda LTK_MiniSubExeArea+$04,y
	cmp #$ff
	beq Lc42d
	and #$7f
	tax
	and #$1c
	lsr a
	lsr a
	cmp $c49a
	bne Lc42d
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	cmp $c49b
	bne Lc42d
	lda LTK_MiniSubExeArea+$04,y
	and #$03
	sta $c497
	lda LTK_MiniSubExeArea+$05,y
	sta $c498
	lda LTK_MiniSubExeArea+$07,y
	clc
	adc $c498
	sta $c496
	lda LTK_MiniSubExeArea+$06,y
	and #$07
	adc $c497
	sta $c495
	jsr Sc43d
	bcc Lc42d
	rts
	
Lc42d
	lda $c499
	clc
	adc #$05
	sta $c499
	dec $c771
	bne Lc3de
	clc
	rts
	
Sc43d
	ldy $c772
	lda LTK_MiniSubExeArea+$04,y
	and #$03
	cmp $c497
	bcc Lc46a
	bne Lc454
	lda LTK_MiniSubExeArea+$05,y
	cmp $c498
	bcc Lc46a
Lc454
	lda LTK_MiniSubExeArea+$04,y
	and #$03
	cmp $c495
	bcc Lc468
	bne Lc46a
	lda LTK_MiniSubExeArea+$05,y
	cmp $c496
	bcs Lc46a
Lc468
	sec
	rts
	
Lc46a
	lda $c493
	cmp $c497
	bcc Lc490
	bne Lc47e
	lda $c494
	cmp $c498
	bcc Lc490
	beq Lc490
Lc47e
	lda $c493
	cmp $c495
	bcc Lc468
	bne Lc490
	lda $c494
	cmp $c496
	bcc Lc468
Lc490
	clc
	rts
	
Lc492	 
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00 
Sc4a3
	sta $c4bc
Lc4a6
	lda #$00
	tax
	ldy #$02
Lc4ab
	sec
	adc #$00
	bne Lc4ab
	inx
	bne Lc4ab
	dey
	bne Lc4ab
	dec $c4bc
	bne Lc4a6
	rts
	
	.byte $00 
Lc4bd
	ldy #$00
	ldx #$0a
Lc4c1
	lda LTK_MiniSubExeArea+$04,y
	cmp #$ff
	beq Lc4d0
	lda LTK_MiniSubExeArea+$06,y
	and #$f7
	sta LTK_MiniSubExeArea+$06,y
Lc4d0
	iny
	iny
	iny
	iny
	iny
	dex
	bne Lc4c1
	ldy #$31
Lc4da
	lda LTK_MiniSubExeArea+$04,y
	sta LTK_LU_Param_Table,y
	dey
	bpl Lc4da
	lda #$e0
	sta $c4f7
	lda #$93
	sta $c4f8
	lda #$00
	tay
	sta $95df
	ldx #$02
Lc4f5
	clc
	adc $c4f6,y
	iny
	bne Lc4f5
	inc $c4f8
	dex
	bne Lc4f5
	sta $95df
	sec
	lda #$1a
	tax
	sbc $95df
	sta $95df
	lda #$0a
	ldy #$00
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
	.byte $b2,$c2,$d2 
Lc51d
	sta $920a
	ldx #$00
	sec
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ; $91e0 
	.byte $b2,$c2,$d2 
Lc52c
	ldx #<str_ParamsSaved 
	ldy #>str_ParamsSaved ;$c93f
	jsr LTK_Print
	lda #$03
	jsr Sc4a3
	jmp Lc0d9
	
Sc53b
	lda #$00
	sta $c772
	sta $c773
	sta $c774
	ldy $c768
	sty $c775
	ldx $c769
	stx $c776
	ldx #<str_Header 
	ldy #>str_Header ;$c778
	jsr LTK_Print
	lda #$2d
	ldx #$27
	jsr Sc338
	jsr Sc34e
	lda #$30
	sta $c76b
	lda #$0a
	sta $c771
	lda $c4a0
	bne Lc57c
	lda $c49a
	bne Lc57f
	lda $c49b
	bne Lc57f
Lc57c
	jsr Sc69e
Lc57f
	ldx #<str_Space2
	ldy #>str_Space2 ;$c76a
	jsr LTK_Print
	ldy $c772
	lda LTK_MiniSubExeArea+$04,y
	cmp #$ff
	bne Lc593
Lc590
	jmp Lc650
	
Lc593
	sta $c777
	ldx $c4a0
	bne Lc5b2
	and #$7f
	tax
	and #$1c
	lsr a
	lsr a
	cmp $c49a
	bne Lc590
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	cmp $c49b
	bne Lc590
Lc5b2
	ldy $c772
	lda LTK_MiniSubExeArea+$05,y
	tax
	lda LTK_MiniSubExeArea+$04,y
	and #$03
	tay
	jsr Sc331
	ldx #<Lcc34
	ldy #>Lcc34
	jsr LTK_Print
	lda #$20
	ldx #$07
	jsr Sc338
	ldy $c772
	lda LTK_MiniSubExeArea+$07,y
	tax
	sta $c767
	lda LTK_MiniSubExeArea+$06,y
	and #$07
	sta $c766
	tay
	jsr Sc32e
	ldx #<Lcc34
	ldy #>Lcc34
	jsr LTK_Print
	lda #$20
	ldx #$06
	jsr Sc338
	ldy $c772
	lda LTK_MiniSubExeArea+$04,y
	and #$7f
	tax
	and #$1c
	lsr a
	lsr a
	clc
	adc #$30
	sta $c7a4
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #$30
	sta $c7a9
	ldx #$a4
	ldy #$c7
	jsr LTK_Print
	lda $c767
	clc
	adc $c774
	sta $c774
	lda $c766
	adc $c773
	sta $c773
	lda $c776
	sec
	sbc $c767
	sta $c776
	lda $c775
	sbc $c766
	sta $c775
	ldx #$ae
	ldy #$c7
	bit $c777
	bpl Lc64d
	ldx #<str_CPM ;$c7b2
	ldy #>str_CPM ;$c7b2
Lc64d
	jsr LTK_Print
Lc650
	jsr Sc34e
	inc $c76b
	lda $c772
	clc
	adc #$05
	sta $c772
	dec $c771
	beq Lc667
	jmp Lc57f
	
Lc667
	lda $c4a0
	bne Lc69a
	ldx #<str_CylUse 
	ldy #>str_CylUse ;$c84b
	jsr LTK_Print
	ldy $c773
	ldx $c774
	jsr Sc32e
	ldx #$34
	ldy #$cc
	jsr LTK_Print
	ldx #<str_CylLeft 
	ldy #>str_CylLeft ; $c86a
	jsr LTK_Print
	ldy $c775
	ldx $c776
	jsr Sc32e
	ldx #<Lcc34
	ldy #>Lcc34
	jsr LTK_Print
Lc69a
	jsr Sc34e
	rts
	
Sc69e
	lda $9216
	sta $c774
	ldx #$30
Lc6a6
	cmp #$0a
	bcc Lc6af
	sbc #$0a
	inx
	bne Lc6a6
Lc6af
	adc #$30
	stx str_Header2+48 ;$cb4f + 48
	sta str_Header2+49 ;$cb4f + 49
	lda $c776
	sec
	sbc $9216
	sta $c776
	lda $c775
	sbc #$00
	sta $c775
	ldx #<str_DOSLine 
	ldy #>str_DOSLine ;$cb6c
	jsr LTK_Print
	jsr Sc34e
	rts
	
Sc6d4
	ldy #$12
	jsr Sc718
	ldx #$00
	stx $b7
	inx
	stx $b8
	lda $c4a1
	sta $ba
	lda $c4a2
	ora #$60
	sta $b9
	ldy #$00
	jsr Sc718
Sc6f1
	bit LTK_Var_CPUMode
	bpl Lc6fb
	ldx #$60
	jsr Sc721
Lc6fb
	ldy #$06
	lda #$01
	jsr Sc718
	bit LTK_Var_CPUMode
	bpl Lc70c
	ldx #$4c
	jsr Sc721
Lc70c
	lda $9a
	cmp $c4a1
	bne Lc757
	dec Lc763
	clc
	rts
	
Sc718
	pha
	jsr LTK_KernalTrapRemove
	pla
	tax
	jmp LTK_KernalCall
	
Sc721
	ldy #$14
Lc723
	lda Lc72f,y
	sta LTK_MiscWorkspace,y
	dey
	bpl Lc723
	jmp LTK_MiscWorkspace ;$8fe0
	
Lc72f
	ldy #$0e
	sty $ff00
	stx $f140
	ldy #$3e
	sty $ff00
	rts
	
Sc73d
	bit Lc763
	bpl Lc757
	jsr Sc6f1
	ldx #<str_Space
	ldy #>str_Space ;$c764
	jsr LTK_Print
	ldy #$02
	jsr LTK_KernalTrapRemove
	lda #$01
	clc
	jsr LTK_KernalCall
Lc757
	lda #$03
	sta $9a
	lda #$00
	sta $99
	sta $90
	sec
	rts
	
Lc763	    
	.byte $00
str_Space ;$c764
	.text " "
	.byte $00,$00,$00,$00,$00
str_Space2 ;$c76a
	.text " "
	.byte $00,$20,$20,$20,$20,$00,$00,$00
	.byte $00,$00,$00,$00,$00 
str_Header ;$c778
	.text "{clr}{return}{return}lu#  beg. cyl  # of cyls  cnt  drv  typ{return}"
	.byte $00,$00 
Lc7a5
	.text "    "
	.byte $00 
Lc7aa
	.text "   "
	.byte $00 
Lc7ae
	.text "reg"
	.byte $00 
str_CPM ;$c7b2
	.text "cpm"
	.byte $00 
str_ManagePrompt ;$c7b6
	.text "{return}{return}{rvs on}a{rvs off}dd, {rvs on}d{rvs off}elete, "
	.text "{rvs on}s{rvs off}et type, {rvs on}u{rvs off}pdate or {rvs on}e"
	.text "{rvs off}xit "
	.byte $00 
str_AddLU ;$c7e9
	.text "{clr}{rvs on}add lu{return}{return}{return}"
str_EnterLU ;$c7f4
	.text "{rvs on}enter lu # (0-9) or <cr>{rvs off} "
	.byte $00 
str_EnterStartCyl ;$c810
	.text "{return}{return}{rvs on}enter starting cylinder{rvs off} "
	.byte $00
	
str_EnterNumCyl ;$c82d
	.text "{return}{rvs on}enter number of cylinders{rvs off} "
	.byte $00
	
str_CylUse ;$c84b
	.text "{return}number of cylinders in use = "
	.byte $00
	
str_CylLeft ; $c86a
	.text "{return}number of cylinders left   = "
	.byte $00 
	
str_NotEnufCyl ;$c889
	.text "{clr}not enough cylinders left !!"
	.byte $00 
	
str_AtLeast16 ;$c8a7
	.text "{return}lu needs at least 16 !!!"
	.byte $00 
str_DeleteLU ;$c8c1
	.text "{clr}{rvs on}delete lu{return}{return}{return}"
	.byte $00 
str_LU_Nonexist ;$c8d0
	.text "{return}{return}{rvs on}lu does not exists !!!"
	.byte $00 
str_LU_DelWarn ;$c8ea
	.text "{return}{return}{rvs on}warning - all files on a deleted lu will"
	.text "{return}{rvs on}be lost !!!{return}"
	.byte $00 
str_OKPrompt ;$c924
	.text "{return}ok to proceed (y or n) ? "
	.byte $00 
str_ParamsSaved ;$c93f
	.text "{return}{return}{rvs on}the above lu parameters have been saved"
	.byte $00 
str_Hardcopy ;$c96a
	.text "{clr}{rvs on}note:{return}{return}the logical unit parameters "
	.text "in your{return}system are {rvs on}extremely imp"
	.text "ortant{rvs off} should{return}the dos lu be recreated or updated !!!"
	.text "{return}{return}{return}it is {rvs on}your{rvs off} responsibil"
	.text "ity to record{return}and keep these parameters.{return}{return}{return}"
	.text "for your convenience, a hard copy print-out may be obtained on your "
	.text "printer.{return}{return}{return}{return}{rvs on}p{rvs off}rinter or "
	.text "{rvs on}s{rvs off}creen ? "
	.byte $00 
str_AnyKey ;$ca94
	.text "{return}{return}{rvs on}press any key to continue{rvs off}"
	.byte $00 
str_PhysController ;$cab2
	.text "{clr}{return}{return}physical controller (0-7) "
	.byte $00 
str_InvalidParams ;$cad0
	.text "{return}{return}invalid physical parameters detected !!"
	.byte $00 
str_PhysDrive ;$cafa
	.text "{return}{return}physical drive (0-3) "
	.byte $00 
str_OnlyPort0 ;$cb12
	.text "{clr}{return}sorry, lu config must be done on port {rvs on}0{return}"
	.byte $00 
str_SetLUType ;$cb3e
	.text "{clr}{rvs on}set lu type{return}{return}{return}"
	.byte $00 
str_Header2 ;$cb4f
	.text "{return}{return}{rvs on}r{rvs off}egular or {rvs on}c{rvs off}"
	.text "pm lu ? r{left}"
	.byte $00
str_DOSLine ;$cb6c
	.text "dos      0         30      0    0   reg"
	.byte $00
;$cb94
	.byte $00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00 
str_Return ;$cb9e
	.text "{Return}"
	.byte $00 
Scba0
	stx $cc32
	sty Lcc31
	php
	pha
	lda #$30
	ldy #$04
Lcbac
	sta $cc33,y
	dey
	bpl Lcbac
	pla
	beq Lcbd0
	lda $cc32
	jsr Scc1c
	sta $cc36
	stx $cc37
	lda Lcc31
	jsr Scc1c
	sta $cc34
	stx $cc35
	jmp Lcc05
	
Lcbd0
	iny
Lcbd1
	lda Lcc31
	cmp $cc39,y
	bcc Lcc00
	bne Lcbe3
	lda $cc32
	cmp $cc3e,y
	bcc Lcc00
Lcbe3
	lda $cc32
	sbc $cc3e,y
	sta $cc32
	lda Lcc31
	sbc $cc39,y
	sta Lcc31
	lda $cc33,y
	clc
	adc #$01
	sta $cc33,y
	bne Lcbd1
Lcc00
	iny
	cpy #$05
	bne Lcbd1
Lcc05
	plp
	bcc Lcc1b
	ldy #$00
Lcc0a
	lda $cc33,y
	cmp #$30
	bne Lcc1b
	lda #$20
	sta $cc33,y
	iny
	cpy #$04
	bne Lcc0a
Lcc1b
	rts
	
Scc1c
	pha
	and #$0f
	jsr Scc28
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
Scc28
	cmp #$0a
	bcc Lcc2e
	adc #$06
Lcc2e
	adc #$30
	rts
	
Lcc31
	.byte $ff,$ff,$00
Lcc34	.byte $00,$00,$00,$00,$00
	.byte $27,$03,$00,$00,$00,$10,$e8,$64
	.byte $0a,$01 
Scc43
	sta Lcc54 + 1
	stx Lcc54 + 2
	lda #$00
	sta BeepIfAllowed
	sta $ccbf
	sta $ccc0
Lcc54
	lda Lcc54,y
	cmp #$30
	bcc Lccac
	cmp #$3a
	bcc Lcc71
	ldx $cc7d
	cpx #$0a
	beq Lccac
	cmp #$41
	bcc Lccac
	cmp #$47
	bcs Lccac
	sec
	sbc #$07
Lcc71
	ldx BeepIfAllowed
	beq Lcc95
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
Lcc7e
	clc
	adc $ccc0
	pha
	txa
	adc $ccbf
	tax
	pla
	dey
	bne Lcc7e
	sta $ccc0
	stx $ccbf
	pla
	tay
	pla
Lcc95
	inc BeepIfAllowed
	sec
	sbc #$30
	clc
	adc $ccc0
	sta $ccc0
	bcc Lcca9
	inc $ccbf
	beq Lccb6
Lcca9
	iny
	bne Lcc54
Lccac
	cmp #$20
	beq Lcca9
	clc
	ldx BeepIfAllowed
	bne Lccb7
Lccb6
	sec
Lccb7
	lda $ccbf
	ldx $ccc0
	rts
	
BeepIfAllowed
	.byte $00,$00,$00 
Sccc1
	lda LTK_BeepOnErrorFlag
	beq Lcd00
	ldy #$18
	lda #$00
Lccca
	sta SID_V1_FreqLo,y
	dey
	bpl Lccca
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lccdc
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beeptimer
	iny
	tya
	cmp #$10
	bne Lccdc
	ldx #$50
	jsr beeptimer
	ldy #$10
	sta SID_V1_Control
Lccf4
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beeptimer
	tya
	bne Lccf4
Lcd00
	rts
	
beeptimer
	dec BeepDelay
	bne beeptimer
	dex
	bne beeptimer
	rts
BeepDelay	
	.byte $00 