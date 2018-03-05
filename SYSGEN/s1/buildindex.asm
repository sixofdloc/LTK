;buildindex.r.prg
	
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/sid_regs.asm"
	
	*=LTK_DOSOverlay ; LTK_DOSOverlay , $4000 for sysgen 
	
L95e0
	lda LTK_Var_ActiveLU
	sta $99a5
	lda LTK_Var_Active_User
	sta $99a6
	lda #$ff
	sta LTK_ReadChanFPTPtr
L95f1
	jsr LTK_ClearHeaderBlock 
	ldx #$e0
	ldy #$99
	jsr S995b
	bcs L95f1
	cpy #$01
	bne L9604
	jmp L9813
	
L9604
	sty $99a8
	lda #$00
	sta $99a7
	jsr S99a9
	bcc L9617
	cmp #$3a
	beq L9620
	bne L962f
L9617
	txa
	jsr LTK_SetLuActive 
	bcc L9620
	jmp L9826
	
L9620
	jsr S99a9
	bcs L962f
	cpx #$10
	bcc L962c
	jmp L982c
	
L962c
	stx LTK_Var_Active_User
L962f
	ldy $99a7
	ldx #$00
L9634
	cpy $99a8
	bcs L9647
	lda L99cf,y
	cmp #$0d
	beq L9647
	sta LTK_FileHeaderBlock ,x
	inx
	iny
	bne L9634
L9647
	lda #$02
	sec
	jsr $9f00
	bcc L9652
	jmp L9835
	
L9652
	jsr LTK_FindFile 
	bcs L9669
	ldx #$fd
	ldy #$99
L965b
	jsr LTK_Print 
	jsr S9c3e
	lda #$03
	jsr S9976
L9666
	jmp L95f1
	
L9669
	sta $99a3
	stx $999c
	sty $999b
	cpx #$ff
	bne L967c
	ldx #$17
	ldy #$9a
	bne L965b
L967c
	cmp #$00
	bne L968c
	txa
	bne L968c
	tya
	bne L968c
	ldx #$2e
	ldy #$9a
	bne L965b
L968c
	ldx #$3f
	ldy #$9a
	jsr S995b
	bcs L968c
	cpy #$01
	beq L9666
	jsr S9990
	sta $9224
	stx $9225
L96a2
	ldx #$52
	ldy #$9a
	jsr S995b
	bcs L96a2
	cpy #$01
	beq L968c
	jsr S9990
	tay
	bne L96a2
	txa
	beq L96a2
	cpx #$06
	bcs L96a2
	stx $9230
	lda #$00
	sta $99a2
	lda #$31
	sta $9a8a
L96c9
	ldx #$78
	ldy #$9a
	jsr S995b
	bcs L96c9
	cpy #$01
	beq L96a2
	jsr S9990
	tay
	bne L96c9
	txa
	beq L96c9
	cpx #$1f
	bcs L96c9
	ldy $99a2
	sta $9231,y
	iny
	sty $99a2
	inc $9a8a
	cpy $9230
	bne L96c9
	lda #$00
	sta $99a2
	sta $999d
	sta $999e
	sta $999f
	sta $99a0
L9706
	ldy $99a2
	lda $9231,y
	jsr S983d
	bcc L9718
	ldx #$9a
	ldy #$9a
	jmp L965b
	
L9718
	ldy $99a2
	lda L999a
	sta $9236,y
	iny
	sty $99a2
	cpy $9230
	bne L9706
	lda #$01
	ldx #$00
	jsr S98cd
	lda #$04
	sta $91f8
	jsr LTK_AllocContigBlks 
	bcc L974a
	cpx #$80
	bne L9743
	tax
	jmp L9832
	
L9743
	ldx #$c2
	ldy #$9a
	jmp L965b
	
L974a
	ldx #$f0
	ldy #$9a
	jsr LTK_Print 
	jsr S9c3e
	ldy $9200
	ldx $9201
	inx
	bne L975e
	iny
L975e
	lda #$00
	sta $99a2
	txa
L9764
	pha
	lda $99a2
	asl a
	tax
	tya
	sta $9202,x
	pla
	sta $9203,x
	clc
	adc #$02
	bcc L9778
	iny
L9778
	inc $99a2
	ldx $99a2
	cpx $9230
	bne L9764
	sta $920d
	sta $9925
	sty $920c
	sty $9927
	clc
	adc $999e
	sta $9219
	tya
	adc $999d
	sta $9218
	jsr S98dd
	lda $999e
	sta $9959
	lda $999d
	sta $9952
	jsr S98f8
	lda $9218
	sta $9927
	lda $9219
	sta $9925
	lda $999f
	sta $9952
	lda $99a0
	sta $9959
	jsr S98f8
	lda $9230
	asl a
	sta $99a2
	lda LTK_Var_ActiveLU
	ldx $9203
	ldy $9202
L97da
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01 ;$8fe0
L97e1
	inx
	bne L97e5
	iny
L97e5
	dec $99a2
	bne L97da
	lda $99a3
	pha
	ldx $999c
	ldy $999b
	lda #$24
	jsr LTK_ExeExtMiniSub 
	lda LTK_Var_ActiveLU
	ldx $9201
	ldy $9200
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L9809
	ldx #$2e
	ldy #$9b
	jsr LTK_Print 
	jsr S9c3e
L9813
	lda #$02
	clc
	jsr $9f00
	lda $99a5
	sta LTK_Var_ActiveLU
	lda $99a6
	sta LTK_Var_Active_User
	rts
	
L9826
	ldx #$4f
	ldy #$9b
	bne L9837
L982c
	ldx #$68
	ldy #$9b
	bne L9837
L9832
	ldy #$04
	.byte $2c 
L9835
	ldy #$05
L9837
	jsr LTK_ErrorHandler 
	jmp L9813
	
S983d
	clc
	adc #$02
	tay
	lda #$00
	sta L9bbc
	lda #$fb
	ldx #$01
	jsr S9b82
	sta L999a
	tay
	lda $9225
	ldx $9224
	jsr S987d
	jsr S98ad
	ldy L999a
	jsr S987d
	jsr S988b
	ldy L999a
	jsr S987d
	cpx #$00
	bne L9874
	cmp #$03
	bcc L9876
L9874
	sec
	rts
	
L9876
	lda #$02
	jsr S98cd
	clc
	rts
	
S987d
	jsr S9b82
	cpy #$00
	beq L988a
	clc
	adc #$01
	bcc L988a
	inx
L988a
	rts
	
S988b
	pha
	lda $99a2
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
	adc $999e
	sta $999e
	txa
	adc $999d
	sta $999d
	jmp L98cc
	
S98ad
	pha
	lda $99a2
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
	adc $99a0
	sta $99a0
	txa
	adc $999f
	sta $999f
L98cc
	tya
S98cd
	clc
	adc $91f1
	sta $91f1
	txa
	adc $91f0
	sta $91f0
	tya
	rts
	
S98dd
	ldx #$05
	lda #$00
	tay
L98e2
	sta LTK_MiscWorkspace,y
	iny
	dex
	bne L98e2
	lda #$ff
L98eb
	sta LTK_MiscWorkspace,y
	iny
	bne L98eb
L98f1
	sta $90e0,y
	iny
	bne L98f1
	rts
	
S98f8
	lda #$00
	sta $99a1
	sta $99a2
L9900
	inc $99a2
	bne L9908
	inc $99a1
L9908
	ldx $9925
	ldy $9927
	inx
	bne L9912
	iny
L9912
	jsr S994e
	bne L991b
	ldx #$00
	ldy #$00
L991b
	sty LTK_MiscWorkspace
	stx $8fe1
	lda LTK_Var_ActiveLU
	ldx #$00
	ldy #$00
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01  ;$8fe0 
L992f
	dec $99a4
	bne L9940
	ldx #$80
	ldy #$9b
	jsr LTK_Print 
	lda #$40
	sta $99a4
L9940
	inc $9925
	bne L9948
	inc $9927
L9948
	jsr S994e
	bne L9900
	rts
	
S994e
	lda $99a1
	cmp #$00
	bne L995a
	lda $99a2
	cmp #$00
L995a
	rts
	
S995b
	jsr LTK_Print 
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$00
L9965
	jsr LTK_KernalCall 
	sta L99cf,y
	iny
	cpy #$11
	bcs L9975
	cmp #$0d
	bne L9965
	clc
L9975
	rts
	
S9976
	sta L998f
L9979
	lda #$00
	tax
	ldy #$02
L997e
	sec
	adc #$00
	bne L997e
	inx
	bne L997e
	dey
	bne L997e
	dec L998f
	bne L9979
	rts
	
L998f
	.byte $00
S9990
	ldy #$00
	lda #$cf
	ldx #$99
	jsr S9bc0
	rts
	
L999a
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00 
S99a9
	ldy $99a7
	lda #$cf
	ldx #$99
	cpy $99a8
	bcs L99cd
	jsr S9bc0
	php
	bcs L99bf
	pha
	pla
	bne L99cc
L99bf
	lda L99cf,y
	cmp #$3a
	bne L99cc
	iny
	sty $99a7
	plp
	rts
	
L99cc
	plp
L99cd
	sec
	rts
	
L99cf			
	.byte $00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
L99e0
	.text "{clr}{return}filename (<cr> to exit) ? "
	.byte $00
L99fd
	.text "{return}{return}file already exists !!{return}"
	.byte $00
L9a17
	.text "{return}{return}illegal filename !!{return}"
	.byte $00
L9a2e
	.text "{return}{return}index full !!{return}"
	.byte $00
L9a3f
	.text "{return}number of keys ? "
	.byte $00
L9a52
	.text "{return}number of key directories (5 max) ? "
	.byte $00
L9a78
	.text "{return}length of key {rvs on} #"
	.byte $00
L9a8b
	.text " {rvs off} (30 max) ? "
	.byte $00
L9a9a
	.text "{return}{return}too many keys - cannot build file !!{return}"
	.byte $00
L9ac2
	.text "{return}{return}not enough {rvs on}contiguous{rvs off} blocks available !{return}"
	.byte $00 
L9af0
	.text "{return}{return}{return}please do not disturb  -  keyfile under construction !!!{return}{return}"
	.byte $00
L9b2e
	.text "{return}{return}keyfile structure complete !!{return}"
	.byte $00
L9b4f
	.text "invalid logical unit !!{return}"
	.byte $00
L9b68
	.text "invalid user number !!{return}"
	.byte $00
L9b80
	.byte $2e,$00 
S9b82
	sta $9bbe
	stx $9bbd
	sty $9bbf
	lda #$00
	ldx #$18
L9b8f
	clc
	rol $9bbe
	rol $9bbd
	rol L9bbc
	rol a
	bcs L9ba1
	cmp $9bbf
	bcc L9bb1
L9ba1
	sbc $9bbf
	inc $9bbe
	bne L9bb1
	inc $9bbd
	bne L9bb1
	inc L9bbc
L9bb1
	dex
	bne L9b8f
	tay
	ldx $9bbd
	lda $9bbe
	rts
	
L9bbc
	.byte $00,$00,$00,$00 
S9bc0
	sta L9bd1 + 1
	stx L9bd1 + 2
	lda #$00
	sta L9c3b
	sta $9c3c
	sta $9c3d
L9bd1
	lda L9bd1,y
	cmp #$30
	bcc L9c29
	cmp #$3a
	bcc L9bee
	ldx $9bfa
	cpx #$0a
	beq L9c29
	cmp #$41
	bcc L9c29
	cmp #$47
	bcs L9c29
	sec
	sbc #$07
L9bee
	ldx L9c3b
	beq L9c12
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9bfb
	clc
	adc $9c3d
	pha
	txa
	adc $9c3c
	tax
	pla
	dey
	bne L9bfb
	sta $9c3d
	stx $9c3c
	pla
	tay
	pla
L9c12
	inc L9c3b
	sec
	sbc #$30
	clc
	adc $9c3d
	sta $9c3d
	bcc L9c26
	inc $9c3c
	beq L9c33
L9c26
	iny
	bne L9bd1
L9c29
	cmp #$20
	beq L9c26
	clc
	ldx L9c3b
	bne L9c34
L9c33
	sec
L9c34
	lda $9c3c
	ldx $9c3d
	rts
	
L9c3b
	.byte $00,$00,$00 
S9c3e
	lda LTK_BeepOnErrorFlag
	beq L9c7d
	ldy #$18
	lda #$00
L9c47
	sta SID_V1_FreqLo,y
	dey
	bpl L9c47
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L9c59
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S9c7e
	iny
	tya
	cmp #$10
	bne L9c59
	ldx #$50
	jsr S9c7e
	ldy #$10
	sta SID_V1_Control
L9c71
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr S9c7e
	tya
	bne L9c71
L9c7d
	rts
	
S9c7e
	dec L9c87
	bne S9c7e
	dex
	bne S9c7e
	rts
	
L9c87
	.byte $00
