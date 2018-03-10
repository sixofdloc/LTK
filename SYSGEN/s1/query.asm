;query.r.prg
	
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_DOSOverlay  ;$95e0, $4000 for sysgen
 
L95e0
	sta L9957
	ldx $c8
	lda LTK_Var_CPUMode
	beq L95ec
	ldx $ea
L95ec
	stx L9b4f
	lda LTK_Var_ActiveLU
	sta L9958
	lda LTK_Var_Active_User
	sta L9959
	lda #$ff
	sta LTK_ReadChanFPTPtr
	jsr LTK_ClearHeaderBlock 
	ldy L9957
	cpy L9b4f
	bcc L960e
	jmp L97f2
	
L960e
	iny
	cpy L9b4f
	bcc L9617
	jmp L97f2
	
L9617
	lda LTK_Command_Buffer,y
	cmp #$22
	bne L961f
	iny
L961f
	ldx L9b4f
	lda $01ff,x
	cmp #$22
	bne L962c
	dec L9b4f
L962c
	cpy L9b4f
	bcc L9634
	jmp L97f2
	
L9634
	sty L9957
	jsr S9931
	bcc L9642
	cmp #$3a
	beq L964b
	bne L965a
L9642
	txa
	jsr LTK_SetLuActive 
	bcc L964b
	jmp L97e6
	
L964b
	jsr S9931
	bcs L965a
	cpx #$10
	bcc L9657
	jmp L97ec
	
L9657
	stx LTK_Var_Active_User
L965a
	ldy L9957
	ldx #$00
L965f
	cpy L9b4f
	bcs L966e
	lda LTK_Command_Buffer,y
	sta LTK_FileHeaderBlock ,x
	inx
	iny
	bne L965f
L966e
	jsr LTK_FindFile 
	bcc L9676
	jmp L97f8
	
L9676
	jsr S98df
	ldx #$b2
	ldy #$99
	jsr LTK_Print 
	lda $91f8
	ldx #$ba
	ldy #$99
	cmp #$01
	beq L96d6
	ldx #$cb
	ldy #$99
	cmp #$02
	beq L96d6
	ldx #$da
	ldy #$99
	cmp #$03
	beq L96d6
	ldx #$e9
	ldy #$99
	cmp #$0b
	beq L96d6
	ldx #$f8
	ldy #$99
	cmp #$0c
	beq L96d6
	ldx #$07
	ldy #$9a
	cmp #$0d
	beq L96d6
	ldx #$18
	ldy #$9a
	cmp #$0e
	beq L96d6
	ldx #$23
	ldy #$9a
	cmp #$0f
	beq L96d6
	ldx #$96
	ldy #$9a
	cmp #$04
	beq L96d6
	ldx #$a8
	ldy #$9a
	cmp #$05
	beq L96d6
	jmp L9801
	
L96d6
	jsr LTK_Print 
	ldx #$32
	ldy #$9a
	jsr LTK_Print 
	ldy $91f0
	ldx $91f1
	lda #$00
	jsr S991b
	ldx #$61
	ldy #$9c
	jsr LTK_Print 
	ldx #$3e
	ldy #$9a
	jsr LTK_Print 
	lda $91fd
	lsr a
	lsr a
	lsr a
	lsr a
	tax
	lda #$00
	tay
	jsr S991e
	ldx #$64
	ldy #$9c
	jsr LTK_Print 
	ldx #$3e
	ldy #$9b
	jsr LTK_Print 
	lda $91f8
	cmp #$01
	beq L9744
	cmp #$02
	beq L9744
	cmp #$03
	beq L9744
	ldx #$50
	ldy #$9a
	jsr LTK_Print 
	ldy $9200
	ldx $9201
	lda #$ff
	jsr S991b
	ldx #$62
	ldy #$9c
	jsr LTK_Print 
	ldx #$46
	ldy #$9b
	jsr LTK_Print 
L9744
	lda $91f8
	cmp #$0b
	beq L9753
	cmp #$05
	beq L9753
	cmp #$0c
	bne L978c
L9753
	ldy $91fa
	ldx $91fb
	lda #$ff
	jsr S991b
	ldx #$5e
	ldy #$9a
	jsr LTK_Print 
	ldx #$62
	ldy #$9c
	jsr LTK_Print 
	ldx $91fb
	ldy $91fa
	lda #$00
	jsr S991b
	ldx #$40
	ldy #$9b
	jsr LTK_Print 
	ldx #$61
	ldy #$9c
	jsr LTK_Print 
	ldx #$42
	ldy #$9b
	jsr LTK_Print 
L978c
	ldx #$3e
	ldy #$9b
	jsr LTK_Print 
	lda $91f8
	cmp #$04
	beq L9815
	cmp #$05
	beq L97a2
	cmp #$0f
	bne L97db
L97a2
	ldx #$6b
	ldy #$9a
	jsr LTK_Print 
	ldy $91f6
	ldx $91f7
	lda #$00
	jsr S991b
	ldx #$61
	ldy #$9c
	jsr LTK_Print 
	ldx #$7f
	ldy #$9a
	jsr LTK_Print 
	ldy $91f4
	ldx $91f5
	lda #$00
	jsr S991b
	ldx #$61
	ldy #$9c
	jsr LTK_Print 
	ldx #$8e
	ldy #$9a
	jsr LTK_Print 
L97db
	ldx #$3e
	ldy #$9b
	jsr LTK_Print 
	ldy #$00
	beq L9805
L97e6
	ldx #$99
	ldy #$99
	bne L9805
L97ec
	ldx #$25
	ldy #$9b
	bne L9805
L97f2
	ldx #$83
	ldy #$99
	bne L9805
L97f8
	jsr S98df
	ldx #$70
	ldy #$99
	bne L9805
L9801
	ldx #$5a
	ldy #$99
L9805
	jsr LTK_ErrorHandler 
	lda L9958
	sta LTK_Var_ActiveLU
	lda L9959
	sta LTK_Var_Active_User
	rts
	
L9815
	ldx #$be
	ldy #$9a
	jsr LTK_Print 
	ldx $9230
	lda #$00
	tay
	jsr S991b
	ldx #$65
	ldy #$9c
	jsr LTK_Print 
	ldx #$ce
	ldy #$9a
	jsr LTK_Print 
	ldy $9224
	ldx $9225
	lda #$00
	jsr S991b
	ldx #$61
	ldy #$9c
	jsr LTK_Print 
	ldx #$f5
	ldy #$9a
	jsr LTK_Print 
	lda #$2d
	ldx #$21
	jsr S98c6
	ldx #$3e
	ldy #$9b
	jsr LTK_Print 
	lda #$00
	sta L98dc
	lda #$31
	sta L98dd
L9864
	lda #$20
	ldx #$02
	jsr S98c6
	ldx #$dd
	ldy #$98
	jsr LTK_Print 
	lda #$20
	ldx #$07
	jsr S98c6
	ldy L98dc
	lda $9231,y
	tax
	lda #$00
	tay
	jsr S991b
	ldx #$64
	ldy #$9c
	jsr LTK_Print 
	lda #$20
	ldx #$09
	jsr S98c6
	lda L98dc
	asl a
	tay
	lda $9227,y
	tax
	lda $9226,y
	tay
	lda #$00
	jsr S991b
	ldx #$61
	ldy #$9c
	jsr LTK_Print 
	ldx #$3e
	ldy #$9b
	jsr LTK_Print 
	inc L98dd
	ldx L98dc
	inx
	stx L98dc
	cpx $9230
	bne L9864
	jmp L97db
	
S98c6
	sta L98d9
	stx L98db
L98cc
	ldx #$d9
	ldy #$98
	jsr LTK_Print 
	dec L98db
	bne L98cc
	rts
	
L98d9
	.byte $00
L98da
	.byte $00
L98db
	.byte $00
L98dc
	.byte $00
L98dd
	.byte $31 
L98de
	.byte $00
S98df
	ldx #$3d
	ldy #$9b
	jsr LTK_Print 
	ldx #$44
	ldy #$9b
	jsr LTK_Print 
	lda LTK_Var_ActiveLU
	jsr S9923
	stx L9b48
	sta L9b49
	lda LTK_Var_Active_User
	jsr S9923
	stx $9b4b
	sta L9b4c
	ldx #$48
	ldy #$9b
	jsr LTK_Print 
	ldx #$e0
	ldy #$91
	jsr LTK_Print 
	ldx #$46
	ldy #$9b
	jsr LTK_Print 
	rts
	
S991b
	sec
	bcs L991f
S991e
	clc
L991f
	jsr S9bce
	rts
	
S9923
	ldx #$30
L9925
	cmp #$0a
	bcc L992e
	sbc #$0a
	inx
	bne L9925
L992e
	adc #$30
	rts
	
S9931
	ldy L9957
	lda #$00
	ldx #$02
	cpy L9b4f
	bcs L9955
	jsr S9b50
	php
	bcs L9947
	pha
	pla
	bne L9954
L9947
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L9954
	iny
	sty L9957
	plp
	rts
	
L9954
	plp
L9955
	sec
	rts
	
L9957
	.byte $00
L9958
	.byte $00
L9959
	.byte $00
L995a
	.text "invalid file type !!{return}"
	.byte $00 
L9970
	.text " does not exist !!"
	.byte $00
L9983
	.text "no filename given !!{return}"
	.byte $00
L9999
	.text "invalid logical unit !!{return}"
	.byte $00
L99b2
	.text " is a {rvs on}"
	.byte $00
L99ba
	.text "dos system file{return}"
	.byte $00
L99cb
	.text "dos processor{return}"
	.byte $00
L99da
	.text "dos processor{return}"
	.byte $00
L99e9
	.text "basic program{return}"
	.byte $00
L99f8
	.text "m. l. program{return}"
	.byte $00
L9a07
	.text "sequential file{return}"
	.byte $00
L9a18
	.text "user file{return}"
	.byte $00
L9a23
	.text "relative file{return}"
	.byte $00
L9a32
	.text "file size {rvs on}"
	.byte $00
L9a3e
	.text "{rvs off} blocks   user {rvs on}"
	.byte $00 
L9a50
	.text "header adr. {rvs on}"
	.byte $00
L9a5e
	.text " load adr. {rvs on}"
	.byte $00
L9a6b
	.text "number of records {rvs on}"
	.byte $00
L9a7f
	.text "{return}record size {rvs on}"
	.byte $00
L9a8e
	.text "{rvs off} bytes"
	.byte $00
L9a96
	.text "keyed index file{return}"
	.byte $00
L9aa8
	.text "contiguous data file{return}"
	.byte $00
L9abe
	.text "file contains {rvs on}"
	.byte $00
L9ace
	.text "{rvs off} dir ctory(s){return}directories will hold {rvs on}"
	.byte $00
L9af5
	.text "{rvs off} keys each{return}{return}dir.#  key size  # of active keys{return}"
	.byte $00
L9b25
	.text "invalid user number !!{return}"
	.byte $00
L9b3d
	.text "{return}{return}"
	.byte $00
L9b40
	.text "("
	.byte $00
L9b42
	.text ")"
	.byte $00
L9b44
	.text "{rvs on}"
	.byte $00
L9b46
	.text "{rvs off}"
	.byte $00
L9b48
	.byte $00
L9b49
	.byte $00
L9b4a
	.text ":"
	.byte $00
L9b4c
	.byte $00
L9b4d
	.text ":"
	.byte $00
L9b4f
	.byte $00
S9b50
	sta L9b61 + 1
	stx L9b61 + 2
	lda #$00
	sta L9bcb
	sta L9bcc
	sta L9bcd
L9b61
	lda L9b61,y
	cmp #$30
	bcc L9bb9
	cmp #$3a
	bcc L9b7e
	ldx $9b8a
	cpx #$0a
	beq L9bb9
	cmp #$41
	bcc L9bb9
	cmp #$47
	bcs L9bb9
	sec
	sbc #$07
L9b7e
	ldx L9bcb
	beq L9ba2
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L9b8b
	clc
	adc L9bcd
	pha
	txa
	adc L9bcc
	tax
	pla
	dey
	bne L9b8b
	sta L9bcd
	stx L9bcc
	pla
	tay
	pla
L9ba2
	inc L9bcb
	sec
	sbc #$30
	clc
	adc L9bcd
	sta L9bcd
	bcc L9bb6
	inc L9bcc
	beq L9bc3
L9bb6
	iny
	bne L9b61
L9bb9
	cmp #$20
	beq L9bb6
	clc
	ldx L9bcb
	bne L9bc4
L9bc3
	sec
L9bc4
	lda L9bcc
	ldx L9bcd
	rts
	
L9bcb
	.byte $00
L9bcc
	.byte $00
L9bcd
	.byte $00
S9bce
	stx L9c60
	sty L9c5f
	php
	pha
	lda #$30
	ldy #$04
L9bda
	sta L9c61,y
	dey
	bpl L9bda
	pla
	beq L9bfe
	lda L9c60
	jsr S9c4a
	sta L9c64
	stx L9c65
	lda L9c5f
	jsr S9c4a
	sta L9c62
	stx L9c63
	jmp L9c33
	
L9bfe
	iny
L9bff
	lda L9c5f
	cmp L9c67,y
	bcc L9c2e
	bne L9c11
	lda L9c60
	cmp L9c6c,y
	bcc L9c2e
L9c11
	lda L9c60
	sbc L9c6c,y
	sta L9c60
	lda L9c5f
	sbc L9c67,y
	sta L9c5f
	lda L9c61,y
	clc
	adc #$01
	sta L9c61,y
	bne L9bff
L9c2e
	iny
	cpy #$05
	bne L9bff
L9c33
	plp
	bcc L9c49
	ldy #$00
L9c38
	lda L9c61,y
	cmp #$30
	bne L9c49
	lda #$20
	sta L9c61,y
	iny
	cpy #$04
	bne L9c38
L9c49
	rts
	
S9c4a
	pha
	and #$0f
	jsr S9c56
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
S9c56
	cmp #$0a
	bcc L9c5c
	adc #$06
L9c5c
	adc #$30
	rts
	
L9c5f
	.byte $ff 
L9c60
	.byte $ff 
L9c61
	.byte $00
L9c62
	.byte $00
L9c63
	.byte $00
L9c64
	.byte $00
L9c65
	.byte $00
L9c66
	.byte $00
L9c67
	.byte $27 
L9c68
	.byte $03 
L9c69
	.byte $00
L9c6a
	.byte $00
L9c6b
	.byte $00
L9c6c
	.byte $10 
L9c6d
	.byte $e8 
L9c6e
	.byte $64 
L9c6f
	.byte $0a 
L9c70
	.byte $01 
