;era.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	.include "../../include/basic.asm"

	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen
 
L95e0
	sta L97d6
	ldx $c8
	lda LTK_Var_CPUMode
	beq L95ec
	ldx $ea
L95ec
	stx L97d9
	jsr LTK_ClearHeaderBlock 
	ldx L97d9
	lda #$ff
	sta LTK_Command_Buffer,x
	lda LTK_Var_ActiveLU
	sta L97d7
	lda LTK_Var_Active_User
	sta L97d8
	ldy L97d6
	cpy L97d9
	bcc L9611
L960e
	jmp L97a6
	
L9611
	iny
	cpy L97d9
	bcs L960e
	lda LTK_Command_Buffer,y
	cmp #$22
	bne L961f
	iny
L961f
	lda $01ff,x
	cmp #$22
	bne L9629
	dec L97d9
L9629
	cpy L97d9
	bcs L960e
	sty L97d6
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L963d
	inc L97d6
	bne L965f
L963d
	lda #$00
	ldx #$02
	jsr S9872
	bcs L965f
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L965f
	iny
	sty L97d6
	cpy L97d9
	bcs L960e
	txa
	jsr LTK_SetLuActive 
	bcc L965f
	jmp L979a
	
L965f
	ldy L97d6
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L966e
	inc L97d6
	bne L9691
L966e
	lda #$00
	ldx #$02
	jsr S9872
	bcs L9691
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L9691
	iny
	sty L97d6
	cpy L97d9
	bcs L960e
	cpx #$10
	bcc L968e
	jmp L9794
	
L968e
	stx LTK_Var_Active_User
L9691
	ldy L97d6
	ldx #$00
L9696
	cpy L97d9
	bcs L96a5
	lda LTK_Command_Buffer,y
	sta LTK_FileHeaderBlock ,x
	inx
	iny
	bne L9696
L96a5
	lda #$02
	sec
	jsr $9f00
	bcc L96b0
	jmp L9790
	
L96b0
	jsr LTK_FindFile 
	bcc L96b8
	jmp L97ac
	
L96b8
	sta L97d4
	stx L96dd + 1
	stx L96e0 + 1
	sty L96dd + 2
	sty L96e0 + 2
	lda $91f8
	cmp #$01
	beq L96d6
	cmp #$02
	beq L96d6
	cmp #$03
	bne L96d9
L96d6
	jmp L97a0
	
L96d9
	lda #$80
	ldy #$1d
L96dd
	ora L96dd,y
L96e0
	sta L96e0,y
	ldx #$00
	dec $8ffc
	bne L96eb
	dex
L96eb
	stx L97d5
	lda #$f0
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq L96f9
	lda #$11
L96f9
	sec
	pha
	ldy #$00
	adc L97d4
	tax
	bcc L9704
	iny
L9704
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L970e
	pla
	tax
	lda L97d5
	beq L9736
	lda LTK_Var_ActiveLU
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9721
	pha
	tya
	pha
	ldy L97d4
	lda #$00
	sta $9002,y
	pla
	tay
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9736
	lda $91f8
	cmp #$0a
	bcs L9744
	jsr LTK_DeallocContigBlks 
	bcc L9754
	bcs L9749
L9744
	jsr LTK_DeallocateRndmBlks 
	bcc L9754
L9749
	cpx #$80
	bne L9751
	tax
	jmp L978c
	
L9751
	jsr LTK_FatalError 
L9754
	ldx #$6e
	ldy #$98
	jsr LTK_Print 
	lda LTK_Var_ActiveLU
	jsr S97c6
	stx L97da
	sta L97db
	lda LTK_Var_Active_User
	jsr S97c6
	stx $97dd
	sta L97de
	ldx #$da
	ldy #$97
	jsr LTK_Print 
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	ldx #$0f
	ldy #$98
	jsr LTK_Print 
	ldy #$00
	beq L97b0
L978c
	ldy #$04
	bne L97b0
L9790
	ldy #$05
	bne L97b0
L9794
	ldx #$56
	ldy #$98
	bne L97b0
L979a
	ldx #$3d
	ldy #$98
	bne L97b0
L97a0
	ldx #$21
	ldy #$98
	bne L97b0
L97a6
	ldx #$e1
	ldy #$97
	bne L97b0
L97ac
	ldx #$f7
	ldy #$97
L97b0
	jsr LTK_ErrorHandler 
	lda #$02
	clc
	jsr $9f00
	lda L97d7
	sta LTK_Var_ActiveLU
	lda L97d8
	sta LTK_Var_Active_User
	rts
	
S97c6
	ldx #$30
L97c8
	cmp #$0a
	bcc L97d1
	sbc #$0a
	inx
	bne L97c8
L97d1
	adc #$30
	rts
	
L97d4
	.byte $00
L97d5
	.byte $00
L97d6
	.byte $00
L97d7
	.byte $00
L97d8
	.byte $00
L97d9
	.byte $00
L97da
	.byte $00
L97db
	.byte $00
L97dc
	.text ":"
	.byte $00
L97de
	.byte $00
	.text ":"
	.byte $00
L97e1
	.text "no filename given !!{return}"
	.byte $00
L97f7
	.text "file does not exist !!{return}"
	.byte $00
L980f
	.text "{rvs off}  file deleted.{return}"
	.byte $00
L9821
	.text "file is erase protected !!{return}"
	.byte $00
L983d
	.text "invalid logical unit !!{return}"
	.byte $00
L9856
	.text "invalid user number !!{return}"
	.byte $00
L986e
	.text "{Return}{Return}{Rvs On}"
	.byte $00
S9872
	sta L9883 + 1
	stx L9883 + 2
	lda #$00
	sta L98ed
	sta L98ee
	sta L98ef
L9883
	lda L9883,y
	cmp #$30
	bcc L98db
	cmp #$3a
	bcc L98a0
	ldx $98ac
	cpx #$0a
	beq L98db
	cmp #$41
	bcc L98db
	cmp #$47
	bcs L98db
	sec
	sbc #$07
L98a0
	ldx L98ed
	beq L98c4
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L98ad
	clc
	adc L98ef
	pha
	txa
	adc L98ee
	tax
	pla
	dey
	bne L98ad
	sta L98ef
	stx L98ee
	pla
	tay
	pla
L98c4
	inc L98ed
	sec
	sbc #$30
	clc
	adc L98ef
	sta L98ef
	bcc L98d8
	inc L98ee
	beq L98e5
L98d8
	iny
	bne L9883
L98db
	cmp #$20
	beq L98d8
	clc
	ldx L98ed
	bne L98e6
L98e5
	sec
L98e6
	lda L98ee
	ldx L98ef
	rts
	
L98ed
	.byte $00
L98ee
	.byte $00
L98ef
	.byte $00
