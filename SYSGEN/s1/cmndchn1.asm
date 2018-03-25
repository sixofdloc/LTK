;cmndchn1.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen

L95e0
	sta L99cd
	lda #$00
	sta L99d2
	sta L99d4
	lda $31
	pha
	lda $32
	pha
	lda LTK_Var_CurRoutine
	cmp #$00
	bne L960d
	lda #$38
	sta S9852
	lda $bb
	sta $31
	lda $bc
	sta $32
	ldy $b7
	sty L99cd
	jmp L9618
	
L960d
	lda LTK_Var_ActiveLU
	sta $9de3
	lda #$18
	sta S9852
L9618
	lda LTK_Var_Active_User
	sta L99c7
	sta L99c9
	sta L99cb
	lda $9de3
	sta L99c8
	sta L99ca
	ldy #$00
	sty L99ce
L9632
	jsr S9852
	sta L9b2e,y
	iny
	cpy L99cd
	bcc L9632
	ldy #$00
L9640
	lda L9b2e,y
	cmp #$20
	bne L964f
	iny
	cpy L99cd
	bcc L9640
	bcs L9690
L964f
	ldx #$00
	cmp #$50
	bne L9658
	jmp L9ace
	
L9658
	cmp #$53
	beq L96af
	inx
	cmp #$52
	beq L96af
	cmp #$4c
	bne L9693
	jsr S987b
	cmp #$10
	bne L966f
	jmp L99ed
	
L966f
	sta LTK_HD_DevNum
	jsr S987b
	tax
	tya
	pha
	txa
	jsr LTK_SetLuActive 
	pla
	tay
	bcs L9690
	stx $9de3
	jsr S987b
	cmp #$10
	bcs L9690
	sta L99c7
L968d
	jmp L9827
	
L9690
	jmp L981b
	
L9693
	cmp #$43
	bne L968d
	pha
	lda L99cd
	pha
	lda S9852
	pha
	tya
	pha
	lda #$95
	pha
	lda #$df
	pha
	lda #$ca
	ldx #$04
	jmp LTK_CallExtDosOvl 
	
L96af
	stx L99d7
L96b2
	iny
	cpy L99cd
	bcs L9690
	lda L9b2e,y
	cmp #$30
	bcc L96b2
	cmp #$3b
	bcs L96b2
	sty L99ce
	jsr S9ae9
	bcc L96d1
	cmp #$3a
	beq L96dd
	bne L9690
L96d1
	txa
	jsr LTK_SetLuActive 
	bcs L9690
	lda LTK_Var_ActiveLU
	sta L99ca
L96dd
	jsr S9ae9
	bcs L96e9
	cpx #$10
	bcs L9690
	stx L99cb
L96e9
	jsr LTK_ClearHeaderBlock 
	ldy L99ce
	lda L99d7
	beq L96f7
	jmp L9899
	
L96f7
	lda L99ca
	sta LTK_Var_ActiveLU
	lda L99cb
	sta LTK_Var_Active_User
	ldx #$00
L9705
	cpy L99cd
	bcs L971e
	lda L9b2e,y
	cmp #$0d
	beq L971e
	cmp #$2c
	beq L971e
	sta LTK_FileHeaderBlock ,x
	iny
	inx
	cpx #$10
	bne L9705
L971e
	lda #$02
	sec
	jsr $9f00
	bcc L9729
	jmp L9818
	
L9729
	jsr LTK_FindFile 
	bcs L9788
	sta L99cc
	stx $97bc
	stx $97bf
	sty $97bd
	sty $97c0
	lda $91f8
	cmp #$01
	beq L9788
	cmp #$03
	beq L9788
	cmp #$02
	beq L9788
	jsr S97b7
	lda $91f8
	cmp #$0a
	bcs L975d
	jsr LTK_DeallocContigBlks 
	bcc L976d
	bcs L9762
L975d
	jsr LTK_DeallocateRndmBlks 
	bcc L976d
L9762
	cpx #$80
	bne L976a
	tax
	jmp L9815
	
L976a
	jsr LTK_FatalError 
L976d
	sed
	clc
	lda L99d4
	adc #$01
	sta L99d4
	lda L99d2
	adc #$00
	sta L99d2
	cld
	bit $9e44
	bvc L9788
	jmp L96e9
	
L9788
	lda L99d4
	jsr S9889
	sta $9ef3
	stx $9ef4
	lda #$2c
	sta $9ef5
	lda L99d2
	jsr S9889
	sta $9ef6
	stx $9ef7
	lda #$0d
	sta $9ef8
	lda #$00
	sta $9ef9
	ldy #$01
	jsr LTK_ErrorHandler 
	jmp L982c
	
S97b7
	lda #$80
	ldy #$1d
	ora $97bb,y
	sta $97be,y
	ldx #$00
	dec $8ffc
	bne L97c9
	dex
L97c9
	stx L99d8
	lda #$f0
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq L97d7
	lda #$11
L97d7
	ldy #$00
	pha
	sec
	adc L99cc
	tax
	bcc L97e2
	iny
L97e2
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L97ec
	pla
	tax
	lda L99d8
	beq L9814
	ldy #$00
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L97ff
	pha
	tya
	pha
	ldy L99cc
	lda #$00
	sta $9002,y
	pla
	tay
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9814
	rts
	
L9815
	ldy #$04
	.byte $2c 
L9818
	ldy #$05
	.byte $2c 
L981b
	ldy #$1f
	.byte $2c 
L981e
	ldy #$1e
	.byte $2c 
L9821
	ldy #$3e
	.byte $2c 
L9824
	ldy #$3f
	.byte $2c 
L9827
	ldy #$00
	jsr LTK_ErrorHandler 
L982c
	lda #$02
	clc
	jsr $9f00
	lda $9de3
	sta LTK_Var_ActiveLU
	lda L99c7
	sta LTK_Var_Active_User
	pla
	sta $32
	pla
	sta $31
	lda LTK_Var_CurRoutine
	cmp #$00
	beq L984c
	rts
	
L984c
	lda #$00
	clc
	jmp LTK_SysRet_AsIs  
	
S9852
	nop
	bcc L9877
	lda LTK_Var_CPUMode
	beq L9873
	stx $9871
	tya
	pha
	sec
	ldx #$74
	ldy #$ff
	jsr LTK_KernalTrapSetup
	pla
	tay
	lda #$bb
	ldx $c7
	jsr LTK_KernalCall 
	ldx #$00
	rts
	
L9873
	jsr $fc6e
	rts
	
L9877
	lda LTK_CMDChannelBuffer,y
	rts
	
S987b
	iny
	lda L9b2e,y
	sec
	sbc #$30
	cmp #$0a
	bcc L9888
	sbc #$07
L9888
	rts
	
S9889
	pha
	and #$0f
	clc
	adc #$30
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc #$30
	rts
	
L9899
	ldx #$10
	lda #$00
L989d
	sta L99d9,x
	dex
	bpl L989d
	inx
L98a4
	lda L9b2e,y
	cmp #$3d
	beq L98bf
	cpx #$10
	bne L98b2
	jmp L981e
	
L98b2
	sta L99d9,x
	inx
	iny
	cpy L99cd
	bcc L98a4
	jmp L981e
	
L98bf
	iny
	cpy L99cd
	bcc L98c8
	jmp L9821
	
L98c8
	ldx #$00
	sty L99ce
	jsr S9ae9
	bcc L98d8
	cmp #$3a
	beq L98e1
	bne L98ed
L98d8
	txa
	jsr LTK_SetLuActive 
	bcc L98e1
L98de
	jmp L981b
	
L98e1
	jsr S9ae9
	bcs L98ed
	cpx #$10
	bcs L98de
	stx L99c9
L98ed
	ldx #$00
	ldy L99ce
L98f2
	lda L9b2e,y
	cpx #$11
	beq L9909
	cmp #$0d
	beq L990c
	sta LTK_FileHeaderBlock ,x
	iny
	cpy L99cd
	bcs L990c
	inx
	bne L98f2
L9909
	jmp L9821
	
L990c
	lda L99c9
	sta LTK_Var_Active_User
	lda #$02
	sec
	jsr $9f00
	bcc L991d
	jmp L9818
	
L991d
	jsr LTK_FindFile 
	sta L99d1
	sta L99cc
	stx $97bc
	stx $97bf
	sty $97bd
	sty $97c0
	bcs L9909
	lda $91f8
	cmp #$04
	bcc L9909
	lda $9200
	sta L99cf
	lda $9201
	sta L99d0
	jsr LTK_ClearHeaderBlock 
	ldy #$0f
L994c
	lda L99d9,y
	sta LTK_FileHeaderBlock ,y
	dey
L9953
	bpl L994c
	lda L99cb
	sta LTK_Var_Active_User
	jsr LTK_FindFile 
	bcs L9963
	jmp L9824
	
L9963
	pha
	stx L99d6
	sty L99d5
	ldy L99cf
	ldx L99d0
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L997a
	ldy #$00
	
L997c
	lda L99d9,y
	sta LTK_FileHeaderBlock ,y
	iny
	cpy #$10
	bne L997c
	ldx L99d6
	ldy L99d5
	lda #$24
	jsr LTK_ExeExtMiniSub 
	ldy $9200
	ldx $9201
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L99a2
	lda #$f0
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq L99ad
	lda #$11
L99ad
	ldy #$00
	sec
	adc L99d1
	tax
	bcc L99b7
	iny
L99b7
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L99c1
	jsr S97b7
	jmp L9827
	
L99c7
	.byte $00
L99c8
	.byte $00
L99c9
	.byte $00
L99ca
	.byte $00
L99cb
	.byte $00
L99cc
	.byte $00
L99cd
	.byte $00
L99ce
	.byte $00
L99cf
	.byte $00
L99d0
	.byte $00
L99d1
	.byte $00
L99d2
	.byte $00
L99d3
	.byte $00
L99d4
	.byte $00
L99d5
	.byte $00
L99d6
	.byte $00
L99d7
	.byte $00
L99d8
	.byte $00
L99d9		  
	.byte $00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
L99ea
	jmp L981b
	
L99ed
	jsr S987b
	cpy L99cd
	bcs L99fa
	jsr LTK_SetLuActive 
	bcs L99ea
L99fa
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L9a05
	ldx #$00
L9a05
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9a0e
	ldy #$1f
	sty $9ed6
	dey
	lda #$00
	sta $9ecf
	sta $9edc
L9a1c
	lda L9b0f,y
	sta LTK_ErrMsgBuffer,y
	dey
	bpl L9a1c
	lda LTK_HD_DevNum
	ldy #$0a
	jsr S9ab6
	lda $9de3
	ldy #$0d
	jsr S9ab6
	lda LTK_Var_Active_User
	ldy #$10
	jsr S9ab6
	lda #$13
	jsr S9a56
	lda $9074
	sta $9071
	lda $9075
	sta $9072
	lda #$19
	jsr S9a56
	jmp L982c
	
S9a56
	pha
	lda #$00
	sta L99d2
	sta L99d3
	sta L99d4
	tax
	tay
	sed
L9a65
	cpy $9071
	bne L9a6f
	cpx $9072
	beq L9a8e
L9a6f
	clc
	lda L99d4
	adc #$01
	sta L99d4
	lda L99d3
	adc #$00
	sta L99d3
	lda L99d2
	adc #$00
	sta L99d2
	inx
	bne L9a65
	iny
	bne L9a65
L9a8e
	cld
	pla
	tay
	lda L99d2
	jsr S9889
	txa
	sta LTK_ErrMsgBuffer,y
	lda L99d3
	jsr S9889
	sta $9ee1,y
	txa
	sta $9ee2,y
	lda L99d4
	jsr S9889
	sta $9ee3,y
	txa
	sta $9ee4,y
	rts
	
S9ab6
	tax
	beq L9ac3
	sed
	lda #$00
L9abc
	clc
	adc #$01
	dex
	bne L9abc
	cld
L9ac3
	jsr S9889
	sta LTK_ErrMsgBuffer,y
	txa
	sta $9ee1,y
	rts
	
L9ace
	ldx #$00
	beq L9ad5
L9ad2
	jsr S9852
L9ad5
	sta LTK_CMDChannelBuffer,x
	cpx #$29
	bcs L9add
	inx
L9add
	iny
	cpy L99cd
	bcc L9ad2
	jsr LTK_CmdChnPosition 
	jmp L982c
	
S9ae9
	ldy L99ce
	lda #$2e
	ldx #$9b
	cpy L99cd
	bcs L9b0d
	jsr S9b60
	php
	bcs L9aff
	pha
	pla
	bne L9b0c
L9aff
	lda L9b2e,y
	cmp #$3a
	bne L9b0c
	iny
	sty L99ce
	plp
	rts
	
L9b0c
	plp
L9b0d
	sec
	rts
	
L9b0f
	.text "06,status,dd,ll,uu,aaaaa,uuuuu{return}"
L9b2e		
	.byte $00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
S9b60
	sta L9b71 + 1
	stx L9b71 + 2
	lda #$00
	sta L9bdb
	sta L9bdc
	sta L9bdd
L9b71
	lda L9b71,y
	cmp #$30
	bcc L9bc9
	cmp #$3a
	bcc L9b8e
	ldx $9b9a
	cpx #$0a
	beq L9bc9
	cmp #$41
	bcc L9bc9
	cmp #$47
	bcs L9bc9
	sec
	sbc #$07
L9b8e
	ldx L9bdb
	beq L9bb2
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9b9b
	clc
	adc L9bdd
	pha
	txa
	adc L9bdc
	tax
	pla
	dey
	bne L9b9b
	sta L9bdd
	stx L9bdc
	pla
	tay
	pla
L9bb2
	inc L9bdb
	sec
	sbc #$30
	clc
	adc L9bdd
	sta L9bdd
	bcc L9bc6
	inc L9bdc
	beq L9bd3
L9bc6
	iny
	bne L9b71
L9bc9
	cmp #$20
	beq L9bc6
	clc
	ldx L9bdb
	bne L9bd4
L9bd3
	sec
L9bd4
	lda L9bdc
	ldx L9bdd
	rts
	
L9bdb
	.byte $00
L9bdc
	.byte $00
L9bdd
	.byte $00
