;indxmod0.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay ;$4000 for sysgen 
L95e0
	ldx #$27
	lda #$00
	sta L9966
L95e7
	sta L996a,x
	dex
	bpl L95e7
	lda LTK_Var_ActiveLU
	sta L9967
	lda LTK_Var_Active_User
	sta L9968
	lda $9ec3
	sta L9969
	lda $9ec4
	sta $99b5
	lda $9ec5
	sta $99b1
	lda $31
	pha
	lda $32
	pha
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldy #$00
L961d
	jsr $fc6e
	sta L996a,y
	iny
	cpy #$28
	beq L962d
	cpy $9e84
	bne L961d
L962d
	pla
	sta $32
	pla
	sta $31
	ldy L9966
	jsr S9954
	pha
	bcs L9654
	lda L996a,y
	cmp #$3a
	bne L9654
	pla
	beq L9649
L9646
	jmp L9820
	
L9649
	txa
	iny
	sty L9966
	jsr LTK_SetLuActive 
	bcs L9646
	pha
L9654
	pla
	ldy L9966
	jsr S9954
	pha
	bcs L9677
	lda L996a,y
	cmp #$3a
	bne L9677
	pla
	beq L966b
L9668
	jmp L9823
	
L966b
	cpx #$10
	bcs L9668
	stx LTK_Var_Active_User
	iny
	sty L9966
	pha
L9677
	pla
	jsr LTK_ClearHeaderBlock 
	ldy L9966
	ldx #$00
L9680
	lda L996a,y
	cmp #$2c
	beq L9692
	sta LTK_FileHeaderBlock ,x
	iny
	inx
	cpx #$11
	beq L96b5
	bne L9680
L9692
	sty L9966
	lda #$02
	sec
	jsr $9f00
	bcc L96a0
	jmp L983e
	
L96a0
	jsr LTK_FindFile 
	bcs L96a8
	jmp L9826
	
L96a8
	sta L9965
	stx L995e
	sty L995d
	cpx #$ff
	bne L96b8
L96b5
	jmp L9829
	
L96b8
	cmp #$00
	bne L96c5
	txa
	bne L96c5
	tya
	bne L96c5
	jmp L982c
	
L96c5
	lda $9ea4
	ldx $9ea5
	sta $9224
	stx $9225
	ldx $9e83
	bne L96d9
L96d6
	jmp L982f
	
L96d9
	cpx #$06
	bcs L96d6
	stx $9230
	lda #$00
	sta L9964
L96e5
	ldy L9966
	lda L996a,y
	cmp #$2c
	beq L96f2
	jmp L9832
	
L96f2
	iny
	sty L9966
	jsr S9954
	sty L9966
	tay
	beq L9702
L96ff
	jmp L9835
	
L9702
	txa
	beq L96ff
	cpx #$1f
	bcs L96ff
	ldy L9964
	sta $9231,y
	iny
	sty L9964
	cpy $9230
	bne L96e5
	lda #$00
	sta L9964
	sta L995f
	sta L9960
	sta L9961
	sta L9962
L9729
	ldy L9964
	lda $9231,y
	jsr S9847
	bcc L9737
	jmp L9838
	
L9737
	ldy L9964
	lda L995c
	sta $9236,y
	iny
	sty L9964
	cpy $9230
	bne L9729
	lda #$01
	ldx #$00
	jsr S98d7
	lda #$04
	sta $91f8
	jsr LTK_AllocContigBlks 
	bcc L9765
	cpx #$80
	bne L9762
	tax
	jmp L9841
	
L9762
	jmp L983b
	
L9765
	ldy $9200
	ldx $9201
	inx
	bne L976f
	iny
L976f
	lda #$00
	sta L9964
	txa
L9775
	pha
	lda L9964
	asl a
	tax
	tya
	sta $9202,x
	pla
	sta $9203,x
	clc
	adc #$02
	bcc L9789
	iny
L9789
	inc L9964
	ldx L9964
	cpx $9230
	bne L9775
	sta $920d
	sta $992f
	sty $920c
	sty $9931
	clc
	adc L9960
	sta $9219
	tya
	adc L995f
	sta $9218
	jsr S98e7
	lda L9960
	sta $9952
	lda L995f
	sta $994b
	jsr S9902
	lda $9218
	sta $9931
	lda $9219
	sta $992f
	lda L9961
	sta $994b
	lda L9962
	sta $9952
	jsr S9902
	lda $9230
	asl a
	sta L9964
	lda LTK_Var_ActiveLU
	ldx $9203
	ldy $9202
L97eb
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L97f2
	inx
	bne L97f6
	iny
L97f6
	dec L9964
	bne L97eb
	lda L9965
	pha
	ldx L995e
	ldy L995d
	lda #$24
	jsr LTK_ExeExtMiniSub 
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L981a
	lda #$00
	
	clc
	jmp L9992
	
L9820
	lda #$01
	.byte $2c 
L9823
	lda #$02
	.byte $2c 
L9826
	lda #$03
	.byte $2c 
L9829
	lda #$04
	.byte $2c 
L982c
	lda #$05
	.byte $2c 
L982f
	lda #$06
	.byte $2c 
L9832
	lda #$07
	.byte $2c 
L9835
	lda #$08
	.byte $2c 
L9838
	lda #$09
	.byte $2c 
L983b
	lda #$0a
L983e = * + 1       
	bit $0ba9
L9841 = * + 1       
	bit $0ca9
	sec
	jmp L9992
	
S9847
	clc
	adc #$02
	tay
	lda #$00
	sta L9a30
	lda #$fb
	ldx #$01
	jsr S99f6
	sta L995c
	tay
	lda $9225
	ldx $9224
	jsr S9887
	jsr S98b7
	ldy L995c
	jsr S9887
	jsr S9895
	ldy L995c
	jsr S9887
	cpx #$00
	bne L987e
	cmp #$03
	bcc L9880
L987e
	sec
	rts
	
L9880
	lda #$02
	jsr S98d7
	clc
	rts
	
S9887
	jsr S99f6
	cpy #$00
	beq L9894
	clc
	adc #$01
	bcc L9894
	inx
L9894
	rts
	
S9895
	pha
	lda L9964
	asl a
	tay
	pla
	sta $920f,y
	pha
	txa
	sta $920e,y
	pla
	tay
	clc
	adc L9960
	sta L9960
	txa
	adc L995f
	sta L995f
	jmp L98d6
	
S98b7
	pha
	lda L9964
	asl a
	tay
	pla
	sta $921b,y
	pha
	txa
	sta $921a,y
	pla
	tay
	clc
	adc L9962
	sta L9962
	txa
	adc L9961
	sta L9961
L98d6
	tya
S98d7
	clc
	adc $91f1
	sta $91f1
	txa
	adc $91f0
	sta $91f0
	tya
	rts
	
S98e7
	ldx #$05
	lda #$00
	tay
L98ec
	sta LTK_MiscWorkspace,y
	iny
	dex
	bne L98ec
	lda #$ff
L98f5
	sta LTK_MiscWorkspace,y
	iny
	bne L98f5
L98fb
	sta $90e0,y
	iny
	bne L98fb
	rts
	
S9902
	lda #$00
	sta L9963
	sta L9964
L990a
	inc L9964
	bne L9912
	inc L9963
L9912
	ldx $992f
	ldy $9931
	inx
	bne L991c
	iny
L991c
	jsr S9947
	bne L9925
	ldx #$00
	ldy #$00
L9925
	sty LTK_MiscWorkspace
	stx $8fe1
	lda LTK_Var_ActiveLU
	ldx #$00
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9939
	inc $992f
	bne L9941
	inc $9931
L9941
	jsr S9947
	bne L990a
	rts
	
S9947
	lda L9963
	cmp #$00
	bne L9953
	lda L9964
	cmp #$00
L9953
	rts
	
S9954
	lda #$6a
	ldx #$99
	jsr S9a34
	rts
	
L995c
	.byte $00
L995d
	.byte $00
L995e
	.byte $00
L995f
	.byte $00
L9960
	.byte $00
L9961
	.byte $00
L9962
	.byte $00
L9963
	.byte $00
L9964
	.byte $00
L9965
	.byte $00
L9966
	.byte $00
L9967
	.byte $00
L9968
	.byte $00
L9969
	.byte $00
L996a
	.byte $00,$00,$00,$00,$00 
L996f			
	.byte $00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00 
L9992
	php
	pha
	lda #$02
	clc
	jsr $9f00
	pla
	tax
	plp
	lda L9967
	sta LTK_Var_ActiveLU
	lda L9968
	sta LTK_Var_Active_User
	txa
	bit L9969
	bmi L99db
	pha
	lda #$00
	sta $7a
	lda #$00
	sta $7b
	jsr $0073
	jsr S99de
	jsr $0073
	jsr S99de
	jsr $0073
	jsr S99e4
	sta $49
	sty $4a
	pla
	tay
	lda #$00
	jsr $b395
	jsr S99ea
	jmp LTK_SysRet_OldRegs 
	
L99db
	jmp LTK_SysRet_AsIs  
	
S99de
	ldx #$9e
	ldy #$ad
	bne L99ee
S99e4
	ldx #$8b
	ldy #$b0
	bne L99ee
S99ea
	ldx #$d0
	ldy #$bb
L99ee
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
S99f6
	sta L9a32
	stx L9a31
	sty L9a33
	lda #$00
	ldx #$18
L9a03
	clc
	rol L9a32
	rol L9a31
	rol L9a30
	rol a
	bcs L9a15
	cmp L9a33
	bcc L9a25
L9a15
	sbc L9a33
	inc L9a32
	bne L9a25
	inc L9a31
	bne L9a25
	inc L9a30
L9a25
	dex
	bne L9a03
	tay
	ldx L9a31
	lda L9a32
	rts
	
L9a30
	.byte $00
L9a31
	.byte $00
L9a32
	.byte $00
L9a33
	.byte $00
S9a34
	sta L9a45 + 1
	stx L9a45 + 2
	lda #$00
	sta L9aaf
	sta L9ab0
	sta L9ab1
L9a45
	lda L9a45,y
	cmp #$30
	bcc L9a9d
	cmp #$3a
	bcc L9a62
	ldx $9a6e
	cpx #$0a
	beq L9a9d
	cmp #$41
	bcc L9a9d
	cmp #$47
	bcs L9a9d
	sec
	sbc #$07
L9a62
	ldx L9aaf
	beq L9a86
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9a6f
	clc
	adc L9ab1
	pha
	txa
	adc L9ab0
	tax
	pla
	dey
	bne L9a6f
	sta L9ab1
	stx L9ab0
	pla
	tay
	pla
L9a86
	inc L9aaf
	sec
	sbc #$30
	clc
	adc L9ab1
	sta L9ab1
	bcc L9a9a
	inc L9ab0
	beq L9aa7
L9a9a
	iny
	bne L9a45
L9a9d
	cmp #$20
	beq L9a9a
	clc
	ldx L9aaf
	bne L9aa8
L9aa7
	sec
L9aa8
	lda L9ab0
	ldx L9ab1
	rts
	
L9aaf
	.byte $00
L9ab0
	.byte $00
L9ab1
	.byte $00
