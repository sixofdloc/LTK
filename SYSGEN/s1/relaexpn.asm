;relaexpn.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen
 
L95e0
	lda LTK_Var_ActiveLU
	sta L9971
	lda #$00
	sta L996c
	sta L9a52
	lda #$ff
	sta LTK_ReadChanFPTPtr
	jsr S9986
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L95fd
	ldx $9de4
	lda $9de1,x
	sta $9e03
	lda $9de2,x
	sta $9e04
	lda $9de6,x
	and #$0f
	jsr LTK_SetLuActive 
	bcc L9619
	jsr LTK_FatalError 
L9619
	lda #$02
	sec
	jsr $9f00
	bcc L9627
	stx $9948
	jmp L9934
	
L9627
	ldx $91f0
	ldy $91f1
	dey
	cpy #$ff
	bne L9633
	dex
L9633
	stx L9972
	sty L9973
	txa
	bne L9640
	cpy #$f0
	bcc L9667
L9640
	ldx #$08
	ldy #$00
L9644
	lsr L9972
	ror L9973
	bcc L964d
	iny
L964d
	dex
	bne L9644
	tya
	beq L9656
	inc L9973
L9656
	inc L9973
	sec
	lda $91f1
	ldx $91f0
	sbc L9973
	tay
	bcs L9667
	dex
L9667
	stx L9974
	sty L9975
	lda $9e03
	sta L996f
	tax
	lda $9e04
	sta L9970
	tay
	iny
	bne L967f
	inx
L967f
	stx $9e03
	sty $9e04
	jsr S9a5c
	sta L997a
	stx L9978
	sty L9976
	ldx #$09
	ldy #$00
L9695
	lsr L9976
	ror L9978
	ror L997a
	bcc L96a1
	iny
L96a1
	dex
	bne L9695
	tya
	beq L96af
	inc L997a
	bne L96af
	inc L9978
L96af
	lda $9e05
	pha
L96b3
	jsr LTK_AppendBlocks 
	bcc L96c1
	sta $9948
	stx L996b
	jmp L975b
	
L96c1
	lda L996c
	bne L96cf
	stx L996d
	sty L996e
	dec L996c
L96cf
	txa
	pha
	tya
	pha
	jsr S9999
	pla
	tax
	pla
	tay
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L96e4
	inc L9975
	bne L96ec
	inc L9974
L96ec
	lda L9974
	cmp L9978
	bcc L96b3
	beq L96f9
	jsr LTK_FatalError 
L96f9
	lda L9975
	cmp L997a
	bcc L96b3
	pla
	sta $9e05
	lda #$00
	sta L9976
	sta $91f6
	sta $91f7
	ldx #$09
L9712
	asl L997a
	rol L9978
	rol L9976
	dex
	bne L9712
L971e
	lda L9976
	bne L9735
	lda $91f4
	cmp L9978
	bcc L9735
	bne L975b
	lda L997a
	cmp $91f5
	bcc L975b
L9735
	inc $91f7
	bne L973d
	inc $91f6
L973d
	sec
	lda L997a
	sbc $91f5
	sta L997a
	lda L9978
	sbc $91f4
	sta L9978
	lda L9976
	sbc #$00
	sta L9976
	jmp L971e
	
L975b
	jsr S9986
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9765
	lda #$00
	
	sta L996c
	lda $91f0
	bne L9776
	lda $91f1
	cmp #$f1
	bcc L9779
L9776
	dec L9a52
L9779
	ldx $9de4
	lda $9df2,x
	sta $9e03
	lda $9df3,x
	sta $9e04
	jsr S9a5c
	sta L997b
	stx L9979
	sty L9977
L9794
	lda L997b
	sta L997a
	lda L9979
	sta L9978
	lda L9977
	sta L9976
	ldx #$09
L97a8
	lsr L9976
	ror L9978
	ror L997a
	dex
	bne L97a8
	jsr S99c9
	lda L996c
	bne L97d2
	lda L9a59
	cmp L996d
	bne L97fd
	lda L9a5a
	cmp L996e
	bne L97fd
	dec L996c
	jsr S9999
L97d2
	lda L9a59
	cmp L996d
	bne L97e2
	lda L9a5a
	cmp L996e
	beq L97e5
L97e2
	jsr L99a9
L97e5
	clc
	lda L997b
	adc #$e0
	sta $97fb
	lda L9979
	and #$01
	adc #$8f
	sta $97fc
	lda #$ff
	sta $97fa
L97fd
	ldx $9de4
	lda L997b
	clc
	adc $9df8,x
	sta L997b
	lda L9979
	adc $9df7,x
	sta L9979
	lda L9977
	adc #$00
	sta L9977
	inc $9e04
	bne L9823
	inc $9e03
L9823
	lda $91f6
	cmp $9e03
	bne L9833
	lda $91f7
	cmp $9e04
	beq L9836
L9833
	jmp L9794
	
L9836
	lda $97fb
	clc
	adc $91f5
	tax
	lda $97fc
	adc $91f4
	cmp #$91
	bcc L984e
	bne L9859
	cpx #$e0
	bcs L9859
L984e
	stx $9857
	sta $9858
	lda #$ff
	sta $9856
L9859
	jsr L99a9
	lda $91f6
	ldx $9de4
	sta $9df2,x
	lda $91f7
	sta $9df3,x
	lda $91f0
	sta $9df0,x
	lda $91f1
	sta $9df1,x
	lda #$8f
	sta S997c + 2
	sta S9981 + 2
	lda #$e0
	sta S997c + 1
	sta S9981 + 1
	lda $9dfd,x
	sta L9a5b
	lda #$f0
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq L9898
	lda #$11
L9898
	ldy #$00
	sec
	adc L9a5b
	tax
	bcc L98a2
	iny
L98a2
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L98ac
	pha
	txa
	pha
	tya
	pha
	lda #$10
	sta L996a
	ldx $9de4
L98b9
	ldy #$1e
	jsr S997c
	cmp $9de7,x
	bne L98cb
	jsr S997c
	cmp $9de8,x
	beq L98e7
L98cb
	lda S997c + 1
	clc
	adc #$20
	sta S997c + 1
	sta S9981 + 1
	bcc L98df
	inc S997c + 2
	inc S9981 + 2
L98df
	dec L996a
	bne L98b9
	jsr LTK_FatalError 
L98e7
	ldx #$10
	lda $91f0
	jsr S9981
	lda $91f1
	jsr S9981
	lda $91f4
	jsr S9981
	lda $91f5
	jsr S9981
	lda $91f6
	jsr S9981
	lda $91f7
	jsr S9981
	pla
	tay
	pla
	tax
	pla
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9919
	lda #$02
	clc
	jsr $9f00
	lda L996b
	beq L993c
	cmp #$80
	beq L9930
	cmp #$fd
	bne L9938
	lda #$48
	bne L993e
L9930
	lda #$04
	bne L993e
L9934
	lda #$05
	bne L993e
L9938
	lda #$34
	bne L993e
L993c
	lda #$00
L993e
	pha
	lda L9971
	sta LTK_Var_ActiveLU
	pla
	tay
	ldx #$00
	jsr LTK_ErrorHandler 
	ldx $9de4
	lda L996f
	sta $9de1,x
	sta $9e03
	lda L9970
	sta $9de2,x
	sta $9e04
	lda #$00
	sta $9dfa,x
	sta $9dfc,x
	rts
	
L996a
	.byte $00
L996b
	.byte $00
L996c
	.byte $00
L996d
	.byte $00
L996e
	.byte $00
L996f
	.byte $00
L9970
	.byte $00
L9971
	.byte $00
L9972
	.byte $00
L9973
	.byte $00
L9974
	.byte $00
L9975
	.byte $00
L9976
	.byte $00
L9977
	.byte $00
L9978
	.byte $00
L9979
	.byte $00
L997a
	.byte $00
L997b
	.byte $00
S997c
	lda S997c,y
	iny
	rts
	
S9981
	sta S9981,x
	inx
	rts
	
S9986
	ldx $9de4
	lda $9de6,x
	and #$0f
	pha
	lda $9de7,x
	tay
	lda $9de8,x
	tax
	pla
	rts
	
S9999
	lda #$00
	tay
L999c
	sta LTK_MiscWorkspace,y
	iny
	bne L999c
L99a2
	sta $90e0,y
	iny
	bne L99a2
	rts
	
L99a9
	ldy L996d
	ldx L996e
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L99b9
	lda L9a5a
	sta L996e
	lda L9a59
	sta L996d
	jsr S9999
	rts
	
S99c9
	ldx L9978
	lda L997a
	stx L9a53
	sta L9a54
	sta L9a55
	tay
	bne L99e3
	txa
	bne L99e3
	lda #$ff
	sta L9a58
L99e3
	lda #$02
	ldx #$92
	jsr S9a36
	lda L9a52
	beq L9a29
	ldy #$08
L99f1
	lsr L9a53
	ror L9a54
	dey
	bne L99f1
	lda L9a54
	cmp L9a58
	php
	beq L9a0f
	sta L9a58
	jsr S9a3d
	sty L9a59
	stx L9a5a
L9a0f
	lda #$e0
	ldx #$9b
	jsr S9a36
	plp
	beq L9a29
	lda LTK_Var_ActiveLU
	ldx L9a5a
	ldy L9a59
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L9a29
	lda L9a55
	jsr S9a3d
	sty L9a59
	stx L9a5a
	rts
	
S9a36
	sta S9a4d + 1
	stx S9a4d + 2
	rts
	
S9a3d
	asl a
	tax
	bcc L9a44
	inc S9a4d + 2
L9a44
	jsr S9a4d
	tay
	jsr S9a4d
	tax
	rts
	
S9a4d
	lda S9a4d,x
	inx
	rts
	
L9a52
	.byte $00
L9a53
	.byte $00
L9a54
	.byte $00
L9a55
	.byte $00
L9a56
	.byte $00
L9a57
	.byte $00
L9a58
	.byte $ff 
L9a59
	.byte $00
L9a5a
	.byte $00
L9a5b
	.byte $00
S9a5c
	ldx $9de4
	lda $9e03
	sta $9a8f
	sta $9de1,x
	lda $9e04
	sta $9a8b
	sta $9de2,x
	lda $9df7,x
	sta $9aa0
	lda $9df8,x
	sta $9aa7
	lda #$00
	sta L9a56
	sta L9a57
	tax
	tay
	pha
L9a88
	pla
	clc
	adc #$00
	pha
	txa
	adc #$00
	tax
	bcc L9a94
	iny
L9a94
	inc L9a57
	bne L9a9c
	inc L9a56
L9a9c
	lda L9a56
	cmp #$00
	bne L9a88
	lda L9a57
	cmp #$00
	bne L9a88
	pla
	rts
