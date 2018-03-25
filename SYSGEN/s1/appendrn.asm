;appendrn.r.prg

	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	
	*=LTK_MiniSubExeArea ;$93e0, $4000 for sysgen
 
L93e0
	lda #$01
	sec
	jsr $9f00
	bcc L93ec
	txa
	ldx #$80
	rts
	
L93ec
	ldx #$00
	stx $9e23
	clc
	jsr S95b0
	lda $8ff3
	sta $9ea5
	lda $8ff5
	sta $9ec3
	lda $8ff6
	sta $9ec4
	lda $8ff7
	sta $9ec5
	lda $8ff9
	sta $9ea4
	lda $91f0
	bne L9429
	lda $91f1
	sta L95cd
	cmp #$f0
	bcc L9476
	bne L9429
	lda #$1c
	jmp LTK_ExeExtMiniSub 
	
L9429
	lda $31
	pha
	lda $32
	pha
	lda $33
	pha
	lda $34
	pha
	lda $91f1
	ldx $91f0
	sec
	sbc #$01
	bcs L9441
	dex
L9441
	tay
	lda #$00
L9444
	cpx #$01
	bcc L945b
	bne L944e
	cpy #$01
	bcc L945b
L944e
	adc #$00
	dey
	cpy #$ff
	bne L9458
	dex
	beq L945b
L9458
	dex
	bne L9444
L945b
	sta $9e85
	lda #$02
	sta $33
	lda #$92
	sta $34
	lda $9e85
	asl a
	sta $9ea3
	bcc L9471
	inc $34
L9471
	lda #$1d
	jmp LTK_ExeExtMiniSub 
	
L9476
	inc L95d0
	lda #$00
	sta L95c9
	clc
	jsr S95a1
	lda #$8f
	sta S9599 + 2
	sta $9517
	lda #$e0
	sta S9599 + 1
	sta $9516
	lda $9ea5
	sta L95ca
L9498
	lda #$00
	sta L95cc
	ldy #$02
L949f
	iny
	lda #$80
	sta L95cb
	jsr S9599
	cmp #$ff
	bne L94bc
	lda #$08
	clc
	adc L95cc
	sta L95cc
	cmp $9ea4
	bcc L949f
	bcs L94d3
L94bc
	bit L95cb
	beq L9512
	inc L95cc
	ldx L95cc
	cpx $9ea4
	beq L94d3
	lsr L95cb
	bne L94bc
	beq L949f
L94d3
	lda $9ec3
	clc
	adc S9599 + 1
	sta S9599 + 1
	sta $9516
	bcc L94e8
	inc S9599 + 2
	inc $9517
L94e8
	ldx #$ff
	dec $9ec5
	beq L94fa
	cpx $9ec5
	bne L9501
	dec $9ec4
	jmp L9501
	
L94fa
	lda $9ec4
	bne L9501
	sec
	rts
	
L9501
	dec L95ca
	bne L9498
	lda L95c9
	beq L950f
	sec
	jsr S95a1
L950f
	jmp L9476
	
L9512
	ora L95cb
	sta $9515,y
	pha
	tya
	pha
	lda #$00
	sta S959d + 1
	ldy #$92
	lda L95cd
	asl a
	tax
	bcc L952a
	iny
L952a
	sty S959d + 2
	inx
	ldy #$01
	jsr S9599
	pha
	iny
	jsr S9599
	clc
	adc L95cc
	sta L95cf
	jsr S959d
	pla
	adc #$00
	sta L95ce
	dex
	jsr S959d
	lda #$ff
	sta L95c9
	pla
	tay
	pla
	inc $91f1
	bne L955c
	inc $91f0
L955c
	sec
L955d
	jsr S95a1
	clc
	jsr S95b0
	lda $9072
	sec
	sbc #$01
	sta $9072
	bcs L9572
	dec $9071
L9572
	lda #$01
	clc
	adc $9075
	sta $9075
	bcc L9580
	inc $9074
L9580
	lda #$ff
	sta $9076
	sta $9077
	sec
	jsr S95b0
	clc
	lda #$01
	jsr $9f00
	ldx L95ce
	ldy L95cf
	rts
	
S9599
	lda S9599,y
	rts
	
S959d
	sta S959d,x
	rts
	
S95a1
	lda LTK_Var_ActiveLU
	ldx L95d0
	ldy #$00
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L95af
	rts
	
S95b0
	php
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L95bc
	ldx #$00
L95bc
	ldy #$00
	plp
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L95c5
	stx L95d0
	rts
	
L95c9
	.byte $00
L95ca
	.byte $00
L95cb
	.byte $00
L95cc
	.byte $00
L95cd
	.byte $00
L95ce
	.byte $00
L95cf
	.byte $00
L95d0
	.byte $00
