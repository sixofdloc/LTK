;alocatrn.r.prg
	
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
	stx $9e65
	clc
	jsr S95ac
	lda $8ff3
	sta $9ea5
	lda $8ff5
	sta $9ec3
	lda $8ff6
	sta $9ec4
	sta $9e83
	lda $8ff7
	sta $9ec5
	sta $9e84
	lda $8ff9
	sta $9ea4
	lda $91f0
	pha
	tax
	lda $91f1
	pha
	ldy #$00
	cpx #$00
	bne L942c
	cmp #$f1
	bcc L9459
L942c
	sec
	sbc #$01
	bcs L9432
	dex
L9432
	sta $9ea3
	stx $9e85
	ldx #$08
L943a
	lsr $9e85
	ror $9ea3
	bcc L9443
	iny
L9443
	dex
	bne L943a
	tya
	beq L944c
	inc $9ea3
L944c
	ldx $9ea3
	inx
	stx $91f1
	ldy #$00
	sty $91f0
	iny
L9459
	sty $9e23
L945c
	inc L95de
	lda #$00
	sta $9e24
	clc
	jsr S959d
	lda #$8f
	sta S9595 + 2
	sta $9503
	lda #$e0
	sta S9595 + 1
	sta $9502
	lda $9ea5
	sta $9e25
L947e
	lda #$00
	sta $9e64
	ldy #$02
L9485
	iny
	lda #$80
	sta $9e63
	jsr S9595
	cmp #$ff
	bne L94a2
	lda #$08
	clc
	adc $9e64
	sta $9e64
	cmp $9ea4
	bcc L9485
	bcs L94b9
L94a2
	bit $9e63
	beq L94fe
L94a7
	inc $9e64
	ldx $9e64
	cpx $9ea4
	beq L94b9
	lsr $9e63
	bne L94a2
	beq L9485
L94b9
	lda $9ec3
	clc
	adc S9595 + 1
	sta S9595 + 1
	sta $9502
	bcc L94ce
	inc S9595 + 2
	inc $9503
L94ce
	ldx #$ff
	dec $9ec5
	beq L94e0
	cpx $9ec5
	bne L94ed
	dec $9ec4
	jmp L94ed
	
L94e0
	lda $9ec4
	bne L94ed
	jsr S95c5
	jsr S9564
	sec
	rts
	
L94ed
	dec $9e25
	bne L947e
	lda $9e24
	beq L94fb
	sec
	jsr S959d
L94fb
	jmp L945c
	
L94fe
	ora $9e63
	sta $9501,y
	pha
	tya
	pha
	lda #$00
	sta S9599 + 1
	ldy #$92
	lda $9e65
	asl a
	tax
	bcc L9516
	iny
L9516
	sty S9599 + 2
	inx
	ldy #$01
	jsr S9595
	pha
	iny
	jsr S9595
	clc
	adc $9e64
	jsr S9599
	pla
	adc #$00
	dex
	jsr S9599
	lda #$ff
	sta $9e24
	pla
	tay
	pla
	inc $9e65
	ldx $9e65
	cpx $91f1
	beq L9548
	jmp L94a7
	
L9548
	jsr S95c5
	lda $9e23
	beq S9564
	lda $9ea3
	clc
	adc $91f1
	sta $91f1
	bcc L955f
	inc $91f0
L955f
	lda #$1b
	jmp LTK_ExeExtMiniSub 
	
S9564
	lda $9072
	sec
	sbc $9e65
	sta $9072
	bcs L9573
	dec $9071
L9573
	lda $9e65
	clc
	adc $9075
	sta $9075
	bcc L9582
	inc $9074
L9582
	lda #$ff
	sta $9076
	sta $9077
	sec
	jsr S95ac
	clc
	lda #$01
	jsr $9f00
	rts
	
S9595
	lda S9595,y
	rts
	
S9599
	sta S9599,x
	rts
	
S959d
	lda LTK_Var_ActiveLU
	ldx L95de
	ldy #$00
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L95ab
	rts
	
S95ac
	php
	lda LTK_Var_ActiveLU
	ldx #$ee
	cmp #$0a
	beq L95b8
	ldx #$00
L95b8
	ldy #$00
	plp
	jsr LTK_HDDiscDriver 
	.byte <LTK_MiscWorkspace,>LTK_MiscWorkspace,$01; $8fe0 
L95c1
	stx L95de
	rts
	
S95c5
	sec
	jsr S959d
	pla
	tax
	pla
	tay
	pla
	sta $91f1
	pla
	sta $91f0
	tya
	pha
	txa
	pha
	clc
	jsr S95ac
	rts
	
L95de
	.byte $00
