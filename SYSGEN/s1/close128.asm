;close128.r.prg
 
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
    
    *=LTK_DOSOverlay ; $95e0

L95e0
	jmp L9655
	
L95e3
	sta L9654
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
	jsr S9645
	jmp L9641
	
L960b
	stx L98f6
	jsr S9645
	ldx L98f6
	cpx #$e0
	bne L9628
	lda LTK_Save_P
	pha
	plp
	bcc L9655
	jsr S98d0
	jsr S9697
	jmp L9689
	
L9628
	lda $b8
	bne L9631
	sta $9dff,x
	beq L9641
L9631
	lda LTK_FileParamTable,x
	bne L963e
	ldy #$3d
	jsr LTK_ErrorHandler 
	jmp LTK_SysRet_AsIs  
	
L963e
	jsr S9697
L9641
	clc
	jmp LTK_SysRet_AsIs  
	
S9645
	sec
	ldx #$e5
	ldy #$f1
	jsr LTK_KernalTrapSetup
	lda L9654
	jsr LTK_KernalCall 
	rts
	
L9654
	.byte $00
L9655
	ldy #$08
	ldx #$00
L9659
	lda $9dff,x
	bne L9668
	txa
	clc
	adc #$20
	tax
	dey
	bne L9659
	beq L9689
L9668
	jsr S98d0
	lda #$08
	sta L98ce
	ldx #$00
L9672
	stx L98f6
	lda $9dff,x
	beq L967d
	jsr S9697
L967d
	lda L98f6
	clc
	adc #$20
	tax
	dec L98ce
	bne L9672
L9689
	lda LTK_Var_CurRoutine
	cmp #$02
	bne L9694
	clc
	jmp LTK_SysRet_AsIs  
	
L9694
	jmp LTK_SysRet_LKRT_OldRegs 
	
S9697
	lda #$00
	sta L98f9
	lda LTK_Var_ActiveLU
	sta L98f7
	ldy #$00
	cpx #$e0
	beq L96bf
	lda $9df9,x
	bmi L96c2
	cmp #$0f
	beq L96c2
	cmp #$10
	beq L96bf
	cpx LTK_ReadChanFPTPtr
	bne L96bf
	lda #$ff
	sta LTK_ReadChanFPTPtr
L96bf
	jmp L98b6
	
L96c2
	lda $9ded,x
	bne L96e0
	lda $9dee,x
	bne L96e0
	lda $9def,x
	bne L96e0
	lda $9df9,x
	cmp #$8d
	bne L9708
	inc $9def,x
	dec L98f9
	bne L9708
L96e0
	cpx LTK_WriteChanFPTPtr
	bne L9708
	lda #$ff
	sta LTK_WriteChanFPTPtr
	lda $9de6,x
	and #$0f
	pha
	lda $9deb,x
	tay
	lda $9dec,x
	tax
	pla
	cpx #$00
	bne L9701
	cpy #$00
	beq L9708
L9701
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$01; $8de0 
L9708
	ldx L98f6
	lda $9df9,x
	cmp #$0f
	bne L9715
	jmp L97c6
	
L9715
	lda $9de6,x
	and #$0f
	sta L98f8
	pha
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	pla
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L972e
	pha
	txa
	pha
	tya
	pha
	lda L98f9
	beq L9777
	lda L98f8
	jsr LTK_SetLuActive 
	bcc L9743
	jsr LTK_FatalError 
L9743
	jsr LTK_AppendBlocks 
	bcc L9753
	ldy #$48
	cpx #$80
	bne L9750
	ldy #$04
L9750
	jmp L98b6
	
L9753
	lda #$00
	tay
L9756
	sta LTK_MiscWorkspace,y
	iny
	bne L9756
L975c
	sta $90e0,y
	iny
	bne L975c
	lda #$0d
	sta LTK_MiscWorkspace
	lda L98f8
	ldx $9203
	ldy $9202
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9777
	ldx L98f6
	lda $9def,x
	sta $91fc
	lda $91f9
	and #$fe
	tay
	lda $9dee,x
	lsr a
	bcc L978d
	iny
L978d
	tya
	sta $91f9
	lda $91f8
	cmp #$0d
	beq L97ba
	cmp #$0e
	beq L97ba
	cmp #$0f
	beq L97ba
	lda $9de1,x
	sta $91fa
	tay
	lda $9de2,x
	sta $91fb
	cpy #$1c
	bne L97b5
	cmp #$01
	beq L97ba
L97b5
	lda #$0c
	sta $91f8
L97ba
	pla
	tay
	pla
	tax
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L97c6
	ldx L98f6
	lda $9de6,x
	and #$0f
	jsr LTK_SetLuActive 
	bcc L97d6
	jsr LTK_FatalError 
L97d6
	ldx L98f6
	lda #$8f
	sta S98e7 + 2
	sta S98ec + 2
	lda #$e0
	sta S98e7 + 1
	sta S98ec + 1
	lda $9dfd,x
	sta L98cf
	lda #$02
	sec
	jsr $9f00
	bcc L97fd
	txa
	ldy #$05
	jmp L98b6
	
L97fd
	ldx LTK_Var_ActiveLU
	lda #$f0
	cpx #$0a
	beq L9808
	lda #$11
L9808
	ldy #$00
	sec
	adc L98cf
	tax
	bcc L9812
	iny
L9812
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L981c
	pha
	txa
	pha
	tya
	pha
	lda #$10
	sta L98fa
	ldx L98f6
L9829
	ldy #$1d
	jsr S98e7
	asl a
	bcs L9841
	jsr S98e7
	cmp $9de7,x
	bne L9841
	jsr S98e7
	cmp $9de8,x
	beq L985d
L9841
	lda S98e7 + 1
	clc
	adc #$20
	sta S98e7 + 1
	sta S98ec + 1
	bcc L9855
	inc S98e7 + 2
	inc S98ec + 2
L9855
	dec L98fa
	bne L9829
	jsr LTK_FatalError 
L985d
	lda $9df9,x
	cmp #$0f
	beq L988c
	ldx #$10
	lda $91f0
	jsr S98ec
	lda $91f1
	jsr S98ec
	ldx #$16
	lda $91f8
	jsr S98ec
	lda $91fa
	jsr S98ec
	lda $91fb
	jsr S98ec
	lda $91fd
	jsr S98ec
L988c
	ldx L98f6
	lda $9dfe,x
	and #$40
	beq L98a2
	ldy #$1a
	jsr S98e7
	ora #$80
	ldx #$1a
	jsr S98ec
L98a2
	pla
	tay
	pla
	tax
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L98ae
	lda #$02
	clc
	jsr $9f00
	ldy #$00
L98b6
	pha
	ldx L98f6
	lda #$00
	sta LTK_FileParamTable,x
	sta $9dff,x
	pla
	tax
	jsr LTK_ErrorHandler 
	lda L98f7
	sta LTK_Var_ActiveLU
	rts
	
L98ce
	.byte $00
L98cf
	.byte $00
S98d0
	lda $9a
	cmp LTK_HD_DevNum
	bne L98db
	lda #$00
	sta $9a
L98db
	lda $99
	cmp LTK_HD_DevNum
	bne L98e6
	lda #$00
	sta $99
L98e6
	rts
	
S98e7
	lda S98e7,y
	iny
	rts
	
S98ec
	sta S98ec,x
	inx
	rts
	
L98f1
	lda L98f1,y
	iny
	rts
	
L98f6
	.byte $00
L98f7
	.byte $00
L98f8
	.byte $00
L98f9
	.byte $00
L98fa
	.byte $00
