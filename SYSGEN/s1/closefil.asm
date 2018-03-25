;closefil.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen

L95e0
	jmp L963c
	
L95e3
	sta L963b
	lda $b9
	and #$0f
	cmp #$0f
	bne L95f2
	ldx #$e0
	bne L960b
L95f2
	ldy #$07
	ldx #$00
L95f6
	lda LTK_FileParamTable,x
	cmp $b8
	beq L960b
	txa
	clc
	adc #$20
	tax
	dey
	bne L95f6
	jsr S962c
	jmp L9628
	
L960b
	stx L98eb
	jsr S962c
	ldx L98eb
	cpx #$e0
	beq L963c
	lda LTK_FileParamTable,x
	bne L9625
	ldy #$3d
	jsr LTK_ErrorHandler 
	jmp LTK_SysRet_AsIs  
	
L9625
	jsr S968f
L9628
	clc
	jmp LTK_SysRet_AsIs  
	
S962c
	sec
	ldx #$f2
	ldy #$f2
	jsr LTK_KernalTrapSetup
	lda L963b
	jsr LTK_KernalCall 
	rts
	
L963b
	.byte $00
L963c
	ldy #$08
	ldx #$00
L9640
	lda LTK_FileParamTable,x
	bne L9650
	txa
	clc
	adc #$20
	tax
	dey
	bne L9640
	jmp L9681
	
L9650
	lda LTK_AutobootFlag
	bne L9662
	lda #$95
	pha
	lda #$df
	pha
	lda #$64
	ldx #$03
	jmp LTK_CallExtDosOvl 
	
L9662
	jsr S98c7
	lda #$08
	sta L98c5
L966a
	stx L98eb
	lda LTK_FileParamTable,x
	beq L9675
	jsr S968f
L9675
	lda L98eb
	clc
	adc #$20
	tax
	dec L98c5
	bne L966a
L9681
	lda LTK_Var_CurRoutine
	cmp #$02
	bne L968c
	clc
	jmp LTK_SysRet_AsIs  
	
L968c
	jmp LTK_SysRet_LKRT_OldRegs 
	
S968f
	lda #$00
	sta L98ee
	lda LTK_Var_ActiveLU
	sta L98ec
	ldy #$00
	cpx #$e0
	beq L96b7
	lda $9df9,x
	bmi L96ba
	cmp #$0f
	beq L96ba
	cmp #$10
	beq L96b7
	cpx LTK_ReadChanFPTPtr
	bne L96b7
	lda #$ff
	sta LTK_ReadChanFPTPtr
L96b7
	jmp L98ad
	
L96ba
	lda $9ded,x
	bne L96d8
	lda $9dee,x
	bne L96d8
	lda $9def,x
	bne L96d8
	lda $9df9,x
	cmp #$8d
	bne L96ff
	inc $9def,x
	dec L98ee
	bne L96ff
L96d8
	cpx LTK_WriteChanFPTPtr
	bne L96ff
	lda #$ff
	sta LTK_WriteChanFPTPtr
	lda $9de6,x
	and #$0f
	pha
	ldy $9deb,x
	lda $9dec,x
	tax
	pla
	cpx #$00
	bne L96f8
	cpy #$00
	beq L96ff
L96f8
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L96ff
	ldx L98eb
	lda $9df9,x
	cmp #$0f
	bne L970c
	jmp L97bd
	
L970c
	lda $9de6,x
	and #$0f
	sta L98ed
	pha
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	pla
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9725
	pha
	txa
	pha
	tya
	pha
	lda L98ee
	beq L976e
	lda L98ed
	jsr LTK_SetLuActive 
	bcc L973a
	jsr LTK_FatalError 
L973a
	jsr LTK_AppendBlocks 
	bcc L974a
	ldy #$48
	cpx #$80
	bne L9747
	ldy #$04
L9747
	jmp L98ad
	
L974a
	lda #$00
	tay
L974d
	sta LTK_MiscWorkspace,y
	iny
	bne L974d
L9753
	sta $90e0,y
	iny
	bne L9753
	lda #$0d
	sta LTK_MiscWorkspace
	lda L98ed
	ldx $9203
	ldy $9202
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L976e
	ldx L98eb
	lda $9def,x
	sta $91fc
	lda $91f9
	and #$fe
	tay
	lda $9dee,x
	lsr a
	bcc L9784
	iny
L9784
	tya
	sta $91f9
	lda $91f8
	cmp #$0d
	beq L97b1
	cmp #$0e
	beq L97b1
	cmp #$0f
	beq L97b1
	lda $9de1,x
	sta $91fa
	tay
	lda $9de2,x
	sta $91fb
	cpy #$08
	bne L97ac
	cmp #$01
	beq L97b1
L97ac
	lda #$0c
	sta $91f8
L97b1
	pla
	tay
	pla
	tax
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L97bd
	ldx L98eb
	lda $9de6,x
	and #$0f
	jsr LTK_SetLuActive 
	bcc L97cd
	jsr LTK_FatalError 
L97cd
	ldx L98eb
	lda #$8f
	sta S98dc + 2
	sta S98e1 + 2
	lda #$e0
	sta S98dc + 1
	sta S98e1 + 1
	lda $9dfd,x
	sta L98c6
	lda #$02
	sec
	jsr $9f00
	bcc L97f4
	txa
	ldy #$05
	jmp L98ad
	
L97f4
	ldx LTK_Var_ActiveLU
	lda #$f0
	cpx #$0a
	beq L97ff
	lda #$11
L97ff
	ldy #$00
	sec
	adc L98c6
	tax
	bcc L9809
	iny
L9809
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9813
	pha
	txa
	pha
	tya
	pha
	lda #$10
	sta L98ef
	ldx L98eb
L9820
	ldy #$1d
	jsr S98dc
	asl a
	bcs L9838
	jsr S98dc
	cmp $9de7,x
	bne L9838
	jsr S98dc
	cmp $9de8,x
	beq L9854
L9838
	lda S98dc + 1
	clc
	adc #$20
	sta S98dc + 1
	sta S98e1 + 1
	bcc L984c
	inc S98dc + 2
	inc S98e1 + 2
L984c
	dec L98ef
	bne L9820
	jsr LTK_FatalError 
L9854
	lda $9df9,x
	cmp #$0f
	beq L9883
	ldx #$10
	lda $91f0
	jsr S98e1
	lda $91f1
	jsr S98e1
	ldx #$16
	lda $91f8
	jsr S98e1
	lda $91fa
	jsr S98e1
	lda $91fb
	jsr S98e1
	lda $91fd
	jsr S98e1
L9883
	ldx L98eb
	lda $9dfe,x
	and #$40
	beq L9899
	ldy #$1a
	jsr S98dc
	ora #$80
	ldx #$1a
	jsr S98e1
L9899
	pla
	tay
	pla
	tax
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L98a5
	lda #$02
	clc
	jsr $9f00
	ldy #$00
L98ad
	pha
	ldx L98eb
	lda #$00
	sta LTK_FileParamTable,x
	sta $9dff,x
	pla
	tax
	jsr LTK_ErrorHandler 
	lda L98ec
	sta LTK_Var_ActiveLU
	rts
	
L98c5
	.byte $00
L98c6
	.byte $00
S98c7
	ldx #$00
	lda $9a
	cmp LTK_HD_DevNum
	bne L98d2
	stx $9a
L98d2
	lda $99
	cmp LTK_HD_DevNum
	bne L98db
	stx $99
L98db
	rts
	
S98dc
	lda S98dc,y
	iny
	rts
	
S98e1
	sta S98e1,x
	inx
	rts
	
L98e6
	lda L98e6,y
	iny
	rts
	
L98eb
	.byte $00
L98ec
	.byte $00
L98ed
	.byte $00
L98ee
	.byte $00
L98ef
	.byte $00
