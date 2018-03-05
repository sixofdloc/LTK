;validate.r.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"
	*=$c000
Lc000
	jmp Lc006
	
Lc003
	jmp Lc012
	
Lc006
	lda LTK_Var_ActiveLU
	sta $9de4
	lda LTK_Var_Active_User
	sta $9de5
Lc012
	ldx #$00
	stx LTK_BLKAddr_DosOvl
	dex
	stx LTK_ReadChanFPTPtr
	lda $31
	pha
	lda $32
	pha
	lda $33
	pha
	lda $34
	pha
	ldx #$f0
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq Lc032
	ldx #$11
Lc032
	ldy #$00
	stx $c1b9
	clc
	jsr LTK_HDDiscDriver 
	.byte $e0,$97,$01; $97e0 
Lc03e
	lda $97fe
	cmp #$ac
	beq Lc04b
	cmp #$af
	beq Lc04b
	lda #$ac
Lc04b
	sta Lc202 + 1
	sta $97fe
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte $e0,$97,$01; $97e0 
Lc05b
	ldy #$0a
Lc05d
	lda $97e0,y
	cmp Lcaba,y
	beq Lc068
	jmp Lc84f
	
Lc068
	dey
	bpl Lc05d
Lc06b
	jsr Sc52d
	lda #$00
	sta $ca86
	sta LTK_Var_Active_User
	sta $ca8d
	sta Lcb63 + 16
	lda #$05
	ldx LTK_Var_ActiveLU
	cpx #$0a
	beq Lc087
	lda #$02
Lc087
	sta $ca8c
	jsr LTK_ClearHeaderBlock 
	ldy #$09
Lc08f
	lda Lcab0,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl Lc08f
	jsr Sc372
	jsr LTK_FindFile 
	bcc Lc0a3
	jmp Lc85c
	
Lc0a3
	jsr Sc39c
	bcc Lc0ab
	jmp Lc85c
	
Lc0ab
	jsr LTK_ClearHeaderBlock 
	ldy #$0a
Lc0b0
	lda Lcaba,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl Lc0b0
	jsr Sc372
	jsr LTK_FindFile 
	bcc Lc0c4
	jmp Lc865
	
Lc0c4
	jsr Sc39c
	bcc Lc0cc
	jmp Lc865
	
Lc0cc
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq Lc0f7
	jsr LTK_ClearHeaderBlock 
	ldy #$0f
Lc0d8
	lda Lcac5,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl Lc0d8
	jsr LTK_FindFile 
	bcs Lc0f4
	inc $ca8c
	jsr Sc372
	jsr Sc39c
	bcc Lc0f4
	jmp Lc8a2
	
Lc0f4
	jmp Lc15a
	
Lc0f7
	jsr LTK_ClearHeaderBlock 
	ldy #$0a
Lc0fc
	lda Lcad5,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl Lc0fc
	jsr Sc372
	jsr LTK_FindFile 
	bcc Lc110
	jmp Lc880
	
Lc110
	jsr Sc39c
	bcc Lc118
	jmp Lc880
	
Lc118
	jsr LTK_ClearHeaderBlock 
	ldy #$0f
Lc11d
	lda Lcae0,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl Lc11d
	jsr Sc372
	jsr LTK_FindFile 
	bcc Lc131
	jmp Lc889
	
Lc131
	jsr Sc39c
	bcc Lc139
	jmp Lc889
	
Lc139
	jsr LTK_ClearHeaderBlock 
	ldy #$0f
Lc13e
	lda Lcaf0,y
	sta LTK_FileHeaderBlock ,y
	dey
	bpl Lc13e
	jsr Sc372
	jsr LTK_FindFile 
	bcc Lc152
	jmp Lc892
	
Lc152
	jsr Sc39c
	bcc Lc15a
	jmp Lc892
	
Lc15a
	ldx #$00
	stx $ca84
	lda #$fe
	sta $ca83
	lda $ca8c
	ldx #$65
	ldy #$03
	cmp #$05
	beq Lc17b
	ldx #$10
	ldy #$01
	cmp #$02
	beq Lc17b
	ldx #$ee
	ldy #$01
Lc17b
	stx $ca8f
	sty $ca8e
Lc181
	lda #$99
	sta Sc398 + 2
	sta Sc380 + 2
	lda #$e0
	sta Sc398 + 1
	sta Sc380 + 1
	lda #$00
	sta $caae
	lda #$10
	sta $caaf
	lda $ca83
	beq Lc1ae
	ldy $ca84
Lc1a3
	lda $9802,y
	bne Lc1b1
	iny
	dec $ca83
	bne Lc1a3
Lc1ae
	jmp Lc9f0
	
Lc1b1
	iny
	sty $ca84
	dec $ca83
	lda #$00
	ldy #$00
	clc
	adc $ca84
	tax
	bcc Lc1c4
	iny
Lc1c4
	lda LTK_Var_ActiveLU
	stx $ca8b
	sty $ca8a
	clc
	jsr LTK_HDDiscDriver 
	.byte $e0,$99,$01; $99e0 
Lc1d4
	lda $99fc
	sta $ca85
Lc1da
	ldy #$1d
	jsr Sc398
	bpl Lc1e4
	jmp Lc2e8
	
Lc1e4
	inc $caae
	ldy #$1f
	jsr Sc398
	tax
	dey
	jsr Sc398
	tay
	lda LTK_Var_ActiveLU
	stx $caad
	sty $caac
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc202
	lda #$00
	
	cmp $91fe
	beq Lc21a
	sta $91fe
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq Lc21a
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc21a
	ldy #$16
	jsr Sc398
	cmp #$01
	bne Lc229
	inc $ca8d
	jmp Lc2e0
	
Lc229
	ldy #$0f
Lc22b
	jsr Sc398
	sta Lcb63 + 16,y
	dey
	bpl Lc22b
	ldx #$63
	ldy #$cb
	jsr LTK_Print 
	ldy #$1e
	jsr Sc398
	cmp $9200
	beq Lc248
	jmp Lc8af
	
Lc248
	iny
	jsr Sc398
	cmp $9201
	beq Lc254
	jmp Lc8af
	
Lc254
	ldy #$0f
Lc256
	jsr Sc398
	cmp LTK_FileHeaderBlock ,y
	beq Lc261
	jmp Lc8c2
	
Lc261
	dey
	bpl Lc256
Lc264
	ldy #$10
	jsr Sc398
	cmp $91f0
	beq Lc271
	jmp Lc8dd
	
Lc271
	iny
	jsr Sc398
	cmp $91f1
	beq Lc27d
	jmp Lc8dd
	
Lc27d
	iny
	jsr Sc398
	cmp $91f4
	beq Lc289
	jmp Lc8f9
	
Lc289
	iny
	jsr Sc398
	cmp $91f5
	beq Lc295
	jmp Lc8f9
	
Lc295
	iny
	jsr Sc398
	cmp $91f6
	beq Lc2a1
	jmp Lc915
	
Lc2a1
	iny
	jsr Sc398
	cmp $91f7
	beq Lc2ad
	jmp Lc915
	
Lc2ad
	iny
	jsr Sc398
	cmp $91f8
	beq Lc2b9
	jmp Lc94d
	
Lc2b9
	iny
	jsr Sc398
	cmp $91fa
	beq Lc2c5
	jmp Lc931
	
Lc2c5
	iny
	jsr Sc398
	cmp $91fb
	beq Lc2d1
	jmp Lc931
	
Lc2d1
	iny
	jsr Sc398
	cmp $91fd
	beq Lc2dd
	jmp Lc962
	
Lc2dd
	jsr Sc39c
Lc2e0
	dec $ca85
	bne Lc2e8
	jmp Lc181
	
Lc2e8
	clc
	lda Sc398 + 1
	adc #$20
	sta Sc398 + 1
	sta Sc380 + 1
	bcc Lc2fc
	inc Sc398 + 2
	inc Sc380 + 2
Lc2fc
	dec $caaf
	beq Lc304
	jmp Lc1da
	
Lc304
	ldy $caae
	sty $99fc
	jsr Sc383
	beq Lc326
	ldy $ca84
	lda #$00
	sta $9801,y
	lda LTK_Var_ActiveLU
	ldx $c1b9
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte $e0,$97,$01; $97e0 
Lc326
	jmp Lc181
	
Lc329
	lda $9c72
	sec
	sbc $9c75
	sta $9c72
	lda $9c71
	sbc $9c74
	sta $9c71
	lda LTK_Var_ActiveLU
	ldx $caa2
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
Lc34b
	ldx $ca86
	beq Lc356
	jsr LTK_HDDiscDriver 
	.byte <LTK_DOSOverlay,>LTK_DOSOverlay,$01 ;$95e0 
Lc356
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	lda $9de4
	sta LTK_Var_ActiveLU
	lda $9de5
	sta LTK_Var_Active_User
	clc
	jmp LTK_MemSwapOut 
	
Sc372
	ldx #$63
	ldy #$cb
	jsr LTK_Print 
	ldx #$e0
	ldy #$91
	jmp LTK_Print 
	
Sc380
	sta Sc380,y
Sc383
	tya
	pha
	lda LTK_Var_ActiveLU
	ldx $ca8b
	ldy $ca8a
	sec
	jsr LTK_HDDiscDriver 
	.byte $e0,$99,$01; $99e0 
Lc395
	pla
	tay
	rts
	
Sc398
	lda Sc398,y
	rts
	
Sc39c
	ldx #$00
	stx $caa3
	stx $caa4
	stx $ca88
	stx $ca89
	inx
	stx $ca87
	lda $91f0
	bne Lc3b9
	lda $91f1
	sec
	beq Lc40c
Lc3b9
	lda $91f8
	cmp #$0b
	bcs Lc3d2
	lda $caa3
	clc
	adc $9201
	tax
	lda $caa4
	adc $9200
	tay
	jmp Lc3ec
	
Lc3d2
	lda $91f0
	bne Lc3de
	lda $91f1
	cmp #$f1
	bcc Lc3e1
Lc3de
	jmp Lc427
	
Lc3e1
	lda #$92
	sta Sc422 + 2
	lda $caa3
	jsr Sc40f
Lc3ec
	jsr Sc78a
	bcc Lc3fb
	lda $91f8
	cmp #$04
	bcc Lc40d
	jsr Sc4ac
Lc3fb
	lda $caa4
	cmp $91f0
	bne Lc3b9
	lda $caa3
	cmp $91f1
	bne Lc3b9
	clc
Lc40c
	rts
	
Lc40d
	sec
	rts
	
Sc40f
	asl a
	tax
	bcc Lc416
	inc Sc422 + 2
Lc416
	jsr Sc422
	tay
	jsr Sc422
	tax
	lda LTK_Var_ActiveLU
	rts
	
Sc422
	lda $9200,x
	inx
	rts
	
Lc427
	ldx $9201
	ldy $9200
	jsr Sc78a
	bcc Lc435
	jsr Sc4ac
Lc435
	lda #$00
	sta $33
	lda #$92
	sta $34
	lda $ca87
	asl a
	tay
	bcc Lc446
	inc $34
Lc446
	lda ($33),y
	tax
	iny
	lda ($33),y
	sta $33
	stx $34
	ldx $33
	ldy $34
	jsr Sc78a
	bcc Lc45c
	jsr Sc4ac
Lc45c
	inc $ca87
	ldy $34
	ldx $33
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
Lc46d
	lda #$e0
	sta $33
	lda #$8f
	sta $34
Lc475
	ldy #$00
	lda ($33),y
	pha
	iny
	lda ($33),y
	tax
	pla
	tay
	jsr Sc78a
	bcc Lc488
	jsr Sc4ac
Lc488
	lda $caa4
	cmp $91f0
	bne Lc498
	lda $caa3
	cmp $91f1
	beq Lc4aa
Lc498
	lda $33
	clc
	adc #$02
	sta $33
	bcc Lc4a3
	inc $34
Lc4a3
	inc $ca88
	bne Lc475
	beq Lc435
Lc4aa
	clc
	rts
	
Sc4ac
	bit $ca89
	bmi Lc4f5
	stx $caab
	dec $ca89
Lc4b7
	ldx #$00
	ldy #$cb
	bit $caab
	bpl Lc4c4
	ldx #$84
	ldy #$cb
Lc4c4
	jsr LTK_Print 
	ldx #$3b
	ldy #$cb
	jsr Sc724
	bcs Lc4b7
	cmp #$44
	bne Lc4de
	jsr Sc4f6
	pla
	pla
	pla
	pla
	jmp Lc06b
	
Lc4de
	cmp #$53
	bne Lc4b7
	sed
	lda $caa7
	clc
	adc #$01
	sta $caa7
	lda $caa8
	adc #$00
	sta $caa8
	cld
Lc4f5
	rts
	
Sc4f6
	dec $99fc
	bne Lc512
	ldy $ca84
	lda #$00
	sta $9801,y
	lda LTK_Var_ActiveLU
	ldx $c1b9
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte $e0,$97,$01; $97e0 
Lc512
	lda #$80
	ldy #$1d
	jsr Sc380
	sed
	lda $caa5
	clc
	adc #$01
	sta $caa5
	lda $caa6
	adc #$00
	sta $caa6
	cld
	rts
	
Sc52d
	lda LTK_Var_ActiveLU
	cmp #$0a
	bne Lc559
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc53f
	lda $91f4
	pha
	lda #$00
	sta $caa0
	lda $9216
	sta $caa1
	lda #$02
	sta $c5de
	ldy $91f9
	jmp Lc59f
	
Lc559
	sta $c560
	asl a
	asl a
	clc
	adc #$00
	sta $ca9f
	tay
	lda #$f7
	and $80aa,y
	sta $80aa,y
	lda #$0a
	ldx #$1a
	ldy #$00
	sty LTK_BLKAddr_MiniSub
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiniSubExeArea,>LTK_MiniSubExeArea,$01 ;$93e0 
Lc57d
	lda #$11
	sta $c5de
	ldy $ca9f
	lda $93e6,y
	and #$07
	sta $caa0
	lda $93e7,y
	sta $caa1
	lda $93e8,y
	pha
	lda $93e6,y
	lsr a
	lsr a
	lsr a
	lsr a
	tay
Lc59f
	ldx #$00
	pla
	jsr LTK_TPMultiply 
	sta $ca92
	ldy #$08
	jsr Sc749
	cpy #$00
	clc
	beq Lc5b3
	sec
Lc5b3
	adc #$03
	sta $ca93
	tay
	ldx #$02
	lda #$00
	jsr Sc749
	sta $ca94
	jsr LTK_ClearHeaderBlock 
	ldx #$09
Lc5c8
	lda Lcab0,x
	sta LTK_FileHeaderBlock ,x
	dex
	bpl Lc5c8
	lda $ca94
	sta $91f3
	lda $ca93
	sta $91f5
	lda #$00
	sta $91f1
	lda $caa1
	sta $91f7
	lda $caa0
	sta $91f6
	lda #$01
	sta $91f8
	lda $ca92
	sta $91f9
	ldx $caa0
	ldy $caa1
Lc5ff
	lda $ca92
	clc
	adc $9272
	sta $9272
	bcc Lc613
	inc $9271
	bne Lc613
	inc $9270
Lc613
	dey
	bne Lc5ff
	cpx #$00
	beq Lc61e
	dex
	jmp Lc5ff
	
Lc61e
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq Lc629
	ldx #$00
Lc629
	stx $ca96
	stx $caa2
	stx $9201
	ldy #$00
	sty $ca95
	lda #$ff
	sta $9276
	sta $9277
	lda LTK_Var_ActiveLU
	sta $91fd
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc64c
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0
Lc653
	lda $9271
	sta $ca90
	lda $9272
	sta $ca91
	lda #$00
	sta $ca97
	sta $ca98
	sta $ca99
	lda $caa0
	sta $ca9a
	lda $caa1
	sta $ca9b
Lc676
	inc $ca96
	lda #$e0
	sta $ca9d
	lda #$91
	sta $ca9c
	lda $ca94
	sta $ca9e
	jsr LTK_ClearHeaderBlock 
Lc68c
	lda $ca9d
	sta Sc718 + 1
	lda $ca9c
	sta Sc718 + 2
	lda $ca97
	jsr Sc718
	lda $ca98
	jsr Sc718
	lda $ca99
	jsr Sc718
	clc
	lda $ca9d
	adc $ca93
	sta $ca9d
	bcc Lc6b9
	inc $ca9c
Lc6b9
	lda $ca99
	clc
	adc $ca92
	sta $ca99
	bcc Lc6cd
	inc $ca98
	bne Lc6cd
	inc $ca97
Lc6cd
	dec $ca9b
	bne Lc6da
	lda $ca9a
	beq Lc6f1
	dec $ca9a
Lc6da
	dec $ca9e
	bne Lc68c
	lda LTK_Var_ActiveLU
	ldx $ca96
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc6ee
	jmp Lc676
	
Lc6f1
	lda $ca9c
	sta Sc718 + 2
	lda $ca9d
	sta Sc718 + 1
	lda #$ff
	jsr Sc718
	jsr Sc718
	jsr Sc718
	lda LTK_Var_ActiveLU
	ldx $ca96
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc717
	rts
	
Sc718
	sta LTK_FileHeaderBlock 
	inc Sc718 + 1
	bne Lc723
	inc Sc718 + 2
Lc723
	rts
	
Sc724
	jsr LTK_Print 
	jsr Scf7d
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
Lc731
	jsr LTK_KernalCall 
	sta $c745,y
	iny
	cpy #$03
	bcs Lc744
	cmp #$0d
	bne Lc731
	lda $c745
	clc
Lc744
	rts
	
	.byte $00,$00,$00,$00 
Sc749
	sta $c77c
	stx $c77b
	sty $c77d
	lda #$00
	ldx #$10
Lc756
	clc
	rol $c77c
	rol $c77b
	rol a
	bcs Lc765
	cmp $c77d
	bcc Lc770
Lc765
	sbc $c77d
	inc $c77c
	bne Lc770
	inc $c77b
Lc770
	dex
	bne Lc756
	tay
	ldx $c77b
	lda $c77c
	rts
	
	.byte $00,$00,$00 
Lc77e
	inc $caa3
	bne Lc786
	inc $caa4
Lc786
	ldx #$ff
	sec
	rts
	
Sc78a
	lda $91f8
	cmp #$01
	beq Lc7a9
	cpy $ca8e
	bcc Lc77e
	bne Lc79d
	cpx $ca8f
	bcc Lc77e
Lc79d
	cpy $ca90
	bcc Lc7a9
	bne Lc77e
	cpx $ca91
	bcs Lc77e
Lc7a9
	txa
	pha
	tya
	tax
	pla
	ldy $ca92
	jsr Sc749
	sty $ca7f
	ldy $ca94
	jsr Sc749
	sty $ca81
	sec
	adc $caa2
	sta $ca96
	lda $ca86
	beq Lc7e0
	cmp $ca96
	beq Lc7f2
	lda LTK_Var_ActiveLU
	ldx $ca86
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_DOSOverlay,>LTK_DOSOverlay,$01 ;$95e0 
Lc7e0
	ldx $ca96
	stx $ca86
	lda LTK_Var_ActiveLU
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_DOSOverlay,>LTK_DOSOverlay,$01 ;$95e0 
Lc7f2
	lda $ca7f
	ldx #$00
	ldy #$08
	jsr Sc749
	sta $ca80
	sty $ca7f
	lda $ca93
	ldx #$00
	ldy $ca81
	jsr LTK_TPMultiply 
	clc
	adc $ca80
	bcc Lc814
	inx
Lc814
	clc
	adc #$e3
	sta $31
	txa
	adc #$95
	sta $32
	lda #$80
	ldy $ca7f
	beq Lc829
Lc825
	lsr a
	dey
	bne Lc825
Lc829
	sta $ca82
	lda ($31),y
	tax
	and $ca82
	sec
	bne Lc844
	txa
	ora $ca82
	sta ($31),y
	clc
	inc $9c75
	bne Lc844
	inc $9c74
Lc844
	inc $caa3
	bne Lc84c
	inc $caa4
Lc84c
	ldx #$00
	rts
	
Lc84f
	ldx #$20
	ldy #$cd
	jsr LTK_Print 
	jsr Scf7d
	jmp Lc356
	
Lc85c
	jsr Sc9a3
	ldx #$b9
	ldy #$cd
	bne Lc86c
Lc865
	jsr Sc9a3
	ldx #$d7
	ldy #$cd
Lc86c
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq Lc899
	jsr LTK_Print 
	ldx #$99
	ldy #$ce
	jsr LTK_Print 
	jmp Lc329
	
Lc880
	jsr Sc9a3
	ldx #$2b
	ldy #$ce
	bne Lc899
Lc889
	jsr Sc9a3
	ldx #$4e
	ldy #$ce
	bne Lc844
Lc892
	jsr Sc9a3
	ldx #$71
	ldy #$ce
Lc899
	jsr LTK_Print 
	jsr Sc9a9
	jmp Lc329
	
Lc8a2
	ldx #$f6
	ldy #$cd
	jsr LTK_Print 
	jsr Scf7d
	jmp Lc329
	
Lc8af
	ldx #$2b
	ldy #$cc
	jsr Sc724
	bcs Lc8af
	cmp #$0d
	bne Lc8af
	jsr Sc4f6
	jmp Lc06b
	
Lc8c2
	ldx #$96
	ldy #$cc
	jsr LTK_Print 
	jsr Sc982
	ldy #$0f
Lc8ce
	jsr Sc398
	sta LTK_FileHeaderBlock ,y
	dey
	bpl Lc8ce
	jsr Sc9b4
	jmp Lc264
	
Lc8dd
	ldx #$a2
	ldy #$cc
	jsr LTK_Print 
	jsr Sc982
	lda $91f0
	ldy #$10
	jsr Sc380
	lda $91f1
	iny
	jsr Sc380
	jmp Lc27d
	
Lc8f9
	ldx #$b6
	ldy #$cc
	jsr LTK_Print 
	jsr Sc982
	lda $91f4
	ldy #$12
	jsr Sc380
	lda $91f5
	iny
	jsr Sc380
	jmp Lc295
	
Lc915
	ldx #$d4
	ldy #$cc
	jsr LTK_Print 
	jsr Sc982
	lda $91f6
	ldy #$14
	jsr Sc380
	lda $91f7
	iny
	jsr Sc380
	jmp Lc2ad
	
Lc931
	ldx #$03
	ldy #$cd
	jsr LTK_Print 
	jsr Sc982
	lda $91fa
	ldy #$17
	jsr Sc380
	lda $91fb
	iny
	jsr Sc380
	jmp Lc2d1
	
Lc94d
	ldx #$f1
	ldy #$cc
	jsr LTK_Print 
	jsr Sc982
	ldy #$16
	lda $91f8
	jsr Sc380
	jmp Lc2b9
	
Lc962
	ldx #$13
	ldy #$cd
	jsr LTK_Print 
	jsr Sc982
	lda $91fd
	and #$f0
	ora LTK_Var_ActiveLU
	sta $91fd
	ldy #$19
	jsr Sc380
	jsr Sc9b4
	jmp Lc2dd
	
Sc982
	ldx #$e6
	ldy #$cb
	jsr Sc724
	bcs Sc982
	cmp #$0d
	bne Sc982
	sed
	lda $caa9
	clc
	adc #$01
	sta $caa9
	lda $caaa
	adc #$00
	sta $caaa
	cld
	rts
	
Sc9a3
	ldx #$6e
	ldy #$cd
	bne Lc9ad
Sc9a9
	ldx #$90
	ldy #$cd
Lc9ad
	jsr LTK_Print 
	jsr Scf7d
	rts
	
Sc9b4
	lda LTK_Var_ActiveLU
	ldx $caad
	ldy $caac
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lc9c4
	rts
	
Sc9c5
	jsr Sc9e0
	sta Lca7a
	stx Lca7a+1
	tya
	jsr Sc9e0
	sta Lca7a+2
	stx Lca7a+3
	ldx #$7a
	ldy #$ca
	jsr LTK_Print 
	rts
	
Sc9e0
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
	
Lc9f0
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq Lca02
	clc
	adc #$30
	sta Lced7 + 8
	lda #$30
	sta Lced7 + 7
Lca02
	ldx #$d7
	ldy #$ce
	jsr LTK_Print 
	jsr Scf7d
	ldx #$f8
	ldy #$ce
	jsr LTK_Print 
	lda $caa6
	ldy $caa5
	jsr Sc9c5
	ldx #$15
	ldy #$cf
	jsr LTK_Print 
	lda $caa8
	ldy $caa7
	jsr Sc9c5
	ldx #$33
	ldy #$cf
	jsr LTK_Print 
	lda $caaa
	ldy $caa9
	jsr Sc9c5
	lda $ca8c
	cmp $ca8d
	beq Lca60
	ldx #$51
	ldy #$cf
	jsr LTK_Print 
	ldx #$90
	ldy #$cd
	lda LTK_Var_ActiveLU
	cmp #$0a
	beq Lca5a
	ldx #$99
	ldy #$ce
Lca5a
	jsr LTK_Print 
	jmp Lc329
	
Lca60
	lda #$0a
	ldx #$00
	ldy #$00
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lca6d
	dec $920a
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
Lca77
	jmp Lc329
	
	
	
Lca7a
	
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$01,$01,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00
	
Lcab0
	.screen "DISCBITMAP"
Lcaba
	.screen "SYSTEMINDEX"
Lcac5
	.screen "LTKERNALDOSIMAGE"
Lcad5
	.screen "SYSTEMTRACK"
Lcae0
	.screen "SYSTEMCONFIGFILE"
Lcaf0
	.screen "FASTCOPY.MODULES"
Lcb00
	.text "{return}{return}{rvs on}warning, this file contains a block{return}{rvs on}already in use !!!"

	.byte $00
Lcb3b
	.text "{return}{return}type {rvs on}d{rvs off}elete file or {rvs on}s{rvs off}kip file  d{left}"
	.byte $00
Lcb63
	.text "{return}processing   {$22}{del}1234567890123456"
	.byte $00
Lcb84
	.text "{return}{return}{rvs on}warning, this file contains a block{return}{rvs on}pointer outside the legal range of{return}{rvs on}this logical unit !!!"
	.byte $00
Lcbe6
	.text "{return}{rvs on}error has been found  and   {$22}corrected{$22}{return}{return}press return to continue "
	.byte $00
Lcc2b
	.text "{return}{return}{rvs on}this file has a corrupted header block.{return}{rvs on}it {$22}cannot{$22} be recovered !!!{return}{return}press return to delete the file "
	.byte $00
Lcc96
	.text "{return}{return}{rvs on}filename"
	.byte $00
Lcca2
	.text "{return}{return}{rvs on}number of blocks"
	.byte $00
Lccb6
	.text "{return}{return}{rvs on}number of bytes per record"
	.byte $00
Lccd4
	.text "{return}{return}{rvs on}number of records in file"
	.byte $00
Lccf1
	.text "{return}{return}{rvs on}file type code"
	.byte $00
Lcd03
	.text "{return}{return}{rvs on}load address"
	.byte $00
Lcd13
	.text "{return}{return}{rvs on}lu number"
	.byte $00
Lcd20
	.text "{return}{return}{rvs on}corrupted {$22}systemindex{$22} header found.{return}{rvs on}cannot proceed with validation !!!{return}"
	.byte $00
Lcd6e
	.text "{return}{return}{rvs on}cannot find and/or allocate -{return}"
	.byte $00
Lcd90
	.text "{return}{return}{rvs on}must do a {$22}sysgen{$22} to correct it !!!{return}"
	.byte $00
Lcdb9
	.text "{return}{return}{rvs on}the {$22}discbitmap{$22} file !!!{return}"
	.byte $00
Lcdd7
	.text "{return}{return}{rvs on}the {$22}systemindex{$22} file !!!{return}"
	.byte $00
Lcdf6
	.text "{return}{return}{rvs on}cannot allocate the {$22}ltkernaldosimage{$22}{return}{rvs on}file !!!{return}"
	.byte $00
Lce2b
	.text "{return}{return}{rvs on}the dos {$22}systemtrack{$22} file !!!{return}"
	.byte $00
Lce4e
	.text "{return}{return}{rvs on}the dos {$22}systemconfigfile{$22} !!!{return}"
	.byte $00
Lce71
	.text "{return}{return}{rvs on}the dos {$22}fastcopy.modules{$22} file !!!{return}"
	.byte $00
Lce99
	.text "{return}{return}{rvs on}must try {$22}autocopy{$22} then reactivate{return}{rvs on}lu to correct it !!!{return}"
	.byte $00
Lced7
	.text "{return}{return}{return}lu {rvs on}10{rvs off} validation complete{return}{return}"
	.byte $00
Lcef8
	.text "number of files deleted     "
	.byte $00
Lcf15
	.text "{return}bad files still on lu       "
	.byte $00
Lcf33
	.text "{return}number of corrected errors  "
	.byte $00
Lcf51
	.text "{return}{return}{rvs on}too many dos system files encountered !{return}"
	.byte $00
Scf7d
	lda LTK_BeepOnErrorFlag
	beq Lcfbc
	ldy #$18
	lda #$00
Lcf86
	sta SID_V1_FreqLo,y
	dey
	bpl Lcf86
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
Lcf98
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scfbd
	iny
	tya
	cmp #$10
	bne Lcf98
	ldx #$50
	jsr Scfbd
	ldy #$10
	sta SID_V1_Control
Lcfb0
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr Scfbd
	tya
	bne Lcfb0
Lcfbc
	rts
	
Scfbd
	dec Lcfc6
	bne Scfbd
	dex
	bne Scfbd
	rts
	
Lcfc6
	.byte $00 
