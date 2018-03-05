;type.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	
	*=$c000 ;$4000 for sysgen
Lc000
	ldx $c8
	bit LTK_Var_CPUMode
	bmi Lc00a
	jmp Lc0a0
	
Lc00a
	ldx $ea
	pha
	lda #$02
	sta $c33d
	lda #$7c
	sta Lc327 + 1
	lda #$c1
	sta $c32a
	lda #$16
	sta $c345
	lda #$17
	sta $c34e
	lda #$3d
	sta $c2dc
	sta $c319
	lda #$3e
	sta $c2e0
	sta $c31d
	lda #$ea
	sta $c5a8
	lda #$2f
	sta $c5b5
	lda #$30
	sta $c5bf
	lda #$31
	sta $c5b7
	lda #$32
	sta $c5c1
	lda #$33
	sta $c5b9
	lda #$34
	sta $c5c3
	lda #$24
	sta $c5b0
	lda #$25
	sta $c5bb
	lda #$4f
	sta $c86e
	lda #$4f
	sta $c86f
	lda #$61
	sta $c373
	lda #$62
	sta $c377
	lda #$f8
	sta $c870
	lda #$50
	sta $c871
	lda #$d4
	sta $c59f
	sta $c5a6
	lda #$d0
	sta $c5a4
	lda #$14
	sta $c1b4
	lda #$fd
	sta $c1b9
	lda #$00
	sta $f4
	pla
	jmp Lc0a6
	
Lc0a0
	pha
	lda #$01
	sta $0f
	pla
Lc0a6
	ldy LTK_HD_DevNum
	sty Lc1e8
	ldy LTK_Var_ActiveLU
	sty Lc17d
	ldy LTK_Var_Active_User
	sty $c17e
	pha
	txa
	pha
	lda #$01
	jsr Sc7ad
	lda #$0f
	jsr Sc7ad
	jsr Sc7a3
	pla
	tax
	pla
	sta Lc0e0
	jsr Sc602
	beq Lc0d6
	jmp Lc17f
	
Lc0d6
	ldx #$e1
	ldy #$c0
	jsr Sc5e6
	jmp Lc530
	
Lc0e0
	
	.byte $00 
Lc0e1
	.text "{return}{$07}syntax is{return}{return}type [lu:user:]filename{return}{return}both lu and user are optional.{return}if user is supplied without an lu,{return}preceed user # with a colon, i.e.{return}type :7:filename{return}"
	.byte $00 
Lc17d
	.byte $00,$00
Lc17f
	jsr Sc7bc
	lda #$0f
	tay
	ldx Lc1e8
	jsr Sc7c6
	lda #$00
	jsr Sc7c1
	jsr Sc7a8
	lda LTK_ErrorTrapFlag
	sta $c564
	lda #$02
	sta LTK_ErrorTrapFlag
	jsr Sc5ce
	lda $c564
	sta LTK_ErrorTrapFlag
	lda $0300
	sta $c56a
	lda $0301
	sta $c56b
	lda #$42
	sta $0300
	lda #$fe
	sta $0301
	lda #$00
	sta $c561
	sta $c55e
	sta $c55f
	lda $c601
	ldx $c568
	ldy #$02
	jsr Sc7c1
	lda #$01
	ldx Lc1e8
	ldy #$02
	jsr Sc7c6
	jsr Sc7a8
	jsr Sc5ce
	beq Lc229
	jmp Lc50a
	
Lc1e8
	.byte $08 
Lc1e9
	.text " is a "
	.byte $00
	
	.text "basic prg {return}"
	.byte $00 
Lc1fc
	.text "m/l prg {return}"
	.byte $00 
Lc206
	.text "seq. file {return}"
	.byte $00 
Lc212
	.text "user file {return}"
	.byte $00 
Lc21e
	.text "rel. file "
	.byte $00 
Lc229
	lda $91f8
	sta $c561
	ldx #$a1
	ldy #$c6
	jsr Sc5e6
	jsr Sc7a3
Lc239
	jsr Sc7df
	tax
	beq Lc239
	cmp #$53
	beq Lc24d
	cmp #$50
	bne Lc239
	dec $c565
	jsr Sc6ea
Lc24d
	lda #$0d
	jsr Sc799
	lda #$12
	jsr Sc799
	lda LTK_Var_ActiveLU
	jsr Sc6d5
	stx Lc6e3
	sta $c6e4
	lda LTK_Var_Active_User
	jsr Sc6d5
	stx $c6e6
	sta $c6e7
	ldx #$e3
	ldy #$c6
	jsr Sc5e6
	ldx #$e0
	ldy #$91
	jsr Sc5e6
	ldx #$e9
	ldy #$c1
	jsr Sc5e6
	ldx #$f0
	ldy #$c1
	lda $c561
	cmp #$0b
	beq Lc2ab
	ldx #$fc
	ldy #$c1
	cmp #$0c
	beq Lc2ab
	ldx #$1e
	ldy #$c2
	cmp #$0f
	beq Lc2ab
	ldx #$06
	ldy #$c2
	cmp #$0d
	beq Lc2ab
	ldx #$12
	ldy #$c2
Lc2ab
	jsr Sc5e6
	ldx #$01
	jsr Sc7b7
	ldy #$00
Lc2b5
	lda $1c00,y
	sta $c982,y
	iny
	bne Lc2b5
	lda $1d00
	sta $ca82
	lda $1d01
	sta $ca83
	ldx #$7b
	ldy #$c1
	jsr Sc5e6
	lda #$00
	sta $1c00
	sta LTK_Command_Buffer
	lda #$00
	sta $7a
	lda #$1c
	sta $7b
	lda $c561
	cmp #$0b
	beq Lc321
	cmp #$0c
	beq Lc2f7
	cmp #$0d
	beq Lc2f7
	cmp #$0e
	beq Lc2f7
	jmp Lc3f4
	
Lc2f7
	jsr Sc79e
	jsr Sc799
	jsr Sc56c
	bne Lc305
	jmp Lc30f
	
Lc305
	jsr Sc6d2
	sec
	sbc #$40
	bcc Lc2f7
	bcs Lc316
Lc30f
	ldx #$96
	ldy #$c3
	jsr Sc5e6
Lc316
	lda #$00
	sta $7a
	lda #$02
	sta $7b
	jmp Lc4f3
	
Lc321
	jsr Sc79e
	jsr Sc79e
Lc327
	ldx #$7b
	ldy #$c1
	jsr Sc5e6
	jsr Sc79e
	sta $c601
	jsr Sc79e
	ora $c601
	beq Lc316
	ldy #$00
	jsr Sc79e
	sta $1c00,y
	sta $14
	iny
	jsr Sc79e
	sta $1c00,y
	sta $15
	iny
Lc350
	jsr Sc79e
	sta $1c00,y
	iny
	ora #$00
	beq Lc363
	jsr Sc6d2
	sec
	sbc #$40
	bcc Lc350
Lc363
	sta $1c00,y
	jsr Sc56c
	bne Lc36e
	jmp Lc30f
	
Lc36e
	ldy #$00
	lda #$00
	sta $5f
	lda #$1c
	sta $60
	bit LTK_Var_CPUMode
	bpl Lc390
	lda #$1c
	sta $1c01
	lda #$00
	sta $1c00
	inc $1c01
	sty $1d00
	sty $1d01
Lc390
	jsr Sc7d0
	jmp Lc327
	
Lc396
	.text "{return}user aborted output{return}"
	.byte $00 
Lc3ac
	.text "{rvs on}with "
	.byte $00 
Lc3b3
	.text " records of "
	.byte $00 
Lc3c0
	.text " bytes each.{return}{return}"
	.byte $00 
Lc3cf
	.text "{return}{return}start with record #?    1{left}"
	.byte $00 
Lc3ec
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
Lc3f4
	ldx #$ac
	ldy #$c3
	jsr Sc5e6
	lda $91f7
	sec
	sbc #$01
	tax
	lda $91f6
	sbc #$00
	tay
	lda #$00
	sec
	jsr Sc8df
	ldx #$72
	ldy #$c9
	jsr Sc5e6
	ldx #$b3
	ldy #$c3
	jsr Sc5e6
	lda $91f4
	tay
	lda $91f5
	tax
	lda #$00
	sec
	jsr Sc8df
	ldx #$72
	ldy #$c9
	jsr Sc5e6
	ldx #$c0
	ldy #$c3
	jsr Sc5e6
	jsr Sc7a3
	ldx #$cf
	ldy #$c3
	jsr Sc5e6
	ldy #$00
Lc444
	jsr Sc79e
	cmp #$0d
	beq Lc453
	sta Lc3ec,y
	iny
	cpy #$05
	bne Lc444
Lc453
	ldy #$00
Lc455
	lda Lc3ec,y
	sta LTK_Command_Buffer,y
	beq Lc462
	iny
	cpy #$05
	bne Lc455
Lc462
	iny
	sty $c601
	ldy #$00
	jsr Sc87a
	lda $c8db
	sec
	sbc #$01
	sta $c55e
	lda $c8dc
	sbc #$00
	sta $c55f
Lc47c
	bit $c565
	bpl Lc486
	ldx #$04
	jsr Sc7b2
Lc486
	ldx #$4f
	ldy #$c5
	jsr Sc5e6
	inc $c55e
	bne Lc495
	inc $c55f
Lc495
	ldx $c55e
	ldy $c55f
	lda #$00
	sec
	jsr Sc8df
	ldx #$72
	ldy #$c9
	jsr Sc5e6
	lda #$20
	jsr Sc799
	lda #$0d
	jsr Sc799
	ldx #$0f
	jsr Sc7b2
	ldx #$05
	ldy #$00
Lc4bb
	lda Lc55c,y
	jsr Sc799
	iny
	dex
	bne Lc4bb
	jsr Sc7a3
	jsr Sc5ce
	bne Lc4f3
	ldx #$01
	jsr Sc7b7
	bit $c565
	bpl Lc4dc
	ldx #$04
	jsr Sc7b2
Lc4dc
	jsr Sc79e
	jsr Sc799
	jsr Sc56c
	bne Lc4ea
	jmp Lc30f
	
Lc4ea
	jsr Sc6d2
	cmp #$40
	bcc Lc4dc
	bcs Lc47c
Lc4f3
	ldy #$00
Lc4f5
	lda $c982,y
	sta $1c00,y
	iny
	bne Lc4f5
	lda $ca82
	sta $1d00
	lda $ca83
	sta $1d01
Lc50a
	lda $c56a
	sta $0300
	lda $c56b
	sta $0301
	lda #$01
	jsr Sc7ad
	bit LTK_Var_CPUMode
	bpl Lc525
	lda #$04
	jsr Sc7ad
Lc525
	lda #$0f
	jsr Sc7ad
	jsr Sc7a3
	jsr Sc5ac
Lc530
	lda LTK_Var_CPUMode
	bpl Lc53f
	lda #$3e
	sta $ff00
	lda #$ff
	sta LTK_DiskRWControl
Lc53f
	lda Lc17d
	jsr LTK_SetLuActive 
	lda $c17e
	sta LTK_Var_Active_User
	clc
	jmp LTK_MemSwapOut 
	
Lc54f
	.text "{return}{rvs on} record # "
	.byte $00 
Lc55c		           
	.byte $50,$02,$00,$00 
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
Sc56c
	stx $c5ab
	jsr Sc59b
	cmp #$3f
	beq Lc595
	cmp #$3c
	bne Lc595
Lc57a
	jsr Sc59b
	cmp #$3c
	beq Lc57a
Lc581
	jsr Sc59b
	cmp #$3c
	beq Lc58e
	cmp #$3f
	bne Lc581
	beq Lc595
Lc58e
	jsr Sc59b
	cmp #$3c
	beq Lc58e
Lc595
	php
	ldx $c5ab
	plp
	rts
	
Sc59b
	jsr Sc7d5
	lda $c5
	pha
	lda #$00
	sta $c6
	sta $c5
	sta $c8
	pla
	rts
	
	.byte $00 
Sc5ac
	jsr Sc7cb
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
Lc5c4
	jsr Sc7df
	dec Lc5cd
	bne Lc5c4
	rts
	
Lc5cd
	.byte $b0 
Sc5ce
	ldx #$0f
	jsr Sc7b7
Lc5d3
	jsr Sc79e
	cmp #$0d
	beq Lc5d3
	pha
Lc5db
	jsr Sc79e
	cmp #$0d
	beq Lc5db
	pla
	cmp #$30
	rts
	
Sc5e6
	stx Lc5ec + 1
	sty Lc5ec + 2
Lc5ec
	lda Lc5ec
	ora #$00
	beq Lc600
	jsr Sc799
	inc Lc5ec + 1
	bne Lc5ec
	inc Lc5ec + 2
	bne Lc5ec
Lc600
	rts
	
	.byte $24 
Sc602
	tay
	iny
	lda #$00
	sta LTK_Command_Buffer,x
	stx $c601
	cpy $c601
	bcc Lc614
	jmp Lc6c9
	
Lc614
	sty $c568
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne Lc623
	inc $c568
	bne Lc64a
Lc623
	jsr Sc87a
	lda Lc8da
	beq Lc64a
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne Lc64a
	iny
	sty $c568
	lda $c8db
	jsr LTK_SetLuActive 
	bcc Lc64a
	pla
	pla
	ldx #$7b
	ldy #$c6
	jsr Sc5e6
	jmp Lc530
	
Lc64a
	ldy $c568
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne Lc659
	inc $c568
	bne Lc6c0
Lc659
	jsr Sc87a
	lda Lc8da
	beq Lc6c0
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne Lc6c0
	lda $c8db
	cmp #$10
	bcc Lc6b9
	pla
	pla
	ldx #$8f
	ldy #$c6
	jsr Sc5e6
	jmp Lc530
	
Lc67b
	.text "{return}{$07}not an active lu{return}"
	.byte $00 
Lc68f
	.text "{return}{$07}invalid user #{return}"
	.byte $00 
Lc6a1
	.text "{return}{return}{rvs on}s{rvs off}creen or {rvs on}p{rvs off}rinter"
	.byte $00 
Lc6b9
	sta LTK_Var_Active_User
	iny
	sty $c568
Lc6c0
	lda $c601
	sec
	sbc $c568
	bne Lc6cb
Lc6c9
	lda #$00
Lc6cb
	sta $c601
	ldx $c601
	rts
	
Sc6d2
	lda $90
	rts
	
Sc6d5
	ldx #$30
Lc6d7
	cmp #$0a
	bcc Lc6e0
	sbc #$0a
	inx
	bne Lc6d7
Lc6e0
	adc #$30
	rts
	
Lc6e3
	.byte $00,$00,$3a,$00,$00,$3a,$00 
Sc6ea
	jsr LTK_GetPortNumber
	clc
	adc #$9e
	tax
	lda #$02
	adc #$00
	tay
	lda #$0a
	clc
	jsr LTK_HDDiscDriver 
	.byte $82,$c9,$01 ;$c982
Lc6ff
	ldx $c992
	ldy $c994
	bit LTK_Var_CPUMode
	bpl Lc710
	ldx $c993
	ldy $c995
Lc710
	stx $c566
	sty $c567
	lda $ff00
	pha
	bit LTK_Var_CPUMode
	bpl Lc724
	lda #$3e
	sta $ff00
Lc724
	lda LTK_DiskRWControl
	pha
	ldx #$00
	stx $b7
	ldx #$04
	stx $b8
	lda $c566
	sta $ba
	lda $c567
	ora #$60
	sta $b9
	ldy #$00
	jsr Sc774
	bit LTK_Var_CPUMode
	bpl Lc74b
	ldx #$60
	jsr Sc77d
Lc74b
	ldy #$06
	lda #$04
	jsr Sc774
	bit LTK_Var_CPUMode
	bpl Lc75c
	ldx #$4c
	jsr Sc77d
Lc75c
	pla
	sta LTK_DiskRWControl
	pla
	bit LTK_Var_CPUMode
	bpl Lc769
	sta $ff00
Lc769
	lda $9a
	cmp $c566
	beq Lc773
	inc $c565
Lc773
	rts
	
Sc774
	pha
	jsr LTK_KernalTrapRemove
	pla
	tax
	jmp LTK_KernalCall 
	
Sc77d
	ldy #$14
Lc77f
	lda Lc78b,y
	sta LTK_MiscWorkspace,y
	dey
	bpl Lc77f
	jmp LTK_MiscWorkspace
	
Lc78b
	ldy #$0e
	sty $ff00
	stx $f140
	ldy #$3e
	sty $ff00
	rts
	
Sc799
	pha
	lda #$00
	beq Lc7e9
Sc79e
	pha
	lda #$01
	bne Lc7e9
Sc7a3
	pha
	lda #$02
	bne Lc7e9
Sc7a8
	pha
	lda #$03
	bne Lc7e9
Sc7ad
	pha
	lda #$04
	bne Lc7e9
Sc7b2
	pha
	lda #$05
	bne Lc7e9
Sc7b7
	pha
	lda #$06
	bne Lc7e9
Sc7bc
	pha
	lda #$07
	bne Lc7e9
Sc7c1
	pha
	lda #$08
	bne Lc7e9
Sc7c6
	pha
	lda #$09
	bne Lc7e9
Sc7cb
	pha
	lda #$0a
	bne Lc7e9
Sc7d0
	pha
	lda #$0b
	bne Lc7e9
Sc7d5
	pha
	lda #$0c
	bne Lc7e9
	pha
	lda #$0d
	bne Lc7e9
Sc7df
	pha
	lda #$0e
	bne Lc7e9
	pha
	lda #$0f
	bne Lc7e9
Lc7e9
	sty Lc852
	stx $c853
	ldy LTK_Save_PreconfigC
	sty $c854
	ldy LTK_Save_PreconfigD
	sty $c855
	ldy LTK_Save_P
	sty $c856
	ldy LTK_Save_Accu
	sty $c857
	ldy LTK_Save_XReg
	sty $c858
	ldy LTK_Save_YReg
	sty $c859
	asl a
	tay
	lda Lc85a,y
	tax
	lda $c85b,y
	tay
	sec
	jsr LTK_KernalTrapSetup
	pla
	ldy Lc852
	ldx $c853
	jsr LTK_KernalCall2 
	pha
	lda $c854
	sta LTK_Save_PreconfigC
	lda $c855
	sta LTK_Save_PreconfigD
	lda $c856
	sta LTK_Save_P
	lda $c857
	sta LTK_Save_Accu
	lda $c858
	sta LTK_Save_XReg
	lda $c859
	sta LTK_Save_YReg
	pla
	rts
	
Lc852
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
Lc85a		     
	.byte $d2,$ff,$cf,$ff,$cc,$ff 
	.byte $c0,$ff,$c3,$ff,$c9,$ff,$c6,$ff,$e7,$ff,$bd,$ff,$ba,$ff,$33,$a5 
	.byte $d8,$a6,$9f,$ff,$79,$a5,$e4,$ff,$78,$c8 
Sc87a
	lda #$00
	sta $c8db
	sta $c8dc
	sta Lc8da
Lc885
	lda LTK_Command_Buffer,y
	cmp #$3a
	bcc Lc88d
Lc88c
	rts
	
Lc88d
	cmp #$30
	bcc Lc88c
	jsr Sc89f
	sty Lc8da
	iny
	cpy $c601
	beq Lc88c
	bne Lc885
Sc89f
	clc
	sbc #$2f
	sta $c8de
	lda $c8dc
	sta $c8dd
	lda $c8db
	asl a
	rol $c8dd
	asl a
	rol $c8dd
	adc $c8db
	sta $c8db
	lda $c8dd
	adc $c8dc
	sta $c8dc
	asl $c8db
	rol $c8dc
	lda $c8db
	adc $c8de
	sta $c8db
	bcc Lc8d9
	inc $c8dc
Lc8d9
	rts
	
Lc8da
	.byte $00,$00,$00,$00,$00 
Sc8df
	stx $c971
	sty Lc970
	php
	pha
	lda #$30
	ldy #$04
Lc8eb
	sta $c972,y
	dey
	bpl Lc8eb
	pla
	beq Lc90f
	lda $c971
	jsr Sc95b
	sta $c975
	stx $c976
	lda Lc970
	jsr Sc95b
	sta $c973
	stx $c974
	jmp Lc944
	
Lc90f
	iny
Lc910
	lda Lc970
	cmp $c978,y
	bcc Lc93f
	bne Lc922
	lda $c971
	cmp $c97d,y
	bcc Lc93f
Lc922
	lda $c971
	sbc $c97d,y
	sta $c971
	lda Lc970
	sbc $c978,y
	sta Lc970
	lda $c972,y
	clc
	adc #$01
	sta $c972,y
	bne Lc910
Lc93f
	iny
	cpy #$05
	bne Lc910
Lc944
	plp
	bcc Lc95a
	ldy #$00
Lc949
	lda $c972,y
	cmp #$30
	bne Lc95a
	lda #$20
	sta $c972,y
	iny
	cpy #$04
	bne Lc949
Lc95a
	rts
	
Sc95b
	pha
	and #$0f
	jsr Sc967
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
Sc967
	cmp #$0a
	bcc Lc96d
	adc #$06
Lc96d
	adc #$30
	rts
	
Lc970
	.byte $ff,$ff,$00,$00,$00,$00,$00,$00,$27,$03,$00,$00,$00,$10,$e8,$64 
	.byte $0a,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00 
