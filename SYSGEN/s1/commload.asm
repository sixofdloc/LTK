;commload.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	
	*=LTK_DOSOverlay ;$95e0, $4000 for sysgen

L95e0
	jsr LTK_ClearHeaderBlock 
	lda LTK_Var_ActiveLU
	sta L96e4
	lda LTK_Var_Active_User
	sta L96e5
	ldy $b7
	bne L95f6
L95f3
	jmp LTK_SysRet_LKRT_OldRegs 
	
L95f6
	cpy #$1e
	bcs L95f3
	lda $31
	pha
	lda $32
	pha
	lda $bb
	sta $31
	lda $bc
	sta $32
	dey
L9609
	lda LTK_Var_CPUMode
	bne L9614
	jsr $fc6e
	jmp L9627
	
L9614
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
L9627
	sta L96e7,y
	dey
	bpl L9609
	pla
	sta $32
	pla
	sta $31
	ldy #$00
	sty L96e6
	jsr S9705
	bcc L9643
	cmp #$3a
	beq L9649
	bne L9655
L9643
	txa
	jsr LTK_SetLuActive 
	bcs L967b
L9649
	jsr S9705
	bcs L9655
	cpx #$10
	bcs L967b
	stx LTK_Var_Active_User
L9655
	ldy L96e6
	ldx #$00
L965a
	cpy $b7
	bcs L9668
	lda L96e7,y
	sta LTK_FileHeaderBlock ,x
	inx
	iny
	bne L965a
L9668
	jsr LTK_FindFile 
	php
	lda L96e4
	sta LTK_Var_ActiveLU
	lda L96e5
	sta LTK_Var_Active_User
	plp
	bcc L96a1
L967b
	ldy #$3e
	lda L96e4
	sta LTK_Var_ActiveLU
L9683
	jsr LTK_ErrorHandler 
L9686
	bit $9e44
	bpl L96da
	lda #$00
	sta $90
	lda LTK_HD_DevNum
	jsr LISTEN
	lda #$ff
	jsr SECOND
	bit $90
	bmi L96da
	jmp LTK_SysRet_LKRT_OldRegs 
	
L96a1
	lda $91f8
	cmp #$0b
	beq L96b0
	cmp #$0c
	beq L96b0
	ldy #$21
	bne L9683
L96b0
	cmp #$0a
	bcs L96ba
	jsr LTK_LoadContigFile 
	jmp L96bd
	
L96ba
	jsr LTK_LoadRandFile 
L96bd
	bcs L9686
	txa
	pha
	tya
	pha
	ldy #$00
	jsr LTK_ErrorHandler 
	pla
	tay
	pla
	tax
	lda #$00
	sta $91
	sta $b9
	lda #$40
	sta $90
	clc
	jmp LTK_SysRet_AsIs  
	
L96da
	lda #$42
	sta $90
	lda #$04
	sec
	jmp LTK_SysRet_AsIs  
	
L96e4
	.byte $00
L96e5
	.byte $00
L96e6
	.byte $00
L96e7	
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00 
S9705
	ldy L96e6
	lda #$e7
	ldx #$96
	cpy $b7
	bcs L9728
	jsr S972a
	php
	bcs L971a
	pha
	pla
	bne L9727
L971a
	lda L96e7,y
	cmp #$3a
	bne L9727
	iny
	sty L96e6
	plp
	rts
	
L9727
	plp
L9728
	sec
	rts
	
S972a
	sta L973b + 1
	stx L973b + 2
	lda #$00
	sta L97a5
	sta L97a6
	sta L97a7
L973b
	lda L973b,y
	cmp #$30
	bcc L9793
	cmp #$3a
	bcc L9758
	ldx $9764
	cpx #$0a
	beq L9793
	cmp #$41
	bcc L9793
	cmp #$47
	bcs L9793
	sec
	sbc #$07
L9758
	ldx L97a5
	beq L977c
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9765
	clc
	adc L97a7
	pha
	txa
	adc L97a6
	tax
	pla
	dey
	bne L9765
	sta L97a7
	stx L97a6
	pla
	tay
	pla
L977c
	inc L97a5
	sec
	sbc #$30
	clc
	adc L97a7
	sta L97a7
	bcc L9790
	inc L97a6
	beq L979d
L9790
	iny
	bne L973b
L9793
	cmp #$20
	beq L9790
	clc
	ldx L97a5
	bne L979e
L979d
	sec
L979e
	lda L97a6
	ldx L97a7
	rts
	
L97a5
	.byte $00
L97a6
	.byte $00
L97a7
	.byte $00
