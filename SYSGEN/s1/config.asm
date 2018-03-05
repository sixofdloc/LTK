;config.r.prg
	
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"
	.include "../../include/kernal.asm"

 	*=LTK_DOSOverlay ; LTK_DOSOverlay , $4000 for sysgen
 	
L95e0
	lda LTK_Var_CPUMode
	beq L95e8
	jsr S97e6
L95e8
	lda #$31
	sta L9841 + 5
	ldx #$1e
	ldy #$98
	jsr LTK_Print 
	ldx #$4c
	ldy #$98
	jsr LTK_Print 
	lda #$19
	sta $981d
L9600
	ldx #$54
	ldy #$98
	jsr LTK_Print 
	dec $981d
	bne L9600
	ldx #$56
	ldy #$98
	jsr LTK_Print 
	jsr S97fa
	ldx #$5d
	ldy #$98
	jsr LTK_Print 
	jsr S97fa
	ldx #$7c
	ldy #$98
	jsr LTK_Print 
	jsr S97fa
	ldx #$98
	ldy #$98
	jsr LTK_Print 
	jsr S97fa
	ldx #$b6
	ldy #$98
	jsr LTK_Print 
L963b
	ldy #$10
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall 
	tax
	beq L963b
	cmp #$85
	bne L964d
	jmp L97bb
	
L964d
	cmp #$86
	bne L9654
	jmp L9676
	
L9654
	cmp #$87
	bne L965b
	jmp L97be
	
L965b
	cmp #$88
	bne L963b
	lda LTK_Var_CPUMode
	beq L9667
	jsr S97e6
L9667
	pha
	pla
	beq L9671
	lda #$00
	sta $7f
	beq L9675
L9671
	lda #$80
	sta $9d
L9675
	rts
	
L9676
	lda LTK_Var_SAndRData
	ldx $8027
	ldy $8026
	cmp #$ff
	beq L96de
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L968a
	ldx #$ca
	ldy #$98
	jsr LTK_Print 
	lda $91fd
	pha
	and #$0f
	jsr S9808
	stx L9816
	sta $9817
	pla
	lsr a
	lsr a
	lsr a
	lsr a
	jsr S9808
	stx $9819
	sta $981a
	ldx #$16
	ldy #$98
	jsr LTK_Print 
	lda #$00
	sta $91f0
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	jsr S99c8
	ldx #$77
	ldy #$99
	jsr LTK_Print 
	ldy #$0a
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall 
	cmp #$59
	bne L96da
L96d7
	jmp L95e8
	
L96da
	cmp #$4e
	bne L9676
L96de
	ldx #$00
	stx LTK_Krn_BankControl
	dex
	stx LTK_Var_SAndRData
	stx $8026
	stx $8027
	lda #$0a
	ldx #$2e
	ldy #$03
	clc
	jsr LTK_HDDiscDriver 
	jsr $321c
	lda #$6c
	sta CHROUT
	sta GETIN
	lda #$26
	sta $ffd3
	lda #$2a
	sta $ffe5
	lda #$03
	sta $ffd4
	sta $ffe6
	jsr $1c20
	lda #$20
	sta CHROUT
	sta GETIN
	lda #$59
	sta $ffd3
	sta $ffe5
	lda #$fc
	sta $ffd4
	sta $ffe6
	lda LTK_Var_CPUMode
	beq L96d7
	ldx #$01
	ldy #$1c
	stx $1210
	sty $1211
	ldx #$4f
	ldy #$4f
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	clc
	lda $2d
	adc #$ff
	sta $3d
	lda $2e
	adc #$ff
	sta $3e
	lda #$00
	sta $98
	ldx #$03
	stx $9a
	sta $99
	ldy #$00
	sty $7a
	dey
	sty $120c
	sty $1209
	sty $120a
	sty $1208
	lda $39
	ldy $3a
	sta $35
	sty $36
	lda #$ff
	ldy #$09
	sta $7d
	sty $7e
	lda $2f
	ldy $30
	sta $31
	sty $32
	sta $33
	sty $34
	ldx #$03
L978f
	lda $97b7,x
	sta $1204,x
	dex
	bpl L978f
	sec
	lda $2d
	ldy $2e
	sbc #$01
	bcs L97a2
	dey
L97a2
	sta $43
	sty $44
	ldx #$1b
	stx $18
	lda #$00
	sta $1203
	sta $12
	sta $03df
	jmp L95e8
	
L97b7
	.byte $20,$2c,$2e,$24 
L97bb
	lda #$3b
	.byte $2c 
L97be
	lda #$33
	pha
	ldx #$08
	stx $97db
	txa
	ldx #$00
	ldy #$c0
	sec
	jsr LTK_MemSwapOut 
	pla
	tax
	lda #$0a
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte $00,$c0,$00 
L97dc
	jsr $c000
	clc
L97e0
	jsr LTK_MemSwapOut 
	jmp L95e8
	
S97e6
	ldy #$11
L97e8
	lda L99b6,y
	tax
	lda $1000,y
	sta L99b6,y
	txa
	sta $1000,y
	dey
	bpl L97e8
	rts
	
S97fa
	ldx #$41
	ldy #$98
	jsr LTK_Print 
	inc L9841 + 5
	inc L9841 + 5
	rts
	
S9808
	ldx #$30
L980a
	cmp #$0a
	bcc L9813
	sbc #$0a
	inx
	bne L980a
L9813
	adc #$30
	rts
	
L9816
	.byte $00,$00,$3a,$00,$00,$3a,$00,$00 
L981e
	.text "{clr}       system configuration mode{return}"
	.byte $00
L9841
	.text "  {rvs on} f1 {rvs off}  {00}       "
	.byte $00
L9854
	.byte $b8
	.byte $00
L9856
	.text "{return}{return}{return}{return}{return}{return}"
	.byte $00
L985d
	.text "set logical unit parameters{return}{return}{return}"
	.byte $00
L987c
	.text "set all other parameters{return}{return}{return}"
	.byte $00
L9898
	.text "set the spreadsheet colors{return}{return}{return}"
	.byte $00
L98b6
	.text "exit configure mode"
	.byte $00
L98ca
	.text "{clr}note: the module you're about to enter{return}      requires the use of nearly all of{return}      the memory where basic programs{return}      run. currently, a program by the{return}      name of {rvs on}"
	.byte $00
L9977
	.text "{return}      occupies this area.{return}{return}{return}do you need to save it first ? y{left}"
	.byte $00
L99b6
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$00,$00 
L99c0
	.byte $85,$89,$86,$8a,$87,$8b,$88,$8c 
S99c8
	lda LTK_BeepOnErrorFlag
	beq L9a07
	ldy #$18
	lda #$00
L99d1
	sta SID_V1_FreqLo,y
	dey
	bpl L99d1
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L99e3
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S9a08
	iny
	tya
	cmp #$10
	bne L99e3
	ldx #$50
	jsr S9a08
	ldy #$10
	sta SID_V1_Control
L99fb
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S9a08
	tya
	bne L99fb
L9a07
	rts
	
S9a08
	dec L9a11
	bne S9a08
	dex
	bne S9a08
	rts
	
L9a11
	.byte $00
