;change.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen
	
L95e0
	sta L991e
	ldx $c8
	lda LTK_Var_CPUMode
	beq L95ec
	ldx $ea
L95ec
	stx L9929
	jsr LTK_ClearHeaderBlock 
	lda LTK_Var_ActiveLU
	sta L991f
	lda LTK_Var_Active_User
	sta L9920
	ldy L991e
	iny
	bcc L960a
	jmp L9889
	
L9607
	jmp L988f
	
L960a
	lda LTK_Command_Buffer,y
	cmp #$22
	bne L9612
	iny
L9612
	ldx L9929
	lda $01ff,x
	cmp #$22
	bne L961f
	dec L9929
L961f
	cpy L9929
	bcs L9607
	sty L991e
	jsr S993b
	bcc L9632
	cmp #$3a
	beq L963b
	bne L964a
L9632
	txa
	jsr LTK_SetLuActive 
	bcc L963b
	jmp L987d
	
L963b
	jsr S993b
	bcs L964a
	cpx #$10
	bcc L9647
	jmp L9883
	
L9647
	stx LTK_Var_Active_User
L964a
	ldx #$00
	ldy L991e
	cpy L9929
	bcs L9607
L9654
	lda LTK_Command_Buffer,y
	cpx #$10
	beq L9607
	sta LTK_FileHeaderBlock ,x
	iny
	cpy L9929
	bcs L9667
	inx
	bne L9654
L9667
	lda #$02
	sec
	jsr $9f00
	bcc L9672
	jmp L9879
	
L9672
	jsr LTK_FindFile 
	sta L9926
	stx $9738
	stx $973b
	sty $9739
	sty $973c
	bcs L9607
	lda $91f8
	cmp #$01
	beq L9695
	cmp #$02
	beq L9695
	cmp #$03
	bne L9698
L9695
	jmp L9895
	
L9698
	lda $9200
	sta L9924
	lda $9201
	sta L9925
	lda $91fd
	lsr a
	lsr a
	lsr a
	lsr a
	sta LTK_Var_Active_User
	sta L9921
L96b1
	jsr S98af
	ldx #$0f
	ldy #$9a
	jsr S98f6
	bcs L96b1
	cpy #$01
	bne L96d6
	lda L9926
	sta L9923
	lda $9738
	sta L9928
	lda $9739
	sta L9927
	jmp L9778
	
L96d6
	jsr LTK_ClearHeaderBlock 
	ldy #$00
L96db
	lda L992a,y
	cmp #$0d
	beq L96ea
	sta LTK_FileHeaderBlock ,y
	iny
	cpy #$10
	bne L96db
L96ea
	jsr S98e0
	bcc L96b1
	sta L9923
	stx L9928
	sty L9927
	jsr S98af
	ldy #$00
L96fd
	lda L992a,y
	cmp #$0d
	bne L9706
	lda #$00
L9706
	sta LTK_FileHeaderBlock ,y
	iny
	cpy #$10
	bne L96fd
	jsr S98c0
	lda #$f0
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq L971c
	lda #$11
L971c
	ldy #$00
	sec
	adc L9926
	tax
	bcc L9726
	iny
L9726
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9730
	pha
	tya
	pha
	ldy #$1d
	lda #$80
	ora $9737,y
	sta $973a,y
	dec $8ffc
	pla
	tay
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L974a
	lda $8ffc
	bne L9778
	ldx #$f0
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq L975a
	ldx #$11
L975a
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9763
	pha
	tya
	pha
	ldy L9926
	lda #$00
	sta $9002,y
	pla
	tay
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9778
	jsr S98af
	lda $91f8
	cmp #$0b
	beq L9786
	cmp #$0c
	bne L97d5
L9786
	ldx #$40
	ldy #$9a
	jsr S98f6
	bcs L9778
	cpy #$01
	beq L97b3
	ldy #$00
	ldx #$0a
	cmp #$24
	bne L979e
	iny
	ldx #$10
L979e
	stx $9ae9
	lda #$2a
	ldx #$99
	jsr S9aaf
	bcs L9778
	stx $91fb
	sta $91fa
	jsr S98c0
L97b3
	jsr S98af
	ldx #$d6
	ldy #$99
	jsr S98f6
	bcs L97b3
	cpy #$01
	beq L97d5
	ldx #$0b
	cmp #$42
	beq L97cf
	ldx #$0c
	cmp #$4d
	bne L97b3
L97cf
	stx $91f8
	jsr S98c0
L97d5
	jsr S98af
	lda L9921
	sta LTK_Var_Active_User
	ldx #$65
	ldy #$9a
	jsr S98f6
	bcs L97d5
	cpy #$01
	beq L9812
	ldy #$00
	lda #$2a
	ldx #$99
	jsr S9aaf
	bcs L97fd
	tay
	bne L97fd
	cpx #$10
	bcc L9807
L97fd
	ldx #$97
	ldy #$9a
	jsr LTK_ErrorHandler 
	jmp L97d5
	
L9807
	stx LTK_Var_Active_User
	jsr S98e0
	bcc L97d5
	jsr S98c0
L9812
	jsr S98af
	ldx #$7a
	ldy #$9a
	jsr S98f6
	bcs L9812
	cmp #$4e
	beq L986e
	cmp #$59
	bne L9812
	lda L9928
	sta S98ee + 1
	sta S98f2 + 1
	lda L9927
	sta S98ee + 2
	sta S98f2 + 2
	lda #$f0
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq L9843
	lda #$11
L9843
	sec
	ldy #$00
	adc L9923
	tax
	bcc L984d
	iny
L984d
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9857
	pha
	tya
	pha
	ldy #$1a
	jsr S98ee
	and #$7f
	jsr S98f2
	pla
	tay
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L986e
	ldx #$61
	ldy #$99
	jsr LTK_Print 
	ldy #$00
	beq L9899
L9879
	ldy #$05
	bne L9899
L987d
	ldx #$f6
	ldy #$99
	bne L9899
L9883
	ldx #$97
	ldy #$9a
	bne L9899
L9889
	ldx #$78
	ldy #$99
	bne L9899
L988f
	ldx #$89
	ldy #$99
	bne L9899
L9895
	ldx #$a1
	ldy #$99
L9899
	jsr LTK_ErrorHandler 
	lda #$02
	clc
	jsr $9f00
	lda L991f
	sta LTK_Var_ActiveLU
	lda L9920
	sta LTK_Var_Active_User
	rts
	
S98af
	lda LTK_Var_ActiveLU
	ldx L9925
	ldy L9924
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L98bf
	rts
	
S98c0
	lda L9923
	pha
	ldx L9928
	ldy L9927
	lda #$24
	jsr LTK_ExeExtMiniSub 
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L98df
	rts
	
S98e0
	jsr LTK_FindFile 
	bcs L98ed
	ldx #$be
	ldy #$99
	jsr LTK_ErrorHandler 
	clc
L98ed
	rts
	
S98ee
	lda S98ee,y
	rts
	
S98f2
	sta S98f2,y
	rts
	
S98f6
	jsr LTK_Print 
	ldy #$10
	lda #$00
L98fd
	sta L992a,y
	dey
	bpl L98fd
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
L990a
	jsr LTK_KernalCall 
	sta L992a,y
	iny
	cpy #$12
	bcs L991a
	cmp #$0d
	bne L990a
	clc
L991a
	lda L992a
	rts
	
L991e
	.byte $00
L991f
	.byte $00
L9920
	.byte $00
L9921
	.byte $00
L9922
	.byte $00
L9923
	.byte $00
L9924
	.byte $00
L9925
	.byte $00
L9926
	.byte $00
L9927
	.byte $00
L9928
	.byte $00
L9929
	.byte $00
L992a
	.byte $00
L992b
	.byte $00
L992c
	.byte $00
L992d
	.byte $00
L992e
	.byte $00
L992f
	.byte $00
L9930
	.byte $00
L9931
	.byte $00
L9932
	.byte $00
L9933
	.byte $00
L9934
	.byte $00
L9935
	.byte $00
L9936
	.byte $00
L9937
	.byte $00
L9938
	.byte $00
L9939
	.byte $00
L993a
	.byte $00
S993b
	ldy L991e
	lda #$00
	ldx #$02
	cpy L9929
	bcs L995f
	jsr S9aaf
	php
	bcs L9951
	pha
	pla
	bne L995e
L9951
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L995e
	iny
	sty L991e
	plp
	rts
	
L995e
	plp
L995f
	sec
	rts
	
L9961
	.text "{return}{return}change(s) completed{return}"
	.byte $00
L9978
	.text "syntax error !!{return}"
	.byte $00
L9989
	.text "file does not exist !!{return}"
	.byte $00
L99a1
	.text "file is change protected !!{return}"
	.byte $00
L99be
	.text "file already exists !!{return}"
	.byte $00
L99d6
	.text "{return}{return}file type  (b)asic or (m)l ? "
	.byte $00
L99f6
	.text "invalid logical unit !!{return}"
	.byte $00
L9a0f
	.text "{return}{return}if no change, hit return only{return}{return}new filename ? "
	.byte $00 
L9a40
	.text "{return}{return}new load address (use $ if hex) ? "
	.byte $00
L9a65
	.text "{return}{return}new user number ? "
	.byte $00
L9a7a
	.text "{return}{return}clear dirty file flag ? n{left}"
	.byte $00
L9a97
	.text "invalid user number !!{return}"
	.byte $00
S9aaf
	sta L9ac0 + 1
	stx L9ac0 + 2
	lda #$00
	sta L9b2a
	sta L9b2b
	sta L9b2c
L9ac0
	lda L9ac0,y
	cmp #$30
	bcc L9b18
	cmp #$3a
	bcc L9add
	ldx $9ae9
	cpx #$0a
	beq L9b18
	cmp #$41
	bcc L9b18
	cmp #$47
	bcs L9b18
	sec
	sbc #$07
L9add
	ldx L9b2a
	beq L9b01
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9aea
	clc
	adc L9b2c
	pha
	txa
	adc L9b2b
	tax
	pla
	dey
	bne L9aea
	sta L9b2c
	stx L9b2b
	pla
	tay
	pla
L9b01
	inc L9b2a
	sec
	sbc #$30
	clc
	adc L9b2c
	sta L9b2c
	bcc L9b15
	inc L9b2b
	beq L9b22
L9b15
	iny
	bne L9ac0
L9b18
	cmp #$20
	beq L9b15
	clc
	ldx L9b2a
	bne L9b23
L9b22
	sec
L9b23
	lda L9b2b
	ldx L9b2c
	rts
	
L9b2a
	.byte $00
L9b2b
	.byte $00
L9b2c
	.byte $00
