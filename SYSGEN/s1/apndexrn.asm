;apndexrn.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"

	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 
L93e0
	txa
	pha
	tya
	pha
	clc
	jsr S95b7
	pla
	tay
	pla
	tax
	bne L941c
	tya
	bne L941c
	jsr S9485
	bcs L945c
	pha
	ldy $9ea3
	txa
	sta ($33),y
	sta $9e24
	iny
	pla
	sta ($33),y
	sta $9e25
	lda #$00
	tay
L940a
	sta LTK_FileReadBuffer ,y
	iny
	bne L940a
L9410
	sta $9ce0,y
	iny
	bne L9410
	lda #$01
	ldx #$02
	bne L9441
L941c
	tya
	pha
	ldy $9ea3
	lda ($33),y
	sta $9e24
	pha
	iny
	lda ($33),y
	tax
	sta $9e25
	pla
	tay
	lda LTK_Var_ActiveLU
	clc
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L943a
	clc
	jsr S95b7
	pla
	ldx #$01
L9441
	stx $9e63
	ldx #$e0
	stx $33
	ldx #$9b
	stx $34
	sec
	sbc #$01
	asl a
	sta $9ea3
	bcc L9457
	inc $34
L9457
	jsr S9485
	bcc L9461
L945c
	jsr S9578
	sec
	rts
	
L9461
	pha
	ldy $9ea3
	txa
	sta ($33),y
	sta $9e64
	iny
	pla
	sta ($33),y
	sta $9e65
	ldy $9e24
	ldx $9e25
	lda LTK_Var_ActiveLU
	sec
	jsr LTK_HDDiscDriver 
	.byte <LTK_FileReadBuffer,>LTK_FileReadBuffer,$01 ;$9be0 
L9482
	jmp L953f
	
S9485
	ldy $9e23
	beq L948f
	lda ($31),y
	jmp L94d6
	
L948f
	inc L95d3
	lda #$00
	sta L95d0
	lda #$e0
	ldx #$8f
	sta $31
	stx $32
	clc
	jsr S95a8
	lda $9ea5
	sta L95d1
L94a9
	lda #$00
	sta $9e05
	ldy #$02
L94b0
	iny
	lda #$80
	sta L95d2
	lda ($31),y
	ldx L95d2
	bpl L94d1
	cmp #$ff
	bne L94d1
	lda #$08
	clc
	adc $9e05
	sta $9e05
	cmp $9ea4
	bcc L94b0
	bcs L94e8
L94d1
	bit L95d2
	beq L951e
L94d6
	inc $9e05
	ldx $9e05
	cpx $9ea4
	beq L94e8
	lsr L95d2
	bne L94d1
	beq L94b0
L94e8
	lda $9ec3
	clc
	adc $31
	sta $31
	bcc L94f4
	inc $32
L94f4
	ldx #$ff
	dec $9ec5
	beq L9506
	cpx $9ec5
	bne L950d
	dec $9ec4
	jmp L950d
	
L9506
	lda $9ec4
	bne L950d
	sec
	rts
	
L950d
	dec L95d1
	bne L94a9
	lda L95d0
	beq L951b
	sec
	jsr S95a8
L951b
	jmp L948f
	
L951e
	ora L95d2
	sta ($31),y
	sty $9e23
	ldy #$01
	lda ($31),y
	tax
	iny
	lda ($31),y
	clc
	adc $9e05
	pha
	txa
	adc #$00
	tax
	pla
	ldy #$ff
	sty L95d0
	clc
	rts
	
L953f
	sec
	jsr S95a8
	clc
	jsr S95b7
	lda $9072
	sec
	sbc $9e63
	sta $9072
	bcs L9556
	dec $9071
L9556
	lda $9e63
	clc
	adc $9075
	sta $9075
	bcc L9565
	inc $9074
L9565
	lda #$ff
	sta LTK_ReadChanFPTPtr
	sta $9076
	sta $9077
	sec
	jsr S95b7
	jsr S9578
	rts
	
S9578
	pla
	tax
	pla
	tay
	pla
	sta $34
	pla
	sta $33
	pla
	sta $32
	pla
	sta $31
	tya
	pha
	txa
	pha
	lda $9e63
	clc
	adc $91f1
	sta $91f1
	bcc L959b
	inc $91f0
L959b
	lda #$01
	clc
	jsr $9f00
	ldx $9e64
	ldy $9e65
	rts
	
S95a8
	lda LTK_Var_ActiveLU
	ldx L95d3
	ldy #$00
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L95b6
	rts
	
S95b7
	php
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L95c3
	ldx #$00
L95c3
	ldy #$00
	plp
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L95cc
	stx L95d3
	rts
	
L95d0
	.byte $00
L95d1
	.byte $00
L95d2
	.byte $00
L95d3
	.byte $00
