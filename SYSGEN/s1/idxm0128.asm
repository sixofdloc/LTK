;idxm0128.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

 
    *=LTK_DOSOverlay 

L95e0
	sta L9628 + 1
	ldx #$27
	lda #$00
	sta L9975
L95ea
	sta L9979,x
	dex
	bpl L95ea
	lda LTK_Var_ActiveLU
	sta L9976
	lda LTK_Var_Active_User
	sta L9977
	lda $9ec3
	sta L9978
	lda $9ec4
	sta L99c3 + 1
	lda $9ec5
	sta L99bf + 1
	lda $31
	pha
	lda $32
	pha
	lda $9ea3
	sta $31
	lda $9e85
	sta $32
	ldx #$74
	ldy #$ff
	sec
	jsr LTK_KernalTrapSetup
	ldy #$00
L9628
	ldx #$00
	lda #$31
	jsr LTK_KernalCall 
	sta L9979,y
	iny
	cpy #$28
	beq L963c
	cpy $9e84
	bne L9628
L963c
	pla
	sta $32
	pla
	sta $31
	ldy L9975
	jsr S9963
	pha
	bcs L9663
	lda L9979,y
	cmp #$3a
	bne L9663
	pla
	beq L9658
L9655
	jmp L982f
	
L9658
	txa
	iny
	sty L9975
	jsr LTK_SetLuActive 
	bcs L9655
	pha
L9663
	pla
	ldy L9975
	jsr S9963
	pha
	bcs L9686
	lda L9979,y
	cmp #$3a
	bne L9686
	pla
	beq L967a
L9677
	jmp L9832
	
L967a
	cpx #$10
	bcs L9677
	stx LTK_Var_Active_User
	iny
	sty L9975
	pha
L9686
	pla
	jsr LTK_ClearHeaderBlock 
	ldy L9975
	ldx #$00
L968f
	lda L9979,y
	cmp #$2c
	beq L96a1
	sta LTK_FileHeaderBlock ,x
	iny
	inx
	cpx #$11
	beq L96c4
	bne L968f
L96a1
	sty L9975
	lda #$02
	sec
	jsr $9f00
	bcc L96af
	jmp L984d
	
L96af
	jsr LTK_FindFile 
	bcs L96b7
	jmp L9835
	
L96b7
	sta L9974
	stx L996d
	sty L996c
	cpx #$ff
	bne L96c7
L96c4
	jmp L9838
	
L96c7
	cmp #$00
	bne L96d4
	txa
	bne L96d4
	tya
	bne L96d4
	jmp L983b
	
L96d4
	lda $9ea4
	ldx $9ea5
	sta $9224
	stx $9225
	ldx $9e83
	bne L96e8
L96e5
	jmp L983e
	
L96e8
	cpx #$06
	bcs L96e5
	stx $9230
	lda #$00
	sta L9973
L96f4
	ldy L9975
	lda L9979,y
	cmp #$2c
	beq L9701
	jmp L9841
	
L9701
	iny
	sty L9975
	jsr S9963
	sty L9975
	tay
	beq L9711
L970e
	jmp L9844
	
L9711
	txa
	beq L970e
	cpx #$1f
	bcs L970e
	ldy L9973
	sta $9231,y
	iny
	sty L9973
	cpy $9230
	bne L96f4
	lda #$00
	sta L9973
	sta L996e
	sta L996f
	sta L9970
	sta L9971
L9738
	ldy L9973
	lda $9231,y
	jsr S9856
	bcc L9746
	jmp L9847
	
L9746
	ldy L9973
	lda L996b
	sta $9236,y
	iny
	sty L9973
	cpy $9230
	bne L9738
	lda #$01
	ldx #$00
	jsr S98e6
	lda #$04
	sta $91f8
	jsr LTK_AllocContigBlks 
	bcc L9774
	cpx #$80
	bne L9771
	tax
	jmp L9850
	
L9771
	jmp L984a
	
L9774
	ldy $9200
	ldx $9201
	inx
	bne L977e
	iny
L977e
	lda #$00
	sta L9973
	txa
L9784
	pha
	lda L9973
	asl a
	tax
	tya
	sta $9202,x
	pla
	sta $9203,x
	clc
	adc #$02
	bcc L9798
	iny
L9798
	inc L9973
	ldx L9973
	cpx $9230
	bne L9784
	sta $920d
	sta L993d + 1
	sty $920c
	sty L993f + 1
	clc
	adc L996f
	sta $9219
	tya
	adc L996e
	sta $9218
	jsr S98f6
	lda L996f
	sta L9960 + 1
	lda L996e
	sta L9959 + 1
	jsr S9911
	lda $9218
	sta L993f + 1
	lda $9219
	sta L993d + 1
	lda L9970
	sta L9959 + 1
	lda L9971
	sta L9960 + 1
	jsr S9911
	lda $9230
	asl a
	sta L9973
	lda LTK_Var_ActiveLU
	ldx $9203
	ldy $9202
L97fa
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9801
	inx
	bne L9805
	iny
L9805
	dec L9973
	bne L97fa
	lda L9974
	pha
	ldx L996d
	ldy L996c
	lda #$24
	jsr LTK_ExeExtMiniSub 
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9829
	lda #$00
	
	clc
	jmp L99a1
	
L982f
	lda #$01
	.byte $2c 
L9832
	lda #$02
	.byte $2c 
L9835
	lda #$03
	.byte $2c 
L9838
	lda #$04
	.byte $2c 
L983b
	lda #$05
	.byte $2c 
L983e
	lda #$06
	.byte $2c 
L9841
	lda #$07
	.byte $2c 
L9844
	lda #$08
	.byte $2c 
L9847
	lda #$09
	.byte $2c 
L984a
	lda #$0a
	.byte $2c 
L984d
	lda #$0b
	.byte $2c 
L9850
	lda #$0c
	sec
	jmp L99a1
	
S9856
	clc
	adc #$02
	tay
	lda #$00
	sta L9a4e
	lda #$fb
	ldx #$01
	jsr S9a14
	sta L996b
	tay
	lda $9225
	ldx $9224
	jsr S9896
	jsr S98c6
	ldy L996b
	jsr S9896
	jsr S98a4
	ldy L996b
	jsr S9896
	cpx #$00
	bne L988d
	cmp #$03
	bcc L988f
L988d
	sec
	rts
	
L988f
	lda #$02
	jsr S98e6
	clc
	rts
	
S9896
	jsr S9a14
	cpy #$00
	beq L98a3
	clc
	adc #$01
	bcc L98a3
	inx
L98a3
	rts
	
S98a4
	pha
	lda L9973
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
	adc L996f
	sta L996f
	txa
	adc L996e
	sta L996e
	jmp L98e5
	
S98c6
	pha
	lda L9973
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
	adc L9971
	sta L9971
	txa
	adc L9970
	sta L9970
L98e5
	tya
S98e6
	clc
	adc $91f1
	sta $91f1
	txa
	adc $91f0
	sta $91f0
	tya
	rts
	
S98f6
	ldx #$05
	lda #$00
	tay
L98fb
	sta LTK_MiscWorkspace,y
	iny
	dex
	bne L98fb
	lda #$ff
L9904
	sta LTK_MiscWorkspace,y
	iny
	bne L9904
L990a
	sta $90e0,y
	iny
	bne L990a
	rts
	
S9911
	lda #$00
	sta L9972
	sta L9973
L9919
	inc L9973
	bne L9921
	inc L9972
L9921
	ldx L993d + 1
	ldy L993f + 1
	inx
	bne L992b
	iny
L992b
	jsr S9956
	bne L9934
	ldx #$00
	ldy #$00
L9934
	sty LTK_MiscWorkspace
	stx $8fe1
	lda LTK_Var_ActiveLU
L993d
	ldx #$00
L993f
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9948
	inc L993d + 1
	bne L9950
	inc L993f + 1
L9950
	jsr S9956
	bne L9919
	rts
	
S9956
	lda L9972
L9959
	cmp #$00
	bne L9962
	lda L9973
L9960
	cmp #$00
L9962
	rts
	
S9963
	lda #$79
L9965
	ldx #$99
	jsr S9a52
	rts
	
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
    .byte $00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00
L99a1
	php
	pha
	lda #$02
	clc
	jsr $9f00
	pla
	tax
	plp
	lda L9976
	sta LTK_Var_ActiveLU
	lda L9977
	sta LTK_Var_Active_User
	txa
	bit L9978
	bmi L99ec
	pha
L99bf
	lda #$00
	sta $3d
L99c3
	lda #$00
	sta $3e
	jsr S99ef
	jsr S99ef
	jsr S99f6
	jsr S9a02
	sta $4b
	sty $4c
	ldx #$c9
	ldy #$84
	sec
	jsr LTK_KernalTrapSetup
	pla
	tay
	lda #$00
	jsr LTK_KernalCall 
	jsr S9a08
	jmp LTK_SysRet_OldRegs 
	
L99ec
	jmp LTK_SysRet_AsIs  
	
S99ef
	jsr S99f6
	jsr S99fc
	rts
	
S99f6
	ldx #$80
	ldy #$03
	bne L9a0c
S99fc
	ldx #$ef
	ldy #$77
	bne L9a0c
S9a02
	ldx #$af
	ldy #$7a
	bne L9a0c
S9a08
	ldx #$fa
	ldy #$53
L9a0c
	sec
	jsr LTK_KernalTrapSetup
	jsr LTK_KernalCall 
	rts
	
S9a14
	sta L9a50
	stx L9a4f
	sty L9a51
	lda #$00
	ldx #$18
L9a21
	clc
	rol L9a50
	rol L9a4f
	rol L9a4e
	rol a
	bcs L9a33
	cmp L9a51
	bcc L9a43
L9a33
	sbc L9a51
	inc L9a50
	bne L9a43
	inc L9a4f
	bne L9a43
	inc L9a4e
L9a43
	dex
	bne L9a21
	tay
	ldx L9a4f
	lda L9a50
	rts
	
L9a4e
	.byte $00
L9a4f
	.byte $00
L9a50
	.byte $00
L9a51
	.byte $00
S9a52
	sta L9a63 + 1
	stx L9a63 + 2
	lda #$00
	sta L9acd
	sta L9ace
	sta L9acf
L9a63
	lda L9a63,y
	cmp #$30
	bcc L9abb
	cmp #$3a
	bcc L9a80
	ldx L9a8b + 1
	cpx #$0a
	beq L9abb
	cmp #$41
	bcc L9abb
	cmp #$47
	bcs L9abb
	sec
	sbc #$07
L9a80
	ldx L9acd
	beq L9aa4
	pha
	tya
	pha
	lda #$00
	tax
L9a8b
	ldy #$0a
L9a8d
	clc
	adc L9acf
	pha
	txa
	adc L9ace
	tax
	pla
	dey
	bne L9a8d
	sta L9acf
	stx L9ace
	pla
	tay
	pla
L9aa4
	inc L9acd
	sec
	sbc #$30
	clc
	adc L9acf
	sta L9acf
	bcc L9ab8
	inc L9ace
	beq L9ac5
L9ab8
	iny
	bne L9a63
L9abb
	cmp #$20
	beq L9ab8
	clc
	ldx L9acd
	bne L9ac6
L9ac5
	sec
L9ac6
	lda L9ace
	ldx L9acf
	rts
	
L9acd
	.byte $00
L9ace
	.byte $00
L9acf
	.byte $00

