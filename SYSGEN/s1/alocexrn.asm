;alocexrn.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 
L93e0
	clc
	jsr S959c
	lda $31
	pha
	lda $32
	pha
	lda $33
	pha
	lda $34
	pha
	ldx $9ea3
	inx
	stx L95b6
L93f7
	lda #$00
	tay
L93fa
	sta LTK_FileReadBuffer ,y
	iny
	bne L93fa
L9400
	sta $9ce0,y
	iny
	bne L9400
L9406
	lda #$e0
	ldx #$9b
	sta $33
	stx $34
	jsr S9471
	pha
	lda L95b8
	asl a
	tay
	bcc L941b
	inc $34
L941b
	txa
	sta ($33),y
	pla
	iny
	sta ($33),y
	inc L95b6
	bne L942a
	inc L95b5
L942a
	lda L95b5
	cmp $91f0
	bne L943f
	lda L95b6
	cmp $91f1
	bne L943f
	lda #$00
	jmp L952e
	
L943f
	inc L95b8
	bne L9406
	jsr S9449
	bne L93f7
S9449
	lda #$02
	sta $33
	lda #$92
	sta $34
	lda L95b7
	asl a
	tay
	bcc L945a
	inc $34
L945a
	lda ($33),y
	pha
	iny
	lda ($33),y
	tax
	pla
	tay
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L946d
	inc L95b7
	rts
	
S9471
	ldy L95bd
	beq L947b
	lda ($31),y
	jmp L94c2
	
L947b
	inc L95be
	lda #$00
	sta L95b9
	lda #$e0
	ldx #$8f
	sta $31
	stx $32
	clc
	jsr S958d
	lda $9ea5
	sta L95ba
L9495
	lda #$00
	sta L95bc
	ldy #$02
L949c
	iny
	lda #$80
	sta L95bb
	lda ($31),y
	ldx L95bb
	bpl L94bd
	cmp #$ff
	bne L94bd
	lda #$08
	clc
	adc L95bc
	sta L95bc
	cmp $9ea4
	bcc L949c
	bcs L94d4
L94bd
	bit L95bb
	beq L950e
L94c2
	inc L95bc
	ldx L95bc
	cpx $9ea4
	beq L94d4
	lsr L95bb
	bne L94bd
	beq L949c
L94d4
	lda $9ec3
	clc
	adc $31
	sta $31
	bcc L94e0
	inc $32
L94e0
	ldx #$ff
	dec $9e84
	beq L94f2
	cpx $9e84
	bne L94fd
	dec $9e83
	jmp L94fd
	
L94f2
	lda $9e83
	bne L94fd
	pla
	pla
	lda #$ff
	bne L952e
L94fd
	dec L95ba
	bne L9495
	lda L95b9
	beq L950b
	sec
	jsr S958d
L950b
	jmp L947b
	
L950e
	ora L95bb
	sta ($31),y
	sty L95bd
	ldy #$01
	lda ($31),y
	tax
	iny
	lda ($31),y
	clc
	adc L95bc
	pha
	txa
	adc #$00
	tax
	pla
	ldy #$ff
	sty L95b9
	rts
	
L952e
	sta L95bf
	jsr S9449
	sec
	jsr S958d
	clc
	jsr S959c
	lda $9072
	sec
	sbc L95b6
	sta $9072
	lda $9071
	sbc L95b5
	sta $9071
	lda L95b6
	clc
	adc $9075
	sta $9075
	lda L95b5
	adc $9074
	sta $9074
	lda #$ff
	sta LTK_ReadChanFPTPtr
	sta $9076
	sta $9077
	sec
	jsr S959c
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	clc
	lda L95bf
	beq L9584
	sec
L9584
	php
	lda #$01
	clc
	jsr $9f00
	plp
	rts
	
S958d
	lda LTK_Var_ActiveLU
	ldx L95be
	ldy #$00
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L959b
	rts
	
S959c
	php
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L95a8
	ldx #$00
L95a8
	ldy #$00
	plp
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L95b1
	stx L95be
	rts
	
L95b5
	.byte $00
	
L95b6
	.byte $00
L95b7
	.byte $00
L95b8
	.byte $00
L95b9
	.byte $00
L95ba
	.byte $00
L95bb
	.byte $00
L95bc
	.byte $00
L95bd
	.byte $00
L95be
	.byte $00
L95bf
	.byte $00
