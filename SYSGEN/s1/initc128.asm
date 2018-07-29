;initc128.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/vic_regs.asm"

    *=LTK_DOSOverlay ;$95e0


L95e0
	lda LTK_HardwarePage
	cmp #$df
	beq L9606
	lda #$0a
	ldx #$28
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L95f4
	lda #$e0
	sta $31
	sta $33
	lda #$95
	sta $32
	clc
	adc #$06
	sta $34
	jsr LTK_MiniSubExeArea 
L9606
	jmp L9630
	
L9609
	lda #$2d
	sta $fffa
	sta $fffc
	lda #$96
	sta $fffb
	sta $fffd
	lda #$0a
	ldx #$ed
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9626
	ldx #$e0
	ldy #$8f
	jsr LTK_Print 
L962d
	jmp L962d
	
L9630
	ldy #$07
L9632
	lda $8fd4,y
	cmp $93d4,y
	bne L9609
	dey
	bpl L9632
	lda #$0a
	ldx #$11
	ldy #$00
L9643
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L964a
	pha
	txa
	pha
	tya
	pha
	jsr S98bc
	pla
	tay
	pla
	tax
	pla
	inx
	dec L992b
	bne L9643
	lda $9be5
	ldx #$04
	ldy #$00
L9664
	sta $d800,y
	iny
	bne L9664
	inc L9664 + 2
	dex
	bne L9664
	bit $d7
	bpl L9677
	lda $9be7
L9677
	sta $f1
	lda $9be3
	sta BORDER
	lda $9be4
	sta BACKGROUND
	lda $9be6
	ldx #$1a
	stx $d600
L968d
	bit $d600
	bpl L968d
	sta $d601
	lda #$08
	sta $ba
	lda #$fe
	sta L99fc + 1
	lda #$20
	sta L9a76
	lda $91f2
	bmi L96dc
	beq L96dc
	and #$3f
	sta L9a7b
	lda $91f3
	sta L9a7c
	ldx $91f9
	dex
	stx L9a7e
	lda $91f7
	sec
	sbc #$01
	sta L9a80
	lda $91f6
	sbc #$00
	sta L9a7f
	lda $91f5
	sta L9a81
	lda $91fa
	sta L9a82
	jsr S99e9
L96dc
	lda #$7f
	sta L99fc + 1
L96e1
	lda #$00
	sta L9a76
	lda L9928
	asl a
	asl a
	asl a
	tay
	lda $92e0,y
	bmi L972e
	beq L972e
	and #$3f
	sta L9a7b
	lda $92e1,y
	sta L9a7c
	ldx $92e3,y
	dex
	stx L9a7e
	lda $92e5,y
	sec
	sbc #$01
	sta L9a80
	lda $92e4,y
	sbc #$00
	sta L9a7f
	lda $92e6,y
	sta L9a81
	lda $92e7,y
	sta L9a82
	jsr S99e9
	lda #$20
	sta L9a76
	jsr S99e9
L972e
	sec
	ror L99fc + 1
	dec L9928
	bpl L96e1
	lda $920a
	beq L9752
	lda $d5
	cmp #$58
	bne L9752
	lda #$0a
	ldx #$c2
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L974f
	jsr LTK_FileWriteBuffer 
L9752
	ldx #$0a
	jsr S9870
	ldx #$ff
	bcs L977e
	lda $91f8
	cmp #$04
	bne L977e
	lda $91f0
	bne L977e
	lda $91f1
	cmp #$19
	bne L977e
	lda $9200
	ora $91fc
	tax
	lda $9201
	clc
	adc #$05
	bcc L977e
	inx
L977e
	stx $9fac
	sta $9fad
	lda $9bed
	sta LTK_Var_Active_User
	lda $9beb
	jsr LTK_SetLuActive 
	bcc L9797
	lda #$0a
	sta LTK_Var_ActiveLU
L9797
	lda LTK_Var_Active_User
	asl a
	asl a
	asl a
	asl a
	ora LTK_Var_ActiveLU
	sta $9e45
	lda #$00
	ldx #$05
L97a8
	sta $03,x
	dex
	bpl L97a8
	sta $7f
	ldx $9bf5
	beq L97b6
	lda #$80
L97b6
	ldx $9bf7
	beq L97bd
	ora #$40
L97bd
	sta $9e44
	ldy #$49
	jsr LTK_ErrorHandler 
	lda $d5
	cmp #$58
	bne L97d2
	ldx #$00
	jsr S9870
	bcc L97d5
L97d2
	jmp L9882
	
L97d5
	lda $91f8
	cmp #$0b
	beq L981b
	cmp #$0c
	bne L97d2
	lda #$01
	sta $b9
	jsr LTK_LoadRandFile 
	lda #$00
	ldx $91fb
	ldy $91fa
	sec
	jsr S9946
	lda #$53
	sta $034a
	sta $034c
	lda #$59
	sta $034b
	ldy #$04
L9802
	lda L99d9,y
	sta $034d,y
	dey
	bpl L9802
	lda #$0d
	sta $0352
	lda #$09
	sta $d0
	lda #$80
	sta $7f
	jmp L98a3
	
L981b
	lda #$00
	sta $b9
	lda LTK_Save_XReg
	sta L9929
	lda LTK_Save_YReg
	sta L992a
	lda $2d
	sta LTK_Save_XReg
	lda $2e
	sta LTK_Save_YReg
	jsr LTK_LoadRandFile 
	lda L992a
	sta LTK_Save_YReg
	lda L9929
	sta LTK_Save_XReg
	stx $1210
	sty $1211
	ldx #$4f
	ldy #$4f
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	lda #$52
	sta $034a
	lda #$55
	sta $034b
	lda #$4e
	sta $034c
	lda #$0d
	sta $034d
	lda #$04
	sta $d0
	jmp L98a3
	
S9870
	jsr LTK_ClearHeaderBlock 
L9873
	lda L992c,x
	beq L987f
	sta LTK_FileHeaderBlock ,y
	iny
	inx
	bne L9873
L987f
	jmp LTK_FindFile 
	
L9882
	lda #$0a
	ldx #$21
	ldy #$00
	sty LTK_BLKAddr_MiniSub
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0
 
L9892
	ldx #$e2
	ldy #$93
	lda $d7
	beq L98a0
	ldx LTK_MiniSubExeArea 
	ldy $93e1
L98a0
	jsr LTK_Print 
L98a3
	lda #$ff
	sta LTK_AutobootFlag
	lda #$00
	sta $2f
	sta $31
	sta $33
	lda #$04
	sta $30
	sta $32
	sta $34
	sec
	jmp LTK_SysRet_AsIs  
	
S98bc
	stx L98dd + 1
	lda $31
	pha
	lda $32
	pha
	lda #$e0
	sta $31
	lda #$8f
	sta $32
	lda #$00
	tay
	ldx #$02
L98d2
	clc
	adc ($31),y
	iny
	bne L98d2
	inc $32
	dex
	bne L98d2
L98dd
	cmp #$00
	bne L9908
	cmp #$1a
	beq L98f6
	cmp #$29
	bne L9901
	ldy #$00
L98eb
	lda LTK_MiscWorkspace,y
	sta $9f00,y
	iny
	bne L98eb
	beq L9901
L98f6
	ldy #$31
L98f8
	lda $8fe4,y
	sta $80a8,y
	dey
	bpl L98f8
L9901
	pla
	sta $32
	pla
	sta $31
	rts
	
L9908
	ldy #$0b
L990a
	lda L991c,y
	sta $0b00,y
	dey
	bpl L990a
	pla
	sta $32
	pla
	sta $31
	jmp $0b00
	
L991c
	lda #$40
	sta $df02
	lda #$3c
	sta $df03
	sec
	rts
	
L9928
	.byte $06 
L9929
	.byte $00
L992a
	.byte $00
L992b
	.byte $1a 
L992c
	.text "autostart"
	.byte $00
L9936
	.text "user.alternates"
	.byte $00
S9946
	stx L99d8
	sty L99d7
	php
	pha
	lda #$30
	ldy #$04
L9952
	sta L99d9,y
	dey
	bpl L9952
	pla
	beq L9976
	lda L99d8
	jsr S99c2
	sta L99dc
	stx L99dd
	lda L99d7
	jsr S99c2
	sta L99da
	stx L99db
	jmp L99ab
	
L9976
	iny
L9977
	lda L99d7
	cmp L99df,y
	bcc L99a6
	bne L9989
	lda L99d8
	cmp L99e4,y
	bcc L99a6
L9989
	lda L99d8
	sbc L99e4,y
	sta L99d8
	lda L99d7
	sbc L99df,y
	sta L99d7
	lda L99d9,y
	clc
	adc #$01
	sta L99d9,y
	bne L9977
L99a6
	iny
	cpy #$05
	bne L9977
L99ab
	plp
	bcc L99c1
	ldy #$00
L99b0
	lda L99d9,y
	cmp #$30
	bne L99c1
	lda #$20
	sta L99d9,y
	iny
	cpy #$04
	bne L99b0
L99c1
	rts
	
S99c2
	pha
	and #$0f
	jsr S99ce
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
S99ce
	cmp #$0a
	bcc L99d4
	adc #$06
L99d4
	adc #$30
	rts
	
L99d7
	.byte $ff 
L99d8
	.byte $ff 
L99d9
	.byte $00
L99da
	.byte $00
L99db
	.byte $00
L99dc
	.byte $00
L99dd
	.byte $00,$00 
L99df
	.byte $27,$03,$00,$00,$00 
L99e4
	.byte $10,$e8,$64,$0a,$01 
S99e9
	jsr S99f9
	bne L99f8
	ldx #$10
	ldy #$00
	jsr S9a21
	jsr S9a5e
L99f8
	rts
	
S99f9
	jsr S9a3a
L99fc
	lda #$7f
	sta $df00
	lda #$50
	sta $df02
	ldx #$00
	ldy #$10
L9a0a
	lda $df02
	and #$08
	beq L9a19
	inx
	bne L9a0a
	dey
	bne L9a0a
	pla
	pla
L9a19
	lda #$40
	sta $df02
	lda #$00
	rts
	
S9a21
	jsr S9a4a
	lda L9a75,y
	eor #$ff
	sta $df00
	jsr S9a50
	iny
	dex
	bne S9a21
	jsr S9a4a
	rts
	
S9a37
	ldx #$00
	.byte $2c 
S9a3a
	ldx #$ff
	lda #$38
	sta $df01
	stx $df00
	lda #$3c
	sta $df01
	rts
	
S9a4a
	lda $df02
	bmi S9a4a
	rts
	
S9a50
	lda #$2c
	sta $df01
	lda $df00
	lda #$3c
	sta $df01
	rts
	
S9a5e
	jsr S9a37
	jsr S9a67
	and #$9f
	tax
S9a67
	jsr S9a4a
	lda $df00
	eor #$ff
	tay
	jsr S9a50
	tya
	rts
	
L9a75
	.byte $c2 
L9a76
	.byte $00,$00,$00,$00,$00 
L9a7b
	.byte $00
L9a7c
	.byte $00,$00 
L9a7e
	.byte $00
L9a7f
	.byte $00
L9a80
	.byte $00
L9a81
	.byte $00
L9a82
	.byte $00,$00,$00 
