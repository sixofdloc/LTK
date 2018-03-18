;di.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay   ;$95e0, $4000 for sysgen
L95e0
	lda #$ff
	sta LTK_ReadChanFPTPtr
	lda #$16
	ldx LTK_Var_CPUMode
	beq L95f1
	ldx $d7
	beq L95f1
	asl a
L95f1
	sta L9a26
	sta $9800
	lda LTK_Var_ActiveLU
	sta L9a21
	lda LTK_Var_Active_User
	sta L9a22
	lda $31
	pha
	lda $32
	pha
	jsr LTK_GetPortNumber
	clc
	adc #$9e
	tax
	lda #$02
	adc #$00
	tay
	lda #$0a
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;$91e0 
L961e
	ldx $91f0
	ldy $91f2
	bit LTK_Var_CPUMode
	bpl L962f
	ldx $91f1
	ldy $91f3
L962f
	stx L9a1d
	sty L9a1e
L9635
	jsr LTK_ClearHeaderBlock 
	ldx #$6c
	ldy #$9a
	jsr S98b3
	bcs L9635
	tya
	bne L9647
	jmp L984e
	
L9647
	ldy #$00
	sty L9a1f
	sta L9a23
	jsr S99d5
	bcc L965a
	cmp #$3a
	beq L9663
	bne L9672
L965a
	txa
	jsr LTK_SetLuActive 
	bcc L9663
	jmp L968e
	
L9663
	jsr S99d5
	bcs L9672
	cpx #$10
	bcc L966f
	jmp L9694
	
L966f
	stx LTK_Var_Active_User
L9672
	ldy L9a1f
	ldx #$00
L9677
	lda L99fb,y
	sta LTK_FileHeaderBlock ,x
	beq L9683
	inx
	iny
	bne L9677
L9683
	jsr LTK_FindFile 
	bcc L969a
	ldx #$8c
	ldy #$9a
	bne L96a5
L968e
	ldx #$37
	ldy #$9a
	bne L96a5
L9694
	ldx #$52
	ldy #$9a
	bne L96a5
L969a
	lda $91f8
	cmp #$04
	beq L96ab
	ldx #$a1
	ldy #$9a
L96a5
	jsr LTK_Print 
	jmp L984e
	
L96ab
	ldx #$bd
	ldy #$9a
	jsr S98b3
	bcs L96ab
	lda L99fb
	sec
	sbc #$30
	bne L96bf
	jmp L9635
	
L96bf
	tax
	dex
	cpx $9230
	bcc L96cc
	ldx #$dc
	ldy #$9a
	bne L96a5
L96cc
	stx L9a20
L96cf
	ldx #$fb
	ldy #$9a
	jsr S98b3
	bcs L96cf
L96d8
	ldx #$16
	ldy #$9b
	jsr LTK_Print 
	ldy #$10
	jsr LTK_KernalTrapRemove
L96e4
	jsr LTK_KernalCall 
	tax
	beq L96e4
	cmp #$53
	beq L96f5
	cmp #$50
	bne L96d8
	dec L9a1c
L96f5
	ldy L9a20
	lda $9231,y
	sta L9a1a
	tax
	inx
	inx
	stx L9a1b
	jsr S99ad
	clc
	jsr S9861
	lda $8de4
	bne L9716
	jsr S99ad
	jmp L984e
	
L9716
	ldx #$e5
	ldy #$8d
	sta $8fe4
	jsr S9885
	ldy L9a1a
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	jsr S987a
	jsr S99ad
	ldx #$e5
	ldy #$8f
	jsr S9885
	ldy L9a1a
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	jsr S987a
	ldx #$e5
	ldy #$8f
	jsr S9885
	php
	lda L9a1c
	beq L9758
	jsr S992f
L9758
	jsr S98d8
	plp
	bcc L9773
	jmp L9829
	
L9761
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L976b
	lda #$e5
	sta $31
	lda #$8f
	sta $32
L9773
	ldy #$0c
	jsr LTK_KernalTrapRemove
	ldy #$00
L977a
	lda ($31),y
	beq L9787
	jsr LTK_KernalCall 
	iny
	cpy L9a1a
	bne L977a
L9787
	lda #$2e
	jsr LTK_KernalCall 
	iny
	cpy #$22
	bne L9787
	ldy L9a1a
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	lda #$00
	sec
	jsr S9bf5
	ldx #$88
	ldy #$9c
	jsr LTK_Print 
	lda L9a1c
	bne L97b8
	lda LTK_Var_CPUMode
	beq L97c8
	lda $d7
	beq L97c8
L97b8
	lda L9a25
	lsr a
	bcs L97c8
	lda #$20
	ldx #$02
	jsr S9911
	jmp L97cb
	
L97c8
	jsr S9927
L97cb
	inc L9a25
	bne L97d3
	inc L9a24
L97d3
	ldy #$10
	jsr LTK_KernalTrapRemove
	jsr LTK_KernalCall 
	cmp #$03
	beq L9829
	lda L9a1c
	bne L9807
	dec L9a26
	bne L9807
	ldx #$30
	ldy #$9b
	jsr LTK_Print 
	ldy #$10
	jsr LTK_KernalTrapRemove
L97f5
	jsr LTK_KernalCall 
	tax
	beq L97f5
	cmp #$03
	beq L984e
	lda #$16
	sta L9a26
	jsr S98d8
L9807
	lda $31
	clc
	adc L9a1b
	sta $31
	bcc L9813
	inc $32
L9813
	dec $8fe4
	beq L981b
	jmp L9773
	
L981b
	ldy LTK_MiscWorkspace
	ldx $8fe1
	bne L9826
	tya
	beq L9829
L9826
	jmp L9761
	
L9829
	ldx #$56
	ldy #$9b
	jsr LTK_Print 
	lda #$00
	ldx L9a25
	ldy L9a24
	sec
	jsr S9bf5
	ldx #$88
	ldy #$9c
	jsr LTK_Print 
	jsr S9927
	lda L9a1c
	beq L984e
	jsr S9985
L984e
	pla
	sta $32
	pla
	sta $31
	lda L9a21
	sta LTK_Var_ActiveLU
	lda L9a22
	sta LTK_Var_Active_User
	rts
	
S9861
	php
	lda L9a20
	asl a
	tax
	lda $9202,x
	tay
	lda $9203,x
	tax
	lda LTK_Var_ActiveLU
	plp
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileWriteBuffer,>LTK_FileWriteBuffer,$02; $8de0 
L9879
	rts
	
S987a
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L9884
	rts
	
S9885
	stx $31
	sty $32
L9889
	ldy #$00
L988b
	lda ($31),y
	cmp L99fb,y
	bne L989a
	iny
	cpy L9a1a
	bne L988b
	beq L98af
L989a
	bcs L98af
	dec $8fe4
	beq L98b1
	lda L9a1b
	clc
	adc $31
	sta $31
	bcc L9889
	inc $32
	bne L9889
L98af
	clc
	rts
	
L98b1
	sec
	rts
	
S98b3
	jsr LTK_Print 
	ldy #$0a
	jsr LTK_KernalTrapRemove
	ldy #$1d
	lda #$00
L98bf
	sta L99fb,y
	dey
	bpl L98bf
	iny
L98c6
	jsr LTK_KernalCall 
	cmp #$0d
	beq L98d6
	sta L99fb,y
	iny
	cpy #$1f
	bcc L98c6
	rts
	
L98d6
	clc
	rts
	
S98d8
	jsr S98fb
	lda L9a1c
	bne L98e9
	lda LTK_Var_CPUMode
	beq L98f7
	lda $d7
	beq L98f7
L98e9
	lda #$20
	ldx #$02
	jsr S9911
	ldx #$2b
	ldy #$9a
	jsr S98ff
L98f7
	jsr S9927
	rts
	
S98fb
	ldx #$29
	ldy #$9a
S98ff
	jsr LTK_Print 
	lda #$20
	ldx #$1d
	jsr S9911
	ldx #$2f
	ldy #$9a
	jsr LTK_Print 
	rts
	
S9911
	sta $9925
	stx $9924
L9917
	ldx #$25
	ldy #$99
	jsr LTK_Print 
	dec $9924
	bne L9917
	rts
	
	.byte $00,$00,$00 
S9927
	ldx #$27
	ldy #$9a
	jsr LTK_Print 
	rts
	
S992f
	ldy #$12
	jsr S997c
	ldx #$00
	stx $b7
	inx
	stx $b8
	lda L9a1d
	sta $ba
	lda L9a1e
	ora #$60
	sta $b9
	ldy #$00
	jsr S997c
S994c
	bit LTK_Var_CPUMode
	bpl L9956
	ldx #$60
	stx $f140
L9956
	ldy #$06
	lda #$01
	jsr S997c
	bit LTK_Var_CPUMode
	bpl L9967
	ldx #$4c
	stx $f140
L9967
	lda $9a
	cmp L9a1d
	beq L9973
	inc L9a1c
	beq L999f
L9973
	lda #$0d
	sta L9a29
	sta L9a29 + 1
	rts
	
S997c
	pha
	jsr LTK_KernalTrapRemove
	pla
	tax
	jmp LTK_KernalCall 
	
S9985
	bit L9a1c
	bpl L999f
	jsr S994c
	ldx #$ab
	ldy #$99
	jsr LTK_Print 
	ldy #$02
	jsr LTK_KernalTrapRemove
	lda #$01
	clc
	jsr LTK_KernalCall 
L999f
	lda #$03
	sta $9a
	lda #$00
	sta $99
	sta $90
	sec
	rts
	
L99ab
	.text " "
	.byte $00
S99ad
	ldy #$00
L99af
	lda LTK_FileWriteBuffer ,y
	tax
	lda LTK_MiniSubExeArea ,y
	sta LTK_FileWriteBuffer ,y
	txa
	sta LTK_MiniSubExeArea ,y
	iny
	bne L99af
L99c0
	lda $8ee0,y
	tax
	lda $94e0,y
	sta $8ee0,y
	txa
	sta $94e0,y
	iny
	bne L99c0
	sty LTK_BLKAddr_MiniSub
	rts
	
S99d5
	ldy L9a1f
	lda #$fb
	ldx #$99
	cpy L9a23
	bcs L99f9
	jsr S9b77
	php
	bcs L99eb
	pha
	pla
	bne L99f8
L99eb
	lda L99fb,y
	cmp #$3a
	bne L99f8
	iny
	sty L9a1f
	plp
	rts
	
L99f8
	plp
L99f9
	sec
	rts
	
L99fb		        
	.byte $00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
L9a1a
	.byte $00
L9a1b
	.byte $00
L9a1c
	.byte $00
L9a1d
	.byte $00
L9a1e
	.byte $00
L9a1f
	.byte $00
L9a20
	.byte $00
L9a21
	.byte $00
L9a22
	.byte $00
L9a23
	.byte $00
L9a24
	.byte $00
L9a25
	.byte $00
L9a26
	.byte $16 
L9a27
	.text "{Return}"
	.byte $00
L9a29
	.text "{Clr}{Rvs On}key"
	.byte $00
L9a2f
	.text "pointer"
	.byte $00
L9a37
	.text "{return}{rvs on}invalid logical unit !!{return}"
	.byte $00
L9a52
	.text "{return}{rvs on}invalid user number !!{return}"
	.byte $00
L9a6c
	.text "{clr}{return}name of keyfile (c/r=exit) ? "
	.byte $00
L9a8c
	.text "{return}{rvs on}file not found !!{return}"
	.byte $00
L9aa1
	.text "{return}{rvs on}file is not a keyfile !!{return}"
	.byte $00
L9abd
	.text "{return}enter directory number (1-5) "
	.byte $00
L9adc
	.text "{return}{rvs on}invalid directory number !!{return}"
	.byte $00
L9afb
	.text "{return}starting key (c/r=first) "
	.byte $00
L9b16
	.text "{return}{rvs on}p{rvs off}rinter or {rvs on}s{rvs off}creen ? "
	.byte $00 
L9b30
	.text "{return}{rvs on}press any key to continue (or stop)"
	.byte $00
L9b56
	.text "{return}{return}total number of keys listed..."
	.byte $00
S9b77
	sta L9b88 + 1
	stx L9b88 + 2
	lda #$00
	sta L9bf2
	sta L9bf3
	sta L9bf4
L9b88
	lda L9b88,y
	cmp #$30
	bcc L9be0
	cmp #$3a
	bcc L9ba5
	ldx $9bb1
	cpx #$0a
	beq L9be0
	cmp #$41
	bcc L9be0
	cmp #$47
	bcs L9be0
	sec
	sbc #$07
L9ba5
	ldx L9bf2
	beq L9bc9
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9bb2
	clc
	adc L9bf4
	pha
	txa
	adc L9bf3
	tax
	pla
	dey
	bne L9bb2
	sta L9bf4
	stx L9bf3
	pla
	tay
	pla
L9bc9
	inc L9bf2
	sec
	sbc #$30
	clc
	adc L9bf4
	sta L9bf4
	bcc L9bdd
	inc L9bf3
	beq L9bea
L9bdd
	iny
	bne L9b88
L9be0
	cmp #$20
	beq L9bdd
	clc
	ldx L9bf2
	bne L9beb
L9bea
	sec
L9beb
	lda L9bf3
	ldx L9bf4
	rts
	
L9bf2
	.byte $00
L9bf3
	.byte $00
L9bf4
	.byte $00
S9bf5
	stx L9c87
	sty L9c86
	php
	pha
	lda #$30
	ldy #$04
L9c01
	sta L9c88,y
	dey
	bpl L9c01
	pla
	beq L9c25
	lda L9c87
	jsr S9c71
	sta L9c8b
	stx L9c8c
	lda L9c86
	jsr S9c71
	sta L9c89
	stx L9c8a
	jmp L9c5a
	
L9c25
	iny
L9c26
	lda L9c86
	cmp L9c8e,y
	bcc L9c55
	bne L9c38
	lda L9c87
	cmp L9c93,y
	bcc L9c55
L9c38
	lda L9c87
	sbc L9c93,y
	sta L9c87
	lda L9c86
	sbc L9c8e,y
	sta L9c86
	lda L9c88,y
	clc
	adc #$01
	sta L9c88,y
	bne L9c26
L9c55
	iny
	cpy #$05
	bne L9c26
L9c5a
	plp
	bcc L9c70
	ldy #$00
L9c5f
	lda L9c88,y
	cmp #$30
	bne L9c70
	lda #$20
	sta L9c88,y
	iny
	cpy #$04
	bne L9c5f
L9c70
	rts
	
S9c71
	pha
	and #$0f
	jsr S9c7d
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
S9c7d
	cmp #$0a
	bcc L9c83
	adc #$06
L9c83
	adc #$30
	rts
	
L9c86
	.byte $ff 
L9c87
	.byte $ff 
L9c88
	.byte $00
L9c89
	.byte $00
L9c8a
	.byte $00
L9c8b
	.byte $00
L9c8c
	.byte $00
L9c8d
	.byte $00
L9c8e
	.byte $27 
L9c8f
	.byte $03 
L9c90
	.byte $00
L9c91
	.byte $00
L9c92
	.byte $00
L9c93
	.byte $10 
L9c94
	.byte $e8 
L9c95
	.byte $64 
L9c96
	.byte $0a 
L9c97
	.byte $01 
