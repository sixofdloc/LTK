;copy.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen 

L95e0
	sta L9a2e
	ldx $c8
	lda LTK_Var_CPUMode
	beq L95ec
	ldx $ea
L95ec
	stx L9a2d
	jsr LTK_ClearHeaderBlock 
	lda LTK_Var_ActiveLU
	sta $9a30
	lda LTK_Var_Active_User
	sta L9a31
	sta L9a34
	sta L9a35
	lda #$00
	sta L9a25
	sta L9a26
	ldx #$10
L960e
	sta L9a3e,x
	dex
	bpl L960e
	ldy L9a2e
	iny
	bcc L961d
	jmp L98d2
	
L961d
	lda LTK_Command_Buffer,y
	cmp #$22
	bne L9625
	iny
L9625
	sty L9a2e
	jsr S99ff
	bcc L9633
	cmp #$3a
	beq L963c
	bne L964b
L9633
	txa
	jsr LTK_SetLuActive 
	bcc L963c
	jmp L98c0
	
L963c
	jsr S99ff
	bcs L964b
	cpx #$10
	bcc L9648
	jmp L98cc
	
L9648
	stx L9a35
L964b
	lda LTK_Var_ActiveLU
	sta L9a33
	ldx #$00
	ldy L9a2e
	cpy L9a2d
	bcc L965e
	jmp L98d2
	
L965e
	lda LTK_Command_Buffer,y
	cmp #$3d
	beq L967d
	cmp #$22
	beq L9674
	cpx #$10
	bne L9670
	jmp L98d2
	
L9670
	sta L9a3e,x
	inx
L9674
	iny
	cpy L9a2d
	bcc L965e
	jmp L98d2
	
L967d
	txa
	bne L9681
	dex
L9681
	stx L9a2f
	iny
	cpy L9a2d
	bcc L968d
L968a
	jmp L98d8
	
L968d
	lda LTK_Command_Buffer,y
	cmp #$22
	bne L9695
	iny
L9695
	ldx L9a2d
	lda $01ff,x
	cmp #$22
	bne L96a2
	dec L9a2d
L96a2
	cpy L9a2d
	bcs L968a
	sty L9a2e
	lda $9a30
	sta LTK_Var_ActiveLU
	jsr S99ff
	bcc L96bb
	cmp #$3a
	beq L96c4
	bne L96d3
L96bb
	txa
	jsr LTK_SetLuActive 
	bcc L96c4
	jmp L98ba
	
L96c4
	jsr S99ff
	bcs L96d3
	cpx #$10
	bcc L96d0
	jmp L98c6
	
L96d0
	stx L9a34
L96d3
	lda LTK_Var_ActiveLU
	sta L9a32
	ldx #$00
	ldy L9a2e
	cpy L9a2d
L96e1
	bcs L968a
L96e3
	lda LTK_Command_Buffer,y
	cpx #$10
	beq L968a
	sta LTK_FileHeaderBlock ,x
	bit L9a2f
	bpl L96f5
	sta L9a3e,x
L96f5
	iny
	cpy L9a2d
	bcs L96fe
	inx
	bne L96e3
L96fe
	lda L9a32
	sta LTK_Var_ActiveLU
	lda L9a34
	sta LTK_Var_Active_User
	lda #$02
	sec
	jsr $9f00
	bcc L9715
	jmp L98b6
	
L9715
	jsr LTK_FindFile 
	sta L9a3b
	bcs L96e1
	lda $91f8
	cmp #$01
	beq L972c
	cmp #$03
	beq L972c
	cmp #$02
	bne L972f
L972c
	jmp L98f3
	
L972f
	cmp #$0a
	bcs L9736
	dec L9a26
L9736
	lda $9200
	sta L9a39
	lda $9201
	sta L9a3a
	jsr LTK_ClearHeaderBlock 
	ldy #$00
	
L9747
	lda L9a3e,y
	sta LTK_FileHeaderBlock ,y
	iny
	cpy #$10
	bne L9747
	lda L9a33
	sta LTK_Var_ActiveLU
	lda L9a35
	sta LTK_Var_Active_User
	lda #$02
	sec
	jsr $9f00
	bcc L9769
	jmp L98b6
	
L9769
	jsr LTK_FindFile 
	bcs L9771
	jmp L98de
	
L9771
	sta L9a36
	stx L9a3d
	sty L9a3c
	ldy L9a39
	ldx L9a3a
	lda L9a32
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L978a
	ldy #$10
L978c
	lda LTK_MiscWorkspace,y
	sta LTK_FileHeaderBlock ,y
	iny
	lda L9a26
	beq L979e
	cpy #$00
	beq L97a2
	bne L978c
L979e
	cpy #$20
	bne L978c
L97a2
	lda L9a26
	bne L97f5
	ldx $91f0
	lda $91f1
	cpx #$00
	bne L97b5
	cmp #$f1
	bcc L97f5
L97b5
	dec L9a25
	sec
	sbc #$01
	bcs L97be
	dex
L97be
	tay
	lda #$00
L97c1
	cpx #$01
	bcc L97d8
	bne L97cb
	cpy #$01
	bcc L97d8
L97cb
	adc #$00
	dey
	cpy #$ff
	bne L97d5
	dex
	beq L97d8
L97d5
	dex
	bne L97c1
L97d8
	cpx #$00
	bne L97e0
	cpy #$00
	beq L97e3
L97e0
	clc
	adc #$01
L97e3
	sta L9a27
	lda $91f1
	sec
	sbc L9a27
	sta $91f1
	bcs L97f5
	dec $91f0
L97f5
	lda L9a26
	beq L9801
	jsr LTK_AllocContigBlks 
	bcc L9811
	bcs L9806
L9801
	jsr LTK_AllocateRandomBlks 
	bcc L9811
L9806
	cpx #$80
	bne L980e
	tax
	jmp L98b2
	
L980e
	jmp L98e4
	
L9811
	ldx #$00
	stx LTK_BLKAddr_MiniSub
	stx L9a37
	stx L9a38
	lda #$ff
	sta LTK_ReadChanFPTPtr
	sta LTK_WriteChanFPTPtr
	lda L9a36
	pha
	ldx L9a3d
	ldy L9a3c
	lda #$24
	jsr LTK_ExeExtMiniSub 
	ldy L9a39
	ldx L9a3a
	lda L9a32
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9843
	ldy $9200
	ldx $9201
	lda L9a33
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9853
	jmp L9877
	
L9856
	jsr S991d
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L9860
	lda L9a26
	bne L986d
	lda L9a2c
	beq L986d
	sta L9a2b
L986d
	jsr S9948
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
L9877
	inc L9a38
	bne L987f
	inc L9a37
L987f
	lda $91f1
	ldx $91f0
	ldy L9a26
	bne L9891
	sec
	sbc L9a27
	bcs L9891
	dex
L9891
	cpx L9a37
	bne L9856
	cmp L9a38
	bne L9856
	lda $91f8
	cmp #$04
	bne L98a7
	lda #$1f
	jsr LTK_ExeExtMiniSub 
L98a7
	ldx #$97
	ldy #$9a
	jsr LTK_Print 
	ldy #$00
	beq L98f7
L98b2
	ldy #$04
	bne L98f7
L98b6
	ldy #$05
	bne L98f7
L98ba
	ldx #$b9
	ldy #$9a
	bne L98f7
L98c0
	ldx #$cf
	ldy #$9a
	bne L98f7
L98c6
	ldx #$0b
	ldy #$9b
	bne L98f7
L98cc
	ldx #$23
	ldy #$9b
	bne L98f7
L98d2
	ldx #$4f
	ldy #$9a
	bne L98f7
L98d8
	ldx #$60
	ldy #$9a
	bne L98f7
L98de
	ldx #$78
	ldy #$9a
	bne L98f7
L98e4
	ldx #$89
	ldy #$9a
	lda L9a26
	beq L98f7
	ldx #$ea
	ldy #$9a
	bne L98f7
L98f3
	ldx #$a6
	ldy #$9a
L98f7
	jsr LTK_ErrorHandler 
	lda L9a32
	jsr S9913
	lda L9a33
	jsr S9913
	lda $9a30
	sta LTK_Var_ActiveLU
	lda L9a31
	sta LTK_Var_Active_User
	rts
	
S9913
	sta LTK_Var_ActiveLU
	lda #$02
	clc
	jsr $9f00
	rts
	
S991d
	lda L9a26
	beq L9935
	lda $9001
	clc
	adc L9a38
	tax
	lda $9000
	adc L9a37
	tay
	lda L9a32
	rts
	
L9935
	lda #$02
	sta L999f + 1
	lda L9a32
	sta $99c8
	lda #$90
	ldx #$e0
	ldy #$9b
	bne L9971
S9948
	lda L9a26
	beq L9960
	lda $9201
	clc
	adc L9a38
	tax
	lda $9200
	adc L9a37
	tay
	lda L9a33
	rts
	
L9960
	lda #$02
	sta L999f + 1
	lda L9a33
	sta $99c8
	lda #$92
	ldx #$e0
	ldy #$8d
L9971
	sta $99a2
	stx L99cd
	sty L99ce
	lda #$00
	sta L9a2c
	ldx L9a37
	lda L9a38
	sec
	sbc #$01
	bcs L998b
	dex
L998b
	stx L9a28
	sta L9a29
	sta L9a2a
	tay
	bne L999f
	txa
	bne L999f
	lda #$ff
	sta L9a2b
L999f
	lda #$00
	ldx #$00
	jsr S99e3
	lda L9a25
	beq L99d9
	ldy #$08
L99ad
	lsr L9a28
	ror L9a29
	dey
	bne L99ad
	lda L9a29
	cmp L9a2b
	beq L99d0
	sta L9a2b
	dec L9a2c
	jsr S99ea
	lda #$00
	clc
	jsr LTK_HDDiscDriver 
L99cd
	.byte $00	
L99ce
	.byte $00
L99cf
	.byte $01 
L99d0
	lda L99cd
	ldx L99ce
	jsr S99e3
L99d9
	lda L9a2a
	jsr S99ea
	lda $99c8
	rts
	
S99e3
	sta S99fa + 1
	stx S99fa + 2
	rts
	
S99ea
	asl a
	tax
	bcc L99f1
	inc S99fa + 2
L99f1
	jsr S99fa
	tay
	jsr S99fa
	tax
	rts
	
S99fa
	lda S99fa,x
	inx
	rts
	
S99ff
	ldy L9a2e
	lda #$00
	ldx #$02
	cpy L9a2d
	bcs L9a23
	jsr S9b40
	php
	bcs L9a15
	pha
	pla
	bne L9a22
L9a15
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L9a22
	iny
	sty L9a2e
	plp
	rts
	
L9a22
	plp
L9a23
	sec
	rts
	
L9a25
	.byte $00
L9a26
	.byte $00
L9a27
	.byte $00
L9a28
	.byte $00
L9a29
	.byte $00
L9a2a
	.byte $00
L9a2b
	.byte $ff 
L9a2c
	.byte $00
L9a2d
	.byte $00
L9a2e
	.byte $00
L9a2f			
	.byte $00
L9a30
	.byte $00
L9a31
	.byte $00
L9a32
	.byte $00
L9a33
	.byte $00
L9a34
	.byte $00
L9a35
	.byte $00
L9a36
	.byte $00
L9a37
	.byte $00
L9a38
	.byte $00
L9a39
	.byte $00
L9a3a
	.byte $00
L9a3b
	.byte $00
L9a3c
	.byte $00
L9a3d
	.byte $00
L9a3e
	.byte $00
L9a3f
	.byte $00
L9a40
	.byte $00
L9a41
	.byte $00
L9a42
	.byte $00
L9a43
	.byte $00
L9a44
	.byte $00
L9a45
	.byte $00
L9a46
	.byte $00
L9a47
	.byte $00
L9a48
	.byte $00
L9a49
	.byte $00
L9a4a
	.byte $00
L9a4b
	.byte $00
L9a4c
	.byte $00
L9a4d
	.byte $00
L9a4e
	.byte $00
L9a4f
	.text "syntax error !!{return}"
	.byte $00 
L9a60
	.text "file does not exist !!{return}"
	.byte $00
L9a78
	.text "file  exists !!{return}"
	.byte $00
L9a89
	.text "disk full !!{return}"
	.byte $00
L9a97
	.text "{return}{return}file copied{return}"
	.byte $00
L9aa6
	.text "copy protected !!{return}"
	.byte $00
L9ab9
	.text "invalid source lu !!{return}"
	.byte $00
L9acf
	.text "invalid destination lu !!{return}"
	.byte $00
L9aea
	.text "not enough contiguous blocks !!{return}"
	.byte $00
L9b0b
	.text "invalid source user !!{return}"
	.byte $00
L9b23
	.text "invalid destination user !!{return}"
	.byte $00
S9b40
	sta L9b51 + 1
	stx L9b51 + 2
	lda #$00
	sta L9bbb
	sta L9bbc
	sta L9bbd
L9b51
	lda L9b51,y
	cmp #$30
	bcc L9ba9
	cmp #$3a
	bcc L9b6e
	ldx $9b7a
	cpx #$0a
	beq L9ba9
	cmp #$41
	bcc L9ba9
	cmp #$47
	bcs L9ba9
	sec
	sbc #$07
L9b6e
	ldx L9bbb
	beq L9b92
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9b7b
	clc
	adc L9bbd
	pha
	txa
	adc L9bbc
	tax
	pla
	dey
	bne L9b7b
	sta L9bbd
	stx L9bbc
	pla
	tay
	pla
L9b92
	inc L9bbb
	sec
	sbc #$30
	clc
	adc L9bbd
	sta L9bbd
	bcc L9ba6
	inc L9bbc
	beq L9bb3
L9ba6
	iny
	bne L9b51
L9ba9
	cmp #$20
	beq L9ba6
	clc
	ldx L9bbb
	bne L9bb4
L9bb3
	sec
L9bb4
	lda L9bbc
	ldx L9bbd
	rts
	
L9bbb
	.byte $00
L9bbc
	.byte $00
L9bbd
	.byte $00
